# noinspection NonAsciiCharacters

select
    ossmf.material_id,
    osslsso.sale_order_id   '销售订单号',
    storage_location        '库存地点（LGORT）',
    non_limitation_storage  '非限制性库存（KALAB）',
    osslsso.update_datetime         '更新时间（ZDATE）',
    ossmf.factory                  '工厂（WERKS）',
    deliver_storage_location '发货存储地点（LGPRO）',
    purchase_type            '采购类型（BESKZ）',
    purchase_special_type    '特殊采购类型（SOBSL）',
    mrp_controller           'MRP控制者（DISPO）',
    purchase_cycle           '采购周期（PLIFZ）',
    manufacture_cycle        '生产周期（DZEIT）',
    receipt_cycle            '收获处理期（WEBAZ）',
    min_batch                '最小批量大小（BSTMI）',
    max_storage              '最高库存（MABST）',
    safe_storage             '安全库存（EISBE）',
    logistics_group          '用于计算工作负荷的后勤处理组（LOGGR）',
    purchase_engineer_id     '采购工程师编号（EKGRP）',
    sign                     '标识：反冲（RGEKZ）',
    last_update_date         '上次更改的日期（LAEDA）',
    '销售订单绑定库存'         as '类别'
from
    ods_sap_supplychain_logistics_storage_sales_order  osslsso
left join ods_sap_supplychain_material_factory ossmf on ossmf.material_id = osslsso.material_id
where ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'