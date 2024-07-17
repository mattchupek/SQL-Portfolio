/*
In this project, I used a database called 'chinook' which contained all the records from a digital media store. The database contained 11 tables. 
To showcase my proficiency in SQL, I answered 16 questions based on the data.
 */

--Q1.(4 table JOIN) What are the top 100 longest tracks? Don't include Rock and only include standard songs (not music from TV Shows, Films etc.).
--Name the title, artist, album, genre, MediaIdType, length in Seconds, and Price.
SELECT 
 ar.Name as Artist
 ,t.Name as Title
 ,al.Title as Album
 ,g.Name as Genre
 ,t.MediaTypeId
 ,t.milliseconds/100 as Seconds
 ,t.UnitPrice as Price
FROM chinook.tracks t
 LEFT JOIN chinook.genres g ON g.GenreId = t.GenreId
 JOIN chinook.albums al ON al.AlbumId = t.AlbumId
 JOIN chinook.artists ar ON ar.ArtistId = al.ArtistId
WHERE MediaTypeId <> 3
 AND Genre <> 'Rock'
ORDER BY t.milliseconds/100 desc LIMIT 100;

--Q2.(Window Function) Show each sales agent with a ranking column that ranks them by number of sales.
SELECT 
 e.FirstName, 
 e.LastName, 
 RANK() OVER (PARTITION BY title ORDER BY ROUND(SUM(i.Total),2) DESC) AS dept_rank
FROM chinook.Employees e 
JOIN chinook.Customers c ON c.SupportRepId = e.EmployeeId
JOIN chinook.Invoices i ON i.CustomerId = c.CustomerId
WHERE e.Title = 'Sales Support Agent' 
AND i.InvoiceDate LIKE '%2009%' 
GROUP BY e.FirstName
ORDER BY (round(sum(i.Total), 2))  DESC;

--Q3. Show the total sales made by each sales agent.
SELECT 
 e.FirstName
 ,e.LastName
 ,ROUND(SUM(i.Total),2) AS 'Total Sales'
FROM chinook.employees e
 JOIN chinook.customers c ON c.SupportRepId = e.EmployeeId
 JOIN chinook.invoices i ON i.CustomerId = c.CustomerId
WHERE e.Title = 'Sales Support Agent'
GROUP BY e.EmployeeId;

--Q4. Which sales agent made the most dollars in sales in 2009?
SELECT 
 e.FirstName
 ,e.LastName
 ,ROUND(SUM(i.Total), 2) as 'Total Sales' 
FROM chinook.Employees e 
 JOIN chinook.Customers c ON c.SupportRepId = e.EmployeeId
 JOIN chinook.Invoices i ON i.CustomerId = c.CustomerId
WHERE e.Title = 'Sales Support Agent' 
 AND i.InvoiceDate LIKE '%2009%' 
GROUP BY e.FirstName
ORDER BY (ROUND(SUM(i.Total), 2))  desc LIMIT 1;

--Q5. Show the Employees who are Sales Agents.
SELECT * 
FROM employees
WHERE title LIKE '%Sales%Agent%';

--Q6. Find a unique/distinct list of billing countries from the Invoice table.
SELECT DISTINCT BillingCountry
FROM chinook.invoices;

--Q7. Provide a query that shows the invoices associated with each sales agent. The resulting table should include the Sales Agent's full name.
SELECT
 e.LastName
 ,e.FirstName
 ,i.InvoiceId
FROM chinook.employees e
 JOIN chinook.customers c ON c.SupportRepId = e.EmployeeId
 JOIN chinook.invoices i ON c.CustomerId = i.CustomerId;

--Q8. Show the Invoice Total, Customer name, Country, and Sales Agent name for all invoices and customers.
SELECT 
 e.LastName as rep_last
 ,e.FirstName as rep_first
 ,c.LastName as cust_last
 ,c.FirstName as cust_first
 ,c.Country 
 ,i.total
FROM chinook.Employees e
 JOIN chinook.Customers c ON c.SupportRepId = e.EmployeeId
 JOIN chinook.Invoices i ON i.CustomerId = c.CustomerId;

--Q9. How many Invoices were there in 2009?
SELECT COUNT(*)
FROM chinook.Invoices
WHERE InvoiceDate BETWEEN '2009-01-01' AND '2009-12-31';

--/or/

SELECT COUNT(*) 
FROM chinook.Invoices 
WHERE Invoicedate LIKE '%2009%';

--Q10. What are the total sales for 2009?
SELECT ROUND(SUM(total),2)
FROM chinook.Invoices
WHERE InvoiceDate BETWEEN '2009-01-01' AND '2009-12-31';

--Q11. Write a query that includes the purchased track name with each invoice line ID.
SELECT 
 t.name
 ,i.InvoiceLineId
FROM chinook.tracks t
 JOIN chinook.invoice_items i ON i.TrackId = t.TrackId;

--Q12. Write a query that includes the purchased track name AND artist name with each invoice line ID.
SELECT 
 ar.name AS Artist
 ,t.name as Track
 ,i.InvoiceLineId
FROM chinook.invoice_items i
 LEFT JOIN chinook.tracks t ON t.TrackId = i.TrackId
 INNER JOIN chinook.albums a ON a.AlbumId = t.AlbumId
 LEFT JOIN chinook.artists ar ON ar.ArtistId = a.ArtistId;

--Q13. Provide a query that shows all the Tracks, and include the Album name, Media type, and Genre.
SELECT 
 t.Name AS 'Track Name'
 ,a.Title AS 'Album Title'
 ,m.Name AS 'Media Type' 
 ,g.Name AS 'Genre'
FROM chinook.tracks t
 LEFT JOIN chinook.Albums a ON a.AlbumId = t.AlbumId
 JOIN chinook.Media_Types m ON m.MediaTypeId = t.MediaTypeId
 JOIN chinook.Genres g ON g.GenreId = t.GenreId;

--Q14. Find the Invoices of customers who are from Brazil. 
--The resulting table should show the customer's full name, Invoice ID, Date of the invoice, and billing country.
SELECT 
 FirstName
 ,LastName
 ,InvoiceId
 ,InvoiceDate
 ,BillingCountry
FROM chinook.customers c
 LEFT JOIN chinook.invoices i ON i.CustomerId = c.CustomerId
WHERE BillingCountry = 'Brazil';

--Q15. Show only the Customers from Brazil.
SELECT *
FROM chinook.customers
WHERE country = 'Brazil';

--Q16. Show Customers (their full names, customer ID, and country) who are not in the US.
SELECT 
 FirstName
 ,LastName
 ,customerid
 ,country
FROM chinook.customers
WHERE country <> 'USA';
