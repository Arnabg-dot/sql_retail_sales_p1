---- SQL Retal Sales Analysis - P1

CREATE TABLE retail_sales(
              transactions_id INT PRIMARY KEY,
              sale_date DATE,
              sale_time TIME,	
	          customer_id INT,
	          gender VARCHAR(15),
	          age INT,
	         category VARCHAR(15),
	         quantiy INT,	
	         price_per_unit FLOAT,
	         cogs FLOAT,
	         total_sale FLOAT
			 )
----- Data cleaning

SELECT COUNT(*) FROM retail_sales
LIMIT 10

SELECT * FROM retail_sales
WHERE  transactions_id IS NULL OR
       sale_date IS NULL  OR
       sale_time IS NULL  OR
	   customer_id IS NULL OR
	   gender IS NULL OR
	   age IS NULL OR
	   category IS NULL OR
	   quantiy IS NULL OR	
	   price_per_unit IS NULL OR
	   cogs IS NULL OR
	   total_sale  IS NULL



       DELETE FROM retail_sales
	   WHERE  transactions_id IS NULL OR
       sale_date IS NULL  OR
       sale_time IS NULL  OR
	   customer_id IS NULL OR
	   gender IS NULL OR
	   age IS NULL OR
	   category IS NULL OR
	   quantiy IS NULL OR	
	   price_per_unit IS NULL OR
	   cogs IS NULL OR
	   total_sale  IS NULL

---- Data Exploration

---- How many slaes we have?
SELECT COUNT(*)AS total_sales FROM retail_sales

---- How many customers we have ?

SELECT COUNT(DISTINCT customer_id)AS total_customers FROM retail_sales

SELECT DISTINCT category FROM retail_sales


---- Data Analysis & Business key problems & Answers

---- Q.1 Write a SQL query to retrieve all column for sales made on '2022-11-05'

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'

---- Q.2 Write  a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantiy>=4

---- Q.3 write  a SQL query to calculate the total sales (total_sale)for each category.

SELECT category, SUM(total_sale)AS total_sales FROM retail_sales
GROUP BY 1

----Q.4 write a SQL query to find the average age of customers who purchased items from the 'Beauty'category

SELECT ROUND(AVG(age),2)AS avg_age FROM retail_sales
WHERE category = 'Beauty'

----Q.5 write a SQL query to find all transactions where the total sale is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale >=1000

---- Q.6 write a SQL query to find the total number of transactions (transaction_id)made by each gender in each category.

SELECT gender, category, COUNT(*)AS count_transaction_id FROM retail_sales
GROUP BY 1,2
ORDER BY 2

----Q.7 Wtite a  SQL query  to calculate the average sale for each month. Find out best selling month  in each year

WITH MY_CTE AS
(SELECT TO_CHAR (sale_date,'Month')AS Month, 
TO_CHAR(sale_date, 'YYYY')AS Year,
AVG(total_sale) AS avg_sales FROM retail_sales
GROUP BY 1,2
ORDER BY 2, 3 DESC)

SELECT month, year, avg_sales FROM
(SELECT *,
        DENSE_RANK()OVER(PARTITION BY Year ORDER BY avg_sales DESC )AS rnk
FROM MY_CTE) X
WHERE rnk =1

---Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT   customer_id, SUM(total_sale) AS total_sales FROM retail_sales
GROUP BY 1
ORDER BY total_sales  DESC
LIMIT 5

--- Q.9 write a SQL query to find the number of unique customers who purchased items for each category.

SELECT category, COUNT(DISTINCT customer_id)AS unique_customers FROM retail_sales
GROUP BY 1

---- Q.10 Write a SQL query to create each shift and number of orders (example morning < 12, Afternoon between 12,17, evening >17 )

WITH MY_CTE AS
(SELECT *, 
CASE WHEN EXTRACT (HOUR FROM sale_time)<12 THEN 'Morning' 
WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'END AS "shift"
FROM retail_sales)

SELECT shift, COUNT(*)AS no_of_orders FROM MY_CTE 
GROUP BY 1

---- End of project



			 