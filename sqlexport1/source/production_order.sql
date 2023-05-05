select
    material_credential_id           as '物料凭证编号（MBLNR）',
    material_credential_year         as '物料凭证的年份（MJAHR）',
    material_credential_project      as '物料凭证中的项目（ZEILE）',
    credential_date                  as '凭证中的凭证日期（BLDAT）',
    post_date                        as '凭证中的过帐日期（BUDAT）',
    material_transfer                as '移动类型(库存管理)（BWART）',
    dspmo.material_id                as '物料编号（MATNR）',
    dspmo.factory                    as '工厂（WERKS）',
    storage_location                 as '库存地点（LGORT）',
    manufacture_order_batch_id       as '批号（CHARG）',
    special_stock_sign               as '特殊库存标识（SOBKZ）',
    supplyer_id                      as '供应商帐户号（LIFNR）',
    dmso.sale_order_id               as '销售订单号（KDAUF）',
    sale_row_id                      as '销售订单行号（KDPOS）',
    identification                   as '借方/贷方标识（SHKZG）',
    money                            as '按本位币计的金额（DMBTR）',
    coin_type                        as '货币码（WAERS）',
    evaluation_type                  as '评估类型（BWTAR）',
    quantity                         as '数量（MENGE）',
    unit                             as '基本计量单位（MEINS）',
    input_quantity                   as '以录入项单位表示的数量（ERFMG）',
    item_unit                        as '条目单位（ERFME）',
    purchase_order_id                as '采购订单号（EBELN）',
    purchase_row_id                  as '采购凭证的项目编号（EBELP）',
    finish_submit_id                 as '“交货已完成”标识（ELIKZ）',
    receiver                         as '收货方（WEMPF）',
    unload_location                  as '卸货点（ABLAD）',
    manufacture_order_id             as '生产订单号（AUFNR）',
    requirement_id                   as '预留/相关需求的编号（RSNUM）',
    requirement_project_id           as '预留 / 相关需求的项目编号（RSPOS）',
    record_type                      as '记录类型（RSART）',
    last_delivery                    as '该预定的最后发货（KZEAR）',
    movement_sign                    as '移动标识（KZBEW）',
    goods_receipt                    as '货物收据，未评估（WEUNB）',
    structure_element                as '工作分解结构元素 (WBS 元素)（PS_PSP_PNR）',
    internet_code                    as '科目分配的网络号（NPLNR）',
    manufacture_order_work_id        as '订单中工序的工艺路线号（AUFPL）',
    manufacture_counter              as '内部计数器（APLZL）',
    zzkm_id                          as '总账科目编号（SAKTO）',
    control_range                    as '控制范围（KOKRS）',
    accounting_credential_entry_date as '会计凭证输入日期（CPUDT）',
    dmsop.refuse_reason              as '拒绝原因',
    dspmo.update_datetime            as '更新时间（ZDATE）'
from ods_sap_supplychain_logistics_order_movement dspmo
         left join ods_sap_marketing_sale_order_head dmso on dspmo.sale_order_id = dmso.sale_order_id
         left join ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
         left join ods_sap_supplychain_material_factory ossmf on ossmf.material_id = dspmo.material_id
where dspmo.post_date < curdate() and dspmo.post_date >= date_sub(curdate(),interval 1 week )
  and ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
  and dspmo.material_transfer = '101'
  and	 (dmso.sale_order_type != 'Z008' AND dmso.sale_order_type != 'Z009' AND dmso.sale_order_type != 'Z006' AND dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null)
GROUP BY
    dspmo.material_credential_id,
    dspmo.material_credential_project,
    dspmo.material_credential_year;