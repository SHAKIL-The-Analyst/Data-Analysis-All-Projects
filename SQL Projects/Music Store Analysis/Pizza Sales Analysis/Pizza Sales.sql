1. --Retrieve the total number of orders placed.

SELECT COUNT(order_id) AS Total_Orders 
FROM orders;



2. --Calculate the total revenue generated from pizza sales.

SELECT ROUND(SUM(o.quantity*p.price)::numeric,2) AS total_revenue 
FROM order_details o
JOIN pizzas p ON
o.pizza_id=p.pizza_id;



3. --Identify the highest-priced pizza.

SELECT p.price, pi.name 
FROM pizzas p
JOIN pizza_type pi ON
p.pizza_type_id=pi.pizza_type_id
order by price desc
limit 1;



4. --Identify the most common pizza size ordered.

SELECT p.size, sum(o.quantity) AS Total_Order 
FROM pizzas p
JOIN order_details o ON
p.pizza_id=o.pizza_id
GROUP BY p.size
ORDER BY Total_Order DESC;


5. --List the top 5 most ordered pizza types along with their quantities.

SELECT pt.name, SUM(o.quantity) AS total_quantity 
FROM pizza_type pt
JOIN pizzas p ON 
pt.pizza_type_id = p.pizza_type_id
join order_details o on
p.pizza_id=o.pizza_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;



6. --Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT SUM(o.quantity) AS Total_Quantity, pt.category
FROM pizza_type pt
JOIN pizzas p on
pt.pizza_type_id=p.pizza_type_id
JOIN order_details o on
p.pizza_id=o.pizza_id
GROUP BY category
ORDER BY Total_Quantity DESC;


7. --Determine the distribution of orders by hour of the day.

SELECT EXTRACT(HOUR FROM o.time) AS Hour, COUNT(o.order_id) AS Total_Orders
FROM orders o
GROUP BY Hour
ORDER BY Total_Orders DESC;


8. --Join relevant tables to find the category-wise distribution of pizzas

SELECT pt.category, COUNT(o.order_id) AS Total_Orders
FROM orders o
JOIN order_details od ON
o.order_id=od.order_id
JOIN pizzas p ON
od.pizza_id=p.pizza_id
JOIN pizza_type pt ON
p.pizza_type_id=pt.pizza_type_id
GROUP BY category
ORDER BY Total_Orders DESC;



9. --Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT ROUND(AVG(Total_order),2) AS Average_pizza_order_per_day FROM
(SELECT o.date, SUM(od.quantity) AS Total_order
FROM order_details od
JOIN orders o ON
od.order_id=o.order_id
GROUP BY date
ORDER BY Total_order DESC) AS Order_quantity;


10. --Determine the top 3 most ordered pizza types based on revenue.

SELECT pt.name, ROUND(SUM(o.quantity*p.price)::numeric,2) AS total_revenue
FROM order_details o
JOIN pizzas p ON
o.pizza_id=p.pizza_id
JOIN pizza_type pt on
p.pizza_type_id=pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;


11. --Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.category,
    SUM(o.quantity * p.price) AS total_revenue,
    (SUM(o.quantity * p.price) / (SELECT SUM(o.quantity * p.price) FROM order_details o JOIN pizzas p ON o.pizza_id = p.pizza_id)) * 100 AS percentage_contribution
FROM 
    order_details o
JOIN 
    pizzas p ON o.pizza_id = p.pizza_id
JOIN 
    pizza_type pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.category
ORDER BY 
    total_revenue DESC;