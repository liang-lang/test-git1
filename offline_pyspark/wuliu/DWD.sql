use tms01;

-- 1. 交易域下单事务事实表
drop table if exists dwd_trade_order_detail_inc;
create external table dwd_trade_order_detail_inc(
  `id` bigint comment '运单明细ID',
  `order_id` string COMMENT '运单ID',
  `cargo_type` string COMMENT '货物类型ID',
  `cargo_type_name` string COMMENT '货物类型名称',
  `volumn_length` bigint COMMENT '长cm',
  `volumn_width` bigint COMMENT '宽cm',
  `volumn_height` bigint COMMENT '高cm',
  `weight` decimal(16,2) COMMENT '重量 kg',
  `order_time` string COMMENT '下单时间',
  `order_no` string COMMENT '运单号',
  `status` string COMMENT '运单状态',
  `status_name` string COMMENT '运单状态名称',
  `collect_type` string COMMENT '取件类型，1为网点自寄，2为上门取件',
  `collect_type_name` string COMMENT '取件类型名称',
  `user_id` bigint COMMENT '用户ID',
  `receiver_complex_id` bigint COMMENT '收件人小区id',
  `receiver_province_id` string COMMENT '收件人省份id',
  `receiver_city_id` string COMMENT '收件人城市id',
  `receiver_district_id` string COMMENT '收件人区县id',
  `receiver_name` string COMMENT '收件人姓名',
  `sender_complex_id` bigint COMMENT '发件人小区id',
  `sender_province_id` string COMMENT '发件人省份id',
  `sender_city_id` string COMMENT '发件人城市id',
  `sender_district_id` string COMMENT '发件人区县id',
  `sender_name` string COMMENT '发件人姓名',
  `cargo_num` bigint COMMENT '货物个数',
  `amount` decimal(16,2) COMMENT '金额',
  `estimate_arrive_time` string COMMENT '预计到达时间',
  `distance` decimal(16,2) COMMENT '距离，单位：公里',
  `ts` bigint COMMENT '时间戳'
) comment '交易域订单明细事务事实表'
    partitioned by (`dt` string comment '统计日期')
    stored as orc
    location '/warehouse/tms/dwd/dwd_trade_order_detail_inc'
    tblproperties('orc.compress' = 'snappy');

-- 2. 交易域支付成功事务事实表
drop table if exists dwd_trade_pay_suc_detail_inc;
create external table dwd_trade_pay_suc_detail_inc(
  `id` bigint comment '运单明细ID',
  `order_id` string COMMENT '运单ID',
  `cargo_type` string COMMENT '货物类型ID',
  `cargo_type_name` string COMMENT '货物类型名称',
  `volumn_length` bigint COMMENT '长cm',
  `volumn_width` bigint COMMENT '宽cm',
  `volumn_height` bigint COMMENT '高cm',
  `weight` decimal(16,2) COMMENT '重量 kg',
  `payment_time` string COMMENT '支付时间',
  `order_no` string COMMENT '运单号',
  `status` string COMMENT '运单状态',
  `status_name` string COMMENT '运单状态名称',
  `collect_type` string COMMENT '取件类型，1为网点自寄，2为上门取件',
  `collect_type_name` string COMMENT '取件类型名称',
  `user_id` bigint COMMENT '用户ID',
  `receiver_complex_id` bigint COMMENT '收件人小区id',
  `receiver_province_id` string COMMENT '收件人省份id',
  `receiver_city_id` string COMMENT '收件人城市id',
  `receiver_district_id` string COMMENT '收件人区县id',
  `receiver_name` string COMMENT '收件人姓名',
  `sender_complex_id` bigint COMMENT '发件人小区id',
  `sender_province_id` string COMMENT '发件人省份id',
  `sender_city_id` string COMMENT '发件人城市id',
  `sender_district_id` string COMMENT '发件人区县id',
  `sender_name` string COMMENT '发件人姓名',
  `payment_type` string COMMENT '支付方式',
  `payment_type_name` string COMMENT '支付方式名称',
  `cargo_num` bigint COMMENT '货物个数',
  `amount` decimal(16,2) COMMENT '金额',
  `estimate_arrive_time` string COMMENT '预计到达时间',
  `distance` decimal(16,2) COMMENT '距离，单位：公里',
  `ts` bigint COMMENT '时间戳'
) comment '交易域支付成功事务事实表'
    partitioned by (`dt` string comment '统计日期')
    stored as orc
    location '/warehouse/tms/dwd/dwd_trade_pay_suc_detail_inc'
    tblproperties('orc.compress' = 'snappy');

-- 3. 交易域取消运单事务事实表
drop table if exists dwd_trade_order_cancel_detail_inc;
create external table dwd_trade_order_cancel_detail_inc(
  `id` bigint comment '运单明细ID',
  `order_id` string COMMENT '运单ID',
  `cargo_type` string COMMENT '货物类型ID',
  `cargo_type_name` string COMMENT '货物类型名称',
  `volumn_length` bigint COMMENT '长cm',
  `volumn_width` bigint COMMENT '宽cm',
  `volumn_height` bigint COMMENT '高cm',
  `weight` decimal(16,2) COMMENT '重量 kg',
  `cancel_time` string COMMENT '取消时间',
  `order_no` string COMMENT '运单号',
  `status` string COMMENT '运单状态',
  `status_name` string COMMENT '运单状态名称',
  `collect_type` string COMMENT '取件类型，1为网点自寄，2为上门取件',
  `collect_type_name` string COMMENT '取件类型名称',
  `user_id` bigint COMMENT '用户ID',
  `receiver_complex_id` bigint COMMENT '收件人小区id',
  `receiver_province_id` string COMMENT '收件人省份id',
  `receiver_city_id` string COMMENT '收件人城市id',
  `receiver_district_id` string COMMENT '收件人区县id',
  `receiver_name` string COMMENT '收件人姓名',
  `sender_complex_id` bigint COMMENT '发件人小区id',
  `sender_province_id` string COMMENT '发件人省份id',
  `sender_city_id` string COMMENT '发件人城市id',
  `sender_district_id` string COMMENT '发件人区县id',
  `sender_name` string COMMENT '发件人姓名',
  `cargo_num` bigint COMMENT '货物个数',
  `amount` decimal(16,2) COMMENT '金额',
  `estimate_arrive_time` string COMMENT '预计到达时间',
  `distance` decimal(16,2) COMMENT '距离，单位：公里',
  `ts` bigint COMMENT '时间戳'
) comment '交易域取消运单事务事实表'
    partitioned by (`dt` string comment '统计日期')
    stored as orc
    location '/warehouse/tms/dwd/dwd_trade_order_cancel_detail_inc'
    tblproperties('orc.compress' = 'snappy');

-- 4. 物流域揽收事务事实表
drop table if exists dwd_trans_receive_detail_inc;
create external table dwd_trans_receive_detail_inc(
  `id` bigint comment '运单明细ID',
  `order_id` string COMMENT '运单ID',
  `cargo_type` string COMMENT '货物类型ID',
  `cargo_type_name` string COMMENT '货物类型名称',
  `volumn_length` bigint COMMENT '长cm',
  `volumn_width` bigint COMMENT '宽cm',
  `volumn_height` bigint COMMENT '高cm',
  `weight` decimal(16,2) COMMENT '重量 kg',
  `receive_time` string COMMENT '揽收时间',
  `order_no` string COMMENT '运单号',
  `status` string COMMENT '运单状态',
  `status_name` string COMMENT '运单状态名称',
  `collect_type` string COMMENT '取件类型，1为网点自寄，2为上门取件',
  `collect_type_name` string COMMENT '取件类型名称',
  `user_id` bigint COMMENT '用户ID',
  `receiver_complex_id` bigint COMMENT '收件人小区id',
  `receiver_province_id` string COMMENT '收件人省份id',
  `receiver_city_id` string COMMENT '收件人城市id',
  `receiver_district_id` string COMMENT '收件人区县id',
  `receiver_name` string COMMENT '收件人姓名',
  `sender_complex_id` bigint COMMENT '发件人小区id',
  `sender_province_id` string COMMENT '发件人省份id',
  `sender_city_id` string COMMENT '发件人城市id',
  `sender_district_id` string COMMENT '发件人区县id',
  `sender_name` string COMMENT '发件人姓名',
  `payment_type` string COMMENT '支付方式',
  `payment_type_name` string COMMENT '支付方式名称',
  `cargo_num` bigint COMMENT '货物个数',
  `amount` decimal(16,2) COMMENT '金额',
  `estimate_arrive_time` string COMMENT '预计到达时间',
  `distance` decimal(16,2) COMMENT '距离，单位：公里',
  `ts` bigint COMMENT '时间戳'
) comment '物流域揽收事务事实表'
    partitioned by (`dt` string comment '统计日期')
    stored as orc
    location '/warehouse/tms/dwd/dwd_trans_receive_detail_inc'
    tblproperties('orc.compress' = 'snappy');

-- 5. 物流域发单事务事实表
drop table if exists dwd_trans_dispatch_detail_inc;
create external table dwd_trans_dispatch_detail_inc(
  `id` bigint comment '运单明细ID',
  `order_id` string COMMENT '运单ID',
  `cargo_type` string COMMENT '货物类型ID',
  `cargo_type_name` string COMMENT '货物类型名称',
  `volumn_length` bigint COMMENT '长cm',
  `volumn_width` bigint COMMENT '宽cm',
  `volumn_height` bigint COMMENT '高cm',
  `weight` decimal(16,2) COMMENT '重量 kg',
  `dispatch_time` string COMMENT '发单时间',
  `order_no` string COMMENT '运单号',
  `status` string COMMENT '运单状态',
  `status_name` string COMMENT '运单状态名称',
  `collect_type` string COMMENT '取件类型，1为网点自寄，2为上门取件',
  `collect_type_name` string COMMENT '取件类型名称',
  `user_id` bigint COMMENT '用户ID',
  `receiver_complex_id` bigint COMMENT '收件人小区id',
  `receiver_province_id` string COMMENT '收件人省份id',
  `receiver_city_id` string COMMENT '收件人城市id',
  `receiver_district_id` string COMMENT '收件人区县id',
  `receiver_name` string COMMENT '收件人姓名',
  `sender_complex_id` bigint COMMENT '发件人小区id',
  `sender_province_id` string COMMENT '发件人省份id',
  `sender_city_id` string COMMENT '发件人城市id',
  `sender_district_id` string COMMENT '发件人区县id',
  `sender_name` string COMMENT '发件人姓名',
  `payment_type` string COMMENT '支付方式',
  `payment_type_name` string COMMENT '支付方式名称',
  `cargo_num` bigint COMMENT '货物个数',
  `amount` decimal(16,2) COMMENT '金额',
  `estimate_arrive_time` string COMMENT '预计到达时间',
  `distance` decimal(16,2) COMMENT '距离，单位：公里',
  `ts` bigint COMMENT '时间戳'
) comment '物流域发单事务事实表'
    partitioned by (`dt` string comment '统计日期')
    stored as orc
    location '/warehouse/tms/dwd/dwd_trans_dispatch_detail_inc'
    tblproperties('orc.compress' = 'snappy');

-- 6. 物流域转运完成事务事实表
drop table if exists dwd_trans_bound_finish_detail_inc;
create external table dwd_trans_bound_finish_detail_inc(
  `id` bigint comment '运单明细ID',
  `order_id` string COMMENT '运单ID',
  `cargo_type` string COMMENT '货物类型ID',
  `cargo_type_name` string COMMENT '货物类型名称',
  `volumn_length` bigint COMMENT '长cm',
  `volumn_width` bigint COMMENT '宽cm',
  `volumn_height` bigint COMMENT '高cm',
  `weight` decimal(16,2) COMMENT '重量 kg',
  `bound_finish_time` string COMMENT '转运完成时间',
  `order_no` string COMMENT '运单号',
  `status` string COMMENT '运单状态',
  `status_name` string COMMENT '运单状态名称',
  `collect_type` string COMMENT '取件类型，1为网点自寄，2为上门取件',
  `collect_type_name` string COMMENT '取件类型名称',
  `user_id` bigint COMMENT '用户ID',
  `receiver_complex_id` bigint COMMENT '收件人小区id',
  `receiver_province_id` string COMMENT '收件人省份id',
  `receiver_city_id` string COMMENT '收件人城市id',
  `receiver_district_id` string COMMENT '收件人区县id',
  `receiver_name` string COMMENT '收件人姓名',
  `sender_complex_id` bigint COMMENT '发件人小区id',
  `sender_province_id` string COMMENT '发件人省份id',
  `sender_city_id` string COMMENT '发件人城市id',
  `sender_district_id` string COMMENT '发件人区县id',
  `sender_name` string COMMENT '发件人姓名',
  `payment_type` string COMMENT '支付方式',
  `payment_type_name` string COMMENT '支付方式名称',
  `cargo_num` bigint COMMENT '货物个数',
  `amount` decimal(16,2) COMMENT '金额',
  `estimate_arrive_time` string COMMENT '预计到达时间',
  `distance` decimal(16,2) COMMENT '距离，单位：公里',
  `ts` bigint COMMENT '时间戳'
) comment '物流域转运完成事务事实表'
    partitioned by (`dt` string comment '统计日期')
    stored as orc
    location '/warehouse/tms/dwd/dwd_trans_bound_finish_detail_inc'
    tblproperties('orc.compress' = 'snappy');

