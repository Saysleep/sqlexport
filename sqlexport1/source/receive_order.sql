# noinspection NonAsciiCharacters

select
    dmso.sale_order_id                as  '销售订单号（VBELN）',
    sale_order_project                as  '销售订单项目（POSNR）',
    dmso.create_date                  as  '记录建立日期（ERDAT）',
    sale_order_type                   as  '销售订单类型（AUART）',
    `groups`                          as  '销售组织（VKORG）',
    distribution_channel              as  '分销渠道（VTWEG）',
    product_group                     as  '产品组（SPART）',
    sale_group                        as  '销售组（VKGRP）',
    sale_office                       as  '销售办事处（VKBUR）',
    client                            as  '客户编号（KUNNR）',
    use_tag                           as  '使用标识（ABRVW）',
    request_delivery_date             as  '要求交货日期（VDATU）',
    dmsop.material_id                 as  '物料编号（MATNR）',
    ossmf.mrp_controller              as 'mrp控制者',
    material_group                    as  '物料组（MATKL）',
    sale_order_project_short_text     as  '销售订单项目的短文本（ARKTX）',
    sale_unit                         as  '销售单位（VRKME）',
    sale_status                       as  '销售与分销凭证项目的总体处理状态(A:没有处理，B：部分处理，C：完全处理，空：无关)（GBSTA）',
    delivery_status                   as  '项目的总体交货状态（A:未发货,B:部分发货,C:全部发货,空值即与发货无关）（LFGSA）',
    row_delivery_status               as  '行项目的发货状态（A:未发货,B:部分发货,C:全部发货,空值即与发货无关）（LFSTA）',
    credential_currency               as  '订单项目的凭证货币净值（交易币）（NETWR）',
    credential_currency_tax           as  '以凭证货币计的税额（交易币）（MWSBP）',
    refuse_reason                     as  '报价和销售订单的拒绝原因（ABGRU）',
    voucher_currency                  as  '销售和分销凭证货币(CNY人民币,USD美元,EUR欧元)（WAERK）',
    box_sticker_printing_model        as  '箱贴打印型号（ZXTDYXH）',
    box_sticker_printing_note         as  '箱贴打印备注（ZXTBZ）',
    reducer_model                     as  '减速机型号（ZXTXH）',
    nameplate_reducer_printing_model  as  '铭牌减速机打印型号（ZXJSJXH）',
    installation_method               as  '安装方式（ZXAZFS）',
    allowable_torque_nm               as  '许用扭矩（n.m）（ZXXYNJ）',
    input_power_kw                    as  '输入功率(kw)（ZXSRGL）',
    lubricant                         as  '润滑油（ZXRHY）',
    speed_ratio                       as  '速比（ZXSB）',
    power1                            as  '功率（ZXGL）',
    allowable_torque_lbfin            as  '许用扭矩（lbf.in）（ZXXYNJM）',
    input_power_hp                    as  '输入功率（HP）（ZXSRGLM）',
    so_number                         as  'SO号（ZXSO）',
    oil_type                          as  '油品种类（ZXYPZL）',
    speed                             as  '转速（ZXDJZS）',
    order_quantity                    as  '以销售单位表示的累计订购数量（订单数量）（KWMENG）',
    dmsop.refuse_reason               as  '拒绝原因',
    dmso.update_datetime              as  '更新时间（ZDATE）'
from
    ods_sap_marketing_sale_order_head dmso
        LEFT JOIN ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
        LEFT JOIN ods_sap_supplychain_material_factory ossmf ON dmsop.material_id = ossmf.material_id #marc
WHERE
        dmso.create_date >= date_sub(curdate(),interval 1 week )
  AND dmso.create_date < curdate()
  AND ( ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$' )
  AND ( dmso.sale_order_type != 'Z008' AND dmso.sale_order_type != 'Z009' AND dmso.sale_order_type != 'Z006' AND dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null);