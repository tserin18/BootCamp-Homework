USE sakila;

-- 1a. Display the first and last names of all actors from the table actor. 
SELECT  first_name, last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. 
SELECT upper(concat_ws(" ",first_name,last_name)) AS `Actor Name`
FROM actor;

/* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
What is one query would you use to obtain this information?*/
SELECT actor_id,first_name,last_name
FROM actor
WHERE first_name LIKE "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT *
FROM actor
WHERE last_name LIKE "%GEN%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT *
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name,first_name ;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id,country
FROM country
WHERE country IN ("Afghanistan","Bangladesh", "China");

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify 
-- the data type.
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(50);

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name 
-- column to blobs.
ALTER TABLE actor
MODIFY COLUMN middle_name LONGBLOB;

-- 3c. Now delete the middle_name column.
ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,COUNT(last_name) AS counts
FROM actor
GROUP BY last_name ;

/* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at 
least two actors */
SELECT last_name,COUNT(last_name) AS counts
FROM actor
GROUP BY last_name 
HAVING counts > 1;

/* 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of 
Harpo's second cousin's husband's yoga teacher. Write a query to fix the record. */
UPDATE actor
SET first_name = "HARPO"
WHERE first_name LIKE "GROUCHO" AND last_name LIKE "WILLIAMS";

/* 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to 
MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE 
FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.) */

UPDATE actor
SET first_name = CASE
         WHEN first_name = "HARPO" THEN "GROUCHO"
         ELSE "MUCHO GROUCHO"
       END
 WHERE actor_id=172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it? 
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
CREATE TABLE IF NOT EXISTS address 
(
	address_id INTEGER(11) AUTO_INCREMENT NOT NULL,
	address VARCHAR(50),
    address_2 VARCHAR(50),
	district VARCHAR(50),
    city_id INTEGER(11),
    postal_code int(10),
    phone INTEGER(15),
    location VARCHAR(50),
    last_update DATETIME,
    PRIMARY KEY(address_id),
    CONSTRAINT FK_CityAddress FOREIGN KEY (city_id) REFERENCES CITY(city_id)
); 

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name,s.last_name, concat_ws(", ",a.address,a.address2,a.district)
FROM staff AS s
LEFT JOIN address AS a
ON s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. 
SELECT s.first_name,s.last_name, SUM(p.amount) AS Amount
FROM staff AS s
LEFT JOIN payment AS p
ON s.staff_id = p.staff_id
WHERE YEAR(p.payment_date)=2005 AND MONTH(p.payment_date)=8
GROUP BY first_name,last_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title, COUNT(a.actor_id) as counts
FROM film AS f
LEFT JOIN film_actor AS a
ON f.film_id = a.film_id
GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title,COUNT(i.inventory_id) AS `Number of copies`
FROM film AS f
LEFT JOIN inventory AS i
ON f.film_id = i.film_id
GROUP BY f.title
HAVING f.title LIKE "Hunchback Impossible";

/* 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers 
alphabetically by last name:
![Total amount paid](Images/total_payment.png) */
SELECT last_name,first_name, SUM(amount) AS 'total payment'
FROM customer 
JOIN payment 
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY last_name desc; 

/* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films 
starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the 
letters K and Q whose language is English. */
SELECT sub.title, l.name
  FROM (
        SELECT *
          FROM film AS f
         WHERE f.title LIKE "K%" OR  f.title LIKE "Q%"
       ) sub	
 JOIN language AS l ON sub.language_id = l.language_id
 WHERE l.name  LIKE 'English';
 
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT film.title,concat_ws(" ", sub.first_name, sub.last_name) AS `Actor Name`
FROM (
        SELECT a.first_name AS first_name, a.last_name AS last_name, f.film_id AS film_id
          FROM film_actor AS f
         JOIN actor AS a ON  a.actor_id =f.actor_id  
       ) sub	
JOIN film ON sub.film_id = film.film_id
WHERE film.title LIKE "%Alone Trip%" ;

/* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all 
Canadian customers. Use joins to retrieve this information. */
SELECT concat_ws(" ", first_name, last_name) AS `Actor Name`
FROM customer
LEFT JOIN address ON (customer.address_id = address.address_id)
	LEFT JOIN city ON (address.city_id = city.city_id)
		LEFT JOIN country ON (city.country_id = country.country_id)
		WHERE country.country = 'Canada';

/* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies 
categorized as famiy films. */
SELECT title FROM film
WHERE film_id IN(
	SELECT film_id FROM film_category 
	WHERE category_id IN(
		SELECT category_id FROM category
		WHERE name LIKE 'Family')
);

-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(inventory.film_id) AS TimesRented
FROM film
    RIGHT JOIN inventory ON film.film_id = inventory.film_id
		RIGHT JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY TimesRented DESC, title ASC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, sum(payment.amount) AS RevenueGenerated
FROM store
    RIGHT JOIN customer ON store.store_id = customer.store_id
		RIGHT JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY store.store_id
ORDER BY RevenueGenerated DESC;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id,city.city,country.country
FROM store
    LEFT JOIN address ON store.address_id = address.address_id
		LEFT JOIN city ON address.city_id = city.city_id
			LEFT JOIN country ON city.country_id = country.country_id;

/* 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, 
film_category, inventory, payment, and rental.) */
SELECT name,sum(payment.amount) as RevenueGenerated
FROM category
    LEFT JOIN  film_category ON category.category_id = film_category.category_id
		LEFT JOIN film ON film_category.film_id = film.film_id
			LEFT JOIN inventory ON film.film_id = inventory.film_id
				LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
					LEFT JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY RevenueGenerated DESC, name ASC;


/*  8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view*/
CREATE VIEW `top_five_genres` AS SELECT name,sum(payment.amount) as RevenueGenerated
FROM category
    LEFT JOIN  film_category ON category.category_id = film_category.category_id
		LEFT JOIN film ON film_category.film_id = film.film_id
			LEFT JOIN inventory ON film.film_id = inventory.film_id
				LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
					LEFT JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY RevenueGenerated DESC, name ASC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SHOW CREATE VIEW `top_five_genres`;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP view `top_five_genres`;