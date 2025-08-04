CREATE TABLE `ads_page_visit` (
 `date` DATE NOT NULL COMMENT '统计日期',
 `page_type` VARCHAR(65533) NOT NULL COMMENT '页面类型',
 `total_visitor` BIGINT COMMENT '总访客数',
 `total_pv` BIGINT COMMENT '总浏览量',
 `stay_rate` FLOAT COMMENT '停留率（PV/访客数）',
 `order_conversion` FLOAT COMMENT '下单转化率（下单数/访客数）'

)UNIQUE KEY(`date`, `page_type`)
    DISTRIBUTED BY HASH(`date`) BUCKETS 5
PROPERTIES (
    "replication_num" = "2",
    "storage_medium" = "HDD"  -- 应用层用 SSD 加速查询
) ;
-- 说明：计算衍生指标（停留率、转化率）
INSERT INTO ads_page_visit
SELECT
    date,
    page_type,
    total_visitor,
    total_pv,
    -- 停留率 = 浏览量 / 访客数（需处理除数为0）
    CASE
        WHEN total_visitor = 0 THEN 0
        ELSE CAST(total_pv AS FLOAT) / total_visitor
        END AS stay_rate,
    -- 下单转化率 = 下单数 / 访客数（需处理除数为0）
    CASE
        WHEN total_visitor = 0 THEN 0
        ELSE CAST(total_order AS FLOAT) / total_visitor
        END AS order_conversion
FROM dws_page_visit;
select * from ads_page_visit;

--  查询 2025年1月 各页面类型的转化率
SELECT
    page_type,
    order_conversion
FROM ads_page_visit
WHERE date BETWEEN '2025-01-01' AND '2025-01-31'
ORDER BY order_conversion DESC;


CREATE TABLE `ads_instore_path` (
 `date` DATE NOT NULL COMMENT '统计日期',
 `from_page` VARCHAR(100) NOT NULL COMMENT '来源页面',
 `conversion_rate` FLOAT COMMENT '关键页面转化率',
 `avg_stay_time` FLOAT COMMENT '平均停留时间（秒）',
 `top3_to_pages` VARCHAR(300) COMMENT 'Top 3 去向页面（逗号分隔）'
)
    UNIQUE KEY(`date`, `from_page`)
DISTRIBUTED BY HASH(`date`) BUCKETS 5
PROPERTIES (
    "replication_num" = "2",
    "storage_medium" = "HDD",  -- 改用集群支持的存储介质
    "compression" = "zstd"
);

INSERT INTO ads_instore_path
SELECT
    `date`,
    `from_page`,
    -- 关键页面转化率（正确聚合）
    SUM(CASE WHEN `to_page` = 'checkout' THEN `path_visit_count` ELSE 0 END)
        / SUM(`path_visit_count`) AS conversion_rate,
    AVG(`total_stay_time` / `path_visit_count`) AS avg_stay_time,
    -- 规范 GROUP_CONCAT：排序+分隔
    GROUP_CONCAT(DISTINCT `to_page` ORDER BY `path_visit_count`)
        AS top_to_pages
FROM dws_instore_path
GROUP BY `date`, `from_page`;
-- 1. 按日期查询来源页面转化情况
SELECT
    `date`,
    `from_page`,
    `conversion_rate`,
    `avg_stay_time`,
    `top3_to_pages`
FROM ads_instore_path
WHERE `date` = '2025-01-01'
ORDER BY `conversion_rate` DESC;

-- 2. 对比不同日期的转化趋势
SELECT
    `date`,
    `from_page`,
    `conversion_rate`
FROM ads_instore_path
WHERE `from_page` = 'homepage'
ORDER BY `date`;


CREATE TABLE `ads_source_stats` (
  `date` DATE NOT NULL COMMENT '统计日期',
  `source_page` VARCHAR(100) NOT NULL COMMENT '来源页面',
  `top_visitor_rank` VARCHAR(300) COMMENT 'TOP 3 来源（按访客数排序）',
  `ratio_trend` VARCHAR(300) COMMENT '占比趋势（近7日变化）',
  `visitor_distribution` FLOAT COMMENT '访客数占比（全渠道）'
)
    UNIQUE KEY(`date`, `source_page`)
DISTRIBUTED BY HASH(`date`) BUCKETS 5
PROPERTIES (
    "replication_num" = "2",
    "storage_medium" = "HDD",  -- 改用集群支持的存储介质
    "compression" = "zstd"
);

SELECT
    `date`,
    `source_page`,
    -- 子查询实现 TOP 3 来源（按访客数排序，逗号分隔）
    (SELECT GROUP_CONCAT(`source_page` ORDER BY `total_visitor` DESC SEPARATOR ',')
     FROM (
              SELECT `source_page`, `total_visitor`
              FROM dws_source_stats
              WHERE `date` = t.`date`
              ORDER BY `total_visitor` DESC
              LIMIT 3
          ) sub
    ) AS top_visitor_rank,
    -- 占比趋势（对比昨日，保留 2 位小数，拼接百分比）
    CONCAT(
            ROUND(
                        ( (`avg_ratio` - LAG(`avg_ratio`, 1) OVER w) / `avg_ratio` ) * 100,
                        2
                ),
            '%'
        ) AS ratio_trend,
    -- 访客数占比（全渠道，按日期分区）
    `total_visitor` / SUM(`total_visitor`) OVER (PARTITION BY `date`) AS visitor_distribution
FROM dws_source_stats t
-- 窗口定义：按日期、来源页面分区，日期排序（用于 LAG 函数）
    WINDOW w AS (PARTITION BY `date`, `source_page` ORDER BY `date`);


-- 1. 按日期查询 TOP 来源页面
SELECT
    `date`,
    `source_page`,
    `top_visitor_rank`,
    `ratio_trend`
FROM ads_source_stats
WHERE `date` = '2025-01-01'
ORDER BY `visitor_distribution` DESC;

-- 2. 分析来源占比趋势
SELECT
    `date`,
    `source_page`,
    `ratio_trend`
FROM ads_source_stats
WHERE `source_page` = 'homepage'
ORDER BY `date`;