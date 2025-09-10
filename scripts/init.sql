-- ==========================================================
-- SQL Server Script: Setup DataWarehouse Database
-- Purpose: Drops existing DataWarehouse database (if any),
--          recreates it, and establishes Bronze, Silver, 
--          and Gold schemas for data organization.
-- ==========================================================

-- Switch context to the master database
-- Required before creating or dropping another database
USE master;
GO


-- ==========================================================
-- Step 1: Drop the DataWarehouse database if it already exists
-- Logic:
--   1. Check sys.databases catalog for 'DataWarehouse'
--   2. If found:
--        a. Force database into SINGLE_USER mode 
--           (ensures no other connections block the drop)
--           WITH ROLLBACK IMMEDIATE will cancel all 
--           active transactions immediately
--        b. Drop the database
-- ==========================================================
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN	
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO


-- ==========================================================
-- Step 2: Create a fresh instance of the DataWarehouse database
-- ==========================================================
CREATE DATABASE DataWarehouse;
GO


-- ==========================================================
-- Step 3: Switch context to the new DataWarehouse database
-- ==========================================================
USE DataWarehouse;
GO


-- ==========================================================
-- Step 4: Create organizational schemas
-- Schemas act as logical containers for tables, views, etc.
--   - Bronze: Raw ingested data
--   - Silver: Cleaned and conformed data
--   - Gold: Curated, business-ready data
-- This follows the "medallion architecture" best practice
-- ==========================================================
CREATE SCHEMA Bronze;
GO

CREATE SCHEMA Silver;
GO

CREATE SCHEMA Gold;
GO
