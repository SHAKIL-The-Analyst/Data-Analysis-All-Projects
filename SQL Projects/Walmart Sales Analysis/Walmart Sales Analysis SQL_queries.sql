
-- Data cleaning
SELECT
	*
FROM sales;


-- Add the time_of_day column
SELECT
    time,
    CASE
        WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sales;


-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE sales
SET time_of_day = (
    CASE
        WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END

);


-- Add day_name column
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales
SET day_name = TO_CHAR(date, 'Day');
SELECT date, day_name FROM sales;



-- Add month_name column
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales
SET month_name = TO_CHAR(date, 'Month');
SELECT
	date,
	month_name
FROM sales;


-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM sales;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

--1. How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM sales;


--2. What is the most selling product line?
SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;


--3. What is the total revenue by month?
SELECT
	month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month 
ORDER BY total_revenue DESC;


--4. What month had the largest COGS?
SELECT
 month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month
ORDER BY cogs DESC;


--5. What product line had the largest revenue?
SELECT product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

--6. What is the city with the largest revenue?
SELECT branch, city,
SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue DESC;

--7. What product line had the largest VAT?
SELECT product_line,
SUM(tax_pct) as total_tax
FROM sales
GROUP BY product_line
ORDER BY total_tax DESC;


8. /* Fetch each product line and add a column to those product 
line showing "Good", "Bad". Good if its greater than average sales?*/

WITH overall_avg AS (
    SELECT AVG(quantity) AS avg_qnty
    FROM sales
)
SELECT product_line,
    CASE
        WHEN AVG(quantity) > (SELECT avg_qnty FROM overall_avg) THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM sales
GROUP BY product_line;


--9. Which branch sold more products than average product sold?
SELECT branch, 
SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


--10. What is the most common product line by gender?
SELECT gender, product_line,
COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

--11. What is the average rating of each product line?
SELECT ROUND(AVG(rating), 2) as avg_rating,
product_line FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;


--How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM sales;


12./* What is the most common customer type?/
/Which customer type buys the most?*/
SELECT customer_type,
count(*) as count
FROM sales
GROUP BY customer_type;



--13. What is the gender of most of the customers?
SELECT gender,
COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;


--14. What is the gender distribution per branch?
SELECT branch,
COUNT(gender) as gender_cnt
FROM sales
GROUP BY branch
ORDER BY gender_cnt DESC;

15./* Gender per branch is more or less the same hence,
I don't think has an effect of the sales per branch and other factors.
Which time of the day do customers give most ratings?*/
SELECT time_of_day,
AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

16./* Looks like time of the day does not really affect the rating,
its more or less the same rating each time of the day.alter Which time
of the day do customers give most ratings per branch?*/

SELECT time_of_day, branch,
AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day, branch
ORDER BY avg_rating DESC;

17./* Branch A and C are doing well in ratings, branch B needs to do a 
little more to get better ratings.
Which day of the week has the best avg ratings?*/
SELECT day_name,
AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;

18./* Monday, Friday and Sunday are the top best days for good ratings
why is that the case, how many sales are made on these days?
Which day of the week has the best average ratings per branch?*/

SELECT 
day_name, branch,
COUNT(day_name), SUM(total) as total_sales
FROM sales
GROUP BY day_name, branch
ORDER BY total_sales DESC;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

19.-- Number of sales made in each time of the day per weekday?
SELECT time_of_day,
COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day 
ORDER BY total_sales DESC;

20./* Evenings experience most sales, the stores are 
filled during the evening hours.
Which of the customer types brings the most revenue?*/
SELECT customer_type,
SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

21.-- Which city has the largest tax/VAT percent?
SELECT city,
ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

22.-- Which customer type pays the most in VAT?
SELECT customer_type,
AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax DESC;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
