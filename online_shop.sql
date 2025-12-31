create database online_shop;
use online_shop;

-- display the product ordered who have quantity is greater then 50
select p1.product_id, p1.product_name, sum(quantity) as total_quantity  from products as p1
left join order_items as o1 on p1.product_id=o1.product_id
group by product_name, p1.product_id
having total_quantity >50;

-- display the product name, customer name, rating and feedback of customer which have 4 and 5 rating for a product.
select rating, p1.product_name, review_text, r1.product_id, c1.first_name from reviews as r1
left join customers as c1 on c1.customer_id=r1.customer_id
left join products as p1 on r1.product_id=p1.product_id
where rating="4" or rating="5";


-- find the product name which have highest rating monthwise
use online_shop;
select * from products;
select * from reviews;

select * from 
(select (r1.rating), r1.review_text,monthname(r1.review_date) as month, p1.product_name,
dense_rank() over (partition by monthname(r1.review_date) order by r1.rating desc)
as row_num,  month(r1.review_date) as month1 from reviews r1 
join products as p1 on r1.product_id=p1.product_id)
as ranked 
where row_num=1
order by month1;

-- query for practice
(select rating, row_number() over (partition by monthname(review_date) order by rating desc)
as rn from reviews);

select rating, monthname(review_date) as month, p1.product_name, review_text from reviews as r1
left join customers as c1 on c1.customer_id=r1.customer_id
left join products as p1 on r1.product_id=p1.product_id
where rating=5
order by rating desc;




with temp as (select*, row_number() over(partition by monthname(review_date)  order by rating desc) as row_num from reviews)
select * from temp where row_num=1;

-- display the supplier name who supply electronics item
select * from suppliers;
select * from products;

select s.supplier_id,p.category, supplier_name from suppliers as s
left join products as p on
s.supplier_id=p.supplier_id
where category="electronics";

-- display the supplier name, product name, price and category where product name has 'com' in itself.
select * from suppliers;
select * from products;
select product_name, s.supplier_name, price, category from products as p
left join suppliers as s on s.supplier_id=p.supplier_id
where product_name like "%com%";

-- top 10 selling product
select * from products;
select * from order_items;
select * from orders;
use online_shop;

select count(*) as num_of_row, p.product_name, sum(p.price) as total_price,p.product_id from products as p left join order_items as ot on
p.product_id=ot.product_id 
group by p.product_id,p.price,p.product_name
order by num_of_row desc
limit 10;

-- show product category with total quantity sold 
with temp as (select count(*) as num_of_rows,sum(p1.price) as total_price,p1.category, sum(ot.quantity) as total_quantity
from products as p1 join products p2 on p1.product_id=p2.product_id
left join order_items as ot on p2.product_id=ot.product_id
group by p1.category, ot.quantity) select sum(total_quantity), sum(total_price),category from temp
group by category;

-- query for practice
select count(*) as num_of_rows,sum(p1.price) as total_price,p1.category, sum(ot.quantity) as total_quantity
from products as p1 join products p2 on p1.product_id=p2.product_id
left join order_items as ot on p2.product_id=ot.product_id left join shipments as s
on ot.order_id=s.order_id
group by p1.category;

select count(*) as num_of_rows,sum(p1.price) as total_price,p1.category as category, sum(ot.quantity) as total_quantity
from products as p1 join order_items ot on p1.product_id=ot.product_id
group by category;


-- show product name with total quantity sold 
select count(*) as num_of_rows,sum(p1.price) as total_price,p1.category as category, sum(ot.quantity) as total_quantity,p1.product_name
from products as p1 join order_items ot on p1.product_id=ot.product_id
group by p1.product_name, category;

-- get all the product shipment with their status and order date
select * from shipments;
select count(*) as num_of_rows,sum(p1.price) as total_price,p1.category, 
sum(ot.quantity) as total_quantity,s.shipment_status as status,p1.product_name, o.order_date
from products as p1 join products p2 on p1.product_id=p2.product_id
left join order_items as ot on p2.product_id=ot.product_id 
left join orders as o on ot.order_id=o.order_id left join shipments as s
on ot.order_id=s.order_id
group by p1.category,p1.product_name, status, o.order_date;

-- total order placed by each customer
select * from customers;
select * from orders;

select c.customer_id, first_name,count(o.order_id) as total_order
from customers as c join orders as o on 
c.customer_id=o.customer_id
group by first_name,c.customer_id;

-- find average rating of each product
select * from products;
select * from reviews;
select avg(rating) as avg_rating, p.product_id, p.product_name as prod_name from products as p
left join reviews as r on p.product_id=r.product_id
group by p.product_id, prod_name
order by avg_rating desc;

-- top 5 most reviewd product
select avg(rating) as ratings, count(*) as num_of_rows, p.product_id,p.product_name as prod_name from products as p
left join reviews as r on p.product_id=r.product_id
group by p.product_id, prod_name
order by ratings desc
limit 5;
select * from reviews;
select * from products;

