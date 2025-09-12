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

