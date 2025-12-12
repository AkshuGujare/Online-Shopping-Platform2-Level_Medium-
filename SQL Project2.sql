create database RetailDB_2 ;
use RetailDB_2;

CREATE TABLE Customers ( 
customer_id INT AUTO_INCREMENT PRIMARY KEY, 
name VARCHAR(100), 
email VARCHAR(100), 
city VARCHAR(50), 
signup_date DATE 
); 

CREATE TABLE Suppliers ( 
supplier_id INT AUTO_INCREMENT PRIMARY KEY, 
supplier_name VARCHAR(100), 
contact_email VARCHAR(100), 
city VARCHAR(50) 
);

CREATE TABLE Products ( 
product_id INT AUTO_INCREMENT PRIMARY KEY, 
product_name VARCHAR(100), 
category VARCHAR(50), 
price DECIMAL(10,2), 
stock_qty INT, 
supplier_id INT, 
FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) 
); 


CREATE TABLE Orders ( 
order_id INT AUTO_INCREMENT PRIMARY KEY, 
customer_id INT, 
order_date DATE, 
total_amount DECIMAL(10,2), 
payment_mode VARCHAR(50), 
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) 
); 

CREATE TABLE Order_Items ( 
order_item_id INT AUTO_INCREMENT PRIMARY KEY, 
order_id INT, 
product_id INT, 
quantity INT, 
price_each DECIMAL(10,2), 
FOREIGN KEY (order_id) REFERENCES Orders(order_id), 
FOREIGN KEY (product_id) REFERENCES Products(product_id) 
);

select * from customers;


select * from order_items;

select * from orders;

select * from products;

select * from suppliers;


select supplier_name from suppliers
inner join products 
on suppliers.supplier_id=products.supplier_id;


#2. Find all customers and their orders, even if they have not placed any (LEFT JOIN). 

select * from customers 
left join orders 
on customers.customer_id=orders.customer_id; 


#3. Get all suppliers and the products they supply, even if no products exist for a supplier (RIGHT JOIN). 
select * from suppliers right join products on suppliers.supplier_id = products.supplier_id;


#4. Show all customers and all orders (FULL OUTER JOIN simulation using UNION).
select * from customers left join orders on customers.customer_id=orders.order_id union 
select * from customers right join orders on customers.customer_id=orders.order_id; 
 
#5. List all products priced between ₹5000 and ₹50,000 and supplied from "Mumbai".
select suppliers.supplier_name from suppliers  join
 products on suppliers.supplier_id = products.supplier_id 
 where products.price between 5000 and 100000 and 
suppliers.city = 'Mumbai';

#6. Find the total number of orders placed by each customer and show only those who placed more than 2 (GROUP BY + HAVING). 

select c.name,count(o.order_id)
from customers as c
join orders as o on 
c.customer_id =o.customer_id
group by c.name having  count(o.order_id)>2 ;
 

#7. Show each supplier’s total sales value (sum of quantity × price_each). 
select s.supplier_name ,
sum(p.price * ot.quantity) as sale_value 
from suppliers as s inner join products as p 
on s.supplier_id=p.supplier_id
inner join order_items as ot on p.product_id=ot.product_id
group by s.supplier_name;

#8. Find the average, highest, and lowest price of products in each category.
 
select category ,
avg(price) as price_avg,
max(price) as highest_price
,min(price) as lowest_price
 from products group by category;


#9. Find the top 5 customers by total spending (ORDER BY SUM(total_amount) DESC LIMIT 5). 
select c.name,sum(o.total_amount) from customers as c
inner join orders as o on c.customer_id =o.customer_id 
group by c.name order by sum(o.total_amount) desc limit 5;

#10. Show the number of unique products ordered by each customer. 
select c.name , count(distinct p.category )  as p_category from 
customers as c inner join products as p on c.customer_id = p.supplier_id 
group by c.name;


#11. Find customers who placed an order with an amount greater than the average order amount (subquery). 
select c.name ,o.total_amount              
from  customers as c 
inner join orders as o
on c.customer_id =o.customer_id 
where o.total_amount >
(select avg(total_amount) from orders );

#12. Find products that have never been ordered (subquery with NOT IN). 

select p.product_name 
from products as p
where p.product_id 
not in (select order_id from orders);

select p.product_name 
from products as p inner join orders as o
on p.product_id= o.customer_id 
where o.customer_id
 not in (select customer_id from orders);

#13. List customers who ordered at least one product from the "Electronics" category. 
select c.name from customers as c 
join orders as o
on c.customer_id = o.customer_id
join order_items as oi 
on o.order_id=oi.order_id 
join products as p on
oi.product_id =p.product_id
where p.category ="Electronics";


#14. Get suppliers who provide products that have been ordered more than 100 times in total. 

select * from order_items as o
join o.order_id = o.product_id
join suppliers as s 
on


select * from orders;
select * from products;
select * from order_items;
select * from customers;
select * from suppliers;


#14. Get suppliers who provide products that have been ordered more than 100 times in total. 

#15. Find the most expensive product(s) using a subquery with MAX(). 
use retail_db2;
select * from products;
select product_name,category,
max(price) from products
group by category,product_name 
order by max(price) desc
limit 1;

# 16. Show orders placed by customers who live in either Mumbai, Delhi, or Bengaluru (IN operator). 
select * from orders;
select* from customers;
select * from orders as o join customers as c on o.customer_id =c.customer_id where c.city in ("Mumbai","Delhi","Bengluru");

#17. Show orders where payment mode is NOT UPI or Credit Card (NOT IN). 
select * from orders where payment_mode not in ("UPI","Credit Card");

#18. Find customers who have no email address recorded (IS NULL). 
select * from customers;
select * from customers where email is null;

#19. Show suppliers who are not from the same city as any customer (NOT IN subquery). 
select * from customers;
select * from suppliers;
select  * from customers as c join suppliers as s on c.city = s.city ;

#20. Get the latest 3 orders placed, skipping the first 2 (ORDER BY + LIMIT + OFFSET).

