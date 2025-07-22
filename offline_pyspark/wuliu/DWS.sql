-- 1. 最近 1 日汇总表
-- 1.1 交易域机构货物类型粒度下单 1 日汇总表
use tms01;
drop table if exists dws_trade_org_cargo_type_order_1d;
create external table dws_trade_org_cargo_type_order_1d(
	`org_id` bigint comment '机构ID',
	`org_name` string comment '转运站名称',
	`city_id` bigint comment '城市ID',
	`city_name` string comment '城市名称',
	`cargo_type` string comment '货物类型',
	`cargo_type_name` string comment '货物类型名称',
	`order_count` bigint comment '下单数',
	`order_amount` decimal(16,2) comment '下单金额'
) comment '交易域机构货物类型粒度下单 1 日汇总表'
	partitioned by(`ds` string comment '统计日期')
	stored as orc
	location '/warehouse/tms/dws/dws_trade_org_cargo_type_order_1d'
	tblproperties('orc.compress' = 'snappy');

-- 1.2 物流域转运站粒度揽收 1 日汇总表
drop table if exists dws_trans_org_receive_1d;
create external table dws_trans_org_receive_1d(
	`org_id` bigint comment '转运站ID',
	`org_name` string comment '转运站名称',
	`city_id` bigint comment '城市ID',
	`city_name` string comment '城市名称',
	`province_id` bigint comment '省份ID',
	`province_name` string comment '省份名称',
	`order_count` bigint comment '揽收次数',
	`order_amount` decimal(16, 2) comment '揽收金额'
) comment '物流域转运站粒度揽收 1 日汇总表'
	partitioned by (`ds` string comment '统计日期')
	stored as orc
	location '/warehouse/tms/dws/dws_trans_org_receive_1d/'
	tblproperties ('orc.compress'='snappy');

-- 1.3 物流域发单 1 日汇总表
drop table if exists dws_trans_dispatch_1d;
create external table dws_trans_dispatch_1d(
	`order_count` bigint comment '发单总数',
	`order_amount` decimal(16,2) comment '发单总金额'
) comment '物流域发单 1 日汇总表'
	partitioned by (`ds` string comment '统计日期')
	stored as orc
	location '/warehouse/tms/dws/dws_trans_dispatch_1d/'
	tblproperties('orc.compress'='snappy');

-- 1.4 物流域机构卡车类别粒度运输最近 1 日汇总表
drop table if exists dws_trans_org_truck_model_type_trans_finish_1d;
create external table dws_trans_org_truck_model_type_trans_finish_1d(
	`org_id` bigint comment '机构ID',
	`org_name` string comment '机构名称',
	`truck_model_type` string comment '卡车类别编码',
	`truck_model_type_name` string comment '卡车类别名称',
	`trans_finish_count` bigint comment '运输完成次数',
	`trans_finish_distance` decimal(16,2) comment '运输完成里程',
	`trans_finish_dur_sec` bigint comment '运输完成时长，单位：秒'
) comment '物流域机构卡车类别粒度运输最近 1 日汇总表'
	partitioned by (`ds` string comment '统计日期')
	stored as orc
	location '/warehouse/tms/dws/dws_trans_org_truck_model_type_trans_finish_1d/'
	tblproperties('orc.compress'='snappy');

-- 1.5 物流域转运站粒度派送成功 1 日汇总表
drop table if exists dws_trans_org_deliver_suc_1d;
create external table dws_trans_org_deliver_suc_1d(
	`org_id` bigint comment '转运站ID',
	`org_name` string comment '转运站名称',
	`city_id` bigint comment '城市ID',
	`city_name` string comment '城市名称',
	`province_id` bigint comment '省份ID',
	`province_name` string comment '省份名称',
	`order_count` bigint comment '派送成功次数（订单数）'
) comment '物流域转运站粒度派送成功 1 日汇总表'
	partitioned by (`ds` string comment '统计日期')
	stored as orc
	location '/warehouse/tms/dws/dws_trans_org_deliver_suc_1d/'
	tblproperties('orc.compress'='snappy');

