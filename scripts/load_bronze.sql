CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
	----------------------------------------------------------
	-- Load CRM Customer Information
	----------------------------------------------------------
	BEGIN TRY
		DECLARE @starttime DATETIME, @endtime DATETIME, @bulkloadstarttime DATETIME, @bulkloadendtime DATETIME;

		SET @bulkloadstarttime=GETDATE();
		SET @starttime=GETDATE();
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
		SET @endtime=GETDATE()
		PRINT '✅ Bronze.crm_cust_info load complete.';
		PRINT 'Time duration to load the table is' + CAST(DATEDIFF(millisecond,@starttime,@endtime) AS NVARCHAR)+ ' milliseconds'
		
		----------------------------------------------------------
		-- Load CRM Product Information
		----------------------------------------------------------
		SET @starttime=GETDATE();
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
		SET @endtime=GETDATE()
		PRINT '✅ Bronze.crm_prd_info load complete.';
		PRINT 'Time duration to load the table is' + CAST(DATEDIFF(millisecond,@starttime,@endtime) AS NVARCHAR)+ ' milliseconds'

	
	
		----------------------------------------------------------
		-- Load CRM Sales Transactions
		----------------------------------------------------------
		SET @starttime=GETDATE();
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
		SET @endtime=GETDATE()
		PRINT '✅ Bronze.crm_sales_details load complete.';
		PRINT 'Time duration to load the table is' + CAST(DATEDIFF(millisecond,@starttime,@endtime) AS NVARCHAR)+ ' milliseconds'

	
	
		----------------------------------------------------------
		-- Load ERP Customer Master (AZ12)
		----------------------------------------------------------
		SET @starttime=GETDATE();
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
		SET @endtime=GETDATE()
		PRINT '✅ Bronze.erp_cust_az12 load complete.';
		PRINT 'Time duration to load the table is' + CAST(DATEDIFF(millisecond,@starttime,@endtime) AS NVARCHAR)+ ' milliseconds'

	
		----------------------------------------------------------
		-- Load ERP Customer Location Data (A101)
		----------------------------------------------------------
		SET @starttime=GETDATE();
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
		SET @endtime=GETDATE()
		PRINT '✅ Bronze.erp_loc_a101 load complete.';
		PRINT 'Time duration to load the table is' + CAST(DATEDIFF(millisecond,@starttime,@endtime) AS NVARCHAR)+ ' milliseconds'
	
	
		----------------------------------------------------------
		-- Load ERP Product Category Data (PX_CAT_G1V2)
		----------------------------------------------------------
		SET @starttime=GETDATE();
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
		SET @endtime=GETDATE()
		PRINT '✅ Bronze.erp_px_cat_g1v2 load complete.';
		PRINT 'Time duration to load the table is' + CAST(DATEDIFF(millisecond,@starttime,@endtime) AS NVARCHAR)+ ' milliseconds'


		SET @bulkloadendtime=GETDATE()
	
		----------------------------------------------------------
		-- Completion Message
		----------------------------------------------------------
		PRINT '🎉 All Bronze layer tables successfully truncated and loaded.';
		PRINT 'Bulk load duration is: ' + CAST(DATEDIFF(millisecond,@bulkloadstarttime,@bulkloadendtime) AS NVARCHAR)+ ' milliseconds' 
	END TRY
	BEGIN CATCH
		PRINT 'ERROR MESSAGE:'+ ERROR_MESSAGE()
		PRINT 'ERROR NUMBER:' + ERROR_NUMBER()
		PRINT 'ERROR STATE:' + ERROR_STATE()
	END CATCH
END


