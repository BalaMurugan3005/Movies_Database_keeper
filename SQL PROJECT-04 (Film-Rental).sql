-- SQL WEEK 04 GRADED PROJECT
-- 		FILM - RENTAL

-- USE THE REQUIRED DATABASE
use film_rental;
-- SHOW THE TABLES IN THE DATABASE
show tables;
/*
1. What is the total revenue generated from all rentals in the database? */
select * from rental;
select * from payment;
select sum(amount) as Total_revenue
from payment;
-- *************************************************************************************
/*
2.	How many rentals were made in each month_name? */
select * from rental;

select monthname(rental_date) as Month_names, count(rental_id) as Rental_counts
from rental
group by Month_names
order by Rental_counts desc;
-- ***************************************************************************************
/*
3.	What is the rental rate of the film with the longest title in the database? */
select * from film;

select Title,Rental_rate
from film
where length(title) = (select max(length(title)) from film);
-- *******************************************************************************************
/*
4.	What is the average rental rate for films that were taken 
from the last 30 days from the date("2005-05-05 22:04:30")? */
select * from film;
select * from inventory;
select * from rental;
select  avg(f.rental_rate) as Average_rental_rate
from film f
join inventory i
on f.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
where r.rental_date between "2005-05-05 22:04:30"
and (select date_add("2005-05-05 22:04:30", interval 30 day) from film limit 1);
-- ************************************************************************************************
/*
5.	What is the most popular category of films in terms of the number of rentals? */
select * from category;
select * from film_category;
select * from film;
select * from inventory;
select * from rental;

select c.Name as Category_name,
count(rental_id) as Rental_count
from category c
join film_category fc
on c.category_id = fc.category_id
join film f
on fc.film_id = f.film_id
join inventory i
on f.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
group by CAtegory_name 
order by Rental_count desc limit 1;
-- ****************************************************************************************************
/*
6.	Find the longest movie duration from the list of films that have not been rented by any customer.*/
select * from film;
select * from inventory;
select * from customer;
select distinct f.Title as Film_title,f.length as Film_duration,
c.Customer_id, c.Active
from film f
join inventory i
on f.film_id = i.film_id
join customer c
on i.store_id = c.store_id
where length = (select max(length) from film)
and Active = 0;
-- *******************************************************************************************************
/*
7.	What is the average rental rate for films, broken down by category? */
select * from film;
select * from film_category;
select * from category;
select c.name as Category_name,avg(f.rental_rate) as Average_rental_rate
from film f
join film_category fc
on f.film_id = fc.film_id
join category c
on fc.category_id = c.category_id
group by Category_name
order by Average_rental_rate desc;
-- ********************************************************************************************
/*
8.	What is the total revenue generated from rentals for each actor in the database? */
select * from payment;
select * from film_actor;
select * from actor;
select * from rental;
select * from film;
select * from inventory;

select concat(a.First_name,' ', a.Last_name) as Actor_name
,sum(p.amount) as Revenue
from film f
join inventory i
on f.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
join payment p
on r.rental_id = p.rental_id
join film_actor fa
on f.film_id = fa.film_id
join actor a
on fa.actor_id = a.actor_id
group by Actor_name;
-- ************************************************************************************
/*
9.	Show all the actresses who worked in a film having a "Wrestler" in the description. */
select * from film_actor;
select * from actor;
select * from film;

select concat(a.first_name,' ',a.last_name) as Actresses_name,
f.Description
from actor a
join film_actor fa
on a.actor_id = fa.actor_id
join film f
on fa.film_id = f.film_id
where description like '%Wrestler%';
-- ********************************************************************************************8
/*
10.	Which customers have rented the same film more than once? */
select * from customer;
select * from rental;
select * from inventory;
select * from film;

select concat(c.first_name,' ',c.last_name) as Customer_name,
f.Title
from customer c
join rental r
on c.customer_id = r.customer_id
join inventory i
on r.inventory_id = i.inventory_id
join film f
on i.film_id = f.film_id;
-- ************************************************************************************************
/*
11.	How many films in the comedy category have a rental rate higher than the average rental rate? */
select * from film;
select * from film_category;
select * from category;

