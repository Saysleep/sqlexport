# noinspection NonAsciiCharacters
with purchase_due as (
select
    *
from
    (    select
             os.purchase_order_id,
             os.row_id,
             os.row_plan,
             os.due_date,
             row_number() over (partition by purchase_order_id,row_id order by row_plan desc) rk
         from ods_sap_supplychain_plan_purchase_order_delivery_schedule os) t
where rk = 1
    )
select
    dsppo.purchase_order_id    as '采购订单号（EBELN）',
    dsppo.row_id               as '行号（EBELP）',
    p.row_plan                 as '计划行',
    project_type               as '项目类别（PSTYP）',
    material_id                as '物料编码（MATNR）',
    material_detail            as '物料描述（TXZ01）',
    unit                       as '单位（MEINS）',
    order_price_unit           as '订单价格单位（BPRME）',
    price_unit                 as '价格单位（PEINH）',
    pure_price                 as '净价（NETPR）',
    pure_value                 as '净值（NETWR）',
    delete_symble              as '删除标识（LOEKZ）',
    update_date                as '更改日期（AEDAT）',
    factory                    as '工厂（WERKS）',
    retuen_id                  as '退货X（RETPO）',
    tax_id                     as '税码（MWSKZ）',
    oversubmit_limitation      as '过量交货限度（UEBTO）',
    lacksubmit_limitation      as '交货不足限度（UNTTO）',
    material_group             as '物料组（MATKL）',
    receipt_sign               as '发票收据标识（REPOS）',
    subject_type               as '科目分配类别（KNTTP）',
    type                       as '凭证类型（BSART）',
    purchase_engineer_id       as '采购组（EKGRP）',
    supplyer_id                as '供应商（LIFNR）',
    purchase_term              as '付款条款（ZTERM）',
    company_id                 as '公司代码（BUKRS）',
    purchase_groups            as '采购组织（EKORG）',
    purchase_credential_status as '采购凭证处理状态（PROCSTAT）',
    coin_type                  as '币种（WAERS）',
    purchase_create_time       as '创建时间（AEDAT）',
    purchase_credential_date   as '采购凭证日期（BEDAT）',
    credential_id              as '凭证条件号（KNUMV）',
    p.due_date                 as '交货日期',
    finish_submit_id           as '交货已完成（ELIKZ）',
    dsppo.quantity             as '数量（MENGE）',
    case
        when dsppo.finish_submit_id = 'X' then '完成采购'
        when dsppo.finish_submit_id is null then '未完成采购' end as 'tips',
    case
        when supplyer_id = 20358 then 'Y'
        when supplyer_id != 20358 then 'N' end as '是否为精益智造部',
    dsppo.update_datetime            as '更新时间（ZDATE）'
from dwd_supplychain_plan_purchase_order dsppo
         left join purchase_due p
                   on dsppo.purchase_order_id = p.purchase_order_id and dsppo.row_id = p.row_id
where p.due_date < curdate() and p.due_date >= date_sub(curdate(),interval 1 week ) and delete_symble is null;