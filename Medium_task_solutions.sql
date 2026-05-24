select * from city;
select * from product;
select * from sales;
select * from customers;

show search_path;
set search_path to coffeesalesdata;

-- -- Q.1
-- City Population and Coffee Consumers (25%)
-- Provide a list of cities along with their populations and estimated coffee consumers.
-- return city_name, total current cx, estimated coffee consumers (25%)

SELECT 
	city_name,
	ROUND(
	(population * 0.25)/1000000, 
	2) as coffee_consumers_in_millions,
	city_rank
FROM city
ORDER BY 2 DESC;


-- -- Q.2
-- Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer

select * from city;
select * from customer;
--Average rent per customer in each city


select c.city_id, c.city_name, round(
sum(total)::numeric / count(distinct s.customer_id)::numeric
) as avg_sale_per_customer_per_city,
round(
estimated_rent::numeric / count(distinct cu.customer_id)::numeric
) as avge_rent_pc
from sales as s
join customers as cu
on s.customer_id = cu.customer_id
join city as c
on cu.city_id = c.city_id
group by c.city_id
order by 3 desc;





