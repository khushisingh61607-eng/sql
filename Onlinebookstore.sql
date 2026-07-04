--CREATE TABLES
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
	Book_ID	SERIAL PRIMARY KEY,
	Title VARCHAR(100),	
	Author VARCHAR(100),	
	Genre VARCHAR(100),	
	Published_Year INT,
	Price NUMERIC(10,2),	
	Stock INT	
);
--Import data into book table
SELECT * FROM Books;

DROP TABLE IF EXISTS customers;
CREATE TABLE customers(
	Customer_ID	SERIAL	PRIMARY KEY,
	Name VARCHAR(100),	
	Email VARCHAR(100),	
	Phone VARCHAR(100),	
	City VARCHAR(100),	
	Country VARCHAR(100)	
);

--Import data into customer table
SELECT * FROM customers;

--CREATE TABLE ORDER
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	Order_ID SERIAL	PRIMARY KEY,
	Customer_ID	INT REFERENCES Customers(customer_id),
	Book_ID	INT	REFERENCES Books(book_id),
	Order_Date DATE,
	Quantity INT,	
	Total_Amount NUMERIC(10,2)	
);

--Import data into orders table
SELECT * FROM Orders;

--for sub query
--mannual
select avg(price) from books;
 select * from books where price > 27.39;
--with the help of subquerry
 select * from books 
 where price > (select avg(price) from books);
 

      --BASIC QUERIES
	  
--1) Retrieve all books in the "Fiction" genre;
 SELECT * FROM books
 WHERE genre = 'Fiction';

--2) Find books published after the year 1950;
 SELECT * FROM books
 WHERE published_year > 1950;

--3) List all customers from canada
 SELECT * FROM Customers
 WHERE country = 'Canada';

--4)Show order placed in November 2023; -use between because november month me 30 din hote hai so we write all the dates or hme kisi specific date l liye bola bi nahi hai isliye
 SELECT * FROM Orders
 WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrieve the total stock of books available; 
 SELECT SUM(stock) AS TOTAL_STOCK
 FROM books;

 SELECT genre,
 SUM(stock) AS total_stock FROM books
 GROUP BY genre;
 

--6) Find the details of most expensive books
     SELECT * FROM books ORDER BY price DESC
	 LIMIT 1;

--7) Show all customer who ordered more than 1 quantity of a book;
	SELECT customer_id, quantity
	FROM Orders
	WHERE quantity > 1;

--8) Retrieve all the orders where the total amount exceeds $20;
	SELECT * FROM Orders
	WHERE total_amount > 20;

--9) List all the genres available in the books tables;
	SELECT DISTINCT genre FROM books;
	
	SELECT genre FROM books
	GROUP BY genre;

--10) Find the book with lowest stock
	SELECT * FROM books ORDER BY stock ASC
	 LIMIT 1;

--11) Calculate the total revenue generated from all orders;
	SELECT SUM(total_amount) AS revenue FROM orders;


          --ADVANCE QUERIES

--1) Retrieve the total number of books sold for each genre;
	SELECT * FROM orders;
	
	SELECT b.genre, SUM(o.quantity) AS TOTAL_BOOKS_SOLD
	FROM books b
    JOIN orders o
	ON b. book_id = o.book_id
	GROUP BY b.genre;

--2) Find the average price of book in fantasy genre;
	SELECT * FROM Books;

	SELECT AVG(price)AS avg_price FROM books
	WHERE genre = 'Fantasy'
	
--3) List customer who have placed at least 2 orders;
	SELECT c.name,c.customer_id, COUNT(o.order_id)AS total_orders
	FROM customers c
	JOIN Orders o
	ON c.customer_id= o.customer_id
	GROUP BY c.name,c.customer_id
	HAVING COUNT(o.order_id)>=2;

	--without join

	SELECT Customer_id,COUNT(order_id)
	FROM orders
	GROUP BY customer_id
	HAVING COUNT (order_id )> 2

	select count(order_id) from orders;


--4) Find the most frequently ordered book;
	SELECT book_id, COUNT(order_id)AS highest_order
	FROM orders
	GROUP BY book_id ORDER BY highest_order DESC LIMIT 1;

	SELECT book_id, COUNT(quantity)AS highest_orderd
	FROM orders
	GROUP BY book_id ORDER BY COUNT(quantity) DESC LIMIT 1

--5) Show the top 3 most expensive books of 'fantasy' genre;
	SELECT * FROM books
	WHERE genre = 'Fantasy' ORDER BY price DESC 
	LIMIT 3;

	--SECOUND HIGHEST SALARY --OFFSET HELP TP SKIP 1ST VALUE
	SELECT * FROM books
	WHERE genre = 'Fantasy' ORDER BY price DESC 
	LIMIT 1 OFFSET 1;
	
 	--also use max function
	SELECT MAX(price) FROM books
	WHERE price <(SELECT MAX(price) 
	FROM books)

	--also use window(dense_rank function)
	SELECT price FROM
	(SELECT price,
	DENSE_RANK() OVER(ORDER BY price DESC)AS rnk FROM books)AS ranked
	WHERE rnk =2;

	--CTEs
	WITH ranked AS(SELECT price,
	DENSE_RANK() OVER(ORDER BY price DESC)AS rnk FROM books)
	SELECT price FROM ranked

	WHERE rnk =2;
	
--6) Retrieve the total quantity of books sold by each author
	SELECT * FROM books
	SELECT * FROM orders
	SELECT b.author,b.title,SUM(o.quantity)AS total_book_sold
	FROM books b 
	JOIN orders o
	ON b.book_id = o.book_id
	GROUP BY b.author,b.title;

--7) List the cities where customers who spent over $30 are located;
	SELECT * FROM customers;
	SELECT * FROM orders;
	SELECT c.city, o.total_amount
	FROM customers c
	JOIN orders o
	ON c.customer_id = o.customer_id
	GROUP BY c.city,o.total_amount
	HAVING o.total_amount >30;

	SELECT DISTINCT(c.city), o.total_amount
	FROM customers c
	JOIN orders o
	ON c.customer_id = o.customer_id
	WHERE o.total_amount >300;

--8) Find the customers who spent more on orders;
	SELECT c.name, SUM(o.total_amount)AS total_spent
	FROM customers c 
	JOIN orders o
	ON c.customer_id = o.order_id
	GROUP BY c.name 
	ORDER BY total_spent DESC LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders;  -- koe bok kafi baar buy huyi hogi or koebook huyi hi nhi hogi
	SELECT * FROM books;
	SELECT * FROM orders;

	SELECT b.book_id, b.stock, COALESCE (SUM(o.quantity),0) AS order_quantity,
	(b.stock - COALESCE (SUM(o.quantity),0)) AS Remaining_quantity
	FROM books b
	LEFT JOIN orders o
	ON b.book_id=o.book_id
	GROUP BY b.book_id;
	

	

	

	
	

	

	
	
