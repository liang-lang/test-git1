create database if not exists ecommerce;
use ecommerce;
CREATE TABLE IF NOT EXISTS page_info (
 page_id INT NOT NULL,
 page_name VARCHAR(100) NOT NULL,
 page_type TINYINT NOT NULL,
 create_time DATETIME NOT NULL,
 is_valid TINYINT NOT NULL
)comment '页面基础信息表'
    ENGINE=OLAP
    UNIQUE KEY(page_id)
DISTRIBUTED BY HASH(page_id) BUCKETS 10
PROPERTIES (
    "replication_num" = "1"
);
select * from page_info;

CREATE TABLE IF NOT EXISTS page_traffic (
 id BIGINT NOT NULL,
 page_id INT NOT NULL,
 stat_date DATE NOT NULL,
 visitor_count INT NOT NULL,
 click_count INT NOT NULL,
 click_user_count INT NOT NULL,
 update_time DATETIME NOT NULL
)comment '页面访问与点击表'
    ENGINE=OLAP
    UNIQUE KEY(id, page_id, stat_date) -- 调整为符合“有序前缀”的顺序
PARTITION BY RANGE(stat_date) (
    PARTITION p202501 VALUES [('2025-01-01'), ('2025-02-01'))
)
DISTRIBUTED BY HASH(page_id) BUCKETS 10
PROPERTIES (
    "replication_num" = "1"
);


CREATE TABLE IF NOT EXISTS page_block_click (
 id BIGINT NOT NULL,
 page_id INT NOT NULL,
 block_name VARCHAR(100) NOT NULL,
 stat_date DATE NOT NULL,
 block_click_count INT NOT NULL,
 block_click_user INT NOT NULL,
 guide_pay_amount DECIMAL(10,2) NOT NULL,
 update_time DATETIME NOT NULL
)comment '页面板块点击分布表'
    ENGINE=OLAP
-- 按表字段顺序，调整唯一键为id、page_id、block_name、stat_date
    UNIQUE KEY(id, page_id, block_name, stat_date)
PARTITION BY RANGE(stat_date) (
    PARTITION p202501 VALUES [('2025-01-01'), ('2025-02-01'))
)
DISTRIBUTED BY HASH(page_id) BUCKETS 10
PROPERTIES (
    "replication_num" = "1"
);

CREATE TABLE IF NOT EXISTS page_guide_detail (
 id BIGINT NOT NULL,
 page_id INT NOT NULL,
 stat_date DATE NOT NULL,
 guide_visit_count INT NOT NULL,
 guide_visitor_count INT NOT NULL,
 guide_buyer_count INT NOT NULL,
 update_time DATETIME NOT NULL
)comment '页面引导详情表'
    ENGINE=OLAP
-- 按表字段顺序，调整唯一键为id、page_id、stat_date
    UNIQUE KEY(id, page_id, stat_date)
PARTITION BY RANGE(stat_date) (
    PARTITION p202501 VALUES [('2025-01-01'), ('2025-02-01'))
)
DISTRIBUTED BY HASH(page_id) BUCKETS 10
PROPERTIES (
    "replication_num" = "1"
);