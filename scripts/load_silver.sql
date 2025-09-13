/*
===============================================================
CLEAN AND READY TO LOAD Bronze.crm_cust_info TABLE
===============================================================
*/
USE DataWarehouse
TRUNCATE Silver.crm_cust_info
INSERT INTO Silver.crm_cust_info 
    (cst_id,
     cst_key,
     cst_firstname,
     cst_lastname,
     cst_maritial_status,
     cst_gndr,
     cst_create_date)
SELECT 
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname)  AS cst_lastname,
    CASE UPPER(cst_maritial_status)
        WHEN 'M' THEN 'Married'
        WHEN 'S' THEN 'Single'
        ELSE 'n/a'
    END AS cst_maritial_status,
    CASE UPPER(cst_gndr)
        WHEN 'M' THEN 'Male'
        WHEN 'F' THEN 'Female'
        ELSE 'n/a'
    END AS cst_gndr,
    cst_create_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS latest
    FROM bronze.crm_cust_info
) t
WHERE latest = 1 
  AND cst_id IS NOT NULL



TRUNCATE TABLE Silver.crm_prd_info;

INSERT INTO Silver.crm_prd_info(
    prd_id,
    cat_id,
    prd_key,
    nm_prd,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT 
    prd_id,
    REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
    SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
    TRIM(nm_prd) AS nm_prd,
    ISNULL(prd_cost,0) AS prd_cost,
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
FROM bronze.crm_prd_info;


TRUNCATE TABLE Silver.crm_sales_details;

INSERT INTO Silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE 
        WHEN LEN(sls_order_dt) != 8 OR sls_order_dt = 0 
            THEN NULL
        ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
    END AS sls_order_dt,
    CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) AS sls_ship_dt,
    CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) AS sls_due_dt,
    CASE
        WHEN sls_sales <= 0 
             OR sls_sales IS NULL 
             OR sls_sales != sls_quantity * ABS(sls_price) 
            THEN ABS(sls_price) * sls_quantity
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE
        WHEN sls_price <= 0 
             OR sls_price IS NULL 
            THEN ABS(sls_sales) / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price
FROM Bronze.crm_sales_details;




TRUNCATE TABLE Silver.erp_cust_az12;
INSERT INTO Silver.erp_cust_az12(cid,bdate,gen)
SELECT 
    CASE 
        WHEN cid LIKE ('NAS%') THEN SUBSTRING(cid, 4, LEN(cid))
        ELSE cid
    END AS cid,
    CASE 
        WHEN bdate > CAST(GETDATE() AS date) THEN NULL
        ELSE bdate
    END AS bdate,
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('') THEN NULL
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
    END AS gen

FROM Bronze.erp_cust_az12;




TRUNCATE TABLE Silver.erp_loc_a101;
INSERT INTO Silver.erp_loc_a101(cid,cntry)
SELECT 
    REPLACE(cid, '-', '') AS cid,
    CASE 
        WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
        WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES') THEN 'United States'
        WHEN cntry IN ('') THEN NULL
        ELSE cntry
    END AS cntry
FROM Bronze.erp_loc_a101;