-- 7. 物流域派送成功事务事实表
drop table if exists dwd_trans_deliver_suc_detail_inc;
create external table dwd_trans_deliver_suc_detail_inc(
  `id` bigint comment '运单明细ID',
  `order_id` string COMMENT '运单ID',
  `cargo_type` string COMMENT '货物类型ID',
  `cargo_type_name` string COMMENT '货物类型名称',
  `volumn_length` bigint COMMENT '长cm',
  `volumn_width` bigint COMMENT '宽cm',
  `volumn_height` bigint COMMENT '高cm',
  `weight` decimal(16,2) COMMENT '重量 kg',
  `deliver_suc_time` string COMMENT '派送成功时间',
  `order_no` string COMMENT '运单号',
  `status` string COMMENT '运单状态',
  `status_name` string COMMENT '运单状态名称',
  `collect_type` string COMMENT '取件类型，1为网点自寄，2为上门取件',
  `collect_type_name` string COMMENT '取件类型名称',
  `user_id` bigint COMMENT '用户ID',
  `receiver_complex_id` bigint COMMENT '收件人小区id',
  `receiver_province_id` string COMMENT '收件人省份id',
  `receiver_city_id` string COMMENT '收件人城市id',
  `receiver_district_id` string COMMENT '收件人区县id',
  `receiver_name` string COMMENT '收件人姓名',
  `sender_complex_id` bigint COMMENT '发件人小区id',
  `sender_province_id` string COMMENT '发件人省份id',
  `sender_city_id` string COMMENT '发件人城市id',
  `sender_district_id` string COMMENT '发件人区县id',
  `sender_name` string COMMENT '发件人姓名',
  `payment_type` string COMMENT '支付方式',
  `payment_type_name` string COMMENT '支付方式名称',
  `cargo_num` bigint COMMENT '货物个数',
  `amount` decimal(16,2) COMMENT '金额',
  `estimate_arrive_time` string COMMENT '预计到达时间',
  `distance` decimal(16,2) COMMENT '距离，单位：公里',
  `ts` bigint COMMENT '时间戳'
) comment '物流域派送成功事务事实表'
    partitioned by (`dt` string comment '统计日期')
    stored as orc
    location '/warehouse/tms/dwd/dwd_trans_deliver_suc_detail_inc'
    tblproperties('orc.compress' = 'snappy');

-- 8. 物流域签收事务事实表
drop table if exists dwd_trans_sign_detail_inc;
create external table dwd_trans_sign_detail_inc(
  `id` bigint comment '运单明细ID',
  `order_id` string COMMENT '运单ID',
  `cargo_type` string COMMENT '货物类型ID',
  `cargo_type_name` string COMMENT '货物类型名称',
  `volumn_length` bigint COMMENT '长cm',
  `volumn_width` bigint COMMENT '宽cm',
  `volumn_height` bigint COMMENT '高cm',
  `weight` decimal(16,2) COMMENT '重量 kg',
  `sign_time` string COMMENT '签收时间',
  `order_no` string COMMENT '运单号',
  `status` string COMMENT '运单状态',
  `status_name` string COMMENT '运单状态名称',
  `collect_type` string COMMENT '取件类型，1为网点自寄，2为上门取件',
  `collect_type_name` string COMMENT '取件类型名称',
  `user_id` bigint COMMENT '用户ID',
  `receiver_complex_id` bigint COMMENT '收件人小区id',
  `receiver_province_id` string COMMENT '收件人省份id',
  `receiver_city_id` string COMMENT '收件人城市id',
  `receiver_district_id` string COMMENT '收件人区县id',
  `receiver_name` string COMMENT '收件人姓名',
  `sender_complex_id` bigint COMMENT '发件人小区id',
  `sender_province_id` string COMMENT '发件人省份id',
  `sender_city_id` string COMMENT '发件人城市id',
  `sender_district_id` string COMMENT '发件人区县id',
  `sender_name` string COMMENT '发件人姓名',
  `payment_type` string COMMENT '支付方式',
  `payment_type_name` string COMMENT '支付方式名称',
  `cargo_num` bigint COMMENT '货物个数',
  `amount` decimal(16,2) COMMENT '金额',
  `estimate_arrive_time` string COMMENT '预计到达时间',
  `distance` decimal(16,2) COMMENT '距离，单位：公里',
  `ts` bigint COMMENT '时间戳'
) comment '物流域签收事务事实表'
    partitioned by (`dt` string comment '统计日期')
    stored as orc
    location '/warehouse/tms/dwd/dwd_trans_sign_detail_inc'
    tblproperties('orc.compress' = 'snappy');

-- 9. 交易域运单累积快照事实表
drop table if exists dwd_trade_order_process_inc;
create external table dwd_trade_order_process_inc(
  `id` bigint comment '运单明细ID',
  `order_id` string COMMENT '运单ID',
  `cargo_type` string COMMENT '货物类型ID',
  `cargo_type_name` string COMMENT '货物类型名称',
  `volumn_length` bigint COMMENT '长cm',
  `volumn_width` bigint COMMENT '宽cm',
  `volumn_height` bigint COMMENT '高cm',
  `weight` decimal(16,2) COMMENT '重量 kg',
  `order_time` string COMMENT '下单时间',
  `order_no` string COMMENT '运单号',
  `status` string COMMENT '运单状态',
  `status_name` string COMMENT '运单状态名称',
  `collect_type` string COMMENT '取件类型，1为网点自寄，2为上门取件',
  `collect_type_name` string COMMENT '取件类型名称',
  `user_id` bigint COMMENT '用户ID',
  `receiver_complex_id` bigint COMMENT '收件人小区id',
  `receiver_province_id` string COMMENT '收件人省份id',
  `receiver_city_id` string COMMENT '收件人城市id',
  `receiver_district_id` string COMMENT '收件人区县id',
  `receiver_name` string COMMENT '收件人姓名',
  `sender_complex_id` bigint COMMENT '发件人小区id',
  `sender_province_id` string COMMENT '发件人省份id',
  `sender_city_id` string COMMENT '发件人城市id',
  `sender_district_id` string COMMENT '发件人区县id',
  `sender_name` string COMMENT '发件人姓名',
  `payment_type` string COMMENT '支付方式',
  `payment_type_name` string COMMENT '支付方式名称',
  `cargo_num` bigint COMMENT '货物个数',
  `amount` decimal(16,2) COMMENT '金额',
  `estimate_arrive_time` string COMMENT '预计到达时间',
  `distance` decimal(16,2) COMMENT '距离，单位：公里',
  `ts` bigint COMMENT '时间戳',
  `start_date` string COMMENT '开始日期',
  `end_date` string COMMENT '结束日期'
) comment '交易域运单累积快照事实表'
    partitioned by (`dt` string comment '统计日期')
    stored as orc
    location '/warehouse/tms/dwd/dwd_order_process'
    tblproperties('orc.compress' = 'snappy');

-- 10. 物流域运输事务事实表
drop table if exists dwd_trans_trans_finish_inc;
create external table dwd_trans_trans_finish_inc(
  `id` bigint comment '运输任务ID',
  `shift_id` bigint COMMENT '车次ID',
  `line_id` bigint COMMENT '路线ID',
  `start_org_id` bigint COMMENT '起始机构ID',
  `start_org_name` string COMMENT '起始机构名称',
  `end_org_id` bigint COMMENT '目的机构ID',
  `end_org_name` string COMMENT '目的机构名称',
  `order_num` bigint COMMENT '运单个数',
  `driver1_emp_id` bigint COMMENT '司机1ID',
  `driver1_name` string COMMENT '司机1名称',
  `driver2_emp_id` bigint COMMENT '司机2ID',
  `driver2_name` string COMMENT '司机2名称',
  `truck_id` bigint COMMENT '卡车ID',
  `truck_no` string COMMENT '卡车号牌',
  `actual_start_time` string COMMENT '实际启动时间',
  `actual_end_time` string COMMENT '实际到达时间',
  `actual_distance` decimal(16,2) COMMENT '实际行驶距离',
  `finish_dur_sec` bigint COMMENT '运输完成历经时长：秒',
  `ts` bigint COMMENT '时间戳'
) comment '物流域运输事务事实表'
    partitioned by (`dt` string comment '统计日期')
    stored as orc
    location '/warehouse/tms/dwd/dwd_trans_trans_finish_inc'
    tblproperties('orc.compress' = 'snappy');

-- 11. 中转域入库事务事实表
drop table if exists dwd_bound_inbound_inc;
create external table dwd_bound_inbound_inc(
  `id` bigint COMMENT '中转记录ID',
  `order_id` bigint COMMENT '运单ID',
  `org_id` bigint COMMENT '机构ID',
  `inbound_time` string COMMENT '入库时间',
  `inbound_emp_id` bigint COMMENT '入库人员'
) comment '中转域入库事务事实表'
    partitioned by (`dt` string comment '统计日期')
    stored as orc
    location '/warehouse/tms/dwd/dwd_bound_inbound_inc'
    tblproperties('orc.compress' = 'snappy');

-- 12. 中转域分拣事务事实表
drop table if exists dwd_bound_sort_inc;
create external table dwd_bound_sort_inc(
  `id` bigint COMMENT '中转记录ID',
  `order_id` bigint COMMENT '订单ID',
  `org_id` bigint COMMENT '机构ID',
  `sort_time` string COMMENT '分拣时间',
  `sorter_emp_id` bigint COMMENT '分拣人员'
) comment '中转域分拣事务事实表'
    partitioned by (`dt` string comment '统计日期')
    stored as orc
    location '/warehouse/tms/dwd/dwd_bound_sort_inc'
    tblproperties('orc.compress' = 'snappy');

-- 13. 中转域出库事务事实表
drop table if exists dwd_bound_outbound_inc;
create external table dwd_bound_outbound_inc(
  `id` bigint COMMENT '中转记录ID',
  `order_id` bigint COMMENT '订单ID',
  `org_id` bigint COMMENT '机构ID',
  `outbound_time` string COMMENT '出库时间',
  `outbound_emp_id` bigint COMMENT '出库人员'
) comment '中转域出库事务事实表'
    partitioned by (`dt` string comment '统计日期')
    stored as orc
    location '/warehouse/tms/dwd/dwd_bound_outbound_inc'
    tblproperties('orc.compress' = 'snappy');


-- 1. dwd_trade_order_detail_inc
-- 1.1 首日装载
select * from ods_order_cargo_full;
select * from ods_order_info_full;
select * from ods_base_dic_full;

set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table tms.dwd_trade_order_detail_inc
    partition (dt)
select cargo.id,
       order_id,
       cargo_type,
       dic_for_cargo_type.name               cargo_type_name,
       volumn_length,
       volumn_width,
       volumn_height,
       weight,
       order_time,
       order_no,
       status,
       dic_for_status.name                   status_name,
       collect_type,
       dic_for_collect_type.name             collect_type_name,
       user_id,
       receiver_complex_id,
       receiver_province_id,
       receiver_city_id,
       receiver_district_id,
       receiver_name,
       sender_complex_id,
       sender_province_id,
       sender_city_id,
       sender_district_id,
       sender_name,
       cargo_num,
       amount,
       estimate_arrive_time,
       distance,
       ts,
       date_format(order_time, 'yyyy-MM-dd') dt
