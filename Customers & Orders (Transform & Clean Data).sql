/* 
In this project, I'm querying a database with multiple tables in it to quantify statistics about customer and order data. 
Lots of the data is dirty so I had to clean much of it with queries.
I then answered 13 questions about the data, showcasing a wide variety of SQL functions.
*/
--Q1. How many orders were placed in January? 
SELECT COUNT(orderid)
FROM BIT_DB.JanSales
WHERE length(orderid) = 6 
  AND orderid <> 'Order ID';

--Q2. How many of those orders were for an iPhone? 
SELECT COUNT(orderid)
FROM BIT_DB.JanSales
WHERE Product='iPhone'
  AND length(orderid) = 6 
  AND orderid <> 'Order ID';

--Q3. Select the customer account numbers for all the orders that were placed in February. 
SELECT DISTINCT acctnum
FROM BIT_DB.customers cust

INNER JOIN BIT_DB.FebSales Feb ON cust.order_id=FEB.orderid
WHERE length(orderid) = 6 
  AND orderid <> 'Order ID';

--Q4.(Subquery) Which product was the cheapest one sold in January, and what was the price? 
SELECT DISTINCT 
  product
  ,price
FROM BIT_DB.JanSales
WHERE price in (
  SELECT MIN(price) FROM BIT_DB.JanSales
);

--OR 

SELECT DISTINCT 
  product
  ,price 
FROM BIT_DB.JanSales 
ORDER BY price ASC LIMIT 1;

--Q5. What is the total revenue for each product sold in January?
SELECT 
  SUM(quantity)*price as revenue
  ,product
FROM BIT_DB.JanSales
GROUP BY product;

--Q6. Which products were sold in February at 548 Lincoln St, Seattle, WA 98101, 
#how many of each were sold, and what was the total revenue?
SELECT 
  product
  ,SUM(quantity)
  ,SUM(quantity)*price as revenue
FROM BIT_DB.FebSales 
WHERE location = '548 Lincoln St, Seattle, WA 98101'
GROUP BY product;

--Q7. How many customers ordered more than 2 products at a time, and what was the average amount spent for those customers? 
SELECT 
  COUNT(DISTINCT cust.acctnum)
  ,AVG(quantity*price)
FROM BIT_DB.FebSales feb
LEFT JOIN BIT_DB.customers cust ON cust.order_id=feb.orderid
WHERE feb.quantity > 2
  AND length(orderid) = 6 
  AND orderid <> 'Order ID';

--Q8. List all the products sold in Los Angeles in February and include how many of each were sold.
SELECT 
  DISTINCT product
  ,SUM(quantity) 
FROM BIT_DB.FEBSales
WHERE location LIKE '%Los Angeles%'
GROUP BY product;

--Q9. Which locations in New York received at least 3 orders in January, and how many orders did they each receive? (Use HAVING)
SELECT
  DISTINCT location
  ,COUNT(orderid)
FROM BIT_DB.JANSales
WHERE length(orderid) = 6
  AND orderid <> ('Order ID')
  AND location LIKE '%New York%'
GROUP BY location
  HAVING COUNT(orderid) >= 3;

--Q10. How many of each type of headphone were sold in February?
SELECT 
  SUM(quantity)
  ,product
FROM BIT_DB.FEBSales
WHERE product LIKE '%headphone%'
GROUP BY product;

--Q11. What was the average amount spent per account in February? 
#(We want the average amount spent per the number of accounts, not the overall average spent)
SELECT 
  SUM(quantity*price)/COUNT(acctnum) as average_spent
FROM BIT_DB.FEBSales s
JOIN BIT_DB.customers c ON c.order_id = s.orderid
WHERE length(orderid) = 6 
  AND orderid <> 'Order ID';
--A:$190

--Q12. What was the average quantity of products purchased per account in February? 
--(We want the overall average, not the average for each account individually)
SELECT 
  AVG(quantity)
FROM BIT_DB.FEBSales s
LEFT JOIN BIT_DB.customers c ON c.order_id = s.orderid
WHERE length(orderid) = 6 
  AND orderid <> 'Order ID';
--A: 1

--Q13. Which product brought in the most revenue in January and how much revenue did it bring in total?
SELECT 
  product
  ,SUM(quantity*price) as revenue
FROM BIT_DB.JANSales
GROUP BY product
ORDER BY revenue desc LIMIT 1;
--A: Macbook Pro Laptop, $399,500
