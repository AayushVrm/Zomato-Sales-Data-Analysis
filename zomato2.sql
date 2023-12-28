Q6. which item was purchased first by the customer after they became a member?

select* from 
(select c.*, rank() over(partition by userid order by created_date) rnk from
(select a.userid, a.created_date, a.product_id, b.gold_signup_date from sales AS a inner join 
goldusers_signup AS b on a.userid= b.userid and created_date>= gold_signup_date)AS c) AS d where rnk=1;

# userid, created_date, product_id, gold_signup_date, rnk
1, 2018-03-19, 3, 2017-09-22, 1
3, 2017-12-07, 2, 2017-04-21, 1

Q7.which item was purchased just before the customeer became gold memeber?
this is opposite of Q6 , do some logical changes in above querry

select * from 
(select  c.*, rank() over(partition by userid order by created_date DESC ) rnk from
(select a.userid, a.created_date, a.product_id, b.gold_signup_date from sales AS a inner join 
goldusers_signup AS b on a.userid= b.userid and created_date<= gold_signup_date)AS c) AS d where rnk=1;

# userid, created_date, product_id, gold_signup_date, rnk
1, 2017-04-19, 2, 2017-09-22, 1
3, 2016-12-20, 2, 2017-04-21, 1

Q8. what is the total orders and amount spent for each memnber before they became a member ?
select userid , count(created_date) order_purchased, sum(price) total_amt_spent from 
(select c.*, d.price from 
(select a.userid, a.created_date, a.product_id, b.gold_signup_date from sales AS a inner join 
goldusers_signup AS b on a.userid= b.userid and created_date<= gold_signup_date) AS c inner join product AS d on c.product_id= d.product_id)AS e
group by userid;

# userid, order_purchased, total_amt_spent
3, 3, 2720
1, 5, 4030


Q9. If buying each product generates points for eg 5rs = 2 zomato points and each product has different purchasing points
 for eg for p1 5rs=1 zomato point , forp2 10rs = 5 zomato point and p3 5rs = 1zomato point 2 rs =1 zomato point,
, calculate points collected by each customer and for which product most points have been given tll now.


SELECT userid, SUM(total_points) AS total_points_earned
FROM (
    SELECT e.*, amt/points AS total_points
    FROM (
        SELECT d.*, CASE WHEN product_id=1 THEN 5 WHEN product_id=2 THEN 2 WHEN product_id=3 THEN 5 ELSE 0 END AS points
        FROM (
            SELECT c.userid, c.product_id, SUM(price) AS amt
            FROM (
                SELECT a.*, b.price
                FROM sales AS a
                INNER JOIN product AS b ON a.product_id= b.product_id
            ) AS c
            GROUP BY userid, product_id
        ) AS d
    ) AS e
) AS f
GROUP BY userid;

# userid, total_points_earned
1, 1829.0000
3, 1697.0000
2, 763.0000
FOR TOTAL CASHBACK EARNED AS 1 zp= 2.5 RS

SELECT userid, SUM(total_points)*2.5 AS total_CASHBACK_earned
FROM (
    SELECT e.*, amt/points AS total_points
    FROM (
        SELECT d.*, CASE WHEN product_id=1 THEN 5 WHEN product_id=2 THEN 2 WHEN product_id=3 THEN 5 ELSE 0 END AS points
        FROM (
            SELECT c.userid, c.product_id, SUM(price) AS amt
            FROM (
                SELECT a.*, b.price
                FROM sales AS a
                INNER JOIN product AS b ON a.product_id= b.product_id
            ) AS c
            GROUP BY userid, product_id
        ) AS d
    ) AS e
) AS f
GROUP BY userid;

# userid, total_CASHBACK_earned
1, 4572.50000
3, 4242.50000
2, 1907.50000  
 
PART 2 - TOTAL POINTS EARNED BY PRODUCT ID 

SELECT product_id, SUM(total_points) AS total_points_earned
FROM (
    SELECT e.*, amt/points AS total_points
    FROM (
        SELECT d.*, CASE WHEN product_id=1 THEN 5 WHEN product_id=2 THEN 2 WHEN product_id=3 THEN 5 ELSE 0 END AS points
        FROM (
            SELECT c.userid, c.product_id, SUM(price) AS amt
            FROM (
                SELECT a.*, b.price
                FROM sales AS a
                INNER JOIN product AS b ON a.product_id= b.product_id
            ) AS c
            GROUP BY userid, product_id
        ) AS d
    ) AS e
) AS f
GROUP BY product_id ;

