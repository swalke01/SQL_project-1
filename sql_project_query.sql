-- Table created using sql_project1

SELECT * FROM sales;

-- Data cleaning -- check for null values in all columns


SELECT * FROM sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
or price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

-- total 13 rows are returned that consists of NULL values, we will delete these so data analysis can be started
-- same query to find NULL values will be used and we will add delete function onto it.

DELETE FROM sales 
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
or price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

--  disabled safe mode in MySQL using SET SQL_SAFE_UPDATES = 0

-- Check the total records after deleting rows with NULL values

SELECT COUNT(*) FROM sales;

-- 1987 records available

-- Data Exploration

-- what is the total sales for this data & how many unique customers do we have & how many categories are present?

SELECT
	SUM(total_sale) AS total_sales,
    COUNT(DISTINCT customer_id) AS num_of_customers,
    COUNT(DISTINCT category) as num_of_categories
FROM sales;

-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022

SELECT * FROM sales
WHERE category = 'Clothing'  AND quantiy > 2
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	category,
    SUM(total_sale) AS total_sales
FROM sales
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
	AVG(age)
FROM sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT
	category,
    gender,
    COUNT(DISTINCT transactions_id)
FROM sales
GROUP BY 1,2;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT
	year,
    month,
    avg_sales
FROM
(
SELECT
	YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    ROUND(AVG(total_sale),2) AS avg_sales,
    RANK() OVER (PARTITION BY YEAR (sale_date) ORDER BY AVG(total_sale) DESC) AS rank1
FROM sales
GROUP BY 1,2) as table1
WHERE rank1 = 1
;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT
	customer_id,
    SUM(total_sale) AS total_sales
FROM sales
GROUP BY 1
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT
	category,
    COUNT(customer_id) as num_of_customers
FROM sales
GROUP BY 1;


    
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN HOUR(sale_time) <= 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END AS shift
FROM sales
)   
SELECT
	shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;


