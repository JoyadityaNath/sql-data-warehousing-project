USE DataWarehouse;

--=================================================================================================--
-- CHANGE OVER TIME ANALYSIS
--=================================================================================================--
/*
Requirement:
1. For each month across all years, calculate:
   - Total sales (SUM of sales_amount)
   - Total customers (COUNT DISTINCT customer_key)
   - Total quantity (SUM of quantity)

2. Present the results in three formats:
   (1) Year and month as separate columns
   (2) A single column showing the first day of the month (e.g., 2023-05-01)
   (3) A single column showing year + abbreviated month (e.g., 2023-May)
*/

-- (1) Using separate year and month columns
SELECT 
    YEAR(order_date) AS [year],
    MONTH(order_date) AS [month],
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY 1, 2;

-- (2) Using a single column (first day of month)
SELECT 
    DATETRUNC(MONTH, order_date) AS [month],
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY 1;

-- (3) Using a single column (year + abbreviated month)
SELECT 
    FORMAT(order_date,'yyyy-MMM') AS [month],
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY FORMAT(order_date,'yyyy-MMM')
ORDER BY 1;


--=================================================================================================--
-- CUMULATIVE ANALYSIS
--=================================================================================================--
/*
Requirement:
1. Calculate total monthly sales.
2. Produce a running cumulative total of sales across months.
*/

SELECT 
    month_num,
    monthly_total,
    SUM(monthly_total) OVER (ORDER BY month_num) AS running_monthly_total
FROM (
    SELECT 
        MONTH(order_date) AS [month_num],
        SUM(sales_amount) AS monthly_total
    FROM gold.fact_sales
    WHERE MONTH(order_date) IS NOT NULL
    GROUP BY MONTH(order_date)
) t
ORDER BY 1;


--=================================================================================================--
-- PERFORMANCE ANALYSIS
--=================================================================================================--
/*
Requirement:
1. Analyze yearly product performance:
   - Compare each product’s yearly sales to the product’s average sales.
   - Show deviation from the average and classify as Above/Below/Equal Average.
2. Include previous year’s sales for each product.
3. Show deviation from previous year and classify as Increase/Decrease/Equal.
*/

SELECT 
    product_name,
    [Year],
    product_key,
    product_sales,
    AVG(product_sales) OVER (PARTITION BY product_key) AS Avg_per_product,
    (product_sales - AVG(product_sales) OVER (PARTITION BY product_key)) AS Standard_Deviation,
    CASE 
        WHEN product_sales < AVG(product_sales) OVER (PARTITION BY product_key) THEN 'Below Average'
        WHEN product_sales > AVG(product_sales) OVER (PARTITION BY product_key) THEN 'Above Average'
        ELSE 'Equal'
    END AS Compare_with_avg,
    COALESCE(LAG(product_sales) OVER (PARTITION BY product_key ORDER BY [Year]), NULL) AS prev_yr_sales,
    (product_sales - LAG(product_sales) OVER (PARTITION BY product_key ORDER BY [Year])) AS Diff_from_prev_year,
    CASE 
        WHEN product_sales < LAG(product_sales) OVER (PARTITION BY product_key ORDER BY [Year]) THEN 'Less than prev year'
        WHEN product_sales > LAG(product_sales) OVER (PARTITION BY product_key ORDER BY [Year]) THEN 'More than prev year'
        WHEN product_sales = LAG(product_sales) OVER (PARTITION BY product_key ORDER BY [Year]) THEN 'Equal to prev year'
        ELSE 'no prev year data available'
    END AS compare_with_prev_year
FROM (
    SELECT 
        p.product_name AS product_name,
        YEAR(s.order_date) AS [Year],
        s.product_key AS product_key,
        SUM(sales_amount) AS product_sales
    FROM gold.fact_sales AS s
    INNER JOIN gold.dim_products AS p 
        ON p.product_key = s.product_key
    WHERE YEAR(order_date) IS NOT NULL
    GROUP BY YEAR(order_date), s.product_key, p.product_name
) AS t
ORDER BY product_name, [Year];


--=================================================================================================--
-- PART TO WHOLE ANALYSIS
--=================================================================================================--
/*
Requirement:
Identify which product category contributes the most to overall sales (in percentage terms).
*/

SELECT 
    category,
    category_sales,
    CONCAT(ROUND((category_sales * 100.0) / SUM(category_sales) OVER(), 2), '%') AS percent_contribution
FROM (
    SELECT 
        p.category AS category,
        SUM(s.sales_amount) AS category_sales
    FROM gold.fact_sales AS s
    LEFT JOIN gold.dim_products AS p 
        ON s.product_key = p.product_key
    GROUP BY p.category
) t
ORDER BY category_sales DESC;


--=================================================================================================--
-- DATA SEGMENTATION
--=================================================================================================--
/*
Requirement 1:
Segment products into cost ranges and count how many products fall into each range.
*/

SELECT 
    price_range,
    COUNT(product_key) AS total_items
FROM (
    SELECT 
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost <= 100 THEN 'cheap'
            WHEN cost > 100 AND cost <= 500 THEN 'average'
            WHEN cost > 500 AND cost <= 1000 THEN 'affordable'
            ELSE 'expensive'
        END AS Price_range
    FROM gold.dim_products
) t
GROUP BY price_range
ORDER BY COUNT(product_key) DESC;


--=================================================================================================--
-- CUSTOMER SEGMENTATION
--=================================================================================================--
/*
Requirement 2:
Group customers into three segments based on history and spending:
1. VIP: At least 12 months of history AND spending > 5000
2. Regular: At least 12 months of history AND spending <= 5000
3. New: Less than 12 months of history
*/

SELECT 
    customer_key,
    fullname,
    first_order,
    last_order,
    DATEDIFF(MONTH, first_order, last_order) AS months_as_member,
    spent_by_customer,
    CASE 
        WHEN DATEDIFF(MONTH, first_order, last_order) > 12 AND spent_by_customer > 5000 THEN 'VIP'
        WHEN DATEDIFF(MONTH, first_order, last_order) > 12 AND spent_by_customer <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS Status
FROM (
    SELECT 
        s.customer_key,
        c.first_name + ' ' + c.last_name AS fullname,
        MIN(s.order_date) AS first_order,
        MAX(s.order_date) AS last_order,
        SUM(s.sales_amount) AS spent_by_customer
    FROM gold.fact_sales AS s
    LEFT JOIN gold.dim_customers AS c 
        ON s.customer_key = c.customer_key
    GROUP BY 
        s.customer_key,
        c.first_name + ' ' + c.last_name
) t;

