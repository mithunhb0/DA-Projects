-- Create DATABASE 
CREATE DATABASE retail_db;

-- Create TABLE 
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- DATA CLEANING: Checking for NULL values across all columns
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- DATA CLEANING: Removing records with NULL values to ensure data integrity 
DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Basic data exploration

-- Count of total transactions in the dataset
SELECT COUNT(*) as total_transactions FROM retail_sales;

-- Calculating the total number of unique customers
SELECT COUNT(DISTINCT customer_id) as total_customer FROM retail_sales;

-- Identifying the total number of unique categories
SELECT COUNT(DISTINCT category) FROM retail_sales;

-- Retrieving the list of distinct categories
SELECT DISTINCT category FROM retail_sales;


-- Data Analysis and Business Key Problems and Answers

-- 1. Write a SQL query to retrieve all columns for sales made on "2022-11-05".
SELECT * 
FROM retail_sales
WHERE sale_date = "2022-11-05";

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is 4 or more in the month of Nov-2022.
SELECT * 
FROM retail_sales
WHERE category = "Clothing" 
	AND quantity >= 4 
            AND DATE_FORMAT(sale_date, '%Y-%m')  = "2022-11";

-- 3. Write a SQL query to calculate the total sales (total_sale) and total orders for each category.
SELECT category, 
	   SUM(total_sale) AS total_sales, 
               COUNT(*) AS total_orders 
FROM retail_sales
GROUP BY 1;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age), 2) AS average_age
FROM retail_sales
WHERE category = "Beauty";

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,
	   gender,
       COUNT(transactions_id) AS total_trasaction
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT Year,
	   Month,
       average_sales
FROM (
		SELECT EXTRACT(YEAR from sale_date) AS Year,
			   EXTRACT(MONTH from sale_date) AS Month,
			   ROUND(AVG(total_sale), 2) AS average_sales,
			   RANK() OVER( PARTITION BY EXTRACT(YEAR from sale_date) ORDER BY ROUND(AVG(total_sale), 2) DESC) AS rnk
        FROM retail_sales       
		GROUP BY 1, 2
) AS t
WHERE rnk = 1;

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT customer_id,
	   SUM(total_sale) AS total_sales
FROM retail_sales       
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sales 
GROUP BY 1;   

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale AS (
        SELECT *,
			   CASE 
					WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN "Morning"
					WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN "Afternoon"
					WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN "Morning"
					ELSE "Evening"
			   END AS shift
		FROM retail_sales 
)
SELECT  shift,
		COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;


