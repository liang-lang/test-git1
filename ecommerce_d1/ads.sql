CREATE TABLE ads_product_sales_daily (
                                         report_date DATE NOT NULL COMMENT '报表日期（2025-01-01 至 2025-01-30）',
                                         product_id BIGINT NOT NULL COMMENT '商品ID',
                                         product_name VARCHAR(200) COMMENT '商品名称',
                                         category_name VARCHAR(100) COMMENT '所属类目',
                                         price DECIMAL(10,2) COMMENT '商品单价',
    -- 核心指标
                                         pv BIGINT COMMENT '当日浏览量',
                                         uv BIGINT COMMENT '当日访客数',
                                         order_amount DECIMAL(15,2) COMMENT '当日下单金额',
    -- 衍生指标
                                         pv_rank INT COMMENT '当日浏览量排名（类目内）',
                                         order_amount_rate DECIMAL(5,2) COMMENT '下单金额占类目比例（%）',
    -- 数据状态
                                         is_exception TINYINT COMMENT '是否异常（1-是，0-否，如 PV 突降）',
                                         etl_time DATETIME COMMENT '生成时间'
)
    DUPLICATE KEY(report_date, product_id)
DISTRIBUTED BY HASH(product_id) BUCKETS 10
PROPERTIES ("replication_num" = "2");

INSERT INTO ads_product_sales_daily (
    report_date, product_id, product_name, category_name, price,
    pv, uv, order_amount,
    pv_rank, order_amount_rate,
    is_exception, etl_time
)
SELECT
    -- 报表日期（限定 2025-01-01 至 2025-01-30）
    s.stat_date AS report_date,
    s.product_id,
    s.product_name,
    c.category_name,
    s.price,
    -- 核心指标（取自 DWS 日表）
    s.pv,
    s.uv,
    s.order_amount,
    -- 类目内浏览量排名
    ROW_NUMBER() OVER (
        PARTITION BY s.category_sk, s.stat_date
        ORDER BY s.pv DESC
        ) AS pv_rank,
    -- 下单金额占类目比例
            (s.order_amount / NULLIF(
                    SUM(s.order_amount) OVER (PARTITION BY s.category_sk, s.stat_date),
                    0
                )) * 100 AS order_amount_rate,
    -- 异常判断（如 PV 较前日降 50% 以上）
    CASE
        -- 补充第 3 个参数 0，避免首行数据偏移时出错
        WHEN s.pv < LAG(s.pv, 1, 0) OVER (PARTITION BY s.product_sk ORDER BY s.stat_date) * 0.5
            THEN 1 ELSE 0
        END AS is_exception,
    NOW() AS etl_time
FROM
    dws_product_daily_summary s
-- 关联类目维度表获取名称
        JOIN dim_category c ON s.category_sk = c.category_sk
-- 限定时间范围：2025-01-01 至 2025-01-30
WHERE s.stat_date BETWEEN '2025-01-01' AND '2025-01-30';


CREATE TABLE ads_category_sales_weekly (
                                           report_week VARCHAR(20) NOT NULL COMMENT '统计周（如 2025-W01）',
                                           category_id BIGINT NOT NULL COMMENT '类目ID',
                                           category_name VARCHAR(100) COMMENT '类目名称',
                                           parent_category_name VARCHAR(100) COMMENT '父类目名称',
    -- 核心指标
                                           total_pv BIGINT COMMENT '周总浏览量',
                                           total_uv BIGINT COMMENT '周总访客数',
                                           total_order_amount DECIMAL(15,2) COMMENT '周总下单金额',
    -- 趋势指标
                                           pv_week_on_week DECIMAL(5,2) COMMENT '浏览量环比（%）',
                                           order_amount_week_on_week DECIMAL(5,2) COMMENT '下单金额环比（%）',
    -- 数据状态
                                           is_top_category TINYINT COMMENT '是否周度TOP3类目（1-是，0-否）',
                                           etl_time DATETIME COMMENT '生成时间'
)
    DUPLICATE KEY(report_week, category_id)