# product_id, total_points_earned
2, 3045.0000
1, 980.0000
3, 264.0000
SELECT *
FROM (
    SELECT *, RANK() OVER (ORDER BY total_points_earned DESC) AS rnk
    FROM (
        SELECT product_id, SUM(total_points) AS total_points_earned
        FROM (
            SELECT e.*, amt/points AS total_points
            FROM (
                SELECT d.*, CASE WHEN product_id=1 THEN 5 WHEN product_id=2 THEN 2 WHEN product_id=3 THEN 5 ELSE 0 END AS points
                FROM (
                    SELECT c.userid, c.product_id, SUM(price) AS amt
                    FROM (
                        SELECT a.*, b.price
                        FROM sales AS a
                        INNER JOIN product AS b ON a.product_id= b.product_id
                    ) AS c
                    GROUP BY userid, product_id
                ) AS d
            ) AS e
        ) AS f
        GROUP BY product_id
    ) AS g
) AS h
WHERE rnk = 1;

# product_id, total_points_earned, rnk
2, 3045.0000, 1

Q in the first one yaer after a customer joins  the gold program (including there joining date )
 irrespective of what customer has purchased they earn  zomato points for every rs spent who earned 
 more  or 3 and what was their points earnings their first year?
 
select c.*, d.price*0.5 as total_points_earned from 
(select a.userid, a.created_date, a.product_id, b.gold_signup_date from sales AS a inner join 
goldusers_signup AS b on a.userid= b.userid and created_date>= gold_signup_date and created_date<= DATE_ADD(gold_signup_date, INTERVAL 1 YEAR)) AS c 
inner join product AS d on c.product_id= d.product_id;

# userid, created_date, product_id, gold_signup_date, total_points_earned
3, 2017-12-07, 2, 2017-04-21, 435.0
1, 2018-03-19, 3, 2017-09-22, 165.0

Q11. rank all the transactions of the customers
select *, rank() over(partition by userid order by created_date) AS rnk from sales;
# userid, created_date, product_id, rnk
1, 2016-03-11, 1, 1
1, 2016-05-20, 3, 2
1, 2016-11-09, 1, 3
1, 2017-03-11, 2, 4
1, 2017-04-19, 2, 5
1, 2018-03-19, 3, 6
1, 2019-10-23, 2, 7
2, 2017-09-24, 1, 1
2, 2017-11-08, 2, 2
2, 2018-09-10, 3, 3
2, 2020-07-20, 3, 4
3, 2016-11-10, 1, 1
3, 2016-12-15, 2, 2
3, 2016-12-20, 2, 3
3, 2017-12-07, 2, 4
3, 2019-12-18, 1, 5

Q12 rank all the transactions for each  member whwenever they are
a zomato gold memeber for every non gold member transaction mark as na

na will be marked for 1& 3 before they became gold member

SELECT e.*, CASE WHEN rnk = 0 THEN 'na' ELSE CAST(rnk AS CHAR) END AS rnkk
FROM (
    SELECT c.*, CAST(
        CASE WHEN gold_signup_date IS NULL THEN 0
             ELSE RANK() OVER (PARTITION BY userid ORDER BY created_date DESC)
        END AS CHAR) AS rnk
    FROM (
        SELECT a.userid, a.created_date, a.product_id, b.gold_signup_date
        FROM sales AS a
        LEFT JOIN goldusers_signup AS b ON a.userid = b.userid AND a.created_date >= b.gold_signup_date
    ) AS c
) AS e;

# userid, created_date, product_id, gold_signup_date, rnk, rnkk
1, 2019-10-23, 2, 2017-09-22, 1, 1
1, 2018-03-19, 3, 2017-09-22, 2, 2
1, 2017-04-19, 2, , 0, na
1, 2017-03-11, 2, , 0, na
1, 2016-11-09, 1, , 0, na
1, 2016-05-20, 3, , 0, na
1, 2016-03-11, 1, , 0, na
2, 2020-07-20, 3, , 0, na
2, 2018-09-10, 3, , 0, na
2, 2017-11-08, 2, , 0, na
2, 2017-09-24, 1, , 0, na
3, 2019-12-18, 1, 2017-04-21, 1, 1
3, 2017-12-07, 2, 2017-04-21, 2, 2
3, 2016-12-20, 2, , 0, na
3, 2016-12-15, 2, , 0, na
3, 2016-11-10, 1, , 0, na


 
 
 








 

