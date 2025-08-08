CREATE TABLE dws_product_daily_summary (
    -- 维度键（关联 DIM 层）
                                           product_sk BIGINT NOT NULL COMMENT '商品维度代理键',
                                           time_sk BIGINT NOT NULL COMMENT '时间维度代理键（日期）',
                                           category_sk BIGINT NOT NULL COMMENT '类目维度代理键',
    -- 商品属性（冗余，便于筛选）
                                           product_id BIGINT COMMENT '商品业务主键',
                                           product_name VARCHAR(200) COMMENT '商品名称',
                                           price DECIMAL(10,2) COMMENT '商品单价',
    -- 核心指标
                                           pv BIGINT COMMENT '当日浏览量（sum of view_count）',
                                           uv BIGINT COMMENT '当日访客数（sum of visitor_count）',
                                           order_amount DECIMAL(15,2) COMMENT '当日下单金额',
    -- 衍生指标
                                           avg_order_per_user DECIMAL(10,2) COMMENT '人均下单金额（order_amount/uv）',
    -- 数据审计
                                           stat_date DATE COMMENT '统计日期',
                                           etl_time DATETIME COMMENT 'ETL 处理时间'
)
    DUPLICATE KEY(product_sk, time_sk)  -- 按商品+日期唯一标识
DISTRIBUTED BY HASH(product_sk) BUCKETS 10
PROPERTIES ("replication_num" = "2");


select * from  dwd_product_metrics m  -- 从 metrics 明细取指标
-- 关联商品基础信息表（补充商品属性和类目）
                   JOIN dwd_product_info i
                        ON m.product_sk = i.product_sk
-- 关联时间维度表（获取日期）
                   JOIN dim_time t
                        ON m.time_sk = t.time_sk

WHERE t.date_value = '2025-01-01';



INSERT INTO dws_product_daily_summary (
    product_sk, time_sk, category_sk,
    product_id, product_name, price,
    pv, uv, order_amount,
    avg_order_per_user,
    stat_date, etl_time
)
SELECT
    -- 维度键（关联 DIM 层）
    m.product_sk,
    m.time_sk,
    i.category_sk,  -- 从商品信息表获取类目
    -- 商品属性（冗余）
    i.product_id,
    i.product_name,
    i.price,
    -- 核心指标（汇总当日数据）
    SUM(m.view_count) AS pv,
    SUM(m.visitor_count) AS uv,
    SUM(m.order_amount) AS order_amount,
    -- 衍生指标（人均下单金额）
    CASE WHEN SUM(m.visitor_count) = 0 THEN 0
         ELSE SUM(m.order_amount) / SUM(m.visitor_count)
        END AS avg_order_per_user,
    -- 统计日期
    t.date_value AS stat_date,
    NOW() AS etl_time
FROM
    dwd_product_metrics m  -- 从 metrics 明细取指标
-- 关联商品基础信息表（补充商品属性和类目）
        JOIN dwd_product_info i
             ON m.product_sk = i.product_sk
-- 关联时间维度表（获取日期）
        JOIN dim_time t
             ON m.time_sk = t.time_sk
-- 筛选当日数据（如 2025-08-08）
WHERE t.date_value = '2025-01-30'
-- 按商品和日期聚合
GROUP BY
    m.product_sk, m.time_sk, i.category_sk,
    i.product_id, i.product_name, i.price, t.date_value;

CREATE TABLE dws_category_weekly_summary (
    -- 维度键
                                             category_sk BIGINT NOT NULL COMMENT '类目维度代理键',
                                             week_sk BIGINT NOT NULL COMMENT '周维度键（如 202501 表示 2025 年第 1 周）',
    -- 类目属性（冗余）
                                             category_name VARCHAR(100) COMMENT '类目名称',
                                             parent_category_name VARCHAR(100) COMMENT '父类目名称',
    -- 核心指标
                                             total_pv BIGINT COMMENT '周总浏览量',
                                             total_uv BIGINT COMMENT '周总访客数',
                                             total_order_amount DECIMAL(15,2) COMMENT '周总下单金额',
    -- 衍生指标
                                             order_amount_ratio DECIMAL(5,2) COMMENT '类目下单金额占父类目的比例（%）',
    -- 数据审计
                                             stat_week VARCHAR(20) COMMENT '统计周（如 2025-W32）',
                                             etl_time DATETIME COMMENT 'ETL 处理时间'
)
    DUPLICATE KEY(category_sk, week_sk)  -- 按类目+周唯一标识