-- 1.6 物流域机构粒度分拣 1 日汇总表
drop table if exists dws_trans_org_sort_1d;
create external table dws_trans_org_sort_1d(
	`org_id` bigint comment '机构ID',
	`org_name` string comment '机构名称',
	`city_id` bigint comment '城市ID',
	`city_name` string comment '城市名称',
	`province_id` bigint comment '省份ID',
	`province_name` string comment '省份名称',
	`sort_count` bigint comment '分拣次数'
) comment '物流域机构粒度分拣 1 日汇总表'
	partitioned by (`ds` string comment '统计日期')
	stored as orc
	location '/warehouse/tms/dws/dws_trans_org_sort_1d/'
	tblproperties('orc.compress'='snappy');

-- 2. 最近 n 日汇总表
-- 2.1 交易域机构货物类型粒度下单 n 日汇总表
drop table if exists dws_trade_org_cargo_type_order_nd;
create external table dws_trade_org_cargo_type_order_nd(
	`org_id` bigint comment '机构ID',
	`org_name` string comment '转运站名称',
	`city_id` bigint comment '城市ID',
	`city_name` string comment '城市名称',
	`cargo_type` string comment '货物类型',
	`cargo_type_name` string comment '货物类型名称',
	`recent_days` tinyint comment '最近天数',
	`order_count` bigint comment '下单数',
	`order_amount` decimal(16,2) comment '下单金额'
) comment '交易域机构货物类型粒度下单 n 日汇总表'
	partitioned by(`ds` string comment '统计日期')
	stored as orc
	location '/warehouse/tms/dws/dws_trade_org_cargo_type_order_nd'
	tblproperties('orc.compress' = 'snappy');

-- 2.2 物流域转运站粒度揽收 n 日汇总表
drop table if exists dws_trans_org_receive_nd;
create external table dws_trans_org_receive_nd(
	`org_id` bigint comment '转运站ID',
	`org_name` string comment '转运站名称',
	`city_id` bigint comment '城市ID',
	`city_name` string comment '城市名称',
	`province_id` bigint comment '省份ID',
	`province_name` string comment '省份名称',
	`recent_days` tinyint comment '最近天数',
	`order_count` bigint comment '揽收次数',
	`order_amount` decimal(16, 2) comment '揽收金额'
) comment '物流域转运站粒度揽收 n 日汇总表'
	partitioned by (`ds` string comment '统计日期')
	stored as orc
	location '/warehouse/tms/dws/dws_trans_org_receive_nd/'
	tblproperties ('orc.compress'='snappy');

-- 2.3 物流域发单 n 日汇总表
drop table if exists dws_trans_dispatch_nd;
create external table dws_trans_dispatch_nd(
	`recent_days` tinyint comment '最近天数',
	`order_count` bigint comment '发单总数',
	`order_amount` decimal(16,2) comment '发单总金额'
) comment '物流域发单 1 日汇总表'
	partitioned by (`ds` string comment '统计日期')
	stored as orc
	location '/warehouse/tms/dws/dws_trans_dispatch_1d/'
	tblproperties('orc.compress'='snappy');

