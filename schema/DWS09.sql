CREATE TABLE `dws_page_visit` (
 `date` DATE NOT NULL COMMENT '统计日期',
 `page_type` VARCHAR(65533) NOT NULL COMMENT '页面类型',
 `total_visitor` BIGINT   COMMENT '总访客数（汇总）',
 `total_pv` BIGINT   COMMENT '总浏览量（汇总）',
 `avg_stay` FLOAT   COMMENT '平均停留时长（均值）',
 `total_order` BIGINT   COMMENT '总下单数（汇总）'

) UNIQUE KEY(`date`, `page_type`)  -- 聚合键：日期 + 页面类型
    DISTRIBUTED BY HASH(`date`) BUCKETS 8
PROPERTIES (
    "replication_num" = "2",
    "storage_medium" = "HDD"
) ;

-- 说明：每日定时执行，聚合 DWD 层数据到 DWS 层
INSERT INTO dws_page_visit
SELECT
    date,
    page_type,
    SUM(visitor_count) AS total_visitor,
    SUM(pv) AS total_pv,
    AVG(avg_stay_time) AS avg_stay,
    SUM(order_buyer_count) AS total_order
FROM  page_visit
GROUP BY date, page_type;


CREATE TABLE `dws_instore_path` (
  `date` DATE NOT NULL COMMENT '统计日期',
  `from_page` VARCHAR(100) NOT NULL COMMENT '来源页面',
  `to_page` VARCHAR(100) NOT NULL COMMENT '去向页面',
  `visitor_count` BIGINT   COMMENT '访客数（去重后汇总）',
  `total_stay_time` BIGINT   COMMENT '总停留时间（秒）',
  `path_visit_count` BIGINT   COMMENT '路径访问次数'

) UNIQUE KEY(`date`, `from_page`, `to_page`)  -- 唯一键保证聚合唯一性
    PARTITION BY RANGE(`date`) (  -- 继承 DWD 层分区
        PARTITION p202501 VALUES LESS THAN ('2025-02-01'),
        PARTITION p202502 VALUES LESS THAN ('2025-03-01')
        )
    DISTRIBUTED BY HASH(`from_page`) BUCKETS 8
PROPERTIES (
    "replication_num" = "2",
    "storage_medium" = "HDD",
    "compression" = "zstd"
) ;

INSERT INTO dws_instore_path
    SELECT
        `date`,
        `from_page`,
        `to_page`,
        COUNT(DISTINCT `visitor_id`) AS visitor_count,
        SUM(`stay_time`) AS total_stay_time,
        COUNT(*) AS path_visit_count
    FROM dwd_instore_path
    GROUP BY `date`, `from_page`, `to_page`;

-- 检查 DWD 层停留时间异常值
SELECT * FROM dwd_instore_path
WHERE stay_time < 0 OR stay_time > 3600;  -- 停留时间>1小时视为异常



CREATE TABLE `dws_source_stats` (
 `date` DATE NOT NULL COMMENT '统计日期',
 `source_page` VARCHAR(100) NOT NULL COMMENT '来源页面',
 `total_visitor` BIGINT   COMMENT '总访客数（去重后汇总）',
 `max_ratio` FLOAT   COMMENT '最大来源占比',
 `avg_ratio` FLOAT   COMMENT '平均来源占比'

) UNIQUE KEY(`date`, `source_page`)  -- 唯一键保证聚合唯一性
    PARTITION BY RANGE(`date`) (  -- 继承 DWD 层分区
        PARTITION p202501 VALUES LESS THAN ('2025-02-01'),
        PARTITION p202502 VALUES LESS THAN ('2025-03-01')
        )
    DISTRIBUTED BY HASH(`source_page`) BUCKETS 8
PROPERTIES (
    "replication_num" = "2",
    "storage_medium" = "HDD",
    "compression" = "zstd"
) ;
INSERT INTO dws_source_stats
  SELECT
      `date`,
      `source_page`,
      COUNT(DISTINCT `id`) AS total_visitor,  -- 去重访客数
      MAX(`source_ratio`) AS max_ratio,       -- 最大占比
      AVG(`source_ratio`) AS avg_ratio        -- 平均占比
  FROM dwd_source_stats
  GROUP BY `date`, `source_page`;