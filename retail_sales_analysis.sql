USE superstore_db; 

ALTER TABLE superstore_sales
MODIFY sales DECIMAL(12,2),
MODIFY discount DECIMAL(8,4),
MODIFY profit DECIMAL(12,2); 

USE superstore_db;

TRUNCATE TABLE superstore_sales;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/superstore_cleaned.csv'
INTO TABLE superstore_sales
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
row_id, order_id, @od, @sd, ship_mode,
customer_id, customer_name, segment, country, city, state,
postel_code, region, product_id, category, sub_category,
product_name, @sales, quantity, @discount, @profit
)
SET
order_date = STR_TO_DATE(@od, '%c/%e/%Y'),
ship_date = STR_TO_DATE(@sd, '%c/%e/%Y'),
sales = CAST(REGEXP_REPLACE(TRIM(@sales), '[^0-9.-]', '') AS DECIMAL(12,2)),
discount = CAST(REGEXP_REPLACE(TRIM(@discount), '[^0-9.-]', '') AS DECIMAL(8,4)) / 100,
profit = CAST(REGEXP_REPLACE(TRIM(@profit), '[^0-9.-]', '') AS DECIMAL(12,2));


SHOW COLUMNS FROM superstore_sales;

SHOW CREATE TABLE superstore_sales; 

SELECT COUNT(*) AS total_records
FROM superstore_sales; 

SELECT * FROM superstore_sales
LIMIT 5; 

SELECT SUM(sales) AS total_sales
FROM superstore_sales; 

SELECT SUM(profit) AS total_profit
FROM superstore_sales; 

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM superstore_sales; 

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM superstore_sales; 

SELECT region, SUM(sales) AS total_sales
FROM superstore_sales
GROUP BY region
ORDER BY total_sales DESC; 

SELECT category, SUM(sales) AS total_sales
FROM superstore_sales
GROUP BY category
ORDER BY total_sales DESC;  

SELECT YEAR(order_date) AS sales_year,
       SUM(sales) AS total_sales
FROM superstore_sales
GROUP BY YEAR(order_date)
ORDER BY sales_year; 

SELECT product_name, SUM(sales) AS total_sales
FROM superstore_sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 5; 

