1./*Show the category_name and description from the categories table sorted by 
category_name.*/

select categoryname, description FROM categories
order by categoryname;


2./*Show all the contact_name, city of all customers which are not from 
'Germany', 'Mexico', 'Spain'*/

select contactname, city from customers
where country NOT IN ('Germany', 'Mexico', 'Spain')


3./*Show order_date, shipped_date, customer_id, Freight of all orders placed 
on 1998-03-02*/


SELECT orderdate, shippeddate, customerid, freight
FROM orders
WHERE orderdate = '1998-03-02';



4. /*Show the employee_id, order_id, customer_id, required_date, shipped_date 
from all orders shipped later than the required date*/

select employeeid, orderid, customerid, requireddate,
shippeddate from orders
where shippeddate>requireddate;


5./*Show all the even numbered Order_id from the orders table*/

select orderid from orders
where orderid%2=0;


6./*Show the city, company_name, contact_name of all customers from cities which 
contains the letter 'L' in the city name, sorted by contact_name*/

select city, companyname, contactname from customers
where city like '%L%'
order by contactname;


7./*Show the company_name, contact_name, fax number of all customers that has a
fax number. (not null)*/

select companyname, contactname, fax from customers
where fax is not null;


8./*Show the first_name, last_name. hire_date of the most recently hired employee.*/

select firstname, lastname, hiredate from employees
order by hiredate desc
limit 1;


9./*Show the average unit price rounded to 2 decimal places, the total units in
stock, total discontinued products from the products table.*/

select ROUND(avg(unitprice)::numeric,2), sum(unitsinstock) as TotalUnitsinstock, 
sum(discontinued) as Discontinueproducts from products


10./*Show the ProductName, CompanyName, CategoryName from the products, 
suppliers, and categories table*/

select products.productname, suppliers.companyname, categories.categoryname 
from products
inner join categories on
categories.categoryid=products.categoryid
inner join suppliers on
products.supplierid=suppliers.supplierid


11./*Show the category_name and the average product unit price for each category
rounded to 2 decimal places.*/

select categories.categoryname, round(avg(unitprice)::numeric,2) from products
inner join categories on
categories.categoryid=products.categoryid
group by categoryname;


12./*Show the city, company_name, contact_name from the customers and suppliers
table merged together. Create a column which contains 'customers' or 'suppliers'
depending on the table it came from.*/

SELECT city, companyname, contactname, 'customers' AS source FROM customers
UNION
SELECT city, companyname, contactname, 'suppliers' AS source FROM suppliers;


13./*Show the employee's first_name and last_name, a "num_orders" column with a
count of the orders taken, and a column called "Shipped" that displays "On Time"
if the order shipped_date is less or equal to the required_date, "Late" if the
order shipped late. Order by employee last_name, then by first_name, and then 
descending by number of orders.*/

SELECT e.firstname, e.lastname, COUNT(o.orderid) AS numorders,(CASE
WHEN o.shippeddate <= o.requireddate THEN 'On Time'
ELSE 'Late'
END)AS Shipped
FROM employees e
JOIN orders o ON e.employeeid = o.employeeid
GROUP BY e.firstname, e.lastname, shipped
ORDER BY e.lastname ASC, e.firstname ASC, numorders DESC;



14./*Show how much money the company lost due to giving discounts each year,
order the years from most recent to least recent. Round to 2 decimal places*/


SELECT EXTRACT (YEAR from orders.orderdate) AS Year,
ROUND(SUM(orders_details.discount * products.unitprice * orders_details.quantity)
::NUMERIC, 2) AS LostRevenue
FROM orders_details
JOIN orders ON orders.orderid = orders_details.orderid
JOIN products ON orders_details.productid = products.productid
GROUP BY Year
ORDER BY Year;

