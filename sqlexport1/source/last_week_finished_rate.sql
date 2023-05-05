# noinspection NonAsciiCharacters

with box_tbl as (
    select
        *
    from
        (
            select
                manufacture_order_id             as '生产订单号（AUFNR）',
                manufacture_row_id               as '行号（posnr）',
                basic_start_date                 as '生产订单内的基本开始日期（GSTRP）',
                basic_start_time                 as '生产订单内的基本开始时间（GSUZP）',
                plan_start_date                  as '生产订单内的计划开始日期（GSTRS）',
                actual_start_date                as '生产订单内的实际开始日期（GSTRI）',
                plan_start_time                  as '生产订单内的计划开始时间（GSUZS）',
                plan_release_date                as '生产订单内的计划下达日期（FTRMS）',
                actual_release_date              as '生产订单内的实际下达日期（FTRMI）',
                plan_publish_date                as '生产订单内的计划发布日期（FTRMP）',
                comfirm_finish_date              as '确认订单完成日期（GETRI）',
                plan_finish_date                 as '计划完工（GLTRS）',
                actual_end_date                  as '生产订单内的实际结束日期（GLTRI）',
                order_quantity                   as '生产订单的数量（GAMNG）',
                manufacture_order_unit           as '生产订单的单位（GMEIN）',
                manufacture_order_work_id        as '订单中工序的工艺路线号（AUFPL）',
                trash_quantity                   as '订单确认中的已确认报废数量（IASMG）',
                output_quantity                  as '订单确认中的已确认产量（IGMNG）',
                modifiy_date                     as '更改日期（AEDAT）',
                dspmo.create_date                      as '创建日期（afko-ERDAT）',
                mrp_controller                   as 'mrp控制者(dispo)',
                ossmd.material_detail            as '物料名称',
                manufacture_order_item_quantity  as '行项目数量（psmng）',
                unit                             as '单位（meins）',
                dspmo.material_id                      as '物料编码（afpo-matnr）',
                sale_order_id                    as '销售订单号（kdauf）',
                sale_row_id                      as '销售订单行项目（kdpos）',
                factory                          as '生产订单对应工厂（dwerk）',
                manufacture_order_type           as '生产订单类型（dauat）',
                manufacture_order_batch_id       as '生产订单内的批次号（charg）',
                sale_order_finish_plan           as '销售订单交货计划（kdein）',
                order_scrap_plan_quantity        as '订单项目计划报废数量（psamg）',
                goods_quantity                   as '订单项目已收货数量（wemng）',
                scrap_plan_quantity              as '计划报废数量（pamng）',
                plan_due_date                    as '计划订单中的交货日期（ltrmp）',
                manufacture_order_status         as '生产订单状态（status）',
                actual_due_date                  as '实际交货日期/结束日期（ltrmi）',
                order_status                     as '订单状态（status_cn）',
                basic_finish_date                as '生产订单内的基本完成日期（GLTRP）',
                '逾期未完成订单'                  as 'tips',
                case
                    when dspmo.mrp_controller = 'A01' and (ossmd.material_detail like '%箱体%' or material_detail like '%箱盖%') then '箱体部门'
                    when dspmo.mrp_controller = 'A01' and (ossmd.material_detail not like '%箱体%' and material_detail not like '%箱盖%') then '精益制造部'
                    when (dspmo.mrp_controller REGEXP '^A[0]{1}[2-9]$' or mrp_controller REGEXP '^B[0]{1}[0-9]$' or
                          mrp_controller = 'C01') then '齿轮制造工厂'
                    when dspmo.mrp_controller = 'C02' then '电机定子制造工厂'
                    when dspmo.mrp_controller in ('C03', 'C04', 'D05') then '电机装配制造工厂'
                    when dspmo.mrp_controller in ('D01', 'D02', 'D03', 'D04') then '整机装配制造工厂'
                    else '未知工厂'
                    end '隶属部门'
            from dwd_supplychain_plan_manufacture_order dspmo
                     left join ods_sap_supplychain_material_description ossmd on dspmo.material_id=ossmd.material_id
            where basic_finish_date < curdate() and basic_finish_date >= date_sub(curdate(),interval 2 week)
              and not (order_status REGEXP '^(?!.*部分交货).*交货.*$' or (order_status REGEXP '技术性完成'  and order_quantity != 0))
              and order_status is not null and actual_due_date is null
            union all
            select
                manufacture_order_id             as '生产订单号（AUFNR）',
                manufacture_row_id               as '行号（posnr）',
                basic_start_date                 as '生产订单内的基本开始日期（GSTRP）',
                basic_start_time                 as '生产订单内的基本开始时间（GSUZP）',
                plan_start_date                  as '生产订单内的计划开始日期（GSTRS）',
                actual_start_date                as '生产订单内的实际开始日期（GSTRI）',
                plan_start_time                  as '生产订单内的计划开始时间（GSUZS）',
                plan_release_date                as '生产订单内的计划下达日期（FTRMS）',
                actual_release_date              as '生产订单内的实际下达日期（FTRMI）',
                plan_publish_date                as '生产订单内的计划发布日期（FTRMP）',
                comfirm_finish_date              as '确认订单完成日期（GETRI）',
                plan_finish_date                 as '计划完工（GLTRS）',
                actual_end_date                  as '生产订单内的实际结束日期（GLTRI）',
                order_quantity                   as '生产订单的数量（GAMNG）',
                manufacture_order_unit           as '生产订单的单位（GMEIN）',
                manufacture_order_work_id        as '订单中工序的工艺路线号（AUFPL）',
                trash_quantity                   as '订单确认中的已确认报废数量（IASMG）',
                output_quantity                  as '订单确认中的已确认产量（IGMNG）',
                modifiy_date                     as '更改日期（AEDAT）',
                dspmo.create_date                      as '创建日期（afko-ERDAT）',
                mrp_controller                   as 'mrp控制者(dispo)',
                ossmd.material_detail            as '物料名称',
                manufacture_order_item_quantity  as '行项目数量（psmng）',
                unit                             as '单位（meins）',
                dspmo.material_id                      as '物料编码（afpo-matnr）',
                sale_order_id                    as '销售订单号（kdauf）',
                sale_row_id                      as '销售订单行项目（kdpos）',
                factory                          as '生产订单对应工厂（dwerk）',
                manufacture_order_type           as '生产订单类型（dauat）',
                manufacture_order_batch_id       as '生产订单内的批次号（charg）',
                sale_order_finish_plan           as '销售订单交货计划（kdein）',
                order_scrap_plan_quantity        as '订单项目计划报废数量（psamg）',
                goods_quantity                   as '订单项目已收货数量（wemng）',
                scrap_plan_quantity              as '计划报废数量（pamng）',
                plan_due_date                    as '计划订单中的交货日期（ltrmp）',
                manufacture_order_status         as '生产订单状态（status）',
                actual_due_date                  as '实际交货日期/结束日期（ltrmi）',
                order_status                     as '订单状态（status_cn）',
                basic_finish_date                as '生产订单内的基本完成日期（GLTRP）',
                '完成逾期订单'                    as 'tips',
                case
                    when dspmo.mrp_controller = 'A01' and (ossmd.material_detail like '%箱体%' or material_detail like '%箱盖%') then '箱体部门'
                    when dspmo.mrp_controller = 'A01' and (ossmd.material_detail not like '%箱体%' and material_detail not like '%箱盖%') then '精益制造部'
                    when (dspmo.mrp_controller REGEXP '^A[0]{1}[2-9]$' or mrp_controller REGEXP '^B[0]{1}[0-9]$' or
                          mrp_controller = 'C01') then '齿轮制造工厂'
                    when dspmo.mrp_controller = 'C02' then '电机定子制造工厂'
                    when dspmo.mrp_controller in ('C03', 'C04', 'D05') then '电机装配制造工厂'
                    when dspmo.mrp_controller in ('D01', 'D02', 'D03', 'D04') then '整机装配制造工厂'
                    else '未知工厂'
                    end '隶属部门'
            from dwd_supplychain_plan_manufacture_order dspmo
                     left join ods_sap_supplychain_material_description ossmd on dspmo.material_id=ossmd.material_id
            where actual_due_date < curdate() and actual_due_date >= date_sub(curdate(),interval 1 week ) and actual_due_date > basic_finish_date
              and
                (
                            order_status REGEXP '^(?!.*部分交货).*交货.*$' or (order_status REGEXP '技术性完成' and order_quantity != 0)
                    )
              and order_status is not null and actual_due_date is not null
            union all
            select
                manufacture_order_id             as '生产订单号（AUFNR）',
                manufacture_row_id               as '行号（posnr）',
                basic_start_date                 as '生产订单内的基本开始日期（GSTRP）',
                basic_start_time                 as '生产订单内的基本开始时间（GSUZP）',
                plan_start_date                  as '生产订单内的计划开始日期（GSTRS）',
                actual_start_date                as '生产订单内的实际开始日期（GSTRI）',
                plan_start_time                  as '生产订单内的计划开始时间（GSUZS）',
                plan_release_date                as '生产订单内的计划下达日期（FTRMS）',
                actual_release_date              as '生产订单内的实际下达日期（FTRMI）',
                plan_publish_date                as '生产订单内的计划发布日期（FTRMP）',
                comfirm_finish_date              as '确认订单完成日期（GETRI）',
                plan_finish_date                 as '计划完工（GLTRS）',
                actual_end_date                  as '生产订单内的实际结束日期（GLTRI）',
                order_quantity                   as '生产订单的数量（GAMNG）',
                manufacture_order_unit           as '生产订单的单位（GMEIN）',
                manufacture_order_work_id        as '订单中工序的工艺路线号（AUFPL）',
                trash_quantity                   as '订单确认中的已确认报废数量（IASMG）',
                output_quantity                  as '订单确认中的已确认产量（IGMNG）',
                modifiy_date                     as '更改日期（AEDAT）',
                dspmo.create_date                      as '创建日期（afko-ERDAT）',
                mrp_controller                   as 'mrp控制者(dispo)',
                ossmd.material_detail            as '物料名称',
                manufacture_order_item_quantity  as '行项目数量（psmng）',
                unit                             as '单位（meins）',
                dspmo.material_id                      as '物料编码（afpo-matnr）',
                sale_order_id                    as '销售订单号（kdauf）',
                sale_row_id                      as '销售订单行项目（kdpos）',
                factory                          as '生产订单对应工厂（dwerk）',
                manufacture_order_type           as '生产订单类型（dauat）',
                manufacture_order_batch_id       as '生产订单内的批次号（charg）',
                sale_order_finish_plan           as '销售订单交货计划（kdein）',
                order_scrap_plan_quantity        as '订单项目计划报废数量（psamg）',
                goods_quantity                   as '订单项目已收货数量（wemng）',
                scrap_plan_quantity              as '计划报废数量（pamng）',
                plan_due_date                    as '计划订单中的交货日期（ltrmp）',
                manufacture_order_status         as '生产订单状态（status）',
                actual_due_date                  as '实际交货日期/结束日期（ltrmi）',
                order_status                     as '订单状态（status_cn）',
                basic_finish_date                as '生产订单内的基本完成日期（GLTRP）',
                '完成交期订单'                    as 'tips',
                case
                    when dspmo.mrp_controller = 'A01' and (ossmd.material_detail like '%箱体%' or material_detail like '%箱盖%') then '箱体部门'
                    when dspmo.mrp_controller = 'A01' and (ossmd.material_detail not like '%箱体%' and material_detail not like '%箱盖%') then '精益制造部'
                    when (dspmo.mrp_controller REGEXP '^A[0]{1}[2-9]$' or mrp_controller REGEXP '^B[0]{1}[0-9]$' or
                          mrp_controller = 'C01') then '齿轮制造工厂'
                    when dspmo.mrp_controller = 'C02' then '电机定子制造工厂'
                    when dspmo.mrp_controller in ('C03', 'C04', 'D05') then '电机装配制造工厂'
                    when dspmo.mrp_controller in ('D01', 'D02', 'D03', 'D04') then '整机装配制造工厂'
                    else '未知工厂'
                    end '隶属部门'
            from dwd_supplychain_plan_manufacture_order dspmo
                     left join ods_sap_supplychain_material_description ossmd on dspmo.material_id=ossmd.material_id
            where basic_finish_date < curdate() and basic_finish_date >= date_sub(curdate(),interval 1 week )
              and actual_due_date <= basic_finish_date
              and (
                        order_status REGEXP '^(?!.*部分交货).*交货.*$' or (order_status REGEXP '技术性完成'  and order_quantity != 0)
                )
              and order_status is not null and actual_due_date is not null)
            t
    where t.`订单状态（status_cn）` not regexp '^.*删除.*$'
),
     purcase_tbl as (
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
         where p.due_date < curdate() and p.due_date >= date_sub(curdate(),interval 1 week ) and delete_symble is null
     )
