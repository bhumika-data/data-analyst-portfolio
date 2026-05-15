/*
Project: Retail Business Performance & Profit Optimization Analysis
Tools Used: SQL (MySQL)
Objective:
Analyze sales, profitability, customer behavior, discount impact,
and business performance using structured SQL queries.
*/

USE retail_business_analysis;
--
=================================================================
-- PART 1: DATA OVERVIEW
-- Objective: Understand dataset structure and quality
--
=================================================================

-- Q1: Preview first 10 rows
SELECT*
	FROM superstore_sales
		LIMIT 10;
    
-- Q2: Total number of orders
SELECT 
    COUNT(*) AS total_orders
FROM
    superstore_sales;
    
-- Q3: Check missing values in key columns
SELECT 
    SUM(CASE
        WHEN sales IS NULL THEN 1
        ELSE 0
    END) AS missing_sales,
    SUM(CASE
        WHEN profit IS NULL THEN 1
        ELSE 0
    END) AS missing_profit,
    SUM(CASE
        WHEN DISCOUNT IS NULL THEN 1
        ELSE 0
    END) AS missing_discount
FROM
    superstore_sales;
    
-- Q4: Unique categories
SELECT DISTINCT
    category
FROM
    superstore_sales;
    
-- Q5: Unique regions
SELECT DISTINCT
    region
FROM
    superstore_sales;
    
-- Q6: Order year range
SELECT 
    MIN(order_year) AS start_year, MAX(order_year) AS end_year
FROM
    superstore_sales;
    
-- Q7: Basic business metrics
SELECT 
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount), 2) AS avg_discount
FROM
    superstore_sales;
    
--
 =================================================================
 -- PART 2: SALES AND PROFIT ANALYSIS
 -- Objective: Evaluate revenue and profitablility drivers
 --
 =================================================================
 
 -- Q1: Category-wise performance
 SELECT category,
	 ROUND(SUM(sales), 2) 
		AS total_sales,
    ROUND(SUM(profit), 2) 
		AS total_profit,
    ROUND(SUM(PROFIT)*100.0/SUM(sales), 2) 
		AS profit_margin_pct
    FROM superstore_sales
    GROUP BY category
    ORDER BY total_sales DESC;
    
-- Q2: Sub-category performance(granular analysis)
SELECT 
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM
    superstore_sales
GROUP BY sub_category
ORDER BY total_sales DESC;
    
-- Q3: Top 10 products by sales
SELECT 
    product_id, ROUND(SUM(sales), 2) AS total_sales
FROM
    superstore_sales
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 10;
    
-- Q4: OVerall sales Vs profit summary
SELECT 
	ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(PROFIT)*100.0/SUM(sales), 2) AS profit_margin_pct
    FROM superstore_sales;
    
-- Q5: Average sales and profit per order 
SELECT
	ROUND(SUM(sales)/COUNT(DISTINCT order_id), 2) AS avg_sales_per_order,
    ROUND(SUM(profit)/COUNT(DISTINCT order_id), 2) AS avg_profit_per_order
    FROM superstore_sales;
    
-- Q6: Sub-categories with high sales but low profit
SELECT 
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM
    superstore_sales
GROUP BY sub_category
HAVING total_sales > 50000
    AND total_profit < 5000
ORDER BY total_sales DESC;
    
-- Q7: Category contribution to total sales(%)
SELECT 
    category,
    ROUND(SUM(sales) * 100.0 / (SELECT 
                    SUM(sales)
                FROM
                    superstore_sales),
            2) AS sales_contribution_pct
FROM
    superstore_sales
GROUP BY category
ORDER BY sales_contribution_pct DESC;
    
    --
    ==========================================================================
    -- PART 3: CUSTOMER AND REGIONAL ANALYSIS
    -- Objective: Analyze customer segments and regional performance
    --
    ==========================================================================
    
    -- Q1: Segment-wise performance
    SELECT 
		segment,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2)AS total_profit,
        ROUND(SUM(profit)*100.0/SUM(sales), 2) AS profit_margin_pct
        FROM superstore_sales
        GROUP BY segment
        ORDER BY total_sales DESC;
        
	-- Q2: REGION-wise performance with margin
SELECT 
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) * 100.0 / SUM(sales), 2) AS profit_margin_pct
FROM
    superstore_sales
GROUP BY region
ORDER BY profit_margin_pct DESC;
        
	-- Q3: Region and segment combined performance
SELECT 
    region,
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM
    superstore_sales
GROUP BY region , segment
ORDER BY region , total_sales DESC;
        
	-- Q4: Top 5 cities by profit
SELECT 
    city, ROUND(SUM(profit), 2) AS total_profit
FROM
    superstore_sales
GROUP BY city
ORDER BY total_profit DESC
LIMIT 5;
        
	-- Q5: Bottom 5 cities by profit(loss area)
SELECT 
    city, ROUND(SUM(profit), 2) AS total_profit
FROM
    superstore_sales
GROUP BY city
ORDER BY total_profit ASC
LIMIT 5;
    
-- Q6: Top 10 customers by sales
SELECT 
    order_id, ROUND(SUM(sales), 2) AS total_sales
FROM
    superstore_sales
GROUP BY order_id
ORDER BY total_sales DESC
LIMIT 10;

