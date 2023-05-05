SELECT
    '最近一天' AS 'time_dimension',
    (
        SELECT
            sum( order_quantity ) AS order_quantity
        FROM
            ods_sap_marketing_sale_order_head dmso
                LEFT JOIN ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                LEFT JOIN ods_sap_supplychain_material_factory ossmf ON dmsop.material_id = ossmf.material_id #marc
        WHERE
                dmso.create_date >= date_sub(curdate(),interval 1 day)
          AND dmso.create_date < curdate()
          AND ( ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$' )
          AND ( dmso.sale_order_type != 'Z008' AND dmso.sale_order_type != 'Z009' AND dmso.sale_order_type != 'Z006' AND dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null )
    ) AS 'order_receive_quantity',
    (
        SELECT
            sum( actual_delivery_quantity ) actual_delivery_quantity
        FROM
            (
                SELECT
                    max( dmsd.actual_delivery_quantity ) actual_delivery_quantity
                from dwd_marketing_sale_delivery dmsd
                         left join ods_sap_marketing_sale_order_head dmso on dmsd.sale_order_id = dmso.sale_order_id
                         left join ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                         left join ods_sap_supplychain_material_factory ossmf on dmsd.material_id = ossmf.material_id
                where dmsd.goods_movement_date >= date_sub(curdate(),interval 1 day) and dmsd.goods_movement_date < curdate()
                  and dmsd.cargo_movement_status = 'C'
                  and (ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$' )
                  and (dmso.sale_order_type != 'Z008' and dmso.sale_order_type != 'Z009' and dmso.sale_order_type != 'Z006' and dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null)
                GROUP BY delivery_order_id,delivery_row_id
            ) t
    ) AS 'sale_quantity',
    (
        SELECT
            sum( order_quantity ) order_quantity
        FROM
            (
                SELECT
                    max( dspmo.quantity ) order_quantity
                from ods_sap_supplychain_logistics_order_movement dspmo
                         left join ods_sap_marketing_sale_order_head dmso on dspmo.sale_order_id = dmso.sale_order_id
                         left join ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                         left join ods_sap_supplychain_material_factory ossmf on ossmf.material_id = dspmo.material_id
                where dspmo.post_date >= date_sub(curdate(),interval 1 day) and dspmo.post_date < curdate()
                  and ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
                  and dspmo.material_transfer = '101'
                  and	 (dmso.sale_order_type != 'Z008' AND dmso.sale_order_type != 'Z009' AND dmso.sale_order_type != 'Z006' AND dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null)
                GROUP BY
                    dspmo.material_credential_id,
                    dspmo.material_credential_project,
                    dspmo.material_credential_year
            ) t
    ) AS 'manufacture_quantity',
    ((
         SELECT
             sum( non_limitation_storage ) used_storage
         FROM
             ods_sap_supplychain_logistics_storage_sales_order osslsso
                 LEFT JOIN ods_sap_supplychain_material_factory ossmf ON ossmf.material_id = osslsso.material_id
         WHERE
                 ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
     ) + (
         SELECT
             sum( non_limitation_storage ) free_storage
         FROM
             ods_sap_supplychain_material_storage_location ossmsl
                 LEFT JOIN ods_sap_supplychain_material_factory ossmf ON ossmf.material_id = ossmsl.material_id
         WHERE
                 ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
     )) AS 'manufactured_inventory' UNION ALL
SELECT
    '最近一周' AS 'time_dimension',
    (
        SELECT
            sum( order_quantity ) AS order_quantity
        FROM
            ods_sap_marketing_sale_order_head dmso
                LEFT JOIN ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                LEFT JOIN ods_sap_supplychain_material_factory ossmf ON dmsop.material_id = ossmf.material_id #marc
        WHERE
                dmso.create_date >= date_sub(curdate(),interval 1 week)
          AND dmso.create_date < curdate()
          AND ( ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$' )
          AND ( dmso.sale_order_type != 'Z008' AND dmso.sale_order_type != 'Z009' AND dmso.sale_order_type != 'Z006' AND dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null )
    ) AS 'order_receive_quantity',
    (
        SELECT
            sum( actual_delivery_quantity ) actual_delivery_quantity
        FROM
            (
                SELECT
                    max( dmsd.actual_delivery_quantity ) actual_delivery_quantity
                from dwd_marketing_sale_delivery dmsd
                         left join ods_sap_marketing_sale_order_head dmso on dmsd.sale_order_id = dmso.sale_order_id
                         left join ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                         left join ods_sap_supplychain_material_factory ossmf on dmsd.material_id = ossmf.material_id
                where dmsd.goods_movement_date >= date_sub(curdate(),interval 1 week) and dmsd.goods_movement_date < curdate()
                  and dmsd.cargo_movement_status = 'C'
                  and (ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$' )
                  and (dmso.sale_order_type != 'Z008' and dmso.sale_order_type != 'Z009' and dmso.sale_order_type != 'Z006' and dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null)
                GROUP BY delivery_order_id,delivery_row_id
            ) t
    ) AS 'sale_quantity',
    (
        SELECT
            sum( order_quantity ) order_quantity
        FROM
            (
                SELECT
                    max( dspmo.quantity ) order_quantity
                from ods_sap_supplychain_logistics_order_movement dspmo
                         left join ods_sap_marketing_sale_order_head dmso on dspmo.sale_order_id = dmso.sale_order_id
                         left join ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                         left join ods_sap_supplychain_material_factory ossmf on ossmf.material_id = dspmo.material_id
                where dspmo.post_date >= date_sub(curdate(),interval 1 week) and dspmo.post_date < curdate()
                  and ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
                  and dspmo.material_transfer = '101'
                  and	 (dmso.sale_order_type != 'Z008' AND dmso.sale_order_type != 'Z009' AND dmso.sale_order_type != 'Z006' AND dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null)
                GROUP BY
                    dspmo.material_credential_id,
                    dspmo.material_credential_project,
                    dspmo.material_credential_year
            ) t
    ) AS 'manufacture_quantity',
    ((
         SELECT
             sum( non_limitation_storage ) used_storage
         FROM
             ods_sap_supplychain_logistics_storage_sales_order osslsso
                 LEFT JOIN ods_sap_supplychain_material_factory ossmf ON ossmf.material_id = osslsso.material_id
         WHERE
                 ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
     ) + (
         SELECT
             sum( non_limitation_storage ) free_storage
         FROM
             ods_sap_supplychain_material_storage_location ossmsl
                 LEFT JOIN ods_sap_supplychain_material_factory ossmf ON ossmf.material_id = ossmsl.material_id
         WHERE
                 ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
     )) AS 'manufactured_inventory' UNION ALL
SELECT
    '最近一月' AS 'time_dimension',
    (
        SELECT
            sum( order_quantity ) AS order_quantity
        FROM
            ods_sap_marketing_sale_order_head dmso
                LEFT JOIN ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                LEFT JOIN ods_sap_supplychain_material_factory ossmf ON dmsop.material_id = ossmf.material_id #marc
        WHERE
                dmso.create_date >= date_format(curdate(),'%Y-%m-01')
          AND dmso.create_date < curdate()
          AND ( ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$' )
          AND ( dmso.sale_order_type != 'Z008' AND dmso.sale_order_type != 'Z009' AND dmso.sale_order_type != 'Z006' AND dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null )
    ) AS 'order_receive_quantity',
    (
        SELECT
            sum( actual_delivery_quantity ) actual_delivery_quantity
        FROM
            (
                SELECT
                    max( dmsd.actual_delivery_quantity ) actual_delivery_quantity
                from dwd_marketing_sale_delivery dmsd
                         left join ods_sap_marketing_sale_order_head dmso on dmsd.sale_order_id = dmso.sale_order_id
                         left join ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                         left join ods_sap_supplychain_material_factory ossmf on dmsd.material_id = ossmf.material_id
                where dmsd.goods_movement_date >= date_format(curdate(),'%Y-%m-01') and dmsd.goods_movement_date < curdate()
                  and dmsd.cargo_movement_status = 'C'
                  and (ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$' )
                  and (dmso.sale_order_type != 'Z008' and dmso.sale_order_type != 'Z009' and dmso.sale_order_type != 'Z006' and dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null)
                GROUP BY delivery_order_id,delivery_row_id
            ) t
    ) AS 'sale_quantity',
    (
        SELECT
            sum( order_quantity ) order_quantity
        FROM
            (
                SELECT
                    max( dspmo.quantity ) order_quantity
                from ods_sap_supplychain_logistics_order_movement dspmo
                         left join ods_sap_marketing_sale_order_head dmso on dspmo.sale_order_id = dmso.sale_order_id
                         left join ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                         left join ods_sap_supplychain_material_factory ossmf on ossmf.material_id = dspmo.material_id
                where dspmo.post_date >= date_format(curdate(),'%Y-%m-01') and dspmo.post_date < curdate()
                  and ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
                  and dspmo.material_transfer = '101'
                  and	 (dmso.sale_order_type != 'Z008' AND dmso.sale_order_type != 'Z009' AND dmso.sale_order_type != 'Z006' AND dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null)
                GROUP BY
                    dspmo.material_credential_id,
                    dspmo.material_credential_project,
                    dspmo.material_credential_year
            ) t
    ) AS 'manufacture_quantity',
    ((
         SELECT
             sum( non_limitation_storage ) used_storage
         FROM
             ods_sap_supplychain_logistics_storage_sales_order osslsso
                 LEFT JOIN ods_sap_supplychain_material_factory ossmf ON ossmf.material_id = osslsso.material_id
         WHERE
                 ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
     ) + (
         SELECT
             sum( non_limitation_storage ) free_storage
         FROM
             ods_sap_supplychain_material_storage_location ossmsl
                 LEFT JOIN ods_sap_supplychain_material_factory ossmf ON ossmf.material_id = ossmsl.material_id
         WHERE
                 ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
     )) AS 'manufactured_inventory' UNION ALL
SELECT
    '最近一季' AS 'time_dimension',
    (
        SELECT
            sum( order_quantity ) AS order_quantity
        FROM
            ods_sap_marketing_sale_order_head dmso
                LEFT JOIN ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                LEFT JOIN ods_sap_supplychain_material_factory ossmf ON dmsop.material_id = ossmf.material_id #marc
        WHERE
                dmso.create_date >= date_format(curdate(),'2023-04-01')
          AND dmso.create_date < curdate()
          AND ( ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$' )
          AND ( dmso.sale_order_type != 'Z008' AND dmso.sale_order_type != 'Z009' AND dmso.sale_order_type != 'Z006' AND dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null )
    ) AS 'order_receive_quantity',
    (
        SELECT
            sum( actual_delivery_quantity ) actual_delivery_quantity
        FROM
            (
                SELECT
                    max( dmsd.actual_delivery_quantity ) actual_delivery_quantity
                from dwd_marketing_sale_delivery dmsd
                         left join ods_sap_marketing_sale_order_head dmso on dmsd.sale_order_id = dmso.sale_order_id
                         left join ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                         left join ods_sap_supplychain_material_factory ossmf on dmsd.material_id = ossmf.material_id
                where dmsd.goods_movement_date >= date_format(curdate(),'2023-04-01') and dmsd.goods_movement_date < curdate()
                  and dmsd.cargo_movement_status = 'C'
                  and (ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$' )
                  and (dmso.sale_order_type != 'Z008' and dmso.sale_order_type != 'Z009' and dmso.sale_order_type != 'Z006' and dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null)
                GROUP BY delivery_order_id,delivery_row_id
            ) t
    ) AS 'sale_quantity',
    (
        SELECT
            sum( order_quantity ) order_quantity
        FROM
            (
                SELECT
                    max( dspmo.quantity ) order_quantity
                from ods_sap_supplychain_logistics_order_movement dspmo
                         left join ods_sap_marketing_sale_order_head dmso on dspmo.sale_order_id = dmso.sale_order_id
                         left join ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                         left join ods_sap_supplychain_material_factory ossmf on ossmf.material_id = dspmo.material_id
                where dspmo.post_date >= date_format(curdate(),'2023-04-01') and dspmo.post_date < curdate()
                  and ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
                  and dspmo.material_transfer = '101'
                  and	 (dmso.sale_order_type != 'Z008' AND dmso.sale_order_type != 'Z009' AND dmso.sale_order_type != 'Z006' AND dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null)
                GROUP BY
                    dspmo.material_credential_id,
                    dspmo.material_credential_project,
                    dspmo.material_credential_year
            ) t
    ) AS 'manufacture_quantity',
    ((
         SELECT
             sum( non_limitation_storage ) used_storage
         FROM
             ods_sap_supplychain_logistics_storage_sales_order osslsso
                 LEFT JOIN ods_sap_supplychain_material_factory ossmf ON ossmf.material_id = osslsso.material_id
         WHERE
                 ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
     ) + (
         SELECT
             sum( non_limitation_storage ) free_storage
         FROM
             ods_sap_supplychain_material_storage_location ossmsl
                 LEFT JOIN ods_sap_supplychain_material_factory ossmf ON ossmf.material_id = ossmsl.material_id
         WHERE
                 ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
     )) AS 'manufactured_inventory' UNION ALL
SELECT
    '最近一年' AS 'time_dimension',
    (
        SELECT
            sum( order_quantity ) AS order_quantity
        FROM
            ods_sap_marketing_sale_order_head dmso
                LEFT JOIN ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                LEFT JOIN ods_sap_supplychain_material_factory ossmf ON dmsop.material_id = ossmf.material_id #marc
        WHERE
                dmso.create_date >= date_format(curdate(),'2023-01-01')
          AND dmso.create_date < curdate()
          AND ( ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$' )
          AND ( dmso.sale_order_type != 'Z008' AND dmso.sale_order_type != 'Z009' AND dmso.sale_order_type != 'Z006' AND dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null )
    ) AS 'order_receive_quantity',
    (
        SELECT
            sum( actual_delivery_quantity ) actual_delivery_quantity
        FROM
            (
                SELECT
                    max( dmsd.actual_delivery_quantity ) actual_delivery_quantity
                from dwd_marketing_sale_delivery dmsd
                         left join ods_sap_marketing_sale_order_head dmso on dmsd.sale_order_id = dmso.sale_order_id
                         left join ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                         left join ods_sap_supplychain_material_factory ossmf on dmsd.material_id = ossmf.material_id
                where dmsd.goods_movement_date >= date_format(curdate(),'2023-01-01') and dmsd.goods_movement_date < curdate()
                  and dmsd.cargo_movement_status = 'C'
                  and (ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$' )
                  and (dmso.sale_order_type != 'Z008' and dmso.sale_order_type != 'Z009' and dmso.sale_order_type != 'Z006' and dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null)
                GROUP BY delivery_order_id,delivery_row_id
            ) t
    ) AS 'sale_quantity',
    (
        SELECT
            sum( order_quantity ) order_quantity
        FROM
            (
                SELECT
                    max( dspmo.quantity ) order_quantity
                from ods_sap_supplychain_logistics_order_movement dspmo
                         left join ods_sap_marketing_sale_order_head dmso on dspmo.sale_order_id = dmso.sale_order_id
                         left join ods_sap_marketing_sale_order_project dmsop on dmso.sale_order_id = dmsop.sale_order_id
                         left join ods_sap_supplychain_material_factory ossmf on ossmf.material_id = dspmo.material_id
                where dspmo.post_date >= date_format(curdate(),'2023-01-01') and dspmo.post_date < curdate()
                  and ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
                  and dspmo.material_transfer = '101'
                  and	 (dmso.sale_order_type != 'Z008' AND dmso.sale_order_type != 'Z009' AND dmso.sale_order_type != 'Z006' AND dmso.sale_order_type != 'Z007' and dmsop.refuse_reason is null)
                GROUP BY
                    dspmo.material_credential_id,
                    dspmo.material_credential_project,
                    dspmo.material_credential_year
            ) t
    ) AS 'manufacture_quantity',
    ((
         SELECT
             sum( non_limitation_storage ) used_storage
         FROM
             ods_sap_supplychain_logistics_storage_sales_order osslsso
                 LEFT JOIN ods_sap_supplychain_material_factory ossmf ON ossmf.material_id = osslsso.material_id
         WHERE
                 ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
     ) + (
         SELECT
             sum( non_limitation_storage ) free_storage
         FROM
             ods_sap_supplychain_material_storage_location ossmsl
                 LEFT JOIN ods_sap_supplychain_material_factory ossmf ON ossmf.material_id = ossmsl.material_id
         WHERE
                 ossmf.mrp_controller REGEXP '^D[0]{1}[0-4]$'
     )) AS 'manufactured_inventory';