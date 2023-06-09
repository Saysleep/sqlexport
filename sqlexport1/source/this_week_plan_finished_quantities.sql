# noinspection NonAsciiCharacters
select
    *
from
    (with plan_order as (
        select manufacture_order_id            '生产订单号（AUFNR）',
               manufacture_row_id              '行号（posnr）',
               basic_start_date                '生产订单内的基本开始日期（GSTRP）',
               basic_start_time                '生产订单内的基本开始时间（GSUZP）',
               plan_start_date                 '生产订单内的计划开始日期（GSTRS）',
               actual_start_date               '生产订单内的实际开始日期（GSTRI）',
               plan_start_time                 '生产订单内的计划开始时间（GSUZS）',
               plan_release_date               '生产订单内的计划下达日期（FTRMS）',
               actual_release_date             '生产订单内的实际下达日期（FTRMI）',
               plan_publish_date               '生产订单内的计划发布日期（FTRMP）',
               comfirm_finish_date             '确认订单完成日期（GETRI）',
               plan_finish_date                '计划完工（GLTRS）',
               actual_end_date                 '生产订单内的实际结束日期（GLTRI）',
               order_quantity                  '生产订单的数量（GAMNG）',
               manufacture_order_unit          '生产订单的单位（GMEIN）',
               manufacture_order_work_id       '订单中工序的工艺路线号（AUFPL）',
               trash_quantity                  '订单确认中的已确认报废数量（IASMG）',
               output_quantity                 '订单确认中的已确认产量（IGMNG）',
               modifiy_date                    '更改日期（AEDAT）',
               dspmo.create_date               '创建日期（afko-ERDAT）',
               mrp_controller                  'mrp控制者(dispo)',
               manufacture_order_item_quantity '行项目数量（psmng）',
               unit                            '单位（meins）',
               dspmo.material_id               '物料编码（afpo-matnr）',
               sale_order_id                   '销售订单号（kdauf）',
               sale_row_id                     '销售订单行项目（kdpos）',
               factory                         '生产订单对应工厂（dwerk）',
               manufacture_order_type          '生产订单类型（dauat）',
               manufacture_order_batch_id      '生产订单内的批次号（charg）',
               sale_order_finish_plan          '销售订单交货计划（kdein）',
               order_scrap_plan_quantity       '订单项目计划报废数量（psamg）',
               goods_quantity                  '订单项目已收货数量（wemng）',
               scrap_plan_quantity             '计划报废数量（pamng）',
               actual_due_date                 '实际交货日期/结束日期（ltrmi）',
               plan_due_date                   '计划订单中的交货日期（ltrmp）',
               manufacture_order_status        '生产订单状态（status）',
               ossmd.material_detail           '物件名称',
               basic_finish_date               '生产订单内的基本完成日期（GLTRP）',
               order_status                    '订单状态（status_cn）',
               case
                   when dspmo.mrp_controller = 'A01' and (ossmd.material_detail like '%箱体%' or material_detail like '%箱盖%')
                       then '箱体部门'
                   when dspmo.mrp_controller = 'A01' and
                        (ossmd.material_detail not like '%箱体%' and material_detail not like '%箱盖%') then '精益制造部'
                   when dspmo.mrp_controller REGEXP '^A[0]{1}[2-9]$' or mrp_controller REGEXP '^B[0]{1}[0-9]$' or
                        mrp_controller = 'C01' then '齿轮制造工厂'
                   when dspmo.mrp_controller = 'C02' then '电机定子制造工厂'
                   when dspmo.mrp_controller in ('C03', 'C04', 'D05') then '电机装配制造工厂'
                   when dspmo.mrp_controller in ('D01', 'D02', 'D03', 'D04') then '整机装配制造工厂'
                   else '未知工厂'
                   end                         '隶属部门'
        from dwd_supplychain_plan_manufacture_order dspmo
                 left join ods_sap_supplychain_material_description ossmd on dspmo.material_id = ossmd.material_id
        where basic_finish_date >=
              curdate()
           and basic_finish_date < date_add(curdate(), interval 1 week)
          and not ((order_status REGEXP '^(?!.*部分交货).*交货.*$' or order_status LIKE '%部分交货%技术性完成%' or order_status LIKE '%技术性完成%部分交货%') and order_quantity != 0 )
          and order_status not regexp '^.*删除.*$' and material_detail is not null
    ),
          overdue_order as (
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
              where basic_finish_date < curdate()
                # and basic_finish_date >= date_sub(curdate(),interval 1 week)
                and not ((order_status REGEXP '^(?!.*部分交货).*交货.*$' or order_status LIKE '%部分交货%技术性完成%' or order_status LIKE '%技术性完成%部分交货%') and order_quantity != 0)
                and order_status is not null and actual_due_date is null and order_status not regexp '^.*删除.*$' and ossmd.material_detail is not null
          )
     select
         '本周计划订单单数',
         count(if(`隶属部门` = '箱体部门',1,null))  '箱体部门本周计划单数',
         count(if(`隶属部门` = '精益制造部',1,null)) '精益制造部本周计划单数',
         count(if(`隶属部门` = '齿轮制造工厂',1,null)) '齿轮制造工厂本周计划单数',
         count(if(`隶属部门` = '电机定子制造工厂',1,null)) '电机定子制造工厂本周计划单数',
         count(if(`隶属部门` = '电机装配制造工厂',1,null)) '电机装配制造工厂本周计划单数',
         count(if(`隶属部门` = '整机装配制造工厂',1,null)) '整机装配制造工厂本周计划单数'
     from plan_order
     union all
     select
         '逾期订单单数',
         count(if(`隶属部门` = '箱体部门',1,null))  '箱体部门本周计划单数',
         count(if(`隶属部门` = '精益制造部',1,null)) '精益制造部本周计划单数',
         count(if(`隶属部门` = '齿轮制造工厂',1,null)) '齿轮制造工厂本周计划单数',
         count(if(`隶属部门` = '电机定子制造工厂',1,null)) '电机定子制造工厂本周计划单数',
         count(if(`隶属部门` = '电机装配制造工厂',1,null)) '电机装配制造工厂本周计划单数',
         count(if(`隶属部门` = '整机装配制造工厂',1,null)) '整机装配制造工厂本周计划单数'
     from overdue_order) t