DISTRIBUTED BY HASH(category_id) BUCKETS 5
PROPERTIES ("replication_num" = "2");

INSERT INTO ads_category_sales_weekly (
    report_week, category_id, category_name, parent_category_name,
    total_pv, total_uv, total_order_amount,
    pv_week_on_week, order_amount_week_on_week,
    is_top_category, etl_time
)
SELECT
    s.stat_week AS report_week,
    c.category_id,
    s.category_name,
    s.parent_category_name,
    s.total_pv,
    s.total_uv,
    s.total_order_amount,
    -- 修正 LAG() 函数，补充第 3 个默认值参数 0
    (s.total_pv / NULLIF(
            LAG(s.total_pv, 1, 0) OVER (PARTITION BY s.category_sk ORDER BY s.stat_week),
            0
        ) - 1) * 100 AS pv_week_on_week,
    -- 同样修正下单金额环比的 LAG() 函数
    (s.total_order_amount / NULLIF(
            LAG(s.total_order_amount, 1, 0) OVER (PARTITION BY s.category_sk ORDER BY s.stat_week),
            0
        ) - 1) * 100 AS order_amount_week_on_week,
    CASE
        WHEN ROW_NUMBER() OVER (PARTITION BY s.stat_week ORDER BY s.total_order_amount DESC) <= 3
            THEN 1 ELSE 0
        END AS is_top_category,
    NOW() AS etl_time
FROM
    dws_category_weekly_summary s
        JOIN dim_category c ON s.category_sk = c.category_sk
WHERE s.stat_week BETWEEN '2025-W01' AND '2025-W05';

CREATE TABLE ads_product_interval_analysis (
                                               analysis_date DATE NOT NULL COMMENT '分析日期',
                                               interval_type VARCHAR(20) NOT NULL COMMENT '区间类型（如 price_range）',
                                               interval_range VARCHAR(50) NOT NULL COMMENT '区间范围（如 0~50）',
                                               category_name VARCHAR(100) COMMENT '类目名称',
                                               product_count INT COMMENT '区间内商品数量',
                                               total_pv BIGINT COMMENT '区间总浏览量',
                                               total_order_amount DECIMAL(15,2) COMMENT '区间总下单金额',
                                               avg_order_per_product DECIMAL(10,2) COMMENT '区间内商品平均下单金额',
                                               pv_contribution_rate DECIMAL(5,2) COMMENT '浏览量贡献占比（%）',
                                               etl_time DATETIME COMMENT '生成时间'
)
    DUPLICATE KEY(analysis_date, interval_type, interval_range, category_name)
DISTRIBUTED BY HASH(category_name) BUCKETS 5
PROPERTIES ("replication_num" = "2");

INSERT INTO ads_product_interval_analysis (
    analysis_date, interval_type, interval_range, category_name,
    product_count, total_pv, total_order_amount,
    avg_order_per_product, pv_contribution_rate,
    etl_time
)
SELECT
    s.stat_date AS analysis_date,
    s.interval_type,
    s.interval_range,
    c.category_name,
    -- 核心指标（取自 DWS 区间表）
    s.product_count,
    s.total_pv,
    s.total_order_amount,
    -- 区间内商品平均下单金额
    s.total_order_amount / NULLIF(s.product_count, 0) AS avg_order_per_product,
    -- 浏览量贡献占比（区间PV/类目总PV）
    (s.total_pv / NULLIF(
            SUM(s.total_pv) OVER (PARTITION BY s.category_sk, s.stat_date),
            0
        )) * 100 AS pv_contribution_rate,
    NOW() AS etl_time
FROM
    dws_product_interval_summary s
-- 关联类目维度表获取名称
        JOIN dim_category c ON s.category_sk = c.category_sk
-- 限定时间范围：2025-01-01 至 2025-01-30
WHERE s.stat_date BETWEEN '2025-01-01' AND '2025-01-30';