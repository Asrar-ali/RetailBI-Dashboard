-- Step 1: Create a new database named 'superstore_data'
CREATE DATABASE superstore_data;

-- Step 2: Switch to the 'superstore_data' database
USE superstore_data;

-- Step 3: Create a 'sales_data' table with columns to store sales and product information
CREATE TABLE sales_data (
    id INT NOT NULL AUTO_INCREMENT,              -- Unique identifier for each record
    ship_mode VARCHAR(50),                      -- Shipping mode for the order
    segment VARCHAR(50),                        -- Customer segment (e.g., Consumer, Corporate)
    country VARCHAR(50),                        -- Country of the order
    city VARCHAR(100),                          -- City where the order was placed
    state VARCHAR(100),                         -- State where the order was placed
    postal_code INT,                            -- Postal code of the delivery address
    region VARCHAR(50),                         -- Geographic region of the order
    category VARCHAR(50),                       -- Category of the product
    sub_category VARCHAR(50),                   -- Sub-category of the product
    sales DECIMAL(10, 2),                       -- Sales amount for the order
    quantity INT,                               -- Quantity of products ordered
    discount DECIMAL(5, 2),                     -- Discount applied to the order
    profit DECIMAL(10, 2),                      -- Profit from the order
    PRIMARY KEY (id)                            -- Primary key to uniquely identify each record
);

-- Step 4: Add a new column to calculate the profit margin percentage
ALTER TABLE sales_data
ADD COLUMN profit_margin_percentage DECIMAL(10, 4);  -- Stores profit margin as a percentage

-- Step 5: Calculate the profit margin percentage and update the column
UPDATE sales_data
SET profit_margin_percentage = (CAST(profit AS DECIMAL(10, 2)) / CAST(sales AS DECIMAL(10, 2))) * 100;
-- The profit margin is calculated as (Profit / Sales) * 100 and stored in the 'profit_margin_percentage' column

-- Step 6: Add a new column to categorize the impact of discounts on profit
ALTER TABLE sales_data
ADD COLUMN discount_impact_category VARCHAR(50);  -- Categorizes the impact of discounts (e.g., Positive/Negative Impact)

-- Step 7: Populate the 'discount_impact_category' column based on discount and profit
UPDATE sales_data
SET discount_impact_category = 
    CASE
        WHEN discount = 0 THEN 'No Discount'                -- No discount applied
        WHEN discount > 0 AND profit > 0 THEN 'Positive Impact'  -- Discount resulted in positive profit
        WHEN discount > 0 AND profit <= 0 THEN 'Negative Impact' -- Discount resulted in zero or negative profit
        ELSE 'Unknown'                                      -- Edge cases (e.g., missing data)
    END;

-- Step 8: Create a temporary table to store total sales for each city
CREATE TEMPORARY TABLE city_sales AS
SELECT 
    city, 
    SUM(sales) AS total_sales  -- Aggregates total sales for each city
FROM sales_data
GROUP BY city;

-- Step 9: Update the 'sales_data' table to include total sales for each city
UPDATE sales_data sd
JOIN city_sales cs ON sd.city = cs.city
SET sd.total_sales_city = cs.total_sales;
-- The 'total_sales_city' column in 'sales_data' is updated with the aggregated sales value from 'city_sales'

-- Step 10: Retrieve all records from the 'sales_data' table
SELECT * FROM sales_data;
-- Displays the updated 'sales_data' table with all the added columns and calculated values