-- Q7: Sales ship_mode
SELECT 
    ship_mode, COUNT(DISTINCT order_id) AS ship_count
FROM
    superstore_sales
GROUP BY ship_mode
HAVING ship_count > 1
ORDER BY ship_count DESC;
    
    --
    ================================================================================
    -- PART 4: DISCOUNT AND LOSS ANALYSIS
    -- Objective: Evaluate Impact of discounting on profitability
    --
    ===================================================================================
    
    -- Q1: Discount category impact on sales and profit
SELECT
  CASE
    WHEN discount = 0 THEN 'No Discount'
    WHEN discount <= 0.2 THEN 'Low'
    WHEN discount <= 0.4 THEN 'Medium'
    ELSE 'High'
  END AS discount_category,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SUM(profit) * 100.0 / SUM(sales), 2) AS profit_margin_pct
FROM superstore_sales
GROUP BY
  CASE
    WHEN discount = 0 THEN 'No Discount'
    WHEN discount <= 0.2 THEN 'Low'
    WHEN discount <= 0.4 THEN 'Medium'
    ELSE 'High'
  END
ORDER BY total_sales DESC;

-- Q2: Orders distribution by profit vs loss
SELECT 
    CASE
        WHEN profit < 0 THEN 'Loss'
        ELSE 'Profit'
    END AS order_type,
    COUNT(*) AS total_orders
FROM
    superstore_sales
GROUP BY order_type;

-- Q3: Categories contributing to losses
SELECT 
    category, ROUND(SUM(profit), 2) AS total_profit
FROM
    superstore_sales
GROUP BY category
HAVING total_profit < 0
ORDER BY total_profit ASC;

-- Q4: Sub-categories with high discount and negative profit
SELECT 
    sub_category,
    ROUND(AVG(discount), 2) AS avg_discount,
    ROUND(SUM(profit), 2) AS total_profit
FROM
    superstore_sales
GROUP BY sub_category
HAVING avg_discount > 0.3 AND total_profit < 0
ORDER BY avg_discount DESC;

-- Q5: Average profit at different discount levels
SELECT 
    ROUND(discount, 2) AS discount_level,
    ROUND(AVG(profit), 2) AS avg_profit
FROM
    superstore_sales
GROUP BY discount_level
ORDER BY discount_level;

-- Q6: Top 10 loss-making products
SELECT 
    product_id, ROUND(SUM(profit), 2) AS total_loss
FROM
    superstore_sales
GROUP BY product_id
HAVING total_loss < 0
ORDER BY total_loss ASC
LIMIT 10;

-- Q7: Percentage of loss-making orders
SELECT 
    ROUND(SUM(CASE
                WHEN profit < 0 THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS loss_order_percentage
FROM
    superstore_sales;
    
      --
    ================================================================================
    -- PART 5: ADVANCED INSIGHTS AND BUSINESS INTELLIGENCE
    -- Objective: Derive actionable insights and advanced KPIs
    --
    ===================================================================================
    
   -- Q1: Month-over-month sales growth
WITH monthly_sales AS (
  SELECT
    order_month AS month,
    SUM(sales) AS total_sales
  FROM superstore_sales
  GROUP BY month)
SELECT
  month,
  total_sales,
  ROUND(
    (total_sales - LAG(total_sales) OVER (ORDER BY month)) * 100.0
    / LAG(total_sales) OVER (ORDER BY month),
    2) AS growth_pct
FROM monthly_sales; 
    
-- Q2: Cumulative sales over time
SELECT
  order_month AS month,
  SUM(sales) AS monthly_sales,
  SUM(SUM(sales)) OVER (ORDER BY order_month) AS cumulative_sales
FROM superstore_sales
GROUP BY month
ORDER BY month;
    
-- Q3: Top 3 vs Bottom 3 sub-categories by profit
WITH ranked_data AS (
  SELECT
    sub_category,
    SUM(profit) AS total_profit,
    RANK() OVER (ORDER BY SUM(profit) DESC) AS top_rank,
    RANK() OVER (ORDER BY SUM(profit) ASC) AS bottom_rank
  FROM superstore_sales
  GROUP BY sub_category
)
 SELECT *
FROM ranked_data
WHERE top_rank <= 3 OR bottom_rank <= 3;

-- Q4: Segment classification based on profit
SELECT 
    segment,
    CASE
        WHEN SUM(profit) > 50000 THEN 'High Profit'
        WHEN SUM(profit) > 10000 THEN 'Moderate Profit'
        ELSE 'Low Profit'
    END AS profit_segment
FROM
    superstore_sales
GROUP BY segment;
    
-- Q5: Identify high-value orders
SELECT 
    order_id, ROUND(SUM(sales), 2) AS order_value
FROM
    superstore_sales
GROUP BY order_id
HAVING order_value > 1000
ORDER BY order_value DESC;
    
-- Q6: Sales per quantity (efficiency metric)
SELECT 
    ROUND(SUM(sales) / SUM(quantity), 2) AS sales_per_unit
FROM
    superstore_sales;

-- Q7: Revenue from loss-making orders
SELECT 
    ROUND(SUM(sales), 2) AS loss_sales
FROM
    superstore_sales
WHERE
    profit < 0;