select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;
Q1. What is the total amount each user spent on zomato?

select a.userid, sum(b.price) as total_amnt_spent from sales as a inner join product as b on a.product_id=b.product_id
group by a.userid
# userid, total_amnt_spent
1, 5230
3, 4570
2, 2510


 Q2. how many days has each user visited zomato?
 select userid, COUNT(DISTINCT created_date) AS Distinct_days from sales group by userid;
 # userid, Distict_days
2, 4
3, 5
1, 7

Q3. what was the first product purchased by each customer?
rank function is doing ranking based on date purachsed and each of user id is sorted for rank 1 that tells the 1st purchase date by each customer

select * from
(select * ,rank() over(partition by userid order by created_date) AS rnk from sales) as a where rnk =1;
# userid, created_date, product_id, rnk
1, 2016-03-11, 1, 1
2, 2017-09-24, 1, 1
3, 2016-11-10, 1, 1

Q4. what is the most purchased item on the menu and how many times it was purchased by all customers?
select userid , count(product_id) as count from sales where product_id=
 (select product_id from sales group by product_id order by count(product_id) DESC limit 1)
 group by userid
# product_id, count
2, 7
1, 5
3, 4
product id 2 is purcahsed most no of times
use limit to get top 1 record
now product id 2 is purchesed by which customer and how many times
# userid, count
1, 3
3, 3
2, 1

Q5.which item was the most popular for each customer?
select * from
(select *,rank() over(partition by userid order by cnt DESC) AS rnk from
(select userid, product_id, count(product_id) AS cnt from sales group by userid, product_id) AS a) AS b
where rnk=1
# userid, product_id, cnt, rnk
1, 2, 3, 1
2, 3, 2, 1
3, 2, 3, 1
