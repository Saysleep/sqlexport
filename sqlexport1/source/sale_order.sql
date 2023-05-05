# noinspection NonAsciiCharacters

select
    delivery_order_id              '发货单号（VBELN）',
    delivery_row_id                '发货单行项目（POSNR）',
    likp_create_date               '记录建立日期（ERDAT）',
    due_date                       '交货日期（LFDAT）',
    dmsd.client                         '客户编号（KUNNR）',
    sold_to_party                  '售达方（KUNAG）',
    update_object                  '更改对象用户的名称（AENAM）',
    goods_movement_date            '实际货物移动日期（WADAT_IST）',
    creator_name                   '创建对象的人员名称（ERNAM）',
    lips_create_date               '记录建立日期（ERDAT）',
    dmsd.material_id                    '物料编号（MATNR）',
    dmsd.material_group                 '物料组（MATKL）',
    ossmf.mrp_controller                'mrp控制者',
    dmsd.sale_order_project_short_text  '销售订单项目的短文本（ARKTX）',
    dmsd.sale_order_id                  '销售订单号（VBELV）',
    dmso.sale_order_type           '销售类型',
    sale_row_id                    '销售订单行号（VGPOS）',
    actual_delivery_quantity       '实际已交货量（按销售单位）（LFIMG）',
    dmsop.refuse_reason               as  '拒绝原因',
    cargo_movement_status          '货物移动状态(WBSTA)(‘’:无关，A:没有处理，B:部分处理，C:完全地处理)',
    dmsd.update_datetime                '更新时间（ZDATE）'
from dwd_marketing_sale_delivery dmsd
         left join ods_sap_marketing_sale_order_head dmso on dmsd.sale_order_id = dmso.sale_order_id
         left join ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
         left join ods_sap_supplychain_material_factory ossmf on dmsd.material_id = ossmf.material_id
where dmsd.goods_movement_date >= date_sub(curdate(),interval 1 week ) and dmsd.goods_movement_date < curdate()
  and dmsd.cargo_movement_status = 'C'
  and (ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$' )
  and (dmso.sale_order_type != 'Z008' and dmso.sale_order_type != 'Z009' and dmso.sale_order_type != 'Z006' and dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null)
GROUP BY delivery_order_id,delivery_row_id;