DISTRIBUTED BY HASH(category_sk) BUCKETS 5
PROPERTIES ("replication_num" = "2");


INSERT INTO dws_category_weekly_summary (
    category_sk, week_sk,
    category_name, parent_category_name,
    total_pv, total_uv, total_order_amount,
    order_amount_ratio,
    stat_week, etl_time
)
SELECT
    -- 维度键
    s.category_sk,
    -- 周维度键（取周内最小 time_sk 作为标识）
    MIN(s.time_sk) AS week_sk,
    -- 类目属性（从 DIM 层获取）
    c.category_name,
    c.parent_category_name,
    -- 核心指标（汇总周内数据）
    SUM(s.pv) AS total_pv,
    SUM(s.uv) AS total_uv,
    SUM(s.order_amount) AS total_order_amount,
    -- 衍生指标（占父类目比例）
    (SUM(s.order_amount) / NULLIF(
            SUM(SUM(s.order_amount)) OVER (PARTITION BY c.parent_category_id),
            0
        )) * 100 AS order_amount_ratio,
    -- 统计周格式（如 2025-W32）
    CONCAT(t.year, '-W', LPAD(t.week_of_year, 2, '0')) AS stat_week,
    NOW() AS etl_time
FROM
    dws_product_daily_summary s  -- 从商品日表聚合
-- 关联类目维度表（补充类目属性）
        JOIN dim_category c
             ON s.category_sk = c.category_sk
-- 关联时间维度表（获取周信息）
        JOIN dim_time t
             ON s.time_sk = t.time_sk
-- 筛选上周数据（如 2025 年第 32 周）
WHERE t.date_value BETWEEN '2025-01-01' AND '2025-01-30'
-- 按类目和周聚合
GROUP BY
    s.category_sk, c.category_name, c.parent_category_name,
    t.year, t.week_of_year, c.parent_category_id;


CREATE TABLE dws_product_interval_summary (
    -- 维度键
                                              interval_type VARCHAR(20) NOT NULL COMMENT '区间类型（如 price_range）',
                                              interval_range VARCHAR(50) NOT NULL COMMENT '区间范围（如 0~50）',
                                              category_sk BIGINT NOT NULL COMMENT '类目维度代理键',
    -- 区间指标
                                              product_count INT COMMENT '区间内商品数量',
                                              total_pv BIGINT COMMENT '区间内总浏览量',
                                              total_order_amount DECIMAL(15,2) COMMENT '区间内总下单金额',
    -- 衍生指标
                                              avg_pv_per_product DECIMAL(10,2) COMMENT '区间内商品平均浏览量',
    -- 数据审计
                                              stat_date DATE COMMENT '统计日期',
                                              etl_time DATETIME COMMENT 'ETL 处理时间'
)
    DUPLICATE KEY(interval_type, interval_range, category_sk)  -- 按区间+类目唯一标识
DISTRIBUTED BY HASH(category_sk) BUCKETS 5
PROPERTIES ("replication_num" = "2");


INSERT INTO dws_product_interval_summary (
    interval_type, interval_range, category_sk,
    product_count, total_pv, total_order_amount,
    avg_pv_per_product,
    stat_date, etl_time
)
SELECT
    -- 区间维度
    i.interval_type,
    i.interval_range,
    i.category_sk,
    -- 区间指标
    COUNT(DISTINCT i.product_id) AS product_count,  -- 区间内商品数
    SUM(m.view_count) AS total_pv,                  -- 区间内总浏览量
    SUM(m.order_amount) AS total_order_amount,      -- 区间内总下单金额
    -- 衍生指标（平均浏览量）
    CASE WHEN COUNT(DISTINCT i.product_id) = 0 THEN 0
         ELSE SUM(m.view_count) / COUNT(DISTINCT i.product_id)
        END AS avg_pv_per_product,
    -- 统计日期
    t.date_value AS stat_date,
    NOW() AS etl_time
FROM
    dwd_product_interval i  -- 从区间明细取区间划分
-- 关联 metrics 明细（取指标）
        JOIN dwd_product_metrics m
             ON i.product_id = m.product_id
                 AND i.stat_date = m.stat_date
-- 关联时间维度表
        JOIN dim_time t
             ON i.stat_date = t.date_value
-- 筛选当日数据
WHERE t.date_value = '2025-01-30'
-- 按区间、类目聚合
GROUP BY
    i.interval_type, i.interval_range, i.category_sk, t.date_value;