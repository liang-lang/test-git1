use ecommerce_d1;
-- 1. 商品维度表（dim_product）
CREATE TABLE IF NOT EXISTS dim_product (
                                           product_sk BIGINT NOT NULL AUTO_INCREMENT COMMENT '商品维度代理键',  -- 添加NOT NULL
                                           product_id BIGINT COMMENT '商品业务主键',
                                           product_name VARCHAR(200) COMMENT '商品名称',
    category_id BIGINT COMMENT '叶子类目ID',
    category_name VARCHAR(100) COMMENT '叶子类目名称',
    price DECIMAL(10,2) COMMENT '商品单价',
    create_time DATETIME COMMENT '商品创建时间',
    is_active TINYINT COMMENT '是否有效（1-有效，0-无效）',
    version INT COMMENT '维度版本',
    start_date DATETIME COMMENT '生效开始时间',
    end_date DATETIME COMMENT '生效结束时间'
    )
    DUPLICATE KEY(product_sk)
    DISTRIBUTED BY HASH(product_id) BUCKETS 10
    PROPERTIES (
                   "replication_num" = "2",
                   "storage_medium" = "HDD"
               );


-- 全量同步（首次初始化）
INSERT INTO dim_product
(
    product_id, product_name, category_id, category_name, price,
    create_time, is_active, version, start_date, end_date
)
SELECT
    product_id, product_name, category_id, category_name, price,
    create_time, 1, 1, create_time, '9999-12-31 23:59:59'
FROM product_info;

-- 增量同步（SCD2 逻辑，检测价格/类目变化）
INSERT INTO dim_product
(
    product_id, product_name, category_id, category_name, price,
    create_time, is_active, version, start_date, end_date
)
SELECT
    p.product_id, p.product_name, p.category_id, p.category_name, p.price,
    p.create_time, 1,
    -- 取当前最大版本 +1
    (SELECT COALESCE(MAX(version), 0) + 1 FROM dim_product WHERE product_id = p.product_id),
    NOW(), '9999-12-31 23:59:59'
FROM product_info p
-- 关联维度表，找变化的记录
         JOIN dim_product d
              ON p.product_id = d.product_id
                  AND (
                     p.price != d.price
                         OR p.category_id != d.category_id
                     )
WHERE d.end_date = '9999-12-31 23:59:59';




-- 2. 时间维度表（dim_time）
CREATE TABLE IF NOT EXISTS dim_time (
                                        time_sk BIGINT NOT NULL COMMENT '时间代理键（如 20250808）',  -- 时间键通常手动生成，需显式NOT NULL
                                        date_value DATE COMMENT '日期',
                                        `year` INT COMMENT '年',
                                        `quarter` INT COMMENT '季度',
                                        `month` INT COMMENT '月',
                                        `day` INT COMMENT '日',
                                        week_of_year INT COMMENT '年第几周',
                                        is_weekday TINYINT COMMENT '是否工作日（1-是，0-否）',
                                        holiday_desc VARCHAR(50) COMMENT '节假日描述'
    )
    DUPLICATE KEY(time_sk)
    DISTRIBUTED BY HASH(time_sk) BUCKETS 4
    PROPERTIES (
                   "replication_num" = "2",
                   "storage_medium" = "HDD"
               );
-- 生成 2020-2030 时间维度（可写存储过程或用 Python 生成）
INSERT INTO dim_time
(time_sk, date_value, year, quarter, month, day, week_of_year, is_weekday, holiday_desc)
SELECT
    -- 代理键：日期转数字（20250808）
    YEAR(date_value)*10000 + MONTH(date_value)*100 + DAY(date_value) AS time_sk,
    date_value,
    YEAR(date_value),
    QUARTER(date_value),
    MONTH(date_value),
    DAY(date_value),
    WEEKOFYEAR(date_value),
    -- 判断是否工作日（示例：简单排除周六日，实际需关联节假日表）
    CASE WHEN WEEKDAY(date_value) IN (5,6) THEN 0 ELSE 1 END AS is_weekday,
    '' AS holiday_desc
FROM (
         SELECT ADDDATE('2020-01-01', t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) AS date_value
         FROM
             (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t0,
             (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
             (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
             (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
             (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t4
         WHERE ADDDATE('2020-01-01', t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) <= '2030-12-31'
     ) dates;




-- 3. 类目维度表（dim_category）
CREATE TABLE IF NOT EXISTS dim_category (
                                            category_sk BIGINT NOT NULL AUTO_INCREMENT COMMENT '类目代理键',  -- 添加NOT NULL
                                            category_id BIGINT COMMENT '叶子类目ID',
                                            category_name VARCHAR(100) COMMENT '叶子类目名称',
    parent_category_id BIGINT COMMENT '父类目ID',
    parent_category_name VARCHAR(100) COMMENT '父类目名称',
    level TINYINT COMMENT '类目层级（1-一级，2-二级...）'
    )
    DUPLICATE KEY(category_sk)
    DISTRIBUTED BY HASH(category_id) BUCKETS 5
    PROPERTIES (
    "replication_num" = "2"
               );
-- 假设 product_info 只有叶子类目，需递归找父类目（实际需业务表支持）
INSERT INTO dim_category
(category_id, category_name, parent_category_id, parent_category_name, level)
SELECT DISTINCT
    p.category_id, p.category_name,
    -- 父类目逻辑（示例：硬编码，实际需关联类目层级表）
    0 AS parent_category_id,
    '一级类目' AS parent_category_name,
    2 AS level  -- 假设叶子类目是二级
FROM product_info p
WHERE NOT EXISTS (
        SELECT 1 FROM dim_category d
        WHERE p.category_id = d.category_id
    );