from (select after.id,
             after.order_id,
             after.cargo_type,
             after.volumn_length,
             after.volumn_width,
             after.volumn_height,
             after.weight,
             concat(substr(after.create_time, 1, 10), ' ', substr(after.create_time, 12, 8)) order_time,
             ts
      from ods_order_cargo_full after
      where dt = '20250719'
        and after.is_deleted = '0') cargo
         join
     (select after.id,
             after.order_no,
             after.status,
             after.collect_type,
             after.user_id,
             after.receiver_complex_id,
             after.receiver_province_id,
             after.receiver_city_id,
             after.receiver_district_id,
             concat(substr(after.receiver_name, 1, 1), '*') receiver_name,
             after.sender_complex_id,
             after.sender_province_id,
             after.sender_city_id,
             after.sender_district_id,
             concat(substr(after.sender_name, 1, 1), '*')   sender_name,
             after.cargo_num,
             after.amount,
             date_format(from_utc_timestamp(
                                 cast(after.estimate_arrive_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')             estimate_arrive_time,
             after.distance
      from ods_order_info_full after
      where dt = '20250719'
        and after.is_deleted = '0') info
     on cargo.order_id = info.id
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_cargo_type
     on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_status
     on info.status = cast(dic_for_status.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_collect_type
     on info.collect_type = cast(dic_for_cargo_type.id as string);

select * from dwd_trade_order_detail_inc;
-- 1.2 每日装载
select * from ods_order_cargo_full;
select * from ods_order_info_full;
select * from ods_base_dic_full;
select * from dwd_trade_order_detail_inc;

insert overwrite table tms.dwd_trade_order_detail_inc
    partition (dt = '20250719')
select cargo.id,
       order_id,
       cargo_type,
       dic_for_cargo_type.name   cargo_type_name,
       volume_length,
       volume_width,
       volume_height,
       weight,
       order_time,
       order_no,
       status,
       dic_for_status.name       status_name,
       collect_type,
       dic_for_collect_type.name collect_type_name,
       user_id,
       receiver_complex_id,
       receiver_province_id,
       receiver_city_id,
       receiver_district_id,
       receiver_name,
       sender_complex_id,
       sender_province_id,
       sender_city_id,
       sender_district_id,
       sender_name,
       cargo_num,
       amount,
       estimate_arrive_time,
       distance,
       dt
from (select after.id,
             after.order_id,
             after.cargo_type,
             after.volume_length,
             after.volume_width,
             after.volume_height,
             after.weight,
             date_format(
                     from_utc_timestamp(
                                 to_unix_timestamp(concat(substr(after.create_time, 1, 10), ' ',
                                                          substr(after.create_time, 12, 8))) * 1000,
                                 'GMT+8'), 'yyyy-MM-dd HH:mm:ss') order_time,
             dt
      from ods_order_cargo_full after
      where dt = '20250719'
     ) cargo
         join
     (select after.id,
             after.order_no,
             after.status,
             after.collect_type,
             after.user_id,
             after.receiver_complex_id,
             after.receiver_province_id,
             after.receiver_city_id,
             after.receiver_district_id,
             concat(substr(after.receiver_name, 1, 1), '*') receiver_name,
             after.sender_complex_id,
             after.sender_province_id,
             after.sender_city_id,
             after.sender_district_id,
             concat(substr(after.sender_name, 1, 1), '*')   sender_name,
             after.cargo_num,
             after.amount,
             date_format(from_utc_timestamp(
                                 cast(after.estimate_arrive_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')             estimate_arrive_time,
             after.distance
      from ods_order_info_full after
      where dt = '20250719'
     ) info
     on cargo.order_id = info.id
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_cargo_type
     on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_status
     on info.status = cast(dic_for_status.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_collect_type
     on info.collect_type = cast(dic_for_cargo_type.id as string);

select * from dwd_trade_order_detail_inc;

-- 2. dwd_trade_pay_suc_detail_inc
-- 2.1 首日装载
select * from tms.ods_order_cargo_full;
select * from tms.ods_order_info_full;
select * from dwd_trade_pay_suc_detail_inc;

set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table tms.dwd_trade_pay_suc_detail_inc
    partition (dt)
select cargo.id,
       order_id,
       cargo_type,
       dic_for_cargo_type.name                 cargo_type_name,
       volume_length,
       volume_width,
       volume_height,
       weight,
       payment_time,
       order_no,
       status,
       dic_for_status.name                     status_name,
       collect_type,
       dic_for_collect_type.name               collect_type_name,
       user_id,
       receiver_complex_id,
       receiver_province_id,
       receiver_city_id,
       receiver_district_id,
       receiver_name,
       sender_complex_id,
       sender_province_id,
       sender_city_id,
       sender_district_id,
       sender_name,
       payment_type,
       dic_for_payment_type.name               payment_type_name,
       cargo_num,
       amount,
       estimate_arrive_time,
       distance,
       dt,
       date_format(payment_time, 'yyyy-MM-dd') dt
from (select after.id,
             after.order_id,
             after.cargo_type,
             after.volume_length,
             after.volume_width,
             after.volume_height,
             after.weight,
             dt
      from ods_order_cargo_full after
      where dt = '20250719'
        and after.is_deleted = '0') cargo
         join
     (select after.id,
             after.order_no,
             after.status,
             after.collect_type,
             after.user_id,
             after.receiver_complex_id,
             after.receiver_province_id,
             after.receiver_city_id,
             after.receiver_district_id,
             concat(substr(after.receiver_name, 1, 1), '*')                                  receiver_name,
             after.sender_complex_id,
             after.sender_province_id,
             after.sender_city_id,
             after.sender_district_id,
             concat(substr(after.sender_name, 1, 1), '*')                                    sender_name,
             after.payment_type,
             after.cargo_num,
             after.amount,
             date_format(from_utc_timestamp(
                                 cast(after.estimate_arrive_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')                                              estimate_arrive_time,
             after.distance,
             concat(substr(after.update_time, 1, 10), ' ', substr(after.update_time, 12, 8)) payment_time
      from ods_order_info_full after
      where dt = '20250719'
        and after.is_deleted = '0'
        and after.status <> '60010'
        and after.status <> '60999') info
     on cargo.order_id = info.id
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_cargo_type
     on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_status
     on info.status = cast(dic_for_status.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_collect_type
     on info.collect_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_payment_type
     on info.payment_type = cast(dic_for_payment_type.id as string);

select * from dwd_trade_pay_suc_detail_inc;

-- 2.2 每日装载
select * from ods_order_info_full;
select * from ods_base_dic_full;
select * from ods_order_cargo_full;
select * from dwd_trade_order_process_inc;


with pay_info
         as
         (select without_status.id,
                 order_no,
                 status,
                 dic_for_status.name status_name,
                 collect_type,
                 user_id,
                 receiver_complex_id,
                 receiver_province_id,
                 receiver_city_id,
                 receiver_district_id,
                 receiver_name,
                 sender_complex_id,
                 sender_province_id,
                 sender_city_id,
                 sender_district_id,
                 sender_name,
                 payment_type,
                 dic_type_name.name  payment_type_name,
                 cargo_num,
                 amount,
                 estimate_arrive_time,
                 distance,
                 payment_time,
                 dt
          from (select after.id,
                       after.order_no,
                       after.status,
                       after.collect_type,
                       after.user_id,
                       after.receiver_complex_id,
                       after.receiver_province_id,
                       after.receiver_city_id,
                       after.receiver_district_id,
                       concat(substr(after.receiver_name, 1, 1), '*')       receiver_name,
                       after.sender_complex_id,
                       after.sender_province_id,
                       after.sender_city_id,
                       after.sender_district_id,
                       concat(substr(after.sender_name, 1, 1), '*')         sender_name,
                       after.payment_type,
                       after.cargo_num,
                       after.amount,
                       date_format(from_utc_timestamp(
                                           cast(after.estimate_arrive_time as bigint), 'UTC'),
                                   'yyyy-MM-dd HH:mm:ss')                   estimate_arrive_time,
                       after.distance,
                       date_format(
                               from_utc_timestamp(
                                           to_unix_timestamp(concat(substr(after.update_time, 1, 10), ' ',
                                                                    substr(after.update_time, 12, 8))) * 1000,
                                           'GMT+8'), 'yyyy-MM-dd HH:mm:ss') payment_time,
                       dt
                from ods_order_info_full after
                where dt = '20250719'
                  and status = '60010'
                  and after.status = '60020'
                  and after.is_deleted = '0') without_status
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_for_status
               on without_status.status = cast(dic_for_status.id as string)
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_type_name
               on without_status.payment_type = cast(dic_type_name.id as string)),
     order_info
         as (
         select id,
                order_id,
                cargo_type,
                cargo_type_name,
                volume_length,
                volume_width,
                volume_height,
                weight,
                order_time,
                order_no,
                status,
                status_name,
                collect_type,
                collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                payment_type,
                payment_type_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from dwd_trade_order_process_inc
         where dt = '9999-12-31'
           and status = '60010'
         union
         select cargo.id,
                order_id,
                cargo_type,
                dic_for_cargo_type.name   cargo_type_name,
                volume_length,
                volumn_width,
                volumn_height,
                weight,
                order_time,
                order_no,
                status,
                dic_for_status.name       status_name,
                collect_type,
                dic_for_collect_type.name collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                ''                        payment_type,
                ''                        payment_type_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from (select after.id,
                      after.order_id,
                      after.cargo_type,
                      after.volume_length,
                      after.volume_width,
                      after.volume_height,
                      after.weight,
                      date_format(
                              from_utc_timestamp(
                                          to_unix_timestamp(concat(substr(after.create_time, 1, 10), ' ',
                                                                   substr(after.create_time, 12, 8))) * 1000,
                                          'GMT+8'), 'yyyy-MM-dd HH:mm:ss') order_time,
                      dt
               from ods_order_cargo_full after
               where dt = '20250719'
              ) cargo
                  join
              (select after.id,
                      after.order_no,
                      after.status,
                      after.collect_type,
                      after.user_id,
                      after.receiver_complex_id,
                      after.receiver_province_id,
                      after.receiver_city_id,
                      after.receiver_district_id,
                      concat(substr(after.receiver_name, 1, 1), '*') receiver_name,
                      after.sender_complex_id,
                      after.sender_province_id,
                      after.sender_city_id,
                      after.sender_district_id,
                      concat(substr(after.sender_name, 1, 1), '*')   sender_name,
                      after.cargo_num,
                      after.amount,
                      date_format(from_utc_timestamp(
                                          cast(after.estimate_arrive_time as bigint), 'UTC'),
                                  'yyyy-MM-dd HH:mm:ss')             estimate_arrive_time,
                      after.distance
               from ods_order_info_full after
               where dt = '20250719'
              ) info
              on cargo.order_id = info.id
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_cargo_type
              on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_status
              on info.status = cast(dic_for_status.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_collect_type
              on info.collect_type = cast(dic_for_cargo_type.id as string))


insert overwrite table tms.dwd_trade_pay_suc_detail_inc
partition(dt = '20220708')
select order_info.id,
       order_id,
       cargo_type,
       cargo_type_name,
       volume_length,
       volume_width,
       volume_height,
       weight,
       pay_info.payment_time,
       order_info.order_no,
       pay_info.status,
       pay_info.status_name,
       order_info.collect_type,
       collect_type_name,
       order_info.user_id,
       order_info.receiver_complex_id,
       order_info.receiver_province_id,
       order_info.receiver_city_id,
       order_info.receiver_district_id,
       order_info.receiver_name,
       order_info.sender_complex_id,
       order_info.sender_province_id,
       order_info.sender_city_id,
       order_info.sender_district_id,
       order_info.sender_name,
       pay_info.payment_type,
       pay_info.payment_type_name,
       order_info.cargo_num,
       order_info.amount,
       order_info.estimate_arrive_time,
       order_info.distance,
       pay_info.dt
from pay_info
         join order_info
              on pay_info.id = order_info.order_id;


select * from ods_base_dic_full;
select * from ods_order_cargo_full;
select * from ods_order_info_full;
select * from dwd_trade_pay_suc_detail_inc;

-- 3. dwd_trade_order_cancel_detail_inc
-- 3.1 首日装载
select * from dwd_trade_order_cancel_detail_inc;
select status from ods_order_info_full;
select * from ods_base_dic_full where is_deleted = '0';

set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table tms.dwd_trade_order_cancel_detail_inc
    partition (dt)
select cargo.id,
       order_id,
       cargo_type,
       dic_for_cargo_type.name                 cargo_type_name,
       volume_length,
       volume_width,
       volume_height,
       weight,
       cancel_time,
       order_no,
       status,
       dic_for_status.name                     status_name,
       collect_type,
       dic_for_collect_type.name               collect_type_name,
       user_id,
       receiver_complex_id,
       receiver_province_id,
       receiver_city_id,
       receiver_district_id,
       receiver_name,
       sender_complex_id,
       sender_province_id,
       sender_city_id,
       sender_district_id,
       sender_name,
       cargo_num,
       amount,
       estimate_arrive_time,
       distance,
       dt,
       date_format(cancel_time, 'yyyy-MM-dd') dt
from (select after.id,
             after.order_id,
             after.cargo_type,
             after.volume_length,
             after.volume_width,
             after.volume_height,
             after.weight,
             dt
      from ods_order_cargo_full after
      where dt = '20250719'
        and after.is_deleted = '0') cargo
         join
     (select after.id,
             after.order_no,
             after.status,
             after.collect_type,
             after.user_id,
             after.receiver_complex_id,
             after.receiver_province_id,
             after.receiver_city_id,
             after.receiver_district_id,
             concat(substr(after.receiver_name, 1, 1), '*')                                  receiver_name,
             after.sender_complex_id,
             after.sender_province_id,
             after.sender_city_id,
             after.sender_district_id,
             concat(substr(after.sender_name, 1, 1), '*')                                    sender_name,
             after.cargo_num,
             after.amount,
             date_format(from_utc_timestamp(
                                 cast(after.estimate_arrive_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')                                              estimate_arrive_time,
             after.distance,
             concat(substr(after.update_time, 1, 10), ' ', substr(after.update_time, 12, 8)) cancel_time
      from ods_order_info_full after
      where dt = '20250719'
        and after.is_deleted = '0'
        and after.status = '60050') info
     on cargo.order_id = info.id
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_cargo_type
     on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_status
     on info.status = cast(dic_for_status.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_collect_type
     on info.collect_type = cast(dic_for_cargo_type.id as string);

select * from dwd_trade_order_cancel_detail_inc;
select * from dwd_trade_order_process_inc;

-- 3.2 每日装载
-- 1111

with cancel_info
         as
         (select without_status.id,
                 order_no,
                 status,
                 dic_for_status.name status_name,
                 collect_type,
                 user_id,
                 receiver_complex_id,
                 receiver_province_id,
                 receiver_city_id,
                 receiver_district_id,
                 receiver_name,
                 sender_complex_id,
                 sender_province_id,
                 sender_city_id,
                 sender_district_id,
                 sender_name,
                 cargo_num,
                 amount,
                 estimate_arrive_time,
                 distance,
                 cancel_time,
                 dt
          from (select after.id,
                       after.order_no,
                       after.status,
                       after.collect_type,
                       after.user_id,
                       after.receiver_complex_id,
                       after.receiver_province_id,
                       after.receiver_city_id,
                       after.receiver_district_id,
                       concat(substr(after.receiver_name, 1, 1), '*')       receiver_name,
                       after.sender_complex_id,
                       after.sender_province_id,
                       after.sender_city_id,
                       after.sender_district_id,
                       concat(substr(after.sender_name, 1, 1), '*')         sender_name,
                       after.payment_type,
                       after.cargo_num,
                       after.amount,
                       date_format(from_utc_timestamp(
                                           cast(after.estimate_arrive_time as bigint), 'UTC'),
                                   'yyyy-MM-dd HH:mm:ss')                   estimate_arrive_time,
                       after.distance,
                       date_format(
                               from_utc_timestamp(
                                           to_unix_timestamp(concat(substr(after.update_time, 1, 10), ' ',
                                                                    substr(after.update_time, 12, 8))) * 1000,
                                           'GMT+8'), 'yyyy-MM-dd HH:mm:ss') cancel_time,
                       dt
                from ods_order_info_full after
                where dt = '20220708'
                  and after.status = '60050'
                  and after.is_deleted = '0') without_status
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_for_status
               on without_status.status = cast(dic_for_status.id as string)),
     order_info
         as (
         select id,
                order_id,
                cargo_type,
                cargo_type_name,
                volumn_length,
                volumn_width,
                volumn_height,
                weight,
                order_time,
                order_no,
                status,
                status_name,
                collect_type,
                collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from dwd_trade_order_process_inc
         where dt = '9999-12-31'
         union
         select cargo.id,
                order_id,
                cargo_type,
                dic_for_cargo_type.name   cargo_type_name,
                volume_length,
                volume_width,
                volume_height,
                weight,
                order_time,
                order_no,
                status,
                dic_for_status.name       status_name,
                collect_type,
                dic_for_collect_type.name collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from (select after.id,
                      after.order_id,
                      after.cargo_type,
                      after.volume_length,
                      after.volume_width,
                      after.volume_height,
                      after.weight,
                      date_format(
                              from_utc_timestamp(
                                          to_unix_timestamp(concat(substr(after.create_time, 1, 10), ' ',
                                                                   substr(after.create_time, 12, 8))) * 1000,
                                          'GMT+8'), 'yyyy-MM-dd HH:mm:ss') order_time,
                      dt
               from ods_order_cargo_full after
               where dt = '20250719'
              ) cargo
                  join
              (select after.id,
                      after.order_no,
                      after.status,
                      after.collect_type,
                      after.user_id,
                      after.receiver_complex_id,
                      after.receiver_province_id,
                      after.receiver_city_id,
                      after.receiver_district_id,
                      concat(substr(after.receiver_name, 1, 1), '*') receiver_name,
                      after.sender_complex_id,
                      after.sender_province_id,
                      after.sender_city_id,
                      after.sender_district_id,
                      concat(substr(after.sender_name, 1, 1), '*')   sender_name,
                      after.cargo_num,
                      after.amount,
                      date_format(from_utc_timestamp(
                                          cast(after.estimate_arrive_time as bigint), 'UTC'),
                                  'yyyy-MM-dd HH:mm:ss')             estimate_arrive_time,
                      after.distance
               from ods_order_info_full after
               where dt = '20250719'
              ) info
              on cargo.order_id = info.id
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_cargo_type
              on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_status
              on info.status = cast(dic_for_status.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_collect_type
              on info.collect_type = cast(dic_for_cargo_type.id as string))
insert overwrite table tms.dwd_trade_order_cancel_detail_inc
partition(dt = '20220708')
select order_info.id,
       order_id,
       cargo_type,
       cargo_type_name,
       volumn_length,
       volumn_width,
       volumn_height,
       weight,
       cancel_info.cancel_time,
       order_info.order_no,
       cancel_info.status,
       cancel_info.status_name,
       order_info.collect_type,
       collect_type_name,
       order_info.user_id,
       order_info.receiver_complex_id,
       order_info.receiver_province_id,
       order_info.receiver_city_id,
       order_info.receiver_district_id,
       order_info.receiver_name,
       order_info.sender_complex_id,
       order_info.sender_province_id,
       order_info.sender_city_id,
       order_info.sender_district_id,
       order_info.sender_name,
       order_info.cargo_num,
       order_info.amount,
       order_info.estimate_arrive_time,
       order_info.distance,
       cancel_info.dt
from cancel_info
         join order_info
              on cancel_info.id = order_info.order_id;

select * from dwd_trade_order_cancel_detail_inc;

-- 4. dwd_trans_receive_detail_inc
-- 4.1 首日装载
select * from dwd_trans_receive_detail_inc;

set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table tms.dwd_trans_receive_detail_inc
    partition (dt)
select cargo.id,
       order_id,
       cargo_type,
       dic_for_cargo_type.name                 cargo_type_name,
       volume_length,
       volume_width,
       volume_height,
       weight,
       receive_time,
       order_no,
       status,
       dic_for_status.name                     status_name,
       collect_type,
       dic_for_collect_type.name               collect_type_name,
       user_id,
       receiver_complex_id,
       receiver_province_id,
       receiver_city_id,
       receiver_district_id,
       receiver_name,
       sender_complex_id,
       sender_province_id,
       sender_city_id,
       sender_district_id,
       sender_name,
       payment_type,
       dic_for_payment_type.name               payment_type_name,
       cargo_num,
       amount,
       estimate_arrive_time,
       distance,
       dt,
       date_format(receive_time, 'yyyy-MM-dd') dt
from (select after.id,
             after.order_id,
             after.cargo_type,
             after.volume_length,
             after.volume_width,
             after.volume_height,
             after.weight,
             dt
      from ods_order_cargo_full after
      where dt = '20250719'
        and after.is_deleted = '0') cargo
         join
     (select after.id,
             after.order_no,
             after.status,
             after.collect_type,
             after.user_id,
             after.receiver_complex_id,
             after.receiver_province_id,
             after.receiver_city_id,
             after.receiver_district_id,
             concat(substr(after.receiver_name, 1, 1), '*')                                  receiver_name,
             after.sender_complex_id,
             after.sender_province_id,
             after.sender_city_id,
             after.sender_district_id,
             concat(substr(after.sender_name, 1, 1), '*')                                    sender_name,
             after.payment_type,
             after.cargo_num,
             after.amount,
             date_format(from_utc_timestamp(
                                 cast(after.estimate_arrive_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')                                              estimate_arrive_time,
             after.distance,
             concat(substr(after.update_time, 1, 10), ' ', substr(after.update_time, 12, 8)) receive_time
      from ods_order_info_full after
      where dt = '20250719'
        and after.is_deleted = '0'
        and after.status <> '60050'
        and after.status <> '60050'
        and after.status <> '60050') info
     on cargo.order_id = info.id
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_cargo_type
     on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_status
     on info.status = cast(dic_for_status.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_collect_type
     on info.collect_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_payment_type
     on info.payment_type = cast(dic_for_payment_type.id as string);

-- 4.2 每日装载

with receive_info
         as
         (select without_status.id,
                 order_no,
                 status,
                 dic_for_status.name status_name,
                 collect_type,
                 user_id,
                 receiver_complex_id,
                 receiver_province_id,
                 receiver_city_id,
                 receiver_district_id,
                 receiver_name,
                 sender_complex_id,
                 sender_province_id,
                 sender_city_id,
                 sender_district_id,
                 sender_name,
                 payment_type,
                 dic_type_name.name  payment_type_name,
                 cargo_num,
                 amount,
                 estimate_arrive_time,
                 distance,
                 receive_time,
                 dt
          from (select after.id,
                       after.order_no,
                       after.status,
                       after.collect_type,
                       after.user_id,
                       after.receiver_complex_id,
                       after.receiver_province_id,
                       after.receiver_city_id,
                       after.receiver_district_id,
                       concat(substr(after.receiver_name, 1, 1), '*')       receiver_name,
                       after.sender_complex_id,
                       after.sender_province_id,
                       after.sender_city_id,
                       after.sender_district_id,
                       concat(substr(after.sender_name, 1, 1), '*')         sender_name,
                       after.payment_type,
                       after.cargo_num,
                       after.amount,
                       date_format(from_utc_timestamp(
                                           cast(after.estimate_arrive_time as bigint), 'UTC'),
                                   'yyyy-MM-dd HH:mm:ss')                   estimate_arrive_time,
                       after.distance,
                       date_format(
                               from_utc_timestamp(
                                           to_unix_timestamp(concat(substr(after.update_time, 1, 10), ' ',
                                                                    substr(after.update_time, 12, 8))) * 1000,
                                           'GMT+8'), 'yyyy-MM-dd HH:mm:ss') receive_time,
                       dt
                from ods_order_info_full after
                where dt = '20250719'
                  and status = '60050'
                  and after.status = '60050'
                  and after.is_deleted = '0') without_status
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_for_status
               on without_status.status = cast(dic_for_status.id as string)
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_type_name
               on without_status.payment_type = cast(dic_type_name.id as string)),
     order_info
         as (
         select id,
                order_id,
                cargo_type,
                cargo_type_name,
                volumn_length,
                volumn_width,
                volumn_height,
                weight,
                order_time,
                order_no,
                status,
                status_name,
                collect_type,
                collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                payment_type,
                payment_type_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from dwd_trade_order_process_inc
         where dt = '9999-12-31'
           and (status = '60050' or
                status = '60050')
         union
         select cargo.id,
                order_id,
                cargo_type,
                dic_for_cargo_type.name   cargo_type_name,
                volume_length,
                volume_width,
                volume_height,
                weight,
                order_time,
                order_no,
                status,
                dic_for_status.name       status_name,
                collect_type,
                dic_for_collect_type.name collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                ''                        payment_type,
                ''                        payment_type_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from (select after.id,
                      after.order_id,
                      after.cargo_type,
                      after.volume_length,
                      after.volume_width,
                      after.volume_height,
                      after.weight,
                      date_format(
                              from_utc_timestamp(
                                          to_unix_timestamp(concat(substr(after.create_time, 1, 10), ' ',
                                                                   substr(after.create_time, 12, 8))) * 1000,
                                          'GMT+8'), 'yyyy-MM-dd HH:mm:ss') order_time,
                      dt
               from ods_order_cargo_full after
               where dt = '20250719'
              ) cargo
                  join
              (select after.id,
                      after.order_no,
                      after.status,
                      after.collect_type,
                      after.user_id,
                      after.receiver_complex_id,
                      after.receiver_province_id,
                      after.receiver_city_id,
                      after.receiver_district_id,
                      concat(substr(after.receiver_name, 1, 1), '*') receiver_name,
                      after.sender_complex_id,
                      after.sender_province_id,
                      after.sender_city_id,
                      after.sender_district_id,
                      concat(substr(after.sender_name, 1, 1), '*')   sender_name,
                      after.cargo_num,
                      after.amount,
                      date_format(from_utc_timestamp(
                                          cast(after.estimate_arrive_time as bigint), 'UTC'),
                                  'yyyy-MM-dd HH:mm:ss')             estimate_arrive_time,
                      after.distance
               from ods_order_info_full after
               where dt = '20250719'
              ) info
              on cargo.order_id = info.id
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20190610'
                 and is_deleted = '0') dic_for_cargo_type
              on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20190610'
                 and is_deleted = '0') dic_for_status
              on info.status = cast(dic_for_status.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20190610'
                 and is_deleted = '0') dic_for_collect_type
              on info.collect_type = cast(dic_for_cargo_type.id as string))
insert overwrite table tms.dwd_trans_receive_detail_inc
partition(dt = '20190610')
select order_info.id,
       order_id,
       cargo_type,
       cargo_type_name,
       volumn_length,
       volumn_width,
       volumn_height,
       weight,
       receive_info.receive_time,
       order_info.order_no,
       receive_info.status,
       receive_info.status_name,
       order_info.collect_type,
       collect_type_name,
       order_info.user_id,
       order_info.receiver_complex_id,
       order_info.receiver_province_id,
       order_info.receiver_city_id,
       order_info.receiver_district_id,
       order_info.receiver_name,
       order_info.sender_complex_id,
       order_info.sender_province_id,
       order_info.sender_city_id,
       order_info.sender_district_id,
       order_info.sender_name,
       receive_info.payment_type,
       receive_info.payment_type_name,
       order_info.cargo_num,
       order_info.amount,
       order_info.estimate_arrive_time,
       order_info.distance,
       receive_info.dt
from receive_info
         join order_info
              on receive_info.id = order_info.order_id;

select * from dwd_trans_receive_detail_inc;

-- 5. dwd_trans_dispatch_detail_inc
-- 5.1 首日装载
-- todo 111
select * from ods_order_info_full where status <> 60010  and status <> '60020'
                                    and status <> '60030'
                                    and status <> '60040'
                                    and status <> '60999';

select * from dwd_trans_dispatch_detail_inc;

set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table tms.dwd_trans_dispatch_detail_inc
    partition (dt)
select cargo.id,
       order_id,
       cargo_type,
       dic_for_cargo_type.name                 cargo_type_name,
       volume_length,
       volume_width,
       volume_height,
       weight,
       dispatch_time,
       order_no,
       status,
       dic_for_status.name                     status_name,
       collect_type,
       dic_for_collect_type.name               collect_type_name,
       user_id,
       receiver_complex_id,
       receiver_province_id,
       receiver_city_id,
       receiver_district_id,
       receiver_name,
       sender_complex_id,
       sender_province_id,
       sender_city_id,
       sender_district_id,
       sender_name,
       payment_type,
       dic_for_payment_type.name               payment_type_name,
       cargo_num,
       amount,
       estimate_arrive_time,
       distance,
       dt,
       date_format(dispatch_time, 'yyyy-MM-dd') dt
from (select after.id,
             after.order_id,
             after.cargo_type,
             after.volume_length,
             after.volume_width,
             after.volume_height,
             after.weight,
             dt
      from ods_order_cargo_full after
      where dt = '20250719'
        and after.is_deleted = '0') cargo
         join
     (select after.id,
             after.order_no,
             after.status,
             after.collect_type,
             after.user_id,
             after.receiver_complex_id,
             after.receiver_province_id,
             after.receiver_city_id,
             after.receiver_district_id,
             concat(substr(after.receiver_name, 1, 1), '*')                                  receiver_name,
             after.sender_complex_id,
             after.sender_province_id,
             after.sender_city_id,
             after.sender_district_id,
             concat(substr(after.sender_name, 1, 1), '*')                                    sender_name,
             after.payment_type,
             after.cargo_num,
             after.amount,
             date_format(from_utc_timestamp(
                                 cast(after.estimate_arrive_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')                                              estimate_arrive_time,
             after.distance,
             concat(substr(after.update_time, 1, 10), ' ', substr(after.update_time, 12, 8)) dispatch_time
      from ods_order_info_full after
      where dt = '20250719'
        and after.is_deleted = '0'
        and after.status <> '60010'
        and after.status <> '60020'
        and after.status <> '60030'
        and after.status <> '60040'
        and after.status <> '60999') info
     on cargo.order_id = info.id
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_cargo_type
     on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_status
     on info.status = cast(dic_for_status.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_collect_type
     on info.collect_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_payment_type
     on info.payment_type = cast(dic_for_payment_type.id as string);

-- 5.2 每日装载
select * from dwd_trade_order_process_inc  where dt = '9999-12-31' and (status = '60010' or
                                                                        status = '60020' or
                                                                        status = '60030' or
                                                                        status = '60040');

select * from  dwd_trade_order_process_inc;

with dispatch_info
         as
         (select without_status.id,
                 order_no,
                 status,
                 dic_for_status.name status_name,
                 collect_type,
                 user_id,
                 receiver_complex_id,
                 receiver_province_id,
                 receiver_city_id,
                 receiver_district_id,
                 receiver_name,
                 sender_complex_id,
                 sender_province_id,
                 sender_city_id,
                 sender_district_id,
                 sender_name,
                 payment_type,
                 dic_type_name.name  payment_type_name,
                 cargo_num,
                 amount,
                 estimate_arrive_time,
                 distance,
                 dispatch_time,
                 dt
          from (select after.id,
                       after.order_no,
                       after.status,
                       after.collect_type,
                       after.user_id,
                       after.receiver_complex_id,
                       after.receiver_province_id,
                       after.receiver_city_id,
                       after.receiver_district_id,
                       concat(substr(after.receiver_name, 1, 1), '*')       receiver_name,
                       after.sender_complex_id,
                       after.sender_province_id,
                       after.sender_city_id,
                       after.sender_district_id,
                       concat(substr(after.sender_name, 1, 1), '*')         sender_name,
                       after.payment_type,
                       after.cargo_num,
                       after.amount,
                       date_format(from_utc_timestamp(
                                           cast(after.estimate_arrive_time as bigint), 'UTC'),
                                   'yyyy-MM-dd HH:mm:ss')                   estimate_arrive_time,
                       after.distance,
                       date_format(
                               from_utc_timestamp(
                                           to_unix_timestamp(concat(substr(after.update_time, 1, 10), ' ',
                                                                    substr(after.update_time, 12, 8))) * 1000,
                                           'GMT+8'), 'yyyy-MM-dd HH:mm:ss') dispatch_time,
                       dt
                from ods_order_info_full after
                where dt = '20220708'
                  and status = '60050'
                  and after.status = '60050'
                  and after.is_deleted = '0') without_status
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_for_status
               on without_status.status = cast(dic_for_status.id as string)
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_type_name
               on without_status.payment_type = cast(dic_type_name.id as string)),
     order_info
         as (
         select id,
                order_id,
                cargo_type,
                cargo_type_name,
                volumn_length,
                volumn_width,
                volumn_height,
                weight,
                order_time,
                order_no,
                status,
                status_name,
                collect_type,
                collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                payment_type,
                payment_type_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from dwd_trade_order_process_inc
         where dt = '9999-12-31'
           and (status = '60010' or
                status = '60020' or
                status = '60030' or
                status = '60040')
         union
         select cargo.id,
                order_id,
                cargo_type,
                dic_for_cargo_type.name   cargo_type_name,
                volume_length,
                volume_width,
                volume_height,
                weight,
                order_time,
                order_no,
                status,
                dic_for_status.name       status_name,
                collect_type,
                dic_for_collect_type.name collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                ''                        payment_type,
                ''                        payment_type_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from (select after.id,
                      after.order_id,
                      after.cargo_type,
                      after.volume_length,
                      after.volume_width,
                      after.volume_height,
                      after.weight,
                      date_format(
                              from_utc_timestamp(
                                          to_unix_timestamp(concat(substr(after.create_time, 1, 10), ' ',
                                                                   substr(after.create_time, 12, 8))) * 1000,
                                          'GMT+8'), 'yyyy-MM-dd HH:mm:ss') order_time,
                      dt
               from ods_order_cargo_full after
               where dt = '20250719'
              ) cargo
                  join
              (select after.id,
                      after.order_no,
                      after.status,
                      after.collect_type,
                      after.user_id,
                      after.receiver_complex_id,
                      after.receiver_province_id,
                      after.receiver_city_id,
                      after.receiver_district_id,
                      concat(substr(after.receiver_name, 1, 1), '*') receiver_name,
                      after.sender_complex_id,
                      after.sender_province_id,
                      after.sender_city_id,
                      after.sender_district_id,
                      concat(substr(after.sender_name, 1, 1), '*')   sender_name,
                      after.cargo_num,
                      after.amount,
                      date_format(from_utc_timestamp(
                                          cast(after.estimate_arrive_time as bigint), 'UTC'),
                                  'yyyy-MM-dd HH:mm:ss')             estimate_arrive_time,
                      after.distance
               from ods_order_info_full after
               where dt = '20250719'
              ) info
              on cargo.order_id = info.id
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_cargo_type
              on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_status
              on info.status = cast(dic_for_status.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_collect_type
              on info.collect_type = cast(dic_for_cargo_type.id as string))
insert overwrite table tms.dwd_trans_dispatch_detail_inc
partition(dt = '20220708')
select order_info.id,
       order_id,
       cargo_type,
       cargo_type_name,
       volumn_length,
       volumn_width,
       volumn_height,
       weight,
       dispatch_info.dispatch_time,
       order_info.order_no,
       dispatch_info.status,
       dispatch_info.status_name,
       order_info.collect_type,
       collect_type_name,
       order_info.user_id,
       order_info.receiver_complex_id,
       order_info.receiver_province_id,
       order_info.receiver_city_id,
       order_info.receiver_district_id,
       order_info.receiver_name,
       order_info.sender_complex_id,
       order_info.sender_province_id,
       order_info.sender_city_id,
       order_info.sender_district_id,
       order_info.sender_name,
       dispatch_info.payment_type,
       dispatch_info.payment_type_name,
       order_info.cargo_num,
       order_info.amount,
       order_info.estimate_arrive_time,
       order_info.distance,
       dispatch_info.dt
from dispatch_info
         join order_info
              on dispatch_info.id = order_info.order_id;

select * from dwd_trans_dispatch_detail_inc;

-- 6. dwd_trans_bound_finish_detail_inc
-- 6.1 首日装载

select * from ods_order_cargo_full;
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table tms.dwd_trans_bound_finish_detail_inc
    partition (dt)
select cargo.id,
       order_id,
       cargo_type,
       dic_for_cargo_type.name                 cargo_type_name,
       volume_length,
       volume_width,
       volume_height,
       weight,
       bound_finish_time,
       order_no,
       status,
       dic_for_status.name                     status_name,
       collect_type,
       dic_for_collect_type.name               collect_type_name,
       user_id,
       receiver_complex_id,
       receiver_province_id,
       receiver_city_id,
       receiver_district_id,
       receiver_name,
       sender_complex_id,
       sender_province_id,
       sender_city_id,
       sender_district_id,
       sender_name,
       payment_type,
       dic_for_payment_type.name               payment_type_name,
       cargo_num,
       amount,
       estimate_arrive_time,
       distance,
       dt,
       date_format(bound_finish_time, 'yyyy-MM-dd') dt
from (select after.id,
             after.order_id,
             after.cargo_type,
             after.volume_length,
             after.volume_width,
             after.volume_height,
             after.weight,
             dt
      from ods_order_cargo_full after
      where dt = '20250719'
        and after.is_deleted = '0') cargo
         join
     (select after.id,
             after.order_no,
             after.status,
             after.collect_type,
             after.user_id,
             after.receiver_complex_id,
             after.receiver_province_id,
             after.receiver_city_id,
             after.receiver_district_id,
             concat(substr(after.receiver_name, 1, 1), '*')                                  receiver_name,
             after.sender_complex_id,
             after.sender_province_id,
             after.sender_city_id,
             after.sender_district_id,
             concat(substr(after.sender_name, 1, 1), '*')                                    sender_name,
             after.payment_type,
             after.cargo_num,
             after.amount,
             date_format(from_utc_timestamp(
                                 cast(after.estimate_arrive_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')                                              estimate_arrive_time,
             after.distance,
             concat(substr(after.update_time, 1, 10), ' ', substr(after.update_time, 12, 8)) bound_finish_time
      from ods_order_info_full after
      where dt = '20250719'
        and after.is_deleted = '0'
        and after.status <> '60010'
        and after.status <> '60020'
        and after.status <> '60030'
        and after.status <> '60040'
        and after.status <> '60999') info
     on cargo.order_id = info.id
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_cargo_type
     on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_status
     on info.status = cast(dic_for_status.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_collect_type
     on info.collect_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_payment_type
     on info.payment_type = cast(dic_for_payment_type.id as string);

select * from dwd_trans_bound_finish_detail_inc;

-- 6.2 每日装载
select * from ods_order_info_full;

with bound_finish_info
         as
         (select without_status.id,
                 order_no,
                 status,
                 dic_for_status.name status_name,
                 collect_type,
                 user_id,
                 receiver_complex_id,
                 receiver_province_id,
                 receiver_city_id,
                 receiver_district_id,
                 receiver_name,
                 sender_complex_id,
                 sender_province_id,
                 sender_city_id,
                 sender_district_id,
                 sender_name,
                 payment_type,
                 dic_type_name.name  payment_type_name,
                 cargo_num,
                 amount,
                 estimate_arrive_time,
                 distance,
                 bound_finish_time,
                 dt
          from (select after.id,
                       after.order_no,
                       after.status,
                       after.collect_type,
                       after.user_id,
                       after.receiver_complex_id,
                       after.receiver_province_id,
                       after.receiver_city_id,
                       after.receiver_district_id,
                       concat(substr(after.receiver_name, 1, 1), '*')       receiver_name,
                       after.sender_complex_id,
                       after.sender_province_id,
                       after.sender_city_id,
                       after.sender_district_id,
                       concat(substr(after.sender_name, 1, 1), '*')         sender_name,
                       after.payment_type,
                       after.cargo_num,
                       after.amount,
                       date_format(from_utc_timestamp(
                                           cast(after.estimate_arrive_time as bigint), 'UTC'),
                                   'yyyy-MM-dd HH:mm:ss')                   estimate_arrive_time,
                       after.distance,
                       date_format(
                               from_utc_timestamp(
                                           to_unix_timestamp(concat(substr(after.update_time, 1, 10), ' ',
                                                                    substr(after.update_time, 12, 8))) * 1000,
                                           'GMT+8'), 'yyyy-MM-dd HH:mm:ss') bound_finish_time,
                       dt
                from ods_order_info_full after
                where dt = '20250719'
                  and status = '60050'
                  and after.status = '60060'
                  and after.is_deleted = '0') without_status
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_for_status
               on without_status.status = cast(dic_for_status.id as string)
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_type_name
               on without_status.payment_type = cast(dic_type_name.id as string)),
     order_info
         as (
         select id,
                order_id,
                cargo_type,
                cargo_type_name,
                volumn_length,
                volumn_width,
                volumn_height,
                weight,
                order_time,
                order_no,
                status,
                status_name,
                collect_type,
                collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                payment_type,
                payment_type_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from dwd_trade_order_process_inc
         where dt = '9999-12-31'
           and (status = '60010' or
                status = '60020' or
                status = '60030' or
                status = '60040' or
                status = '60050')
         union
         select cargo.id,
                order_id,
                cargo_type,
                dic_for_cargo_type.name   cargo_type_name,
                volume_length,
                volume_width,
                volume_height,
                weight,
                order_time,
                order_no,
                status,
                dic_for_status.name       status_name,
                collect_type,
                dic_for_collect_type.name collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                ''                        payment_type,
                ''                        payment_type_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from (select after.id,
                      after.order_id,
                      after.cargo_type,
                      after.volume_length,
                      after.volume_width,
                      after.volume_height,
                      after.weight,
                      date_format(
                              from_utc_timestamp(
                                          to_unix_timestamp(concat(substr(after.create_time, 1, 10), ' ',
                                                                   substr(after.create_time, 12, 8))) * 1000,
                                          'GMT+8'), 'yyyy-MM-dd HH:mm:ss') order_time,
                      dt
               from ods_order_cargo_full after
               where dt = '20250719'
              ) cargo
                  join
              (select after.id,
                      after.order_no,
                      after.status,
                      after.collect_type,
                      after.user_id,
                      after.receiver_complex_id,
                      after.receiver_province_id,
                      after.receiver_city_id,
                      after.receiver_district_id,
                      concat(substr(after.receiver_name, 1, 1), '*') receiver_name,
                      after.sender_complex_id,
                      after.sender_province_id,
                      after.sender_city_id,
                      after.sender_district_id,
                      concat(substr(after.sender_name, 1, 1), '*')   sender_name,
                      after.cargo_num,
                      after.amount,
                      date_format(from_utc_timestamp(
                                          cast(after.estimate_arrive_time as bigint), 'UTC'),
                                  'yyyy-MM-dd HH:mm:ss')             estimate_arrive_time,
                      after.distance
               from ods_order_info_full after
               where dt = '20250719') info
              on cargo.order_id = info.id
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_cargo_type
              on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_status
              on info.status = cast(dic_for_status.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_collect_type
              on info.collect_type = cast(dic_for_cargo_type.id as string))
insert overwrite table tms.dwd_trans_bound_finish_detail_inc
partition(dt = '2023-01-11')
select order_info.id,
       order_id,
       cargo_type,
       cargo_type_name,
       volumn_length,
       volumn_width,
       volumn_height,
       weight,
       bound_finish_info.bound_finish_time,
       order_info.order_no,
       bound_finish_info.status,
       bound_finish_info.status_name,
       order_info.collect_type,
       collect_type_name,
       order_info.user_id,
       order_info.receiver_complex_id,
       order_info.receiver_province_id,
       order_info.receiver_city_id,
       order_info.receiver_district_id,
       order_info.receiver_name,
       order_info.sender_complex_id,
       order_info.sender_province_id,
       order_info.sender_city_id,
       order_info.sender_district_id,
       order_info.sender_name,
       bound_finish_info.payment_type,
       bound_finish_info.payment_type_name,
       order_info.cargo_num,
       order_info.amount,
       order_info.estimate_arrive_time,
       order_info.distance,
       bound_finish_info.dt
from bound_finish_info
         join order_info
              on bound_finish_info.id = order_info.order_id;

select * from dwd_trans_bound_finish_detail_inc;

-- 7. dwd_trans_deliver_suc_detail_inc
-- 7.1 首日装载

select * from ods_order_cargo_full;

set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table tms.dwd_trans_deliver_suc_detail_inc
    partition (dt)
select cargo.id,
       order_id,
       cargo_type,
       dic_for_cargo_type.name                 cargo_type_name,
       volume_length,
       volume_width,
       volume_height,
       weight,
       deliver_suc_time,
       order_no,
       status,
       dic_for_status.name                     status_name,
       collect_type,
       dic_for_collect_type.name               collect_type_name,
       user_id,
       receiver_complex_id,
       receiver_province_id,
       receiver_city_id,
       receiver_district_id,
       receiver_name,
       sender_complex_id,
       sender_province_id,
       sender_city_id,
       sender_district_id,
       sender_name,
       payment_type,
       dic_for_payment_type.name               payment_type_name,
       cargo_num,
       amount,
       estimate_arrive_time,
       distance,
       dt,
       date_format(deliver_suc_time, 'yyyy-MM-dd') dt
from (select after.id,
             after.order_id,
             after.cargo_type,
             after.volume_length,
             after.volume_width,
             after.volume_height,
             after.weight,
             dt
      from ods_order_cargo_full after
      where dt = '20250719'
        and after.is_deleted = '0') cargo
         join
     (select after.id,
             after.order_no,
             after.status,
             after.collect_type,
             after.user_id,
             after.receiver_complex_id,
             after.receiver_province_id,
             after.receiver_city_id,
             after.receiver_district_id,
             concat(substr(after.receiver_name, 1, 1), '*')                                  receiver_name,
             after.sender_complex_id,
             after.sender_province_id,
             after.sender_city_id,
             after.sender_district_id,
             concat(substr(after.sender_name, 1, 1), '*')                                    sender_name,
             after.payment_type,
             after.cargo_num,
             after.amount,
             date_format(from_utc_timestamp(
                                 cast(after.estimate_arrive_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')                                              estimate_arrive_time,
             after.distance,
             concat(substr(after.update_time, 1, 10), ' ', substr(after.update_time, 12, 8)) deliver_suc_time
      from ods_order_info_full after
      where dt = '20250719'
        and after.is_deleted = '0'
        and after.status <> '60010'
        and after.status <> '60020'
        and after.status <> '60030'
        and after.status <> '60040'
        and after.status <> '60060'
        and after.status <> '60999') info
     on cargo.order_id = info.id
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_cargo_type
     on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_status
     on info.status = cast(dic_for_status.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_collect_type
     on info.collect_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_payment_type
     on info.payment_type = cast(dic_for_payment_type.id as string);

select * from dwd_trans_deliver_suc_detail_inc;

-- 7.2 每日装载

select * from ods_order_info_full  where dt = '20250719'
                                     and status = '60050'
                                     and status = '60050'
                                     and is_deleted = '0';

with deliver_suc_info
         as
         (select without_status.id,
                 order_no,
                 status,
                 dic_for_status.name status_name,
                 collect_type,
                 user_id,
                 receiver_complex_id,
                 receiver_province_id,
                 receiver_city_id,
                 receiver_district_id,
                 receiver_name,
                 sender_complex_id,
                 sender_province_id,
                 sender_city_id,
                 sender_district_id,
                 sender_name,
                 payment_type,
                 dic_type_name.name  payment_type_name,
                 cargo_num,
                 amount,
                 estimate_arrive_time,
                 distance,
                 deliver_suc_time,
                 dt
          from (select after.id,
                       after.order_no,
                       after.status,
                       after.collect_type,
                       after.user_id,
                       after.receiver_complex_id,
                       after.receiver_province_id,
                       after.receiver_city_id,
                       after.receiver_district_id,
                       concat(substr(after.receiver_name, 1, 1), '*')       receiver_name,
                       after.sender_complex_id,
                       after.sender_province_id,
                       after.sender_city_id,
                       after.sender_district_id,
                       concat(substr(after.sender_name, 1, 1), '*')         sender_name,
                       after.payment_type,
                       after.cargo_num,
                       after.amount,
                       date_format(from_utc_timestamp(
                                           cast(after.estimate_arrive_time as bigint), 'UTC'),
                                   'yyyy-MM-dd HH:mm:ss')                   estimate_arrive_time,
                       after.distance,
                       date_format(
                               from_utc_timestamp(
                                           to_unix_timestamp(concat(substr(after.update_time, 1, 10), ' ',
                                                                    substr(after.update_time, 12, 8))) * 1000,
                                           'GMT+8'), 'yyyy-MM-dd HH:mm:ss') deliver_suc_time,
                       dt
                from ods_order_info_full after
                where dt = '20250719'
                  and status = '60050'
                  and after.status = '60050'
                  and after.is_deleted = '0') without_status
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_for_status
               on without_status.status = cast(dic_for_status.id as string)
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_type_name
               on without_status.payment_type = cast(dic_type_name.id as string)),
     order_info
         as (
         select id,
                order_id,
                cargo_type,
                cargo_type_name,
                volumn_length,
                volumn_width,
                volumn_height,
                weight,
                order_time,
                order_no,
                status,
                status_name,
                collect_type,
                collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                payment_type,
                payment_type_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from dwd_trade_order_process_inc
         where dt = '9999-12-31'
           and (status = '60010' or
                status = '60020' or
                status = '60030' or
                status = '60040' or
                status = '60060')
         union
         select cargo.id,
                order_id,
                cargo_type,
                dic_for_cargo_type.name   cargo_type_name,
                volume_length,
                volume_width,
                volume_height,
                weight,
                order_time,
                order_no,
                status,
                dic_for_status.name       status_name,
                collect_type,
                dic_for_collect_type.name collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                ''                        payment_type,
                ''                        payment_type_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from (select after.id,
                      after.order_id,
                      after.cargo_type,
                      after.volume_length,
                      after.volume_width,
                      after.volume_height,
                      after.weight,
                      date_format(
                              from_utc_timestamp(
                                          to_unix_timestamp(concat(substr(after.create_time, 1, 10), ' ',
                                                                   substr(after.create_time, 12, 8))) * 1000,
                                          'GMT+8'), 'yyyy-MM-dd HH:mm:ss') order_time,
                      dt
               from ods_order_cargo_full after
               where dt = '20250719'
              ) cargo
                  join
              (select after.id,
                      after.order_no,
                      after.status,
                      after.collect_type,
                      after.user_id,
                      after.receiver_complex_id,
                      after.receiver_province_id,
                      after.receiver_city_id,
                      after.receiver_district_id,
                      concat(substr(after.receiver_name, 1, 1), '*') receiver_name,
                      after.sender_complex_id,
                      after.sender_province_id,
                      after.sender_city_id,
                      after.sender_district_id,
                      concat(substr(after.sender_name, 1, 1), '*')   sender_name,
                      after.cargo_num,
                      after.amount,
                      date_format(from_utc_timestamp(
                                          cast(after.estimate_arrive_time as bigint), 'UTC'),
                                  'yyyy-MM-dd HH:mm:ss')             estimate_arrive_time,
                      after.distance
               from ods_order_info_full after
               where dt = '20250719'
              ) info
              on cargo.order_id = info.id
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_cargo_type
              on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_status
              on info.status = cast(dic_for_status.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_collect_type
              on info.collect_type = cast(dic_for_cargo_type.id as string))
insert overwrite table tms.dwd_trans_deliver_suc_detail_inc
partition(dt = '20220708')
select order_info.id,
       order_id,
       cargo_type,
       cargo_type_name,
       volumn_length,
       volumn_width,
       volumn_height,
       weight,
       deliver_suc_info.deliver_suc_time,
       order_info.order_no,
       deliver_suc_info.status,
       deliver_suc_info.status_name,
       order_info.collect_type,
       collect_type_name,
       order_info.user_id,
       order_info.receiver_complex_id,
       order_info.receiver_province_id,
       order_info.receiver_city_id,
       order_info.receiver_district_id,
       order_info.receiver_name,
       order_info.sender_complex_id,
       order_info.sender_province_id,
       order_info.sender_city_id,
       order_info.sender_district_id,
       order_info.sender_name,
       deliver_suc_info.payment_type,
       deliver_suc_info.payment_type_name,
       order_info.cargo_num,
       order_info.amount,
       order_info.estimate_arrive_time,
       order_info.distance,
       deliver_suc_info.dt
from deliver_suc_info
         join order_info
              on deliver_suc_info.id = order_info.order_id;

select * from dwd_trans_deliver_suc_detail_inc;

-- 8. dwd_trans_sign_detail_inc
-- 8.1 首日装载

select * from ods_order_cargo_full;

set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table tms.dwd_trans_sign_detail_inc
    partition (dt)
select cargo.id,
       order_id,
       cargo_type,
       dic_for_cargo_type.name                 cargo_type_name,
       volume_length,
       volume_width,
       volume_height,
       weight,
       sign_time,
       order_no,
       status,
       dic_for_status.name                     status_name,
       collect_type,
       dic_for_collect_type.name               collect_type_name,
       user_id,
       receiver_complex_id,
       receiver_province_id,
       receiver_city_id,
       receiver_district_id,
       receiver_name,
       sender_complex_id,
       sender_province_id,
       sender_city_id,
       sender_district_id,
       sender_name,
       payment_type,
       dic_for_payment_type.name               payment_type_name,
       cargo_num,
       amount,
       estimate_arrive_time,
       distance,
       dt,
       date_format(sign_time, 'yyyy-MM-dd') dt
from (select after.id,
             after.order_id,
             after.cargo_type,
             after.volume_length,
             after.volume_width,
             after.volume_height,
             after.weight,
             dt
      from ods_order_cargo_full after
      where dt = '20250719'
        and after.is_deleted = '0') cargo
         join
     (select after.id,
             after.order_no,
             after.status,
             after.collect_type,
             after.user_id,
             after.receiver_complex_id,
             after.receiver_province_id,
             after.receiver_city_id,
             after.receiver_district_id,
             concat(substr(after.receiver_name, 1, 1), '*')                                  receiver_name,
             after.sender_complex_id,
             after.sender_province_id,
             after.sender_city_id,
             after.sender_district_id,
             concat(substr(after.sender_name, 1, 1), '*')                                    sender_name,
             after.payment_type,
             after.cargo_num,
             after.amount,
             date_format(from_utc_timestamp(
                                 cast(after.estimate_arrive_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')                                              estimate_arrive_time,
             after.distance,
             concat(substr(after.update_time, 1, 10), ' ', substr(after.update_time, 12, 8)) sign_time
      from ods_order_info_full after
      where dt = '20250719'
        and after.is_deleted = '0'
        and after.status <> '60010'
        and after.status <> '60020'
        and after.status <> '60030'
        and after.status <> '60040'
        and after.status <> '60060'
        and after.status <> '60070'
        and after.status <> '60999') info
     on cargo.order_id = info.id
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_cargo_type
     on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_status
     on info.status = cast(dic_for_status.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_collect_type
     on info.collect_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_payment_type
     on info.payment_type = cast(dic_for_payment_type.id as string);

select * from dwd_trans_sign_detail_inc;
-- todo 111
-- 8.2 每日装载

select * from ods_order_info_full;
with sign_info
         as
         (select without_status.id,
                 order_no,
                 status,
                 dic_for_status.name status_name,
                 collect_type,
                 user_id,
                 receiver_complex_id,
                 receiver_province_id,
                 receiver_city_id,
                 receiver_district_id,
                 receiver_name,
                 sender_complex_id,
                 sender_province_id,
                 sender_city_id,
                 sender_district_id,
                 sender_name,
                 payment_type,
                 dic_type_name.name  payment_type_name,
                 cargo_num,
                 amount,
                 estimate_arrive_time,
                 distance,
                 sign_time,
                 dt
          from (select after.id,
                       after.order_no,
                       after.status,
                       after.collect_type,
                       after.user_id,
                       after.receiver_complex_id,
                       after.receiver_province_id,
                       after.receiver_city_id,
                       after.receiver_district_id,
                       concat(substr(after.receiver_name, 1, 1), '*')       receiver_name,
                       after.sender_complex_id,
                       after.sender_province_id,
                       after.sender_city_id,
                       after.sender_district_id,
                       concat(substr(after.sender_name, 1, 1), '*')         sender_name,
                       after.payment_type,
                       after.cargo_num,
                       after.amount,
                       date_format(from_utc_timestamp(
                                           cast(after.estimate_arrive_time as bigint), 'UTC'),
                                   'yyyy-MM-dd HH:mm:ss')                   estimate_arrive_time,
                       after.distance,
                       date_format(
                               from_utc_timestamp(
                                           to_unix_timestamp(concat(substr(after.update_time, 1, 10), ' ',
                                                                    substr(after.update_time, 12, 8))) * 1000,
                                           'GMT+8'), 'yyyy-MM-dd HH:mm:ss') sign_time,
                       dt
                from ods_order_info_full after
                where dt = '20250719'
                  and status = '60050'
                  and after.status = '60050'
                  and after.is_deleted = '0') without_status
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_for_status
               on without_status.status = cast(dic_for_status.id as string)
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_type_name
               on without_status.payment_type = cast(dic_type_name.id as string)),
     order_info
         as (
         select id,
                order_id,
                cargo_type,
                cargo_type_name,
                volumn_length,
                volumn_width,
                volumn_height,
                weight,
                order_time,
                order_no,
                status,
                status_name,
                collect_type,
                collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                payment_type,
                payment_type_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from dwd_trade_order_process_inc
         where dt = '9999-12-31'
         union
         select cargo.id,
                order_id,
                cargo_type,
                dic_for_cargo_type.name   cargo_type_name,
                volume_length,
                volume_width,
                volume_height,
                weight,
                order_time,
                order_no,
                status,
                dic_for_status.name       status_name,
                collect_type,
                dic_for_collect_type.name collect_type_name,
                user_id,
                receiver_complex_id,
                receiver_province_id,
                receiver_city_id,
                receiver_district_id,
                receiver_name,
                sender_complex_id,
                sender_province_id,
                sender_city_id,
                sender_district_id,
                sender_name,
                ''                        payment_type,
                ''                        payment_type_name,
                cargo_num,
                amount,
                estimate_arrive_time,
                distance
         from (select after.id,
                      after.order_id,
                      after.cargo_type,
                      after.volume_length,
                      after.volume_width,
                      after.volume_height,
                      after.weight,
                      date_format(
                              from_utc_timestamp(
                                          to_unix_timestamp(concat(substr(after.create_time, 1, 10), ' ',
                                                                   substr(after.create_time, 12, 8))) * 1000,
                                          'GMT+8'), 'yyyy-MM-dd HH:mm:ss') order_time,
                      dt
               from ods_order_cargo_full after
               where dt = '20250719'
              ) cargo
                  join
              (select after.id,
                      after.order_no,
                      after.status,
                      after.collect_type,
                      after.user_id,
                      after.receiver_complex_id,
                      after.receiver_province_id,
                      after.receiver_city_id,
                      after.receiver_district_id,
                      concat(substr(after.receiver_name, 1, 1), '*') receiver_name,
                      after.sender_complex_id,
                      after.sender_province_id,
                      after.sender_city_id,
                      after.sender_district_id,
                      concat(substr(after.sender_name, 1, 1), '*')   sender_name,
                      after.cargo_num,
                      after.amount,
                      date_format(from_utc_timestamp(
                                          cast(after.estimate_arrive_time as bigint), 'UTC'),
                                  'yyyy-MM-dd HH:mm:ss')             estimate_arrive_time,
                      after.distance
               from ods_order_info_full after
               where dt = '20250719'
              ) info
              on cargo.order_id = info.id
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_cargo_type
              on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_status
              on info.status = cast(dic_for_status.id as string)
                  left join
              (select id,
                      name
               from ods_base_dic_full
               where dt = '20220708'
                 and is_deleted = '0') dic_for_collect_type
              on info.collect_type = cast(dic_for_cargo_type.id as string))
insert overwrite table tms.dwd_trans_sign_detail_inc
partition(dt = '20220708')
select order_info.id,
       order_id,
       cargo_type,
       cargo_type_name,
       volumn_length,
       volumn_width,
       volumn_height,
       weight,
       sign_info.sign_time,
       order_info.order_no,
       sign_info.status,
       sign_info.status_name,
       order_info.collect_type,
       collect_type_name,
       order_info.user_id,
       order_info.receiver_complex_id,
       order_info.receiver_province_id,
       order_info.receiver_city_id,
       order_info.receiver_district_id,
       order_info.receiver_name,
       order_info.sender_complex_id,
       order_info.sender_province_id,
       order_info.sender_city_id,
       order_info.sender_district_id,
       order_info.sender_name,
       sign_info.payment_type,
       sign_info.payment_type_name,
       order_info.cargo_num,
       order_info.amount,
       order_info.estimate_arrive_time,
       order_info.distance,
       sign_info.dt
from sign_info
         join order_info
              on sign_info.id = order_info.order_id;

select * from dwd_trans_sign_detail_inc;

-- 9. dwd_trade_order_process_inc
-- 9.1 首日装载
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table tms.dwd_trade_order_process_inc
    partition (dt)
select cargo.id,
       order_id,
       cargo_type,
       dic_for_cargo_type.name               cargo_type_name,
       volume_length,
       volume_width,
       volume_height,
       weight,
       order_time,
       order_no,
       status,
       dic_for_status.name                   status_name,
       collect_type,
       dic_for_collect_type.name             collect_type_name,
       user_id,
       receiver_complex_id,
       receiver_province_id,
       receiver_city_id,
       receiver_district_id,
       receiver_name,
       sender_complex_id,
       sender_province_id,
       sender_city_id,
       sender_district_id,
       sender_name,
       payment_type,
       dic_for_payment_type.name             payment_type_name,
       cargo_num,
       amount,
       estimate_arrive_time,
       distance,
       dt,
       date_format(order_time, 'yyyy-MM-dd') start_date,
       end_date,
       end_date                              dt
from (select after.id,
             after.order_id,
             after.cargo_type,
             after.volume_length,
             after.volume_width,
             after.volume_height,
             after.weight,
             concat(substr(after.create_time, 1, 10), ' ', substr(after.create_time, 12, 8)) order_time,
             dt
      from ods_order_cargo_full after
      where dt = '20250719'
        and after.is_deleted = '0') cargo
         join
     (select after.id,
             after.order_no,
             after.status,
             after.collect_type,
             after.user_id,
             after.receiver_complex_id,
             after.receiver_province_id,
             after.receiver_city_id,
             after.receiver_district_id,
             concat(substr(after.receiver_name, 1, 1), '*') receiver_name,
             after.sender_complex_id,
             after.sender_province_id,
             after.sender_city_id,
             after.sender_district_id,
             concat(substr(after.sender_name, 1, 1), '*')   sender_name,
             after.payment_type,
             after.cargo_num,
             after.amount,
             date_format(from_utc_timestamp(
                                 cast(after.estimate_arrive_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')             estimate_arrive_time,
             after.distance,
             if(after.status = '60080' or
                after.status = '60999',
                concat(substr(after.update_time, 1, 10)),
                '9999-12-31')                               end_date
      from ods_order_info_full after
      where dt = '20250719'
        and after.is_deleted = '0') info
     on cargo.order_id = info.id
         left join
     (select id,
             name
      from ods_base_dic_full after
      where dt = '20220708'
        and is_deleted = '0') dic_for_cargo_type
     on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_status
     on info.status = cast(dic_for_status.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_collect_type
     on info.collect_type = cast(dic_for_cargo_type.id as string)
         left join
     (select id,
             name
      from ods_base_dic_full
      where dt = '20220708'
        and is_deleted = '0') dic_for_payment_type
     on info.payment_type = cast(dic_for_payment_type.id as string);


select * from dwd_trade_order_process_inc;

-- 9.2 每日装载

select * from  dwd_trade_order_process_inc;
with tmp
         as
         (select id,
                 order_id,
                 cargo_type,
                 cargo_type_name,
                 volumn_length,
                 volumn_width,
                 volumn_height,
                 weight,
                 order_time,
                 order_no,
                 status,
                 status_name,
                 collect_type,
                 collect_type_name,
                 user_id,
                 receiver_complex_id,
                 receiver_province_id,
                 receiver_city_id,
                 receiver_district_id,
                 receiver_name,
                 sender_complex_id,
                 sender_province_id,
                 sender_city_id,
                 sender_district_id,
                 sender_name,
                 payment_type,
                 payment_type_name,
                 cargo_num,
                 amount,
                 estimate_arrive_time,
                 distance,
                 dt,
                 start_date,
                 end_date
          from dwd_trade_order_process_inc
          where dt = '9999-12-31'
          union
          select cargo.id,
                 order_id,
                 cargo_type,
                 dic_for_cargo_type.name               cargo_type_name,
                 volume_length,
                 volume_width,
                 volume_height,
                 weight,
                 order_time,
                 order_no,
                 status,
                 dic_for_status.name                   status_name,
                 collect_type,
                 dic_for_collect_type.name             collect_type_name,
                 user_id,
                 receiver_complex_id,
                 receiver_province_id,
                 receiver_city_id,
                 receiver_district_id,
                 receiver_name,
                 sender_complex_id,
                 sender_province_id,
                 sender_city_id,
                 sender_district_id,
                 sender_name,
                 payment_type,
                 dic_for_payment_type.name             payment_type_name,
                 cargo_num,
                 amount,
                 estimate_arrive_time,
                 distance,
                 dt,
                 date_format(order_time, 'yyyy-MM-dd') start_date,
                 '9999-12-31'                          end_date
          from (select after.id,
                       after.order_id,
                       after.cargo_type,
                       after.volume_length,
                       after.volume_width,
                       after.volume_height,
                       after.weight,
                       date_format(
                               from_utc_timestamp(
                                           to_unix_timestamp(concat(substr(after.create_time, 1, 10), ' ',
                                                                    substr(after.create_time, 12, 8))) * 1000,
                                           'GMT+8'), 'yyyy-MM-dd HH:mm:ss') order_time,
                       dt
                from ods_order_cargo_full after
                where dt = '20250719'
               ) cargo
                   join
               (select after.id,
                       after.order_no,
                       after.status,
                       after.collect_type,
                       after.user_id,
                       after.receiver_complex_id,
                       after.receiver_province_id,
                       after.receiver_city_id,
                       after.receiver_district_id,
                       concat(substr(after.receiver_name, 1, 1), '*') receiver_name,
                       after.sender_complex_id,
                       after.sender_province_id,
                       after.sender_city_id,
                       after.sender_district_id,
                       concat(substr(after.sender_name, 1, 1), '*')   sender_name,
                       after.payment_type,
                       after.cargo_num,
                       after.amount,
                       date_format(from_utc_timestamp(
                                           cast(after.estimate_arrive_time as bigint), 'UTC'),
                                   'yyyy-MM-dd HH:mm:ss')             estimate_arrive_time,
                       after.distance
                from ods_order_info_full after
                where dt = '20250719'
               ) info
               on cargo.order_id = info.id
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_for_cargo_type
               on cargo.cargo_type = cast(dic_for_cargo_type.id as string)
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_for_status
               on info.status = cast(dic_for_status.id as string)
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_for_collect_type
               on info.collect_type = cast(dic_for_cargo_type.id as string)
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_for_payment_type
               on info.payment_type = cast(dic_for_payment_type.id as string)),
     inc
         as
         (select without_type_name.id,
                 status,
                 payment_type,
                 dic_for_payment_type.name payment_type_name
          from (select id,
                       status,
                       payment_type
                from (select after.id,
                             after.status,
                             after.payment_type,
                             row_number() over (partition by after.id order by dt desc) rn
                      from ods_order_info_full after
                      where dt = '20250719'
                        and after.is_deleted = '0'
                     ) inc_origin
                where rn = 1) without_type_name
                   left join
               (select id,
                       name
                from ods_base_dic_full
                where dt = '20220708'
                  and is_deleted = '0') dic_for_payment_type
               on without_type_name.payment_type = cast(dic_for_payment_type.id as string)
         )
insert overwrite table dwd_trade_order_process_inc
partition(dt)
select tmp.id,
       order_id,
       cargo_type,
       cargo_type_name,
       volumn_length,
       volumn_width,
       volumn_height,
       weight,
       order_time,
       order_no,
       inc.status,
       status_name,
       collect_type,
       collect_type_name,
       user_id,
       receiver_complex_id,
       receiver_province_id,
       receiver_city_id,
       receiver_district_id,
       receiver_name,
       sender_complex_id,
       sender_province_id,
       sender_city_id,
       sender_district_id,
       sender_name,
       inc.payment_type,
       inc.payment_type_name,
       cargo_num,
       amount,
       estimate_arrive_time,
       distance,
       dt,
       start_date,
       if(inc.status = '60050' or
          inc.status = '60999',
          '2023-01-11', tmp.end_date) end_date,
       if(inc.status = '60050' or
          inc.status = '60999',
          '20220708', tmp.end_date) dt
from tmp
         left join inc
                   on tmp.order_id = inc.id;

select * from dwd_trade_order_process_inc;


-- todo 2222
-- 10. dwd_trans_trans_finish_inc
-- 10.1 首日装载\
-- todo 3333
select * from  dwd_trans_trans_finish_inc;
select * from ods_transport_task_full;
select * from dim_shift_full;
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table dwd_trans_trans_finish_inc
    partition (dt)
select info.id,
       shift_id,
       line_id,
       start_org_id,
       start_org_name,
       end_org_id,
       end_org_name,
       order_num,
       driver1_emp_id,
       driver1_name,
       driver2_emp_id,
       driver2_name,
       truck_id,
       truck_no,
       actual_start_time,
       actual_end_time,
       actual_distance,
       finish_dur_sec,
       ts,
       info.dt
from (select after.id,
             after.shift_id,
             after.line_id,
             after.start_org_id,
             after.start_org_name,
             after.end_org_id,
             after.end_org_name,
             after.order_num,
             after.driver1_emp_id,
             concat(substr(after.driver1_name, 1, 1), '*')                                            driver1_name,
             after.driver2_emp_id,
             concat(substr(after.driver2_name, 1, 1), '*')                                            driver2_name,
             after.truck_id,
             md5(after.truck_no)                                                                      truck_no,
             date_format(from_utc_timestamp(
                                 cast(after.actual_start_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')                                                       actual_start_time,
             date_format(from_utc_timestamp(
                                 cast(after.actual_end_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')                                                       actual_end_time,

             after.actual_distance,
             (cast(after.actual_end_time as bigint) - cast(after.actual_start_time as bigint)) / 1000 finish_dur_sec,
             dt,
             date_format(from_utc_timestamp(
                                 cast(after.actual_end_time as bigint), 'UTC'),
                         'yyyy-MM-dd')                                                                ts
      from ods_transport_task_full after
      where dt = '20250719'
        and after.is_deleted = '0'
        and after.actual_end_time is not null) info
         left join
     (select id,
             dt
      from dim_shift_full
      where dt = '20250719') dim_tb
     on info.shift_id = dim_tb.id;

-- 10.2 每日装载

-- todo 4444
select * from ods_transport_task_full;
insert overwrite table dwd_trans_trans_finish_inc
    partition (dt = '20250719')
select info.id,
       shift_id,
       line_id,
       start_org_id,
       start_org_name,
       end_org_id,
       end_org_name,
       order_num,
       driver1_emp_id,
       driver1_name,
       driver2_emp_id,
       driver2_name,
       truck_id,
       truck_no,
       actual_start_time,
       actual_end_time,
       actual_distance,
       finish_dur_sec,
       ts
from (select after.id,
             after.shift_id,
             after.line_id,
             after.start_org_id,
             after.start_org_name,
             after.end_org_id,
             after.end_org_name,
             after.order_num,
             after.driver1_emp_id,
             concat(substr(after.driver1_name, 1, 1), '*')                                            driver1_name,
             after.driver2_emp_id,
             concat(substr(after.driver2_name, 1, 1), '*')                                            driver2_name,
             after.truck_id,
             md5(after.truck_no)                                                                      truck_no,
             date_format(from_utc_timestamp(
                                 cast(after.actual_start_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')                                                       actual_start_time,
             date_format(from_utc_timestamp(
                                 cast(after.actual_end_time as bigint), 'UTC'),
                         'yyyy-MM-dd HH:mm:ss')                                                       actual_end_time,
             after.actual_distance,
             (cast(after.actual_end_time as bigint) - cast(after.actual_start_time as bigint)) / 1000 finish_dur_sec,
             dt                                                                         ts
      from ods_transport_task_full after
      where dt = '20250719'
        and after.actual_end_time is not null
        and after.is_deleted = '0') info
         left join
     (select id,
             dt
      from dim_shift_full
      where dt = '20250719') dim_tb
     on info.shift_id = dim_tb.id;

select * from dwd_trans_trans_finish_inc;

-- 11. dwd_bound_inbound_inc
-- 11.1 首日装载
select * from ods_order_org_bound_full;
-- todo sssssssss
-- 11.2 每日装载
select * from ods_order_org_bound_full;

insert overwrite table dwd_bound_inbound_inc
    partition (dt = '20250719')
select after.id,
       after.order_id,
       after.org_id,
       date_format(from_utc_timestamp(
                           cast(after.inbound_time as bigint), 'UTC'),
                   'yyyy-MM-dd HH:mm:ss') inbound_time,
       after.inbound_emp_id
from ods_order_org_bound_full after
where dt = '20250719';

select * from dwd_bound_inbound_inc;
-- 12. dwd_bound_sort_inc
-- 12.1 首日装载
select * from ods_order_org_bound_full;
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table dwd_bound_sort_inc
    partition (dt)
select after.id,
       after.order_id,
       after.org_id,
       date_format(from_utc_timestamp(
                           cast(after.sort_time as bigint), 'UTC'),
                   'yyyy-MM-dd HH:mm:ss') sort_time,
       after.sorter_emp_id,
       date_format(from_utc_timestamp(
                           cast(after.sort_time as bigint), 'UTC'),
                   'yyyy-MM-dd')          dt
from ods_order_org_bound_full after
where dt = '20250719'
  and after.sort_time is not null;

select * from dwd_bound_sort_inc;
-- 12.2 每日装载
select * from ods_order_org_bound_full;
insert overwrite table dwd_bound_sort_inc
    partition (dt = '20250719')
select after.id,
       after.order_id,
       after.org_id,
       date_format(from_utc_timestamp(
                           cast(after.sort_time as bigint), 'UTC'),
                   'yyyy-MM-dd HH:mm:ss') sort_time,
       after.sorter_emp_id
from ods_order_org_bound_full after
where dt = '20250719'
  and sort_time is null
  and after.sort_time is not null
  and after.is_deleted = '0';

select * from dwd_bound_sort_inc;
-- 13. dwd_bound_outbound_inc
-- 13.1 首日装载
select * from ods_order_org_bound_full;
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table dwd_bound_outbound_inc
    partition (dt)
select after.id,
       after.order_id,
       after.org_id,
       date_format(from_utc_timestamp(
                           cast(after.outbound_time as bigint), 'UTC'),
                   'yyyy-MM-dd HH:mm:ss') outbound_time,
       after.outbound_emp_id,
       date_format(from_utc_timestamp(
                           cast(after.outbound_time as bigint), 'UTC'),
                   'yyyy-MM-dd')          dt
from ods_order_org_bound_full after
where dt = '20250719'
  and after.outbound_time is not null;

select * from ods_order_org_bound_full;
-- 13.2 每日装载

select * from ods_order_org_bound_full;
insert overwrite table dwd_bound_outbound_inc
    partition (dt = '20250719')
select after.id,
       after.order_id,
       after.org_id,
       date_format(from_utc_timestamp(
                           cast(after.outbound_time as bigint), 'UTC'),
                   'yyyy-MM-dd HH:mm:ss') outbound_time,
       after.outbound_emp_id
from ods_order_org_bound_full after
where dt = '20250719'
  and outbound_time is null
  and after.outbound_time is not null
  and after.is_deleted = '0';
select * from dwd_bound_outbound_inc;

