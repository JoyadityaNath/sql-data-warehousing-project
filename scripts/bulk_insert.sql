----------------------------------------------------------
-- Load CRM Customer Information
-- Step 1: Truncate table to ensure a clean load
-- Step 2: Bulk insert data from source CSV file
----------------------------------------------------------
TRUNCATE TABLE Bronze.crm_cust_info;

BULK INSERT Bronze.crm_cust_info
FROM 'D:\STUDY\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2,              -- Skip header row
	FIELDTERMINATOR = ',',     -- Columns separated by comma
	TABLOCK                    -- Table-level lock for performance
);

----------------------------------------------------------
-- Load CRM Product Information
----------------------------------------------------------
TRUNCATE TABLE Bronze.crm_prd_info;

BULK INSERT Bronze.crm_prd_info
FROM 'D:\STUDY\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
	FIRSTROW = 2, 
	FIELDTERMINATOR = ',', 
	TABLOCK
);

----------------------------------------------------------
-- Load CRM Sales Transactions
----------------------------------------------------------
TRUNCATE TABLE Bronze.crm_sales_details;

BULK INSERT Bronze.crm_sales_details
FROM 'D:\STUDY\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2, 
	FIELDTERMINATOR = ',', 
	TABLOCK
);

----------------------------------------------------------
-- Load ERP Customer Master (AZ12)
----------------------------------------------------------
TRUNCATE TABLE Bronze.erp_cust_az12;

BULK INSERT Bronze.erp_cust_az12
FROM 'D:\STUDY\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
WITH (
	FIRSTROW = 2, 
	FIELDTERMINATOR = ',', 
	TABLOCK
);

----------------------------------------------------------
-- Load ERP Customer Location Data (A101)
----------------------------------------------------------
TRUNCATE TABLE Bronze.erp_loc_a101;

BULK INSERT Bronze.erp_loc_a101
FROM 'D:\STUDY\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
WITH (
	FIRSTROW = 2, 
	FIELDTERMINATOR = ',', 
	TABLOCK
);

----------------------------------------------------------
-- Load ERP Product Category Data (PX_CAT_G1V2)
----------------------------------------------------------
TRUNCATE TABLE Bronze.erp_px_cat_g1v2;

BULK INSERT Bronze.erp_px_cat_g1v2
FROM 'D:\STUDY\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
	FIRSTROW = 2, 
	FIELDTERMINATOR = ',', 
	TABLOCK
);
