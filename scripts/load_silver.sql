/*
===============================================================
CLEAN AND READY TO LOAD Bronze.crm_cust_info TABLE
===============================================================
*/
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
  AND cst_id IS NOT NULL;


/*
===============================================================
CLEAN AND READY TO LOAD Bronze.crm_prd_info TABLE
===============================================================
*/

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