-- 2.4 物流域班次粒度转运完成最近 n 日汇总表
drop table if exists dws_trans_shift_trans_finish_nd;
create external table dws_trans_shift_trans_finish_nd(
	`shift_id` bigint comment '班次ID',
	`city_id` bigint comment '城市ID',
	`city_name` string comment '城市名称',
	`org_id` bigint comment '机构ID',
	`org_name` string comment '机构名称',
	`line_id` bigint comment '线路ID',
	`line_name` string comment '线路名称',
	`driver1_emp_id` bigint comment '第一司机员工ID',
	`driver1_name` string comment '第一司机姓名',
	`driver2_emp_id` bigint comment '第二司机员工ID',
	`driver2_name` string comment '第二司机姓名',
	`truck_model_type` string comment '卡车类别编码',
	`truck_model_type_name` string comment '卡车类别名称',
	`recent_days` tinyint comment '最近天数',
	`trans_finish_count` bigint comment '转运完成次数',
	`trans_finish_distance` decimal(16,2) comment '转运完成里程',
	`trans_finish_dur_sec` bigint comment '转运完成时长，单位：秒',
	`trans_finish_order_count` bigint comment '转运完成运单数',
	`trans_finish_delay_count` bigint comment '逾期次数'
) comment '物流域班次粒度转运完成最近 n 日汇总表'
	partitioned by (`ds` string comment '统计日期')
	stored as orc
	location '/warehouse/tms/dws/dws_trans_shift_trans_finish_nd/'
	tblproperties('orc.compress'='snappy');

-- 2.5 物流域转运站粒度派送成功 n 日汇总表
drop table if exists dws_trans_org_deliver_suc_nd;
create external table dws_trans_org_deliver_suc_nd(
	`org_id` bigint comment '转运站ID',
	`org_name` string comment '转运站名称',
	`city_id` bigint comment '城市ID',
	`city_name` string comment '城市名称',
	`province_id` bigint comment '省份ID',
	`province_name` string comment '省份名称',
	`recent_days` tinyint comment '最近天数',
	`order_count` bigint comment '派送成功次数（订单数）'
) comment '物流域转运站粒度派送成功 n 日汇总表'
	partitioned by (`ds` string comment '统计日期')
	stored as orc
	location '/warehouse/tms/dws/dws_trans_org_deliver_suc_nd/'
	tblproperties('orc.compress'='snappy');

-- 2.6 物流域机构粒度分拣 n 日汇总表
drop table if exists dws_trans_org_sort_nd;
create external table dws_trans_org_sort_nd(
	`org_id` bigint comment '机构ID',
	`org_name` string comment '机构名称',
	`city_id` bigint comment '城市ID',
	`city_name` string comment '城市名称',
	`province_id` bigint comment '省份ID',
	`province_name` string comment '省份名称',
	`recent_days` tinyint comment '最近天数',
	`sort_count` bigint comment '分拣次数'
) comment '物流域机构粒度分拣 n 日汇总表'
	partitioned by (`ds` string comment '统计日期')
	stored as orc
	location '/warehouse/tms/dws/dws_trans_org_sort_nd/'
	tblproperties('orc.compress'='snappy');

-- 3. 历史至今汇总表
-- 3.1 物流域发单历史至今汇总表
drop table if exists dws_trans_dispatch_td;
create external table dws_trans_dispatch_td(
	`order_count` bigint comment '发单数',
	`order_amount` decimal(16,2) comment '发单金额'
) comment '物流域发单历史至今汇总表'
	partitioned by (`ds` string comment '统计日期')
	stored as orc
	location '/warehouse/tms/dws/dws_trans_dispatch_td'
	tblproperties('orc.compress'='snappy');

-- 3.2 物流域转运完成历史至今汇总表
drop table if exists dws_trans_bound_finish_td;
create external table dws_trans_bound_finish_td(
	`order_count` bigint comment '发单数',
	`order_amount` decimal(16,2) comment '发单金额'
) comment '物流域转运完成历史至今汇总表'
	partitioned by (`ds` string comment '统计日期')
	stored as orc
	location 'warehouse/tms/dws/dws_trans_bound_finish_td'
	tblproperties('orc.compress'='snappy');
    -- 1.1.1 首日装载
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table dws_trade_org_cargo_type_order_1d
    partition (ds)
select org_id,
       org_name,
       city_id,
       region.name city_name,
       cargo_type,
       cargo_type_name,
       order_count,
       order_amount,
       ds
from (select org_id,
             org_name,
             sender_city_id  city_id,
             cargo_type,
             cargo_type_name,
             count(order_id) order_count,
             sum(amount)     order_amount,
             ds
      from (select order_id,
                   cargo_type,
                   cargo_type_name,
                   sender_district_id,
                   sender_city_id,
                   sum(amount) amount,
                   ds
            from (select order_id,
                         cargo_type,
                         cargo_type_name,
                         sender_district_id,
                         sender_city_id,
                         amount,
                         ds
                  from dwd_trade_order_detail) detail
            group by order_id,
                     cargo_type,
                     cargo_type_name,
                     sender_district_id,
                     sender_city_id,
                     ds) distinct_detail
               left join
           (select id org_id,
                   org_name,
                   region_id
            from dim_organ
            where ds = '2023-01-10') org
           on distinct_detail.sender_district_id = org.region_id
      group by org_id,
               org_name,
               cargo_type,
               cargo_type_name,
               sender_city_id,
               ds) agg
         left join (
    select id,
           name
    from dim_region
    where ds = '2023-01-10'
) region on city_id = region.id;

-- 1.1.2 每日装载
insert overwrite table dws_trade_org_cargo_type_order_1d
    partition (ds = '2023-01-11')
select org_id,
       org_name,
       city_id,
       region.name city_name,
       cargo_type,
       cargo_type_name,
       order_count,
       order_amount
from (select org_id,
             org_name,
             city_id,
             cargo_type,
             cargo_type_name,
             count(order_id) order_count,
             sum(amount)     order_amount
      from (select order_id,
                   cargo_type,
                   cargo_type_name,
                   sender_district_id,
                   sender_city_id city_id,
                   sum(amount)    amount
            from (select order_id,
                         cargo_type,
                         cargo_type_name,
                         sender_district_id,
                         sender_city_id,
                         amount
                  from dwd_trade_order_detail
                  where ds = '2023-01-11') detail
            group by order_id,
                     cargo_type,
                     cargo_type_name,
                     sender_district_id,
                     sender_city_id) distinct_detail
               left join
           (select id org_id,
                   org_name,
                   region_id
            from dim_organ
            where ds = '2023-01-11') org
           on distinct_detail.sender_district_id = org.region_id
      group by org_id,
               org_name,
               city_id,
               cargo_type,
               cargo_type_name) agg
         left join (
    select id,
           name
    from dim_region
    where ds = '2023-01-11'
) region on city_id = region.id;

-- 2.1 dws_trade_org_cargo_type_order_nd
insert overwrite table dws_trade_org_cargo_type_order_nd
    partition (ds = '2023-01-10')
select org_id,
       org_name,
       city_id,
       city_name,
       cargo_type,
       cargo_type_name,
       recent_days,
       sum(order_count)  order_count,
       sum(order_amount) order_amount
from dws_trade_org_cargo_type_order_1d lateral view
    explode(array(7, 30)) tmp as recent_days
where ds >= date_add('2023-01-10', -recent_days + 1)
group by org_id,
    org_name,
    city_id,
    city_name,
    cargo_type,
    cargo_type_name,
    recent_days;

-- 1.2 dws_trans_org_receive_1d
-- 1.2.1 首日装载
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table dws_trans_org_receive_1d
    partition (ds)
select org_id,
       org_name,
       city_id,
       city_name,
       province_id,
       province_name,
       count(order_id)      order_count,
       sum(distinct_amount) order_amount,
       ds
from (select order_id,
             org_id,
             org_name,
             city_id,
             city_name,
             province_id,
             province_name,
             max(amount) distinct_amount,
             ds
      from (select order_id,
                   amount,
                   sender_district_id,
                   ds
            from dwd_trans_receive_detail) detail
               left join
           (select id org_id,
                   org_name,
                   region_id
            from dim_organ
            where ds = '2023-01-10') organ
           on detail.sender_district_id = organ.region_id
               left join
           (select id,
                   parent_id
            from dim_region
            where ds = '2023-01-10') district
           on region_id = district.id
               left join
           (select id   city_id,
                   name city_name,
                   parent_id
            from dim_region
            where ds = '2023-01-10') city
           on district.parent_id = city_id
               left join
           (select id   province_id,
                   name province_name,
                   parent_id
            from dim_region
            where ds = '2023-01-10') province
           on city.parent_id = province_id
      group by order_id,
               org_id,
               org_name,
               city_id,
               city_name,
               province_id,
               province_name,
               ds) distinct_tb
group by org_id,
         org_name,
         city_id,
         city_name,
         province_id,
         province_name,
         ds;

-- 1.2.2 每日装载
insert overwrite table dws_trans_org_receive_1d
    partition (ds = '2023-01-11')
select org_id,
       org_name,
       city_id,
       city_name,
       province_id,
       province_name,
       count(order_id)      order_count,
       sum(distinct_amount) order_amount
from (select order_id,
             org_id,
             org_name,
             city_id,
             city_name,
             province_id,
             province_name,
             max(amount) distinct_amount
      from (select order_id,
                   amount,
                   sender_district_id
            from dwd_trans_receive_detail
            where ds = '2023-01-11') detail
               left join
           (select id org_id,
                   org_name,
                   region_id
            from dim_organ
            where ds = '2023-01-11') organ
           on detail.sender_district_id = organ.region_id
               left join
           (select id,
                   parent_id
            from dim_region
            where ds = '2023-01-11') district
           on region_id = district.id
               left join
           (select id   city_id,
                   name city_name,
                   parent_id
            from dim_region
            where ds = '2023-01-11') city
           on district.parent_id = city_id
               left join
           (select id   province_id,
                   name province_name,
                   parent_id
            from dim_region
            where ds = '2023-01-11') province
           on city.parent_id = province_id
      group by order_id,
               org_id,
               org_name,
               city_id,
               city_name,
               province_id,
               province_name) distinct_tb
group by org_id,
         org_name,
         city_id,
         city_name,
         province_id,
         province_name;

-- 2.2 dws_trans_org_receive_nd
insert overwrite table dws_trans_org_receive_nd
    partition (ds = '2023-01-10')
select org_id,
       org_name,
       city_id,
       city_name,
       province_id,
       province_name,
       recent_days,
       sum(order_count)  order_count,
       sum(order_amount) order_amount
from dws_trans_org_receive_1d
         lateral view explode(array(7, 30)) tmp as recent_days
where ds >= date_add('2023-01-10', -recent_days + 1)
group by org_id,
    org_name,
    city_id,
    city_name,
    province_id,
    province_name,
    recent_days;

-- 1.3 dws_trans_dispatch_1d
-- 1.3.1 首日装载
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table dws_trans_dispatch_1d
    partition (ds)
select count(order_id)      order_count,
       sum(distinct_amount) order_amount,
       ds
from (select order_id,
             ds,
             max(amount) distinct_amount
      from dwd_trans_dispatch_detail
      group by order_id,
               ds) distinct_info
group by ds;

-- 1.3.2 每日装载
insert overwrite table dws_trans_dispatch_1d
    partition (ds = '2023-01-11')
select count(order_id)      order_count,
       sum(distinct_amount) order_amount
from (select order_id,
             max(amount) distinct_amount
      from dwd_trans_dispatch_detail
      where ds = '2023-01-11'
      group by order_id) distinct_info;

-- 2.3 dws_trans_dispatch_nd
insert overwrite table dws_trans_dispatch_nd
    partition (ds = '2023-01-10')
select recent_days,
       sum(order_count)  order_count,
       sum(order_amount) order_amount
from dws_trans_dispatch_1d lateral view
    explode(array(7, 30)) tmp as recent_days
where ds >= date_add('2023-01-10', -recent_days + 1)
group by recent_days;

-- 3.1 dws_trans_dispatch_td
-- 3.1.1 首日装载
insert overwrite table dws_trans_dispatch_td
    partition (ds = '2023-01-10')
select sum(order_count)  order_count,
       sum(order_amount) order_amount
from dws_trans_dispatch_1d;

-- 3.1.2 每日装载
insert overwrite table dws_trans_dispatch_td
    partition (ds = '2023-01-11')
select sum(order_count)  order_count,
       sum(order_amount) order_amount
from (select order_count,
             order_amount
      from dws_trans_dispatch_td
      where ds = date_add('2023-01-11', -1)
      union
      select order_count,
             order_amount
      from dws_trans_dispatch_1d
      where ds = '2023-01-11') all_data;

-- 3.2 dws_trans_bound_finish_td
-- 3.2.1 首日装载
insert overwrite table dws_trans_bound_finish_td
    partition (ds = '2023-01-10')
select count(order_id)   order_count,
       sum(order_amount) order_amount
from (select order_id,
             max(amount) order_amount
      from dwd_trans_bound_finish_detail
      group by order_id) distinct_info;

-- 3.2.2 每日装载
insert overwrite table dws_trans_bound_finish_td
    partition (ds = '2023-01-11')
select sum(order_count)  order_count,
       sum(order_amount) order_amount
from (select order_count,
             order_amount
      from dws_trans_bound_finish_td
      where ds = date_add('2023-01-11', -1)
      union
      select count(order_id)   order_count,
             sum(order_amount) order_amount
      from (select order_id,
                   max(amount) order_amount
            from dwd_trans_bound_finish_detail
            where ds = '2023-01-11'
            group by order_id) distinct_tb) all_data;

-- 1.4 dws_trans_org_truck_type_trans_finish_1d
-- 1.4.1 首日装载
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table dws_trans_org_truck_model_type_trans_finish_1d
    partition (ds)
select org_id,
       org_name,
       truck_model_type,
       truck_model_type_name,
       count(trans_finish.id) truck_finish_count,
       sum(actual_distance)   trans_finish_distance,
       sum(finish_dur_sec)    finish_dur_sec,
       ds
from (select id,
             start_org_id   org_id,
             start_org_name org_name,
             truck_id,
             actual_distance,
             finish_dur_sec,
             ds
      from dwd_trans_trans_finish) trans_finish
         left join
     (select id,
             truck_model_type,
             truck_model_type_name
      from dim_truck
      where ds = '2023-01-10') truck_info
     on trans_finish.truck_id = truck_info.id
group by org_id,
         org_name,
         truck_model_type,
         truck_model_type_name,
         ds;

-- 1.4.2 每日装载
insert overwrite table dws_trans_org_truck_model_type_trans_finish_1d
    partition (ds = '2023-01-11')
select org_id,
       org_name,
       truck_model_type,
       truck_model_type_name,
       count(trans_finish.id) truck_finish_count,
       sum(actual_distance)   trans_finish_distance,
       sum(finish_dur_sec)    finish_dur_sec
from (select id,
             start_org_id   org_id,
             start_org_name org_name,
             truck_id,
             actual_distance,
             finish_dur_sec
      from dwd_trans_trans_finish
      where ds = '2023-01-11') trans_finish
         left join
     (select id,
             truck_model_type,
             truck_model_type_name
      from dim_truck
      where ds = '2023-01-11') truck_info
     on trans_finish.truck_id = truck_info.id
group by org_id,
         org_name,
         truck_model_type,
         truck_model_type_name;

-- 2.4 dws_trans_shift_trans_finish_nd
insert overwrite table dws_trans_shift_trans_finish_nd
    partition (ds = '2023-01-10')
select shift_id,
       if(org_level = 1, first.region_id, city.id)     city_id,
       if(org_level = 1, first.region_name, city.name) city_name,
       org_id,
       org_name,
       line_id,
       line_name,
       driver1_emp_id,
       driver1_name,
       driver2_emp_id,
       driver2_name,
       truck_model_type,
       truck_model_type_name,
       recent_days,
       trans_finish_count,
       trans_finish_distance,
       trans_finish_dur_sec,
       trans_finish_order_count,
       trans_finish_delay_count
