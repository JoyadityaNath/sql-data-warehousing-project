CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
	----------------------------------------------------------
	-- Load CRM Customer Information
	----------------------------------------------------------
	PRINT 'Step 1: Truncating Bronze.crm_cust_info...';
	TRUNCATE TABLE Bronze.crm_cust_info;

	PRINT 'Step 1: Loading Bronze.crm_cust_info from cust_info.csv...';
	BULK INSERT Bronze.crm_cust_info
	FROM 'D:\STUDY\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	PRINT '✅ Bronze.crm_cust_info load complete.';


	----------------------------------------------------------
	-- Load CRM Product Information
	----------------------------------------------------------
	PRINT 'Step 2: Truncating Bronze.crm_prd_info...';
	TRUNCATE TABLE Bronze.crm_prd_info;

	PRINT 'Step 2: Loading Bronze.crm_prd_info from prd_info.csv...';
	BULK INSERT Bronze.crm_prd_info
	FROM 'D:\STUDY\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	PRINT '✅ Bronze.crm_prd_info load complete.';


	----------------------------------------------------------
	-- Load CRM Sales Transactions
	----------------------------------------------------------
	PRINT 'Step 3: Truncating Bronze.crm_sales_details...';
	TRUNCATE TABLE Bronze.crm_sales_details;

	PRINT 'Step 3: Loading Bronze.crm_sales_details from sales_details.csv...';
	BULK INSERT Bronze.crm_sales_details
	FROM 'D:\STUDY\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	PRINT '✅ Bronze.crm_sales_details load complete.';


	----------------------------------------------------------
	-- Load ERP Customer Master (AZ12)
	----------------------------------------------------------
	PRINT 'Step 4: Truncating Bronze.erp_cust_az12...';
	TRUNCATE TABLE Bronze.erp_cust_az12;

	PRINT 'Step 4: Loading Bronze.erp_cust_az12 from CUST_AZ12.csv...';
	BULK INSERT Bronze.erp_cust_az12
	FROM 'D:\STUDY\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	WITH (
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	PRINT '✅ Bronze.erp_cust_az12 load complete.';


	----------------------------------------------------------
	-- Load ERP Customer Location Data (A101)
	----------------------------------------------------------
	PRINT 'Step 5: Truncating Bronze.erp_loc_a101...';
	TRUNCATE TABLE Bronze.erp_loc_a101;

	PRINT 'Step 5: Loading Bronze.erp_loc_a101 from LOC_A101.csv...';
	BULK INSERT Bronze.erp_loc_a101
	FROM 'D:\STUDY\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	WITH (
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	PRINT '✅ Bronze.erp_loc_a101 load complete.';


	----------------------------------------------------------
	-- Load ERP Product Category Data (PX_CAT_G1V2)
	----------------------------------------------------------
	PRINT 'Step 6: Truncating Bronze.erp_px_cat_g1v2...';
	TRUNCATE TABLE Bronze.erp_px_cat_g1v2;

	PRINT 'Step 6: Loading Bronze.erp_px_cat_g1v2 from PX_CAT_G1V2.csv...';
	BULK INSERT Bronze.erp_px_cat_g1v2
	FROM 'D:\STUDY\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH (
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	PRINT '✅ Bronze.erp_px_cat_g1v2 load complete.';


	----------------------------------------------------------
	-- Completion Message
	----------------------------------------------------------
	PRINT '🎉 All Bronze layer tables successfully truncated and loaded.';
END
