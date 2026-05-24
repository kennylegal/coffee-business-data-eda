show search_path;
set search_path to coffeesalesdata;

-- Q.1
-- Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?

select city_name, count(distinct(sale.customer_id)) as total_unique_customers
from sales as sale
join customers as cust
on cust.customer_id = sale.customer_id
join city
on cust.city_id = city.city_id
group by 1
order by 2 desc;


-- -- Q.2
-- Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?

with city_sale_rank as (
select city_name, product_name, count(sale_id) as sale_count
from sales as sale
join product as prod
on prod.product_id = sale.product_id
join customers as cust
on cust.customer_id = sale.customer_id
join city
on cust.city_id = city.city_id
group by city_name, product_name
order by 1, 3 desc
), top3_city_sale as (select *, 
row_number() over(partition by city_name) as rnk
from city_sale_rank)
select * from top3_city_sale
where rnk <= 3;


-- Q.10
-- Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer

WITH city_table
AS
(
	SELECT 
		ci.city_name,
		SUM(s.total) as total_revenue,
		COUNT(DISTINCT s.customer_id) as total_cx,
		ROUND(
				SUM(s.total)::numeric/
					COUNT(DISTINCT s.customer_id)::numeric
				,2) as avg_sale_pr_cx
				
	FROM sales as s
	JOIN customers as c
	ON s.customer_id = c.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY 1
	ORDER BY 2 DESC
),
city_rent
AS
(
	SELECT 
		city_name, 
		estimated_rent,
		ROUND((population * 0.25)/1000000, 3) as estimated_coffee_consumer_in_millions
	FROM city
)
SELECT 
	cr.city_name,
	total_revenue,
	cr.estimated_rent as total_rent,
	ct.total_cx,
	estimated_coffee_consumer_in_millions,
	ct.avg_sale_pr_cx,
	ROUND(
		cr.estimated_rent::numeric/
									ct.total_cx::numeric
		, 2) as avg_rent_per_cx
FROM city_rent as cr
JOIN city_table as ct
ON cr.city_name = ct.city_name
ORDER BY 2 DESC