from (select recent_days,
             shift_id,
             line_id,
             truck_id,
             start_org_id                                       org_id,
             start_org_name                                     org_name,
             driver1_emp_id,
             driver1_name,
             driver2_emp_id,
             driver2_name,
             count(id)                                          trans_finish_count,
             sum(actual_distance)                               trans_finish_distance,
             sum(finish_dur_sec)                                trans_finish_dur_sec,
             sum(order_num)                                     trans_finish_order_count,
             sum(if(actual_end_time > estimate_end_time, 1, 0)) trans_finish_delay_count
      from dwd_trans_trans_finish lateral view
          explode(array(7, 30)) tmp as recent_days
      where ds >= date_add('2023-01-10', -recent_days + 1)
      group by recent_days,
          shift_id,
          line_id,
          start_org_id,
          start_org_name,
          driver1_emp_id,
          driver1_name,
          driver2_emp_id,
          driver2_name,
          truck_id) aggregated
         left join
     (select id,
             org_level,
             region_id,
             region_name
      from dim_organ
      where ds = '2023-01-10'
     ) first
on aggregated.org_id = first.id
    left join
    (select id,
    parent_id
    from dim_region
    where ds = '2023-01-10'
    ) parent
    on first.region_id = parent.id
    left join
    (select id,
    name
    from dim_region
    where ds = '2023-01-10'
    ) city
    on parent.parent_id = city.id
    left join
    (select id,
    line_name
    from dim_shift
    where ds = '2023-01-10') for_line_name
    on shift_id = for_line_name.id
    left join (
    select id,
    truck_model_type,
    truck_model_type_name
    from dim_truck
    where ds = '2023-01-10'
    ) truck_info on truck_id = truck_info.id;

-- 1.5 dws_trans_org_deliver_suc_1d
-- 1.5.1 首日装载
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table dws_trans_org_deliver_suc_1d
    partition (ds)
select org_id,
       org_name,
       city_id,
       city.name       city_name,
       province_id,
       province.name   province_name,
       count(order_id) order_count,
       ds
from (select order_id,
             sender_district_id,
             ds
      from dwd_trans_deliver_suc_detail
      group by order_id, sender_district_id, ds) detail
         left join
     (select id org_id,
             org_name,
             region_id district_id
      from dim_organ
      where ds = '2023-01-10') organ
     on detail.sender_district_id = organ.district_id
         left join
     (select id,
             parent_id city_id
      from dim_region
      where ds = '2023-01-10') district
     on district_id = district.id
         left join
     (select id,
             name,
             parent_id province_id
      from dim_region
      where ds = '2023-01-10') city
     on city_id = city.id
         left join
     (select id,
             name
      from dim_region
      where ds = '2023-01-10') province
     on province_id = province.id
group by org_id,
         org_name,
         city_id,
         city.name,
         province_id,
         province.name,
         ds;

-- 1.5.2 每日装载
insert overwrite table dws_trans_org_deliver_suc_1d
    partition (ds = '2023-01-11')
select org_id,
       org_name,
       city_id,
       city.name       city_name,
       province_id,
       province.name   province_name,
       count(order_id) order_count
from (select order_id,
             sender_district_id
      from dwd_trans_deliver_suc_detail
      where ds = '2023-01-11'
      group by order_id, sender_district_id) detail
         left join
     (select id org_id,
             org_name,
             region_id district_id
      from dim_organ
      where ds = '2023-01-11') organ
     on detail.sender_district_id = organ.district_id
         left join
     (select id,
             parent_id city_id
      from dim_region
      where ds = '2023-01-11') district
     on district_id = district.id
         left join
     (select id,
             name,
             parent_id province_id
      from dim_region
      where ds = '2023-01-11') city
     on city_id = city.id
         left join
     (select id,
             name
      from dim_region
      where ds = '2023-01-11') province
     on province_id = province.id
group by org_id,
         org_name,
         city_id,
         city.name,
         province_id,
         province.name;

-- 2.5 dws_trans_org_deliver_suc_nd
insert overwrite table dws_trans_org_deliver_suc_nd
    partition (ds = '2023-01-10')
select org_id,
       org_name,
       city_id,
       city_name,
       province_id,
       province_name,
       recent_days,
       sum(order_count) order_count
from dws_trans_org_deliver_suc_1d lateral view
    explode(array(7, 30)) tmp as recent_days
where ds >= date_add('2023-01-10', -recent_days + 1)
group by org_id,
    org_name,
    city_id,
    city_name,
    province_id,
    province_name,
    recent_days;

-- 1.6 dws_trans_org_sort_1d
-- 1.6.1 首日装载
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table dws_trans_org_sort_1d
    partition (ds)
select org_id,
       org_name,
       if(org_level = 1, city_for_level1.id, province_for_level1.id)         city_id,
       if(org_level = 1, city_for_level1.name, province_for_level1.name)     city_name,
       if(org_level = 1, province_for_level1.id, province_for_level2.id)     province_id,
       if(org_level = 1, province_for_level1.name, province_for_level2.name) province_name,
       sort_count,
       ds
from (select org_id,
             count(*) sort_count,
             ds
      from dwd_bound_sort
      group by org_id, ds) agg
         left join
     (select id,
             org_name,
             org_level,
             region_id
      from dim_organ
      where ds = '2023-01-10') org
     on org_id = org.id
         left join
     (select id,
             name,
             parent_id
      from dim_region
      where ds = '2023-01-10') city_for_level1
     on region_id = city_for_level1.id
         left join
     (select id,
             name,
             parent_id
      from dim_region
      where ds = '2023-01-10') province_for_level1
     on city_for_level1.parent_id = province_for_level1.id
         left join
     (select id,
             name,
             parent_id
      from dim_region
      where ds = '2023-01-10') province_for_level2
     on province_for_level1.parent_id = province_for_level2.id;

-- 1.6.2 每日装载
insert overwrite table dws_trans_org_sort_1d
    partition (ds = '2023-01-11')
select org_id,
       org_name,
       if(org_level = 1, city_for_level1.id, province_for_level1.id)         city_id,
       if(org_level = 1, city_for_level1.name, province_for_level1.name)     city_name,
       if(org_level = 1, province_for_level1.id, province_for_level2.id)     province_id,
       if(org_level = 1, province_for_level1.name, province_for_level2.name) province_name,
       sort_count
from (select org_id,
             count(*) sort_count
      from dwd_bound_sort
      where ds = '2023-01-11'
      group by org_id) agg
         left join
     (select id,
             org_name,
             org_level,
             region_id
      from dim_organ
      where ds = '2023-01-11') org
     on org_id = org.id
         left join
     (select id,
             name,
             parent_id
      from dim_region
      where ds = '2023-01-11') city_for_level1
     on region_id = city_for_level1.id
         left join
     (select id,
             name,
             parent_id
      from dim_region
      where ds = '2023-01-11') province_for_level1
     on city_for_level1.parent_id = province_for_level1.id
         left join
     (select id,
             name,
             parent_id
      from dim_region
      where ds = '2023-01-11') province_for_level2
     on province_for_level1.parent_id = province_for_level2.id;

-- 2.6 dws_trans_org_sort_nd
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table dws_trans_org_sort_nd
    partition (ds = '2023-01-10')
select org_id,
       org_name,
       city_id,
       city_name,
       province_id,
       province_name,
       recent_days,
       sum(sort_count) sort_count
from dws_trans_org_sort_1d lateral view
    explode(array(7, 30)) tmp as recent_days
where ds >= date_add('2023-01-10', -recent_days + 1)
group by org_id,
    org_name,
    city_id,
    city_name,
    province_id,
    province_name,
    recent_days;