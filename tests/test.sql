--STEPS TO ELIMINATE UNCLEAN DATA
/*
===============================================================
SELECTING ROWS THAT HAVE UNIQUE AND NOT NULL CST_ID
===============================================================
*/
use DataWarehouse
select * from  bronze.crm_cust_info

select c.cst_id,count(*) from Bronze.crm_cust_info as c group by c.cst_id having count(*)>1


select * from
(select *,
row_number() over(partition by cst_id order by cst_create_date desc) as latest
from bronze.crm_cust_info)t 
where latest=1 and cst_id is not null

/*
=====================================================================
CHECK FOR UNWANTED WHITESPACES
=====================================================================
*/
select cst_id,cst_key,TRIM(cst_firstname),TRIM(cst_lastname),cst_maritial_status,cst_gndr,cst_create_date from 
Bronze.crm_cust_info where cst_firstname!=TRIM(cst_firstname) 



/*
=====================================================================
STANDARDIZE M=MARRIED, S=SINGLE, M=MALE AND F=FEMALE ELSE 'n/a'
=====================================================================
*/

/*
=====================================================================
Bronze.crm_prod_info
=====================================================================

*/

-- NO duplicate product id.

select * from Bronze.crm_prd_info
select prd_id,count(*) from bronze.crm_prd_info group by prd_id having count(*)!=1

select id from bronze.erp_px_cat_g1v2

select prd_id,REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,SUBSTRING(prd_key,7,LEN(prd_key)) as prd_key,
TRIM(nm_prd) as nm_prd,ISNULL(prd_cost,0) prd_cost,
CASE 
    WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
    WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
    WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
    WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
    ELSE 'n/a'
END AS prd_line,
prd_start_dt,
DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (
    PARTITION BY prd_key 
    ORDER BY prd_start_dt
)) AS prd_end_dt
from bronze.crm_prd_info

select * from silver.crm_prd_info




/*
=====================================================================
Bronze.crm_sales_details
=====================================================================

*/
select * from Bronze.crm_sales_details where sls_ord_num='SO58335'
select * from Bronze.crm_sales_details where trim(sls_prd_key)!=sls_prd_key


--changing sls_ord_date andother date columns' data types to Date instead of int. 

select sls_ord_num,sls_sales,sls_quantity,sls_price from (
select
sls_ord_num,
sls_prd_key,
sls_cust_id,
case 
    when len(sls_order_dt)!=8 or sls_order_dt=0 then NULL
    else cast(cast(sls_order_dt as varchar)as date)
    end sls_order_dt,
cast(cast(sls_ship_dt as varchar) as date) as sls_ship_dt,
cast(cast(sls_due_dt as varchar) as date) as sls_due_dt,
case
when sls_sales<=0 or sls_sales is null or sls_sales!=sls_quantity*abs(sls_price) then abs(sls_price)*sls_quantity
else sls_sales
end as sls_sales,
sls_quantity,
case
when sls_price<=0 or sls_price is null then abs(sls_sales)/nullif(sls_quantity,0)
else sls_price
end as sls_price
from Bronze.crm_sales_details)t

select * from silver.crm_prd_info


select [sls_due_dt] from Bronze.crm_sales_details where len(sls_due_dt)<8
select Cast(Cast(sls_order_dt as varchar) as date)  from Bronze.crm_sales_details
 
 select sls_sales,sls_quantity,sls_price from Bronze.crm_sales_details where sls_sales is null or sls_sales<0 
 or sls_quantity is null or sls_quantity<0 or sls_price is null or sls_price<=0



 /*
=====================================================================
Bronze.erp_cust_az12
=====================================================================

*/

select * from Bronze.erp_cust_az12

select distinct gen from(
select 
case 
when cid like ('NAS%') then SUBSTRING(cid,4,len(cid))
else cid
end as cid,
case 
when bdate>cast(getdate() as date) then NULL
else bdate
end as bdate,
case 
when UPPER(TRIM(gen)) in ('') then NULL
when UPPER(TRIM(gen)) in ('M','MALE') then 'Male'
when UPPER(TRIM(gen)) in ('F','FEMALE') then 'Female'
end as gen
from Bronze.erp_cust_az12  
)t

select * from Bronze.erp_cust_az12 where bdate<'1920-01-01' or bdate>cast(GETDATE() as date)

select distinct gen from Bronze.erp_cust_az12




 /*
=====================================================================
Bronze.erp_loc_a101
=====================================================================

*/


select * from Bronze.erp_loc_a101

select distinct cntry from (
select 
replace(cid,'-','') as cid,
case 
when upper(trim(cntry)) in ('DE','GERMANY') THEN 'Germany'
when upper(trim(cntry)) in ('US','USA','UNITED STATES') then 'United States'
when cntry in ('') then NULL
else cntry
end as cntry
from Bronze.erp_loc_a101)t 

USE DATAWAREHOUSE


SELECT * FROM BRONZE.erp_px_cat_g1v2


 





select distinct cntry from Bronze.erp_loc_a101 

select * from Bronze.erp_loc_a101 where cid not like ('AW%')
select * from Bronze.erp_px_cat_g1v2
