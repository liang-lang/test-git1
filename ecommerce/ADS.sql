CREATE TABLE ads_page_core_metrics (
 stat_date DATE NOT NULL,
 page_id INT NOT NULL,
 page_name VARCHAR(100) NOT NULL,
 page_type TINYINT NOT NULL,
 visitor_count INT NOT NULL,
 click_count INT NOT NULL,
 guide_buyer_count INT NOT NULL

)
    UNIQUE KEY (stat_date, page_id)
    PARTITION BY RANGE (stat_date) (
        PARTITION p202501 VALUES [('2025-01-01'), ('2025-02-01'))
    )
DISTRIBUTED BY HASH(page_id) BUCKETS 10
PROPERTIES ("replication_num" = "1");

-- 汇总页面每日访问、点击、引导转化核心指标
INSERT INTO ads_page_core_metrics
SELECT
    dpt.stat_date,
    dpt.page_id,
    pbi.page_name,
    pbi.page_type,
    dpt.visitor_count,
    dpt.click_count,
    dpg.guide_buyer_count
FROM dws_page_daily_traffic dpt
         JOIN dws_page_base_info pbi ON dpt.page_id = pbi.page_id
         JOIN dws_page_daily_guide dpg ON dpt.stat_date = dpg.stat_date AND dpt.page_id = dpg.page_id;


CREATE TABLE ads_page_block_click_topn (
  stat_date DATE NOT NULL,
  page_id INT NOT NULL,
  block_name VARCHAR(100) NOT NULL,
  block_click_count INT NOT NULL,
  block_click_rank INT NOT NULL

)
    UNIQUE KEY (stat_date, page_id, block_name)
    PARTITION BY RANGE (stat_date) (
        PARTITION p202501 VALUES [('2025-01-01'), ('2025-02-01'))
    )
DISTRIBUTED BY HASH(page_id) BUCKETS 10
PROPERTIES ("replication_num" = "1");

-- 数据加工：用窗口函数取 TopN按日统计页面内点击量最高的板块。
INSERT INTO ads_page_block_click_topn
SELECT
    stat_date,
    page_id,
    block_name,
    block_click_count,
    block_click_rank
FROM (
         SELECT
             stat_date,
             page_id,
             block_name,
             block_click_count,
             ROW_NUMBER() OVER (
                 PARTITION BY stat_date, page_id
                 ORDER BY block_click_count DESC
                 ) AS block_click_rank
         FROM dws_page_block_daily_click
     ) sub
WHERE block_click_rank <= 5;
select *from ads_page_block_click_topn;


CREATE TABLE ads_page_type_conversion (
   stat_date DATE NOT NULL,
   page_type TINYINT NOT NULL,
   page_count INT NOT NULL,  -- 该类型页面数量
   total_visitor_count INT NOT NULL,
   total_guide_buyer_count INT NOT NULL,
   conversion_rate DECIMAL(5,2) NOT NULL -- 转化率 = 购买数 / 访问数

)
    UNIQUE KEY (stat_date, page_type)
    PARTITION BY RANGE (stat_date) (
        PARTITION p202501 VALUES [('2025-01-01'), ('2025-02-01'))
    )
DISTRIBUTED BY HASH(page_type) BUCKETS 5
PROPERTIES ("replication_num" = "1");

-- 数据加工：分析不同页面类型（如首页、商品页）的引导购买转化率。
INSERT INTO ads_page_type_conversion
SELECT
    stat_date,
    page_type,
    COUNT(DISTINCT page_id) AS page_count,
    SUM(visitor_count) AS total_visitor_count,
    SUM(guide_buyer_count) AS total_guide_buyer_count,
    -- 避免除零：用 CASE WHEN 处理
    CASE
        WHEN SUM(visitor_count) = 0 THEN 0
        ELSE ROUND(SUM(guide_buyer_count) / SUM(visitor_count) * 100, 2)
        END AS conversion_rate
FROM ads_page_core_metrics
GROUP BY stat_date, page_type;
select * from ads_page_type_conversion;