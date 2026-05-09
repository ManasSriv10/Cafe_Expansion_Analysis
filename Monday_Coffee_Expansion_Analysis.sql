use monday_coffee;

select * from city;
select * from customers;
select * from products;
select * from sales;

-- 1. coffee consumers count
-- given: 25% of population consume coffee

select 
	city_name, 
	(population * 0.25) / 100000 as consumer_count_in_lakhs
from city
order by consumer_count_in_lakhs desc;

-- conclusion: delhi has highest number of consumers


-- 2. total revenue from coffee sales in each city last quarter year

select 
	ci.city_name, 
	sum(s.total) / 100000 as total_rev_in_lakhs
from sales s
join customers c 
	on s.customer_id = c.customer_id
join city ci 
	on c.city_id = ci.city_id
where extract(year from sale_date) = 2023
and extract(quarter from sale_date) = 4
group by ci.city_name
order by total_rev_in_lakhs desc;

-- conclusion: last quarter, highest revenue is from jaipur


-- 3. sales count for each product

select 
	p.product_name, 
	count(s.product_id) as sales_count
from sales s
left join products p 
	on s.product_id = p.product_id
group by p.product_name
order by sales_count desc;

-- conclusion: cold brew coffee pack of 6 bottles has highest sales count


-- 4. average sales amount per customer in each city

select 
	ci.city_name, 
	sum(s.total) as total_rev, 
	count(distinct s.customer_id) as total_customers,  
	sum(s.total) / count(distinct s.customer_id) as avg_sales
from sales s
join customers c 
	on s.customer_id = c.customer_id
join city ci 
	on c.city_id = ci.city_id
group by ci.city_name
order by avg_sales desc;


-- 5. city population and coffee consumers (25%)

with city_table as 
(
	select 
		city_id,
		city_name,
		round((population * 0.25) / 1000000, 2) as coffee_consumers
	from city
),
customers_table as
(
	select 
		ci.city_name,
		count(distinct c.customer_id) as unique_cx
	from sales s
	join customers c 
		on s.customer_id = c.customer_id
	join city ci 
		on c.city_id = ci.city_id
	group by ci.city_name
)
select
	ct.city_name,
	ct.coffee_consumers as coffee_consumer_in_millions,
	cs.unique_cx
from city_table ct
join customers_table cs
	on ct.city_name = cs.city_name;


-- 6. top selling products by city

select *
from (
	select 
		ci.city_name,
		p.product_name,
		count(s.sale_id) as total_orders,
		dense_rank() over(
			partition by ci.city_name 
			order by count(s.sale_id) desc
		) as rnk
	from sales s
	join products p 
		on s.product_id = p.product_id
	join customers c 
		on s.customer_id = c.customer_id
	join city ci 
		on c.city_id = ci.city_id
	group by ci.city_name, p.product_name
) t1
where rnk <= 3;


-- 7. customer segmentation by city

select 
	ci.city_name,
	count(distinct c.customer_id) as unique_cx
from city ci
left join customers c 
	on c.city_id = ci.city_id
join sales s 
	on s.customer_id = c.customer_id
where s.product_id in (1,2,3,4,5,6,7,8,9,10,11,12,13,14)
group by ci.city_name;


-- 8. average sale vs rent

with city_table as
(
	select 
		ci.city_id,
		ci.city_name,
		sum(s.total) as total_revenue,
		count(distinct s.customer_id) as total_cx,
		sum(s.total) / count(distinct s.customer_id) as avg_sale_pr_cx
	from sales s
	join customers c 
		on s.customer_id = c.customer_id
	join city ci 
		on c.city_id = ci.city_id
	group by ci.city_id, ci.city_name
),
city_rent as
(
	select 
		city_id,
		city_name,
		estimated_rent
	from city
)
select 
	cr.city_name,
	cr.estimated_rent,
	ct.total_cx,
	ct.avg_sale_pr_cx,
	cr.estimated_rent / ct.total_cx as avg_rent_per_cx
from city_rent cr
join city_table ct 
	on cr.city_id = ct.city_id
order by avg_rent_per_cx desc;

-- 9. monthly sales growth

with monthly_sales as
(
	select 
		ci.city_name,
		extract(month from s.sale_date) as month,
		extract(year from s.sale_date) as year,
		sum(s.total) as total_sale
	from sales s
	join customers c 
		on c.customer_id = s.customer_id
	join city ci 
		on ci.city_id = c.city_id
	group by ci.city_name, month, year
),
growth_ratio as
(
	select
		city_name,
		month,
		year,
		total_sale as current_month_sale,
		lag(total_sale) over(
			partition by city_name 
			order by year, month
		) as previous_month_sale
	from monthly_sales
)
select
	city_name,
	month,
	year,
	current_month_sale,
	previous_month_sale,
	round(
		(current_month_sale - previous_month_sale) * 100.0 
		/ nullif(previous_month_sale, 0)
	,2) as growth_percentage
from growth_ratio
where previous_month_sale is not null;


-- 10. market potential analysis

with city_table as
(
	select 
		ci.city_id,
		ci.city_name,
		sum(s.total) as total_revenue,
		count(distinct s.customer_id) as total_cx,
		sum(s.total) / count(distinct s.customer_id) as avg_sale_pr_cx
	from sales s
	join customers c 
		on s.customer_id = c.customer_id
	join city ci 
		on ci.city_id = c.city_id
	group by ci.city_id, ci.city_name
),
city_rent as
(
	select 
		city_id,
		city_name,
		estimated_rent,
		round((population * 0.25) / 1000000, 3) as estimated_coffee_consumers_millions
	from city
)
select 
	cr.city_name,
	ct.total_revenue,
	cr.estimated_rent,
	ct.total_cx,
	cr.estimated_coffee_consumers_millions,
	ct.avg_sale_pr_cx,
	round(
		cr.estimated_rent / ct.total_cx
	,2) as avg_rent_per_cx
from city_rent cr
join city_table ct 
	on cr.city_id = ct.city_id
order by ct.total_revenue desc
limit 3;


/*
-- Recomendation
City 1: Pune
	1.Average rent per customer is very low.
	2.Highest total revenue.
	3.Average sales per customer is also high.

City 2: Delhi
	1.Highest estimated coffee consumers at 7.7 million.
	2.Highest total number of customers, which is 68.
	3.Average rent per customer is 330 (still under 500).

City 3: Jaipur
	1.Highest number of customers, which is 69.
	2.Average rent per customer is very low at 156.
	3.Average sales per customer is better at 11.6k.