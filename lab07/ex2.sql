-- 1
SELECT *
FROM film AS f
         JOIN film_category fc on f.film_id = fc.film_id
         JOIN category c on fc.category_id = c.category_id
WHERE (rating = 'R' OR rating = 'PG-13')
  AND (c.name = 'Horror' OR c.name = 'Sci-fi')
  AND f.film_id NOT IN (SELECT ff.film_id
                        FROM film AS ff
                                 JOIN inventory i on ff.film_id = i.film_id
                                 JOIN rental r on i.inventory_id = r.inventory_id);

-- 2
SELECT c.city, SUM(p.amount)
FROM store
         JOIN address a on store.address_id = a.address_id
         JOIN city c on a.city_id = c.city_id
         JOIN staff s on a.address_id = s.address_id
         JOIN payment p on s.staff_id = p.staff_id
WHERE p.payment_date >= Date('2007-05-01')
GROUP BY c.city
ORDER BY SUM(p.amount) DESC
LIMIT 1;


-- 1
EXPLAIN
SELECT *
FROM film AS f
         JOIN film_category fc on f.film_id = fc.film_id
         JOIN category c on fc.category_id = c.category_id
WHERE (rating = 'R' OR rating = 'PG-13')
  AND (c.name = 'Horror' OR c.name = 'Sci-fi')
  AND f.film_id NOT IN (SELECT ff.film_id
                        FROM film AS ff
                                 JOIN inventory i on ff.film_id = i.film_id
                                 JOIN rental r on i.inventory_id = r.inventory_id);

-- Looking at the given query execution plan,
--     the most expensive step is the Hash Join between
--     the rental, inventory, and film tables, as it has a cost of 204.57..620.53 and is estimated to return 16900 rows.

-- One possible solution to optimize this query could be to create indexes on the columns used in the join condition. For example, we can create an index on the inventory_id column in the rental table,
--     and another index on the film_id column in the inventory table.

EXPLAIN
SELECT c.city, SUM(p.amount)
FROM store
         JOIN address a on store.address_id = a.address_id
         JOIN city c on a.city_id = c.city_id
         JOIN staff s on a.address_id = s.address_id
         JOIN payment p on s.staff_id = p.staff_id
WHERE p.payment_date >= Date('2007-05-01')
GROUP BY c.city
ORDER BY SUM(p.amount) DESC
LIMIT 1;


-- Looking at the given query execution plan,
-- the most expensive step is the Bitmap Heap Scan on the payment table,
-- as it has a cost of 80.59..305.59 and is estimated to return 98 rows.
-- One possible solution to optimize this query could be to create an index on the staff_id and payment_date columns used in the query.
-- For example, we can create the following index: