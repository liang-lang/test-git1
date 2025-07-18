create database if not exists tms01;

use tms01;
drop table dim_complex;
create table if not exists dim_complex(
                                          id String ,
                                          complex_name String ,
                                          courier_emp_ids array<STRING> ,
                                          province_id String ,
                                          province_name String,
                                          city_id String ,
                                          city_name String ,
                                          district_id String ,
                                          district_name String
)partitioned by (`ds` string)
    stored as orc
    location 'hdfs://cdh01:8020/bigdata_warehouse/tms01/dim/dim_complex/'
    tblproperties (
                      'orc.compress' = 'SNAPPY',
                      'external.table.purge' = 'true');
with cx as (
    select
        id,
        complex_name,
        province_id,
        city_id,
        district_id,
        district_name
    from ods_base_complex where ds='20250717' and is_deleted= '0'
),pv as (
    select
        id,
        name
    from ods_base_region_info where ds = '20250717' and is_deleted= '0'
),cy as(
    select
        id,
        name
    from ods_base_region_info where ds = '20250717' and is_deleted= '0'
),ex as (
    select
        collect_set(cast(courier_emp_id as string)) courier_emp_ids,
        complex_id
    from ods_express_courier_complex where ds = '20250717' and is_deleted= '0'
    group by complex_id
)
insert overwrite table dim_complex partition(ds='20250717')
select
    cx.id,
    complex_name,
    courier_emp_ids,
    province_id,
    pv.name,
    city_id,
    cy.name,
    district_id,
    district_name
from cx left join pv on cx.province_id = pv.id
        left join cy on cx.city_id = cy.id
        left join ex on cx.id = ex.complex_id;



select * from dim_complex;

create table if not exists dim_organ(
                                        id  STRING,
                                        org_name STRING COMMENT '机构名称',
                                        org_level STRING COMMENT '行政级别',
                                        region_id STRING COMMENT '区域id，1级机构为city ,2级机构为district',
                                        region_name STRING COMMENT '区域名称，1级机构为city ,2级机构为district',
                                        region_code String,
                                        org_parent_id STRING COMMENT '上级机构id',
                                        org_parent_name STRING COMMENT '上级机构名称'
)partitioned by ( ds  string)
    stored as orc
    location 'hdfs://cdh01:8020/bigdata_warehouse/tms01/dim/dim_organ/'
    tblproperties (
                      'orc.compress' = 'SNAPPY',
                      'external.table.purge' = 'true');
with og as (
    select
        id,
        org_name,
        org_level,
        region_id,
        org_parent_id
    from ods_base_organ where ds = '20250717' and is_deleted= '0'
),rg as (
    select
        id,
        name,
        dict_code
    from ods_base_region_info where ds = '20250717' and is_deleted= '0'
)
insert overwrite table dim_organ partition(ds='20250717')
select
    og.id,
    og.org_name,
    og.org_level,
    og.region_id,
    rg.name,
    dict_code,
    og.org_parent_id,
    pog.org_name
from og left join rg on og.region_id = rg.id
        left join og pog on og.org_parent_id = pog.id;
select * from dim_organ;

create external table dim_region
(
    id         STRING,
    parent_id  STRING,
    name       STRING,
    dict_code  STRING,
    short_name STRING
)partitioned by ( ds  string)
    stored as orc
    location 'hdfs://cdh01:8020/bigdata_warehouse/tms01/dim/dim_region/'
    tblproperties (
        'orc.compress' = 'SNAPPY',
        'external.table.purge' = 'true');
insert overwrite table dim_region partition(ds='20250717')
select
    id,
    parent_id,
    name,
    dict_code,
    short_name
from ods_base_region_info where ds = '20250717' and is_deleted= '0';
select * from dim_region;

create external table dim_express_courier(
   id STRING,
   emp_id STRING,
   org_id STRING,
   org_name STRING,
   working_phone STRING,
   express_type STRING,
   express_type_name STRING
)partitioned by (ds string)
    stored as orc
    location 'hdfs://cdh01:8020/bigdata_warehouse/tms01/dim/dim_express_courier/'
    tblproperties (
        'orc.compress' = 'SNAPPY',
        'external.table.purge' = 'true');
with ex as (
    select
        id,
        emp_id,
        org_id,
        working_phone,
        express_type
    from ods_express_courier where ds = '20250717' and is_deleted= '0'
),rg as (
    select
        id,
        org_name
    from ods_base_organ where ds = '20250717' and is_deleted= '0'
),dc as (
    select
        id,
        name
    from ods_base_dic where ds = '20250717' and is_deleted= '0'
)
insert overwrite table dim_express_courier partition(ds='20250717')
select
    ex.id,
    emp_id,
    org_id,
    rg.org_name,
    working_phone,
    express_type,
    dc.name
from ex left join rg
                  on ex.org_id = rg.id
        left join dc on ex.express_type = dc.id;
select * from dim_express_courier;

create external table dim_shift
(
    id         STRING,
    line_id  STRING,
    line_name       STRING,
    line_no  STRING,
    line_level  STRING,
    org_id  STRING,
    transport_line_type_id  STRING,
    transport_line_type_name  STRING,
    start_org_id STRING,
    start_org_name STRING,
    end_org_id STRING,
    end_org_name STRING,
    pair_line_id STRING,
    distance STRING,
    `cost` STRING,
    estimated_time STRING,
    start_time STRING,
    driver1_emp_id STRING,
    driver2_emp_id STRING,
    truck_id STRING,
    pair_shift_id STRING
)partitioned by (ds string)
    stored as orc
    location 'hdfs://cdh01:8020/bigdata_warehouse/tms01/dim/dim_shift/'
    tblproperties (
        'orc.compress' = 'SNAPPY',
        'external.table.purge' = 'true');
with sf as (
    select
        id,
        line_id,
        start_time,
        driver1_emp_id,
        driver2_emp_id,
        truck_id,
        pair_shift_id
    from ods_line_base_shift where ds = '20250717' and is_deleted= '0'
),le as (
    select
        id,
        name,
        line_no,
        line_level,
        org_id,
        transport_line_type_id,
        start_org_id,
        start_org_name,
        end_org_id,
        end_org_name,
        pair_line_id,
        distance,
        `cost`,
        estimated_time,
        `status`
    from ods_line_base_info where ds = '20250717' and is_deleted= '0'
),bc as (
    select
        id,
        name
    from ods_base_dic where ds = '20250717' and is_deleted= '0'
)
insert overwrite table dim_shift partition(ds='20250717')
select
    sf.id,
    line_id,
    le.name,
    line_no,
    line_level,
    org_id,
    transport_line_type_id,
    bc.name,
    start_org_id,
    start_org_name,
    end_org_id,
    end_org_name,
    pair_line_id,
    distance,
    `cost`,
    estimated_time,
    start_time,
    driver1_emp_id,
    driver2_emp_id,
    truck_id,
    pair_shift_id
from sf left join le on sf.line_id = le.id
        left join bc on le.transport_line_type_id = bc.id;
select * from dim_shift;

create external table dim_truck_driver(
 id STRING,
 emp_id STRING,
 org_id STRING,
 org_name STRING,
 team_id STRING,
 team_name STRING,
 license_type STRING,
 init_license_date STRING,
 expire_date STRING,
 license_no STRING,
 is_enabled STRING
)partitioned by (ds string)
    stored as orc
    location 'hdfs://cdh01:8020/bigdata_warehouse/tms01/dim/dim_truck_driver/'
    tblproperties (
        'orc.compress' = 'SNAPPY',
        'external.table.purge' = 'true');
with dv as (
    select
        id,
        emp_id,
        org_id,
        team_id,
        license_type,
        init_license_date,
        expire_date,
        license_no,
        license_picture_url,
        is_enabled
    from ods_truck_driver where ds = '20250717' and is_deleted= '0'
),og as (
    select
        id,
        org_name
    from ods_base_organ where ds = '20250717' and is_deleted= '0'
),tm as (
    select
        id,
        name
    from ods_truck_team where ds = '20250717' and is_deleted= '0'
)
insert overwrite table dim_truck_driver partition(ds='20250717')
select
    dv.id,
    emp_id,
    org_id,
    org_name,
    team_id,
    tm.name,
    license_type,
    init_license_date,
    expire_date,
    license_no,
    is_enabled
from dv left join og on dv.org_id = og.id
        left join tm on dv.team_id = tm.id;
select * from dim_truck_driver;

create external table dim_truck
(
    id                        STRING,
    team_id                   STRING,
    team_name                 STRING,
    team_no                   STRING,
    org_id                    STRING,
    org_name                  STRING,
    manager_emp_id            STRING,
    truck_no                  STRING,
    truck_model_id            STRING,
    truck_model_name          STRING,
    truck_model_type          STRING,
    truck_model_type_name     STRING,
    truck_model_no            STRING,
    truck_brand               STRING,
    truck_brand_name          STRING,
    truck_weight              STRING,
    load_weight               STRING,
    total_weight              STRING,
    eev                       STRING,
    boxcar_len                STRING,
    boxcar_wd                 STRING,
    boxcar_hg                 STRING,
    max_speed                 STRING,
    oil_vol                   STRING,
    device_gps_id             STRING,
    engine_no                 STRING,
    license_registration_date STRING,
    license_last_check_date   STRING,
    license_expire_date       STRING,
    is_enabled                STRING
) partitioned by (ds string)
    stored as orc
    location 'hdfs://cdh01:8020/bigdata_warehouse/tms01/dim/dim_truck/'
    tblproperties (
        'orc.compress' = 'SNAPPY',
        'external.table.purge' = 'true');
with tk as (
    select
        id,
        team_id,
        truck_no,
        truck_model_id,
        device_gps_id,
        engine_no,
        license_registration_date,
        license_last_check_date,
        license_expire_date,
        picture_url,
        is_enabled
    from ods_truck_info where ds = '20250717' and is_deleted= '0'
),tm as (
    select
        id,
        name,
        team_no,
        org_id,
        manager_emp_id
    from ods_truck_team where ds = '20250717' and is_deleted= '0'
),og as (
    select
        id,
        org_name
    from ods_base_organ where ds = '20250717' and is_deleted= '0'
),bc as (
    select
        id,
        name
    from ods_base_dic where ds = '20250717' and is_deleted= '0'
),td as (
    select
        id,
        model_name,
        model_type,
        model_no,
        brand,
        truck_weight,
        load_weight,
        total_weight,
        eev,
        boxcar_len,
        boxcar_wd,
        boxcar_hg,
        max_speed,
        oil_vol
    from ods_truck_model where ds = '20250717' and is_deleted= '0'
)
insert overwrite table dim_truck partition(ds='20250717')
select
    tk.id,
    tk.team_id,
    tm.name,
    tm.team_no,
    tm.org_id,
    og.org_name,
    tm.manager_emp_id,
    tk.truck_no,
    td.id,
    td.model_name,
    td.model_type,
    mtp.name,
    td.model_no,
    td.brand,
    bd.name,
    td.truck_weight,
    td.load_weight,
    td.total_weight,
    td.eev,
    td.boxcar_len,
    td.boxcar_wd,
    td.boxcar_hg,
    td.max_speed,
    td.oil_vol,
    tk.device_gps_id,
    tk.engine_no,
    tk.license_registration_date,
    tk.license_last_check_date,
    tk.license_expire_date,
    tk.is_enabled
from tk left join tm on tk.team_id = tm.id
        left join og on tm.org_id = og.id
        left join td on tk.truck_model_id = td.id
        left join bc mtp on td.model_type = mtp.id
        left join bc bd
                  on td.brand = bd.id;
select * from dim_truck;

drop table if exists dim_user_zip;
create external table dim_user_zip(
  id                        STRING,
  login_name                  STRING,
  nick_name                  STRING,
  passwd                  STRING,
  real_name                  STRING,
  phone_num                  STRING,
  email                  STRING,
  user_level                  STRING,
  birthday                  STRING,
  gender                  STRING,
  start_date                  STRING,
  end_date                  STRING
)partitioned by (ds string)
    stored as orc
    location 'hdfs://cdh01:8020/bigdata_warehouse/tms01/dim/dim_user_zip1/'
    tblproperties (
        'orc.compress' = 'SNAPPY',
        'external.table.purge' = 'true');
insert overwrite table dim_user_zip partition(ds='20250717')
select
    id,
    login_name,
    nick_name,
    passwd,
    real_name,
    phone_num,
    email,
    user_level,
    birthday,
    gender,
    date_format(nvl(update_time, create_time),'yyyy-MM-dd'),
    '9999-12-31'
from ods_user_info where ds='20250717' and  is_deleted='0';
select * from dim_user_zip;

create external table dim_user_address_zip(
  id                        STRING,
  user_id                  STRING,
  phone                 STRING,
  province_id             STRING,
  city_id                 STRING,
  district_id             STRING,
  complex_id                 STRING,
  address                 STRING,
  is_default                 STRING,
  start_date                 STRING,
  end_date                 STRING
)partitioned by (ds string)
    stored as orc
    location 'hdfs://cdh01:8020/bigdata_warehouse/tms01/dim/dim_user_address_zip/'
    tblproperties (
        'orc.compress' = 'SNAPPY',
        'external.table.purge' = 'true');
insert overwrite table dim_user_address_zip partition(ds='20250717')
select
    id,
    user_id,
    phone,
    province_id,
    city_id,
    district_id,
    complex_id,
    address,
    is_default,
    date_format(nvl(update_time, create_time),'yyyy-MM-dd'),
    '9999-12-31'
from ods_user_address where ds='20250717' and  is_deleted='0';
select * from dim_user_address_zip;