select
    '最近一周',
    count(if((box_tbl.tips = '完成逾期订单' or box_tbl.tips = '完成交期订单') and `隶属部门` = '箱体部门',1,null))/count(if(`隶属部门` = '箱体部门',1,null)) '箱体部门上周完成率',
    (count(if((box_tbl.tips = '完成逾期订单' or box_tbl.tips = '完成交期订单') and `隶属部门` = '精益制造部',1,null)) + (
        select count(*) from purcase_tbl where purcase_tbl.tips = '完成采购' and purcase_tbl.`是否为精益智造部` = 'Y'
    ))/(count(if(`隶属部门` = '精益制造部',1,null)) + (
        select count(*) from purcase_tbl where purcase_tbl.`是否为精益智造部` = 'Y'
    )) '精益制造部上周完成率',
    count(if((box_tbl.tips = '完成逾期订单' or box_tbl.tips = '完成交期订单') and `隶属部门` = '齿轮制造工厂',1,null))/count(if(`隶属部门` = '齿轮制造工厂',1,null)) '齿轮制造工厂上周完成率',
    count(if((box_tbl.tips = '完成逾期订单' or box_tbl.tips = '完成交期订单') and `隶属部门` = '电机定子制造工厂',1,null))/count(if(`隶属部门` = '电机定子制造工厂',1,null)) '电机定子制造工厂上周完成率',
    count(if((box_tbl.tips = '完成逾期订单' or box_tbl.tips = '完成交期订单') and `隶属部门` = '电机装配制造工厂',1,null))/count(if(`隶属部门` = '电机装配制造工厂',1,null)) '电机装配制造工厂上周完成率',
    count(if((box_tbl.tips = '完成逾期订单' or box_tbl.tips = '完成交期订单') and `隶属部门` = '整机装配制造工厂',1,null))/count(if(`隶属部门` = '整机装配制造工厂',1,null)) '整机装配制造工厂上周完成率',
    ((select count(*) from purcase_tbl where purcase_tbl.tips = '完成采购' and purcase_tbl.`是否为精益智造部` = 'N')/(select count(*) from purcase_tbl where purcase_tbl.`是否为精益智造部` = 'N')) as '采购完成率'
from box_tbl
where box_tbl.`生产订单内的基本完成日期（GLTRP）` < curdate()
  and box_tbl.`生产订单内的基本完成日期（GLTRP）` >= date_sub(curdate(),interval 1 week )
  and box_tbl.`订单状态（status_cn）` not like '%删除%';