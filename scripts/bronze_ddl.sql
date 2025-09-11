-- Switch to the target database context
USE DataWarehouse;

----------------------------------------------------------
-- Customer Information Table (CRM Source)
-- Holds basic customer master data such as name, marital
-- status, gender, and record creation date
----------------------------------------------------------
IF OBJECT_ID('Bronze.crm_cust_info','U') IS NOT NULL 
	DROP TABLE Bronze.crm_cust_info;

CREATE TABLE Bronze.crm_cust_info (
	cst_id INT,                        -- Customer ID (numeric identifier)
	cst_key NVARCHAR(50),              -- Customer Key (business key from source)
	cst_firstname NVARCHAR(50),        -- Customer First Name
	cst_lastname NVARCHAR(50),         -- Customer Last Name
	cst_maritial_status NVARCHAR(50),  -- Marital Status
	cst_gndr NVARCHAR(50),             -- Gender
	cst_create_date DATE               -- Record Creation Date
);

----------------------------------------------------------
-- Product Information Table (CRM Source)
-- Stores product master data including cost, line, and
-- effective start and end dates
----------------------------------------------------------
IF OBJECT_ID('Bronze.crm_prd_info','U') IS NOT NULL 
	DROP TABLE Bronze.crm_prd_info;

CREATE TABLE Bronze.crm_prd_info( 
	prd_id INT,               -- Product ID (numeric identifier)
	prd_key NVARCHAR(50),     -- Product Key (business key from source)
	nm_prd NVARCHAR(50),      -- Product Name
	prd_cost INT,             -- Product Cost
	prd_line NVARCHAR(50),    -- Product Line / Category
	prd_start_dt DATE,        -- Validity Start Date
	prd_end_dt DATE           -- Validity End Date
);

----------------------------------------------------------
-- Sales Transactions Table (CRM Source)
-- Captures sales orders with customer/product references,
-- dates, amounts, quantities, and pricing details
----------------------------------------------------------
IF OBJECT_ID('Bronze.crm_sales_details','U') IS NOT NULL 
    DROP TABLE Bronze.crm_sales_details;

CREATE TABLE Bronze.crm_sales_details(
	sls_ord_num NVARCHAR(50),   -- Sales Order Number
	sls_prd_key NVARCHAR(50),   -- Product Key (FK to product master)
	sls_cust_id INT,            -- Customer ID (FK to customer master)
	sls_order_dt INT,           -- Order Date (stored as INT, e.g., YYYYMMDD)
	sls_ship_dt INT,            -- Ship Date (stored as INT)
	sls_due_dt INT,             -- Due Date (stored as INT)
	sls_sales INT,              -- Sales Amount
	sls_quantity INT,           -- Quantity Sold
	sls_price INT               -- Unit Price
);

----------------------------------------------------------
-- ERP Customer Data Table
-- Stores customer information from ERP, including birthdate
-- and gender attributes
----------------------------------------------------------
IF OBJECT_ID('Bronze.erp_cust_az12','U') IS NOT NULL
	DROP TABLE Bronze.erp_cust_az12;

CREATE TABLE Bronze.erp_cust_az12(
	cid NVARCHAR(50),   -- Customer Identifier
	bdate DATE,         -- Birth Date
	gen NVARCHAR(50)    -- Gender
);

----------------------------------------------------------
-- ERP Customer Location Data
-- Stores customer location details (country-level)
----------------------------------------------------------
IF OBJECT_ID('Bronze.erp_loc_a101','U') IS NOT NULL
	DROP TABLE Bronze.erp_loc_a101;

CREATE TABLE Bronze.erp_loc_a101(
	cid NVARCHAR(50),   -- Customer Identifier
	cntry NVARCHAR(50)  -- Country
);

----------------------------------------------------------
-- ERP Product Category Data
-- Maintains product classification with category,
-- subcategory, and maintenance attributes
----------------------------------------------------------
IF OBJECT_ID('Bronze.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE Bronze.erp_px_cat_g1v2;

CREATE TABLE Bronze.erp_px_cat_g1v2(
	id NVARCHAR(50),          -- Identifier (likely product/category key)
	cat NVARCHAR(50),         -- Category
	subcat NVARCHAR(50),      -- Subcategory
	maintenance NVARCHAR(50)  -- Maintenance Type / Status
);
