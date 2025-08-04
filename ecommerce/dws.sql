CREATE TABLE dws_page_base_info (
  page_id INT NOT NULL,
  page_name VARCHAR(100) NOT NULL,
  page_type TINYINT NOT NULL,
  is_valid TINYINT NOT NULL,
  create_time DATETIME NOT NULL
)
    UNIQUE KEY (page_id)
    DISTRIBUTED BY HASH(page_id) BUCKETS 10
PROPERTIES ("replication_num" = "1");

-- 数据加工：从 DWD 层关联同步
INSERT INTO dws_page_base_info
SELECT
    pi.page_id,
    pi.page_name,
    pi.page_type,
    pi.is_valid,
    pi.create_time
FROM page_info pi;


CREATE TABLE dws_page_daily_traffic (
 stat_date DATE NOT NULL,
 page_id INT NOT NULL,
 visitor_count INT NOT NULL,
 click_count INT NOT NULL,
 click_user_count INT NOT NULL

)
    UNIQUE KEY(stat_date, page_id)
    PARTITION BY RANGE (stat_date) (
        PARTITION p202501 VALUES [('2025-01-01'), ('2025-02-01'))
    )
DISTRIBUTED BY HASH(page_id) BUCKETS 10
PROPERTIES ("replication_num" = "1");

-- 数据加工：从 DWD 层聚合
INSERT INTO dws_page_daily_traffic
SELECT
    pt.stat_date,
    pt.page_id,
    SUM(pt.visitor_count) AS visitor_count,
    SUM(pt.click_count) AS click_count,
    SUM(pt.click_user_count) AS click_user_count
FROM  page_traffic pt
GROUP BY pt.stat_date, pt.page_id;
select * from dws_page_daily_traffic;

CREATE TABLE dws_page_block_daily_click (
  stat_date DATE NOT NULL,
  page_id INT NOT NULL,
  block_name VARCHAR(100) NOT NULL,
  block_click_count INT NOT NULL,
  block_click_user_count INT NOT NULL,
  guide_pay_amount DECIMAL(10,2) NOT NULL

)
    UNIQUE KEY (stat_date, page_id, block_name)
    PARTITION BY RANGE (stat_date) (
        PARTITION p202501 VALUES [('2025-01-01'), ('2025-02-01'))
    )
DISTRIBUTED BY HASH(page_id) BUCKETS 10
PROPERTIES ("replication_num" = "1");

-- 数据加工：从 DWD 层聚合
INSERT INTO dws_page_block_daily_click
SELECT
    pbc.stat_date,
    pbc.page_id,
    pbc.block_name,
    SUM(pbc.block_click_count) AS block_click_count,
    SUM(pbc.block_click_user) AS block_click_user_count,
    SUM(pbc.guide_pay_amount) AS guide_pay_amount
FROM  page_block_click pbc
GROUP BY pbc.stat_date, pbc.page_id, pbc.block_name;
select * from dws_page_block_daily_click;



CREATE TABLE dws_page_daily_guide (
 stat_date DATE NOT NULL,
 page_id INT NOT NULL,
 guide_visit_count INT NOT NULL,
 guide_visitor_count INT NOT NULL,
 guide_buyer_count INT NOT NULL

)
    UNIQUE KEY (stat_date, page_id)
    PARTITION BY RANGE (stat_date) (
        PARTITION p202501 VALUES [('2025-01-01'), ('2025-02-01'))
    )
DISTRIBUTED BY HASH(page_id) BUCKETS 10
PROPERTIES ("replication_num" = "1");

-- 数据加工：从 DWD 层聚合
INSERT INTO dws_page_daily_guide
SELECT
    pgd.stat_date,
    pgd.page_id,
    SUM(pgd.guide_visit_count) AS guide_visit_count,
    SUM(pgd.guide_visitor_count) AS guide_visitor_count,
    SUM(pgd.guide_buyer_count) AS guide_buyer_count
FROM  page_guide_detail pgd
GROUP BY pgd.stat_date, pgd.page_id;
select * from dws_page_daily_guide;