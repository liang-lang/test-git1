create database if not exists ecommerce_d1;
use ecommerce_d1;
-- Doris 表结构（Duplicate 模型，适合存基础维度信息）
CREATE TABLE IF NOT EXISTS product_info (
                                            `product_id` BIGINT COMMENT '商品ID（主键）',
                                            `product_name` VARCHAR(200) COMMENT '商品名称',
    `category_id` BIGINT COMMENT '叶子类目ID',
    `category_name` VARCHAR(100) COMMENT '叶子类目名称',
    `price` DECIMAL(10,2) COMMENT '商品单价',
    `create_time` DATETIME COMMENT '商品创建时间',
    `update_time` DATETIME COMMENT '商品更新时间'
    )
    DUPLICATE KEY(`product_id`)  -- Doris 中 Duplicate 模型的唯一键，类似 MySQL 主键，保证数据唯一性
    DISTRIBUTED BY HASH(`product_id`) BUCKETS 10  -- 按 product_id 哈希分桶，分 10 个桶，可根据数据量调整
    PROPERTIES (
                   "replication_num" = "2",  -- 副本数，生产环境根据集群节点数调整，测试环境可设 1
                   "storage_medium" = "HDD",
                   "compression" = "zstd"
               );

-- Doris 表结构（Duplicate 模型，存每日/周期指标明细）
CREATE TABLE IF NOT EXISTS product_metrics (
                                               `id` BIGINT COMMENT '自增主键（Doris 中可不用自增，用业务唯一键更好，这里保留原逻辑）',
                                               `product_id` BIGINT COMMENT '商品ID（外键关联 product_info）',
                                               `stat_date` DATE COMMENT '统计日期',
                                               `time_dimension` VARCHAR(20) COMMENT '时间维度（day/week/month/7days/30days 等）',
    `visitor_count` INT COMMENT '商品访客数',
    `visited_product_count` INT COMMENT '有访问商品数',
    `view_count` INT COMMENT '商品浏览量',
    `avg_stay_time` DECIMAL(8,2) COMMENT '平均停留时长（秒）',
    `bounce_rate` DECIMAL(5,4) COMMENT '详情页跳出率',
    `micro_viewer_count` INT COMMENT '微详情访客数',
    `collect_count` INT COMMENT '收藏人数',
    `cart_add_count` INT COMMENT '加购件数',
    `cart_add_user_count` INT COMMENT '加购人数',
    `visit_collect_rate` DECIMAL(5,4) COMMENT '访问收藏转化率',
    `visit_cart_rate` DECIMAL(5,4) COMMENT '访问加购转化率',
    `order_user_count` INT COMMENT '下单买家数',
    `order_item_count` INT COMMENT '下单件数',
    `order_amount` DECIMAL(12,2) COMMENT '下单金额',
    `order_convert_rate` DECIMAL(5,4) COMMENT '下单转化率',
    `pay_user_count` INT COMMENT '支付买家数',
    `pay_item_count` INT COMMENT '支付件数',
    `pay_amount` DECIMAL(12,2) COMMENT '支付金额',
    `pay_convert_rate` DECIMAL(5,4) COMMENT '支付转化率',
    `paid_product_count` INT COMMENT '有支付商品数',
    `new_pay_user_count` INT COMMENT '支付新买家数',
    `old_pay_user_count` INT COMMENT '支付老买家数',
    `old_pay_amount` DECIMAL(12,2) COMMENT '老买家支付金额',
    `customer_price` DECIMAL(10,2) COMMENT '客单价',
    `refund_amount` DECIMAL(12,2) COMMENT '成功退款退货金额',
    `juhuasuan_pay_amount` DECIMAL(12,2) COMMENT '聚划算支付金额',
    `annual_pay_amount` DECIMAL(15,2) COMMENT '年累计支付金额',
    `avg_visitor_value` DECIMAL(10,2) COMMENT '访客平均价值',
    `competitiveness_score` INT COMMENT '竞争力评分（0-100）',
    `active_product_count` INT COMMENT '动销商品数',
    `item_price` DECIMAL(10,2) COMMENT '件单价',
    `create_time` DATETIME COMMENT '记录创建时间'
    )
    DUPLICATE KEY(id,`product_id`, `stat_date`, `time_dimension`)
    DISTRIBUTED BY HASH(`product_id`) BUCKETS 10
    PROPERTIES (
                   "replication_num" = "2",  -- 副本数，生产环境根据集群节点数调整，测试环境可设 1
                   "storage_medium" = "HDD",
                   "compression" = "zstd"
               );

-- Doris 表结构（Duplicate 模型，存区间维度关联数据）
CREATE TABLE IF NOT EXISTS product_interval
(
    `id`             BIGINT COMMENT '自增主键',
    `product_id`     BIGINT COMMENT '商品ID（外键关联 product_info）',
    `stat_date`      DATE COMMENT '统计日期',
    `interval_type`  VARCHAR(20) COMMENT '区间类型（price_band/pay_item_count/pay_amount 等）',
    `interval_range` VARCHAR(50) COMMENT '区间范围（如 0~50、51~100）',
    `category_id`    BIGINT COMMENT '叶子类目ID',
    `sort_index`     INT COMMENT '排序指标对应值（如动销商品数、支付金额等）',
    `create_time`    DATETIME COMMENT '记录创建时间'
    )
    DUPLICATE KEY(id,`product_id`, `stat_date`, `interval_type`)  -- 组合唯一键
    DISTRIBUTED BY HASH(`product_id`) BUCKETS 10
    PROPERTIES (
                   "replication_num" = "2",  -- 副本数，生产环境根据集群节点数调整，测试环境可设 1
                   "storage_medium" = "HDD",
                   "compression" = "zstd"
               );