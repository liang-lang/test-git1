create database if not exists schema;
use schema;
CREATE TABLE `page_visit` (
 `id` BIGINT NOT NULL COMMENT '主键ID',
 `date` DATE NOT NULL COMMENT '统计日期',
 `page_type` VARCHAR(65533) NOT NULL COMMENT '页面类型',
 `page_name` VARCHAR(65533) NOT NULL COMMENT '页面名称',
 `visitor_count` INT NOT NULL COMMENT '页面访客数',
 `pv` INT NOT NULL COMMENT '页面浏览量',
 `avg_stay_time` FLOAT COMMENT '平均停留时长',
 `order_buyer_count` INT COMMENT '下单买家数',
 `terminal_type` VARCHAR(65533) NOT NULL COMMENT '终端类型（无线端/PC端等）'
)
UNIQUE KEY(`id`)
DISTRIBUTED BY HASH(`id`) BUCKETS 10
PROPERTIES (
  "replication_num" = "2",
  "storage_medium" = "HDD"  -- 改为 HDD，适配现有节点
);
select * from page_visit;
CREATE TABLE `instore_path` (
 `id` BIGINT NOT NULL COMMENT '主键ID',
 `date` DATE NOT NULL COMMENT '统计日期',
 `visitor_id` VARCHAR(50) NOT NULL COMMENT '访客唯一标识',
 `from_page` VARCHAR(100) COMMENT '来源页面',
 `to_page` VARCHAR(100) NOT NULL COMMENT '去向页面',
 `stay_time` INT COMMENT '停留时间（秒）'
) UNIQUE KEY(`id`)
DISTRIBUTED BY HASH(`id`) BUCKETS 10
PROPERTIES (
  "replication_num" = "2",
  "storage_medium" = "HDD",
  "compression" = "zstd"
) ;
select * from instore_path;
CREATE TABLE `source_stats` (
 `id` BIGINT NOT NULL COMMENT '主键ID',
 `date` DATE NOT NULL COMMENT '统计日期',
 `source_page` VARCHAR(100) NOT NULL COMMENT '来源页面',
 `source_count` INT NOT NULL COMMENT '来源访客数',
 `source_ratio` FLOAT(5, 2) NOT NULL COMMENT '来源占比'
)
    UNIQUE KEY(`id`)
DISTRIBUTED BY HASH(`id`) BUCKETS 10
PROPERTIES (
  "replication_num" = "2",
  "storage_medium" = "HDD",
  "compression" = "zstd"
) ;
select * from source_stats;