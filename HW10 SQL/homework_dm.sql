use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name 
	from actor;
    
-- 1b. Display the first and last name of each actor in a single column in
-- upper case letters. Name the column Actor Name.
select first_name, last_name, concat(first_name,' ',last_name)
	as 'Actor Name' 
    from actor;
    
-- 2a. You need to find the ID number, first name, and last name of an actor,
-- of whom you know only the first name, "Joe." What is one query would you 
-- use to obtain this information?
select actor_id, first_name, last_name 
	from actor 
	where first_name = 'JOE';
    
-- 2b. Find all actors whose last name contain the letters GEN:
select actor_id, first_name, last_name 
	from actor 
	where last_name 
    like '%GEN%';
    
-- 2c. Find all actors whose last names contain the letters LI. This time, 
-- order the rows by last name and first name, in that order:
select actor_id, first_name, last_name 
	from actor
	where last_name 
    like '%LI%'
    order by last_name, first_name;
    
-- 2d. Using IN, display the country_id and country columns of the following countries:
-- Afghanistan, Bangladesh, and China:
select country_id, country 
	from country
    where country IN ('Afghanistan', 'Bangladesh', 'China');
    
-- 3a. Add a middle_name column to the table actor. Position it between first_name and
-- last_name. Hint: you will need to specify the data type.
ALTER TABLE actor
	ADD COLUMN `middle_name` VARCHAR(45) NULL AFTER `first_name`;

-- 3b. You realize that some of these actors have tremendously long last names.
-- Change the data type of the middle_name column to blobs.
ALTER TABLE actor CHANGE COLUMN `middle_name` `middle_name` blob DEFAULT NULL;

-- 3c. Now delete the middle_name column.
ALTER TABLE actor
	drop middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, 
	COUNT(last_name) AS NumActors
	FROM actor
    group by last_name;	
    
-- 4b. List last names of actors and the number of actors who have that last name,
-- but only for names that are shared by at least two actors
SELECT last_name, 
	COUNT(last_name) AS NumActors
	FROM actor
    group by last_name
    HAVING ( COUNT(last_name) > 1 );
    
-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as
-- GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher.
-- Write a query to fix the record.
UPDATE actor
	SET first_name = 'HARPO'
	WHERE actor_id IN (172);
   
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that
-- GROUCHO was the correct name after all! In a single query, if the first name
-- of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the
-- first name to MUCHO GROUCHO, as that is exactly what the actor will be with
-- the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR
-- TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
	SET first_name = 'GROUCHO'
	WHERE actor_id IN (172);

-- 5a. You cannot locate the schema of the address table.
-- Which query would you use to re-create it?
-- show create table address;
CREATE TABLE `address` (
	`address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
	`address` varchar(50) NOT NULL,
    `address2` varchar(50) DEFAULT NULL,
    `district` varchar(20) NOT NULL,
    `city_id` smallint(5) unsigned NOT NULL,
    `postal_code` varchar(10) DEFAULT NULL,
    `phone` varchar(20) NOT NULL,
    `location` geometry NOT NULL,
	`last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`address_id`),
    KEY `idx_fk_city_id` (`city_id`),
    SPATIAL KEY `idx_location` (`location`),
    CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
    ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;
    
-- 6a. Use JOIN to display the first and last names, as well as the address,
-- of each staff member. Use the tables staff and address:
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
address.address_id = staff.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in
-- August of 2005. Use tables staff and payment.
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff
INNER JOIN payment ON
payment.staff_id = staff.staff_id
group by staff_id;

-- 6c. List each film and the number of actors who are listed for that film.
-- Use tables film_actor and film. Use inner join.
SELECT film.film_id, film.title, COUNT(film_actor.actor_id) as NumActors
FROM film
INNER JOIN film_actor ON
film_actor.film_id = film.film_id
group by title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.film_id, film.title, Count(film.title) as NumCopies
FROM film
INNER JOIN inventory ON
inventory.film_id = film.film_id
where title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid
-- by each customer. List the customers alphabetically by last name:
SELECT customer.customer_id, customer.first_name, customer.last_name, sum(payment.amount) as TotPaid
FROM customer
INNER JOIN payment ON
payment.customer_id = customer.customer_id
group by customer_id
order by last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
-- As an unintended consequence, films starting with the letters K and Q have also
-- soared in popularity. Use subqueries to display the titles of movies starting with 
-- the letters K and Q whose language is English.
SELECT language.name as language_name, film.title
from film
inner join language on
language.language_id = film.language_id
where language.name = 'English'
and (title  LIKE 'K%' OR title LIKE 'Q%');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT f.title, a.first_name, a.last_name
FROM film f
INNER JOIN film_actor fa ON
fa.film_id = f.film_id
INNER JOIN actor a on
fa.actor_id = a.actor_id
where title = 'Alone Trip';

-- 7c. You want to run an email marketing campaign in Canada, for which you will
-- need the names and email addresses of all Canadian customers. Use joins to 
-- retrieve this information.
SELECT customer.first_name, customer.last_name, customer.email,
	   country.country
FROM customer
INNER JOIN address ON
address.address_id = customer.address_id
INNER JOIN city on
address.city_id = city.city_id
INNER JOIN country on
city.country_id = country.country_id
where country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all
-- family movies for a promotion. Identify all movies categorized as famiy films.
SELECT film.title, category.name as category
FROM film
INNER JOIN film_category ON
film_category.film_id = film.film_id
INNER JOIN category ON
film_category.category_id = category.category_id
where category.name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT film.title, count(film.title) as TimesRented
FROM film
INNER JOIN inventory ON
inventory.film_id = film.film_id
INNER JOIN rental ON
inventory.inventory_id = rental.inventory_id
group by film.title
order by TimesRented desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, sum(payment.amount) as 'TotIncome (USD)'
FROM store
INNER JOIN staff ON
staff.store_id = store.store_id
INNER JOIN payment ON
staff.staff_id = payment.staff_id
group by store.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address ON
address.address_id = store.address_id
INNER JOIN city ON
address.city_id = city.city_id
INNER JOIN country ON
city.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category,
-- inventory, payment, and rental.)
SELECT category.name as category, SUM(payment.amount) as 'gross revenue'
FROM category
INNER JOIN film_category ON
film_category.category_id = category.category_id
INNER JOIN inventory ON
film_category.film_id = inventory.film_id
INNER JOIN rental ON
inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON
rental.rental_id = payment.rental_id
group by category.name
order by SUM(payment.amount) desc
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of
-- viewing the Top five genres by gross revenue. Use the solution from the problem
-- above to create a view. If you haven't solved 7h, you can substitute another
-- query to create a view.
CREATE VIEW `top_five_genres` AS
SELECT category.name as category, SUM(payment.amount) as 'gross revenue'
FROM category
INNER JOIN film_category ON
film_category.category_id = category.category_id
INNER JOIN inventory ON
film_category.film_id = inventory.film_id
INNER JOIN rental ON
inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON
rental.rental_id = payment.rental_id
group by category.name
order by SUM(payment.amount) desc
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM `top_five_genres`;

-- 8c. You find that you no longer need the view top_five_genres. Write a query
-- to delete it.
DROP VIEW `top_five_genres`;