select count(c.Name) as Film_Category_count
from film f
join film_category fc
on f.film_id = fc.film_id
join category c
on fc.category_id = c.category_id
where c.name = 'Comedy'
and f.rental_rate > (select avg(rental_rate) from film);
-- ****************************************************************************************************
/*
12.	Which films have been rented the most by customers living in each city? */
select * from film;
select * from inventory;
select * from customer;
select * from address;
select * from city; 

select distinct ci.City,f.title,(select max(rental_rate) from film) as Rental_rate
from  film f
join inventory i
on f.film_id = i.film_id
join customer c
on i.store_id = c.store_id
join address ad
on c.address_id = ad.address_id
join city ci
on ad.city_id = ci.city_id;
-- ********************************************************************************************
/*
13.	What is the total amount spent by customers whose rental payments exceed $200? */
select * from customer;
select * from payment
;

select concat(c.first_name,' ', c.last_name) as Customer_name,
sum(amount) Total_amount
from customer c
join payment p
on c.customer_id = p.customer_id
group by Customer_name
order by total_amount desc
limit 2;
-- ****************************************************************************************************
/*
14.	Display the fields which are having foreign key constraints related to the "rental" table.
[Hint: using Information_schema] */
select 
CONSTRAINT_NAME,
TABLE_NAME,
REFERENCED_TABLE_NAME,
REFERENCED_COLUMN_NAME
from information_schema.KEY_COLUMN_USAGE
where REFERENCED_TABLE_NAME = 'rental';
-- ***********************************************************************************************************
/*
15.	Create a View for the total revenue generated by each staff member, broken down by store city with the country name.*/
select * from staff;
select *from store;
select * from address;
select * from country;
select * from city;
select * from payment; 

create view Staff_View as
select s.Staff_id, concat(s.first_name,' ',s.last_name) as Staff_name,
st.Store_id,ci.City,c.Country,sum(p.Amount) as Revenue
from staff s
left join store st
on s.store_id = st.store_id
join address a
on st.address_id = a.address_id
join city ci
on a.city_id = ci.city_id
join country c
on ci.country_id = c.country_id
join payment p
on s.staff_id = p.staff_id
group by s.staff_id;

select * from Staff_View;
-- *************************************************************************************************************
/*
16.	Create a view based on rental information consisting of visiting_day, customer_name, the title of the film, 
no_of_rental_days, the amount paid by the customer along with the percentage of customer spending. */
select * from rental;
select * from customer;
select * from inventory;
select * from film;
select * from payment;

create view Customer_spent as
select distinct r.rental_date as Visiting_date, concat(c.first_name,' ',c.last_name) as Customer_name,
f.Title, f.rental_duration as No_of_rental_days,p.amount as Amount_paid
from customer c
join rental r
on c.customer_id = r.customer_id
join inventory i
on r.inventory_id = i.inventory_id
join film f
on i.film_id = f.film_id
join payment p
on r.rental_id = p.rental_id;

select * from Customer_spent;

-- PERCENTAGE OF CUSTOMER SPENDING
select customer_id, (concat(sum(amount)/(select sum(amount) from payment)*100,'%')) as Percentage_spent
from payment
group by customer_id;
-- *******************************************************************************************************
/*
17.	Display the customers who paid 50% of their total rental costs within one day.*/
select * from customer;
select * from payment;
select * from inventory;
select * from rental;

select c.customer_id,c.first_name,sum(p.amount)/2 as Customer_50percent_spent
from customer c
join payment p
on c.customer_id = p.customer_id
group by c.first_name,c.customer_id;
 
create view customer_spent_50 as
select c.first_name,sum(p.amount) as First_day_spent,
datediff(r.return_date,r.rental_date) as Df
from rental r
join payment p
on r.rental_id = p.rental_id
join customer c
on p.customer_id = c.customer_id
where r.rental_date = p.payment_date
and datediff(r.return_date,r.rental_date) = 1
group by c.first_name,df
order by First_day_spent desc;

select * from customer_spent_50;
-- ************************************************************************************