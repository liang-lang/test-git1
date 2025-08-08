CREATE TABLE dwd_product_info (
    -- 业务主键
                                  product_id BIGINT COMMENT '商品业务主键',
    -- 维度代理键
                                  product_sk BIGINT COMMENT '商品维度代理键（关联 dim_product）',
                                  category_sk BIGINT COMMENT '类目维度代理键（关联 dim_category）',
    -- 商品属性（清洗后）
                                  product_name VARCHAR(200) COMMENT '商品名称（去重空格）',
                                  price DECIMAL(10,2) COMMENT '商品单价（异常值填充 0）',
                                  create_time DATETIME COMMENT '商品创建时间（格式统一：yyyy-MM-dd HH:mm:ss）',
                                  update_time DATETIME COMMENT '商品更新时间（清洗后）',
    -- 数据审计字段
                                  etl_time DATETIME COMMENT 'ETL 处理时间'
)
    DUPLICATE KEY(product_id)
DISTRIBUTED BY HASH(product_id) BUCKETS 10
    PROPERTIES (
    "replication_num" = "2",
    "storage_medium" = "HDD"
);

INSERT INTO dwd_product_info (
    product_id, product_sk, category_sk,
    product_name, price, create_time, update_time,
    etl_time
)
SELECT
    p.product_id,
    d.product_sk,  -- 关联 dim_product
    c.category_sk, -- 关联 dim_category
    TRIM(UPPER(p.product_name)) AS product_name,
    CASE WHEN p.price < 0 THEN 0 ELSE p.price END AS price,
    DATE_FORMAT(p.create_time, '%Y-%m-%d %H:%i:%s') AS create_time,
    DATE_FORMAT(p.update_time, '%Y-%m-%d %H:%i:%s') AS update_time,
    NOW() AS etl_time
FROM product_info p
-- 关联商品维度表
         JOIN dim_product d ON p.product_id = d.product_id
-- 关联类目维度表
         JOIN dim_category c ON p.category_id = c.category_id;


CREATE TABLE dwd_product_metrics (
    -- 业务主键
                                     id BIGINT COMMENT '原始 metrics 记录 ID',
                                     product_id BIGINT COMMENT '商品业务主键',
    -- 维度代理键
                                     product_sk BIGINT COMMENT '商品维度代理键',
                                     time_sk BIGINT COMMENT '时间维度代理键（关联 dim_time）',
    -- 指标（清洗后）
                                     visitor_count INT COMMENT '商品访客数（空值填 0）',
                                     view_count INT COMMENT '商品浏览量（异常值填 0）',
                                     order_amount DECIMAL(12,2) COMMENT '下单金额（负数填 0）',
    -- 数据审计字段
                                     stat_date DATE COMMENT '统计日期（关联 dim_time）',
                                     etl_time DATETIME COMMENT 'ETL 处理时间'
)
    DUPLICATE KEY(id)
DISTRIBUTED BY HASH(product_id) BUCKETS 10
     PROPERTIES (
    "replication_num" = "2",
    "storage_medium" = "HDD"
);
INSERT INTO dwd_product_metrics (
    id, product_id, product_sk, time_sk,
    visitor_count, view_count, order_amount,
    stat_date, etl_time
)
SELECT
    m.id,
    m.product_id,
    d.product_sk,  -- 关联 dim_product
    t.time_sk,     -- 关联 dim_time
    CASE WHEN m.visitor_count IS NULL THEN 0 ELSE m.visitor_count END AS visitor_count,
    CASE WHEN m.view_count IS NULL THEN 0 ELSE m.view_count END AS view_count,
    CASE WHEN m.order_amount < 0 THEN 0 ELSE m.order_amount END AS order_amount,
    m.stat_date,
    NOW() AS etl_time
FROM product_metrics m
         JOIN dim_product d ON m.product_id = d.product_id
         JOIN dim_time t ON m.stat_date = t.date_value;

CREATE TABLE dwd_product_interval (
    -- 业务主键
                                      id BIGINT COMMENT '原始 interval 记录 ID',
                                      product_id BIGINT COMMENT '商品业务主键',
    -- 维度代理键
                                      product_sk BIGINT COMMENT '商品维度代理键',
                                      category_sk BIGINT COMMENT '类目维度代理键',
                                      time_sk BIGINT COMMENT '时间维度代理键',
    -- 区间指标（清洗后）
                                      interval_type VARCHAR(20) COMMENT '区间类型（标准化：小写）',
                                      interval_range VARCHAR(50) COMMENT '区间范围（去重空格）',
                                      sort_index INT COMMENT '排序指标对应值（异常值填 0）',
    -- 数据审计字段
                                      stat_date DATE COMMENT '统计日期',
                                      etl_time DATETIME COMMENT 'ETL 处理时间'
)
    DUPLICATE KEY(id)
DISTRIBUTED BY HASH(product_id) BUCKETS 10
      PROPERTIES (
    "replication_num" = "2",
    "storage_medium" = "HDD"
);

INSERT INTO dwd_product_interval (
    id, product_id, product_sk, category_sk, time_sk,
    interval_type, interval_range, sort_index,
    stat_date, etl_time
)
SELECT
    -- ODS 原始字段
    o.id,
    o.product_id,
    -- 关联 DIM 层，补充代理键
    d.product_sk,          -- 商品维度代理键（关联 dim_product）
    c.category_sk,         -- 类目维度代理键（关联 dim_category）
    t.time_sk,             -- 时间维度代理键（关联 dim_time）
    -- 清洗字段
    LOWER(o.interval_type) AS interval_type,  -- 标准化：转小写
    TRIM(o.interval_range) AS interval_range, -- 去重空格
    CASE WHEN o.sort_index < 0 THEN 0 ELSE o.sort_index END AS sort_index, -- 异常值处理
    -- 时间字段
    o.stat_date AS stat_date,
    -- ETL 时间
    NOW() AS etl_time
FROM
    product_interval o
-- 关联商品维度表（dim_product）
        JOIN dim_product d
             ON o.product_id = d.product_id
                 AND o.stat_date BETWEEN d.start_date AND d.end_date
-- 关联类目维度表（dim_category）
        JOIN dim_category c
             ON d.category_id = c.category_id
-- 关联时间维度表（dim_time）
        JOIN dim_time t
             ON o.stat_date = t.date_value
-- 去重（避免重复加载）
WHERE NOT EXISTS (
        SELECT 1 FROM dwd_product_interval d
        WHERE d.id = o.id
    );
