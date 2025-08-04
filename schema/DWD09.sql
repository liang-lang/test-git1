use `schema`;
CREATE TABLE `dwd_page_visit` (
 `date` DATE NOT NULL COMMENT '统计日期',  -- 分区列提前，作为KEY列的前缀
 `id` BIGINT NOT NULL COMMENT '主键ID',
 `page_type` VARCHAR(50) NOT NULL COMMENT '页面类型',
 `page_name` VARCHAR(100) NOT NULL COMMENT '页面名称',
 `visitor_count` INT NOT NULL COMMENT '访客数'
    -- 关键：分区列`date`包含在UNIQUE KEY中，且是有序前缀

)  UNIQUE KEY(`date`, `id`)
    PARTITION BY RANGE(`date`) (  -- 分区列`date`已在KEY列中
        PARTITION p202501 VALUES LESS THAN ('2025-02-01'),
        PARTITION p202502 VALUES LESS THAN ('2025-03-01')
        )
    DISTRIBUTED BY HASH(`id`) BUCKETS 10
PROPERTIES (
    "replication_num" = "2",

    "storage_medium" = "HDD"
);
INSERT INTO dwd_page_visit (
    `date`, `id`, `page_type`, `page_name`, `visitor_count`
)
SELECT
    `date`, `id`, `page_type`, `page_name`, `visitor_count`
FROM page_visit
WHERE date >= '2025-01-01';
select *from dwd_page_visit;


CREATE TABLE `dwd_instore_path` (
 `date` DATE NOT NULL COMMENT '统计日期', -- 分区列提前，作为 KEY 前缀
 `id` BIGINT NOT NULL COMMENT '主键ID',
 `visitor_id` VARCHAR(50) NOT NULL COMMENT '访客唯一标识',
 `from_page` VARCHAR(100) COMMENT '来源页面',
 `to_page` VARCHAR(100) NOT NULL COMMENT '去向页面',
 `stay_time` INT COMMENT '停留时间（秒）'
)
    UNIQUE KEY(`date`, `id`) -- 分区列 `date` 加入 UNIQUE KEY
PARTITION BY RANGE(`date`) (
    PARTITION p202501 VALUES LESS THAN ('2025-02-01'),
    PARTITION p202502 VALUES LESS THAN ('2025-03-01')
)
DISTRIBUTED BY HASH(`id`) BUCKETS 10
PROPERTIES (
    "replication_num" = "2",
    "storage_medium" = "HDD",
    "compression" = "zstd"
);-- 全量同步+增量过滤（只同步2025年1月后的数据）
-- 设置会话级参数（可选）
SET SESSION max_filter_ratio = 0.1;

-- 插入数据
INSERT INTO dwd_instore_path (
    `id`, `date`, `visitor_id`, `from_page`, `to_page`, `stay_time`
)
SELECT
    `id`, `date`, `visitor_id`, `from_page`, `to_page`, `stay_time`
FROM instore_path;
select *from dwd_instore_path;


-- DWD层：来源统计明细（保留原始字段+分区优化）
CREATE TABLE `dwd_source_stats` (
         `date` DATE NOT NULL COMMENT '统计日期', -- 调整为第一个字段，作为 KEY 前缀
         `id` BIGINT NOT NULL COMMENT '主键ID',
         `source_page` VARCHAR(100) NOT NULL COMMENT '来源页面',
         `source_count` INT NOT NULL COMMENT '来源访客数',
         `source_ratio` FLOAT NOT NULL COMMENT '来源占比'
)
    UNIQUE KEY(`date`, `id`) -- 分区列 `date` 加入 UNIQUE KEY
PARTITION BY RANGE(`date`) (
    PARTITION p202501 VALUES LESS THAN ('2025-02-01'),
    PARTITION p202502 VALUES LESS THAN ('2025-03-01')
)
DISTRIBUTED BY HASH(`id`) BUCKETS 10
PROPERTIES (
    "replication_num" = "2",
    "storage_medium" = "HDD",
    "compression" = "zstd"
);
-- 全量同步+增量过滤（只同步2025年1月后的数据）
SET SESSION max_filter_ratio = 0.1;
INSERT INTO dwd_source_stats
SELECT
    `id`, `date`, `source_page`, `source_count`, `source_ratio`
FROM source_stats
WHERE `date` >= '2025-01-01';
SET SESSION max_filter_ratio = 0.1;-- 按业务需求调整时间范围
select * from dwd_source_stats;