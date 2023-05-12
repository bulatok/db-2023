CREATE INDEX IF NOT EXISTS inventory_film_id_idx ON inventory (film_id); -- (store_id, film_id) exists
CREATE INDEX IF NOT EXISTS film_category_category_id_idx ON film_category (category_id);
CREATE INDEX IF NOT EXISTS category_category_id_idx ON category (category_id);
CREATE INDEX IF NOT EXISTS customer_customer_id_idx ON customer (customer_id);
CREATE INDEX IF NOT EXISTS rental_customer_id_idx ON rental (customer_id);
CREATE INDEX IF NOT EXISTS inventory_inventory_id_film_id_idx ON inventory (inventory_id, film_id); -- (store_id, film_id) exists
CREATE INDEX IF NOT EXISTS film_film_id_rating_idx ON film (film_id, rating);
CREATE INDEX IF NOT EXISTS film_actor_actor_id_film_id_idx ON film_actor (actor_id, film_id); -- (film_id) exists
CREATE INDEX IF NOT EXISTS actor_actor_id_first_name_idx ON actor (actor_id, first_name);

CREATE INDEX payment_rental_id_idx ON payment (rental_id);


DROP INDEX IF EXISTS inventory_film_id_idx;
DROP INDEX IF EXISTS film_category_category_id_idx;
DROP INDEX IF EXISTS category_category_id_idx;
DROP INDEX IF EXISTS customer_customer_id_idx;
DROP INDEX IF EXISTS rental_customer_id_idx;
DROP INDEX IF EXISTS inventory_inventory_id_film_id_idx;
DROP INDEX IF EXISTS film_film_id_rating_idx;
DROP INDEX IF EXISTS film_actor_actor_id_film_id_idx;
DROP INDEX IF EXISTS actor_actor_id_first_name_idx, payment_rental_id_idx;

EXPLAIN ANALYSE SELECT tc.first_name AS top_customer_first_name,
       tc.last_name AS top_customer_last_name,
       tf.title AS top_film_title,
       cf.first_name AS customer_first_name,
       cf.last_name AS customer_last_name,
       cf.title AS customer_film_title,
       cf.rental_date AS customer_rental_date,
       cf.amount AS customer_rental_amount
FROM
    (SELECT c.first_name, c.last_name,
            (SELECT COUNT(*)
             FROM rental r
             WHERE c.customer_id = r.customer_id
               AND r.rental_date >= '2023-01-01'
               AND r.rental_date < '2023-02-01') AS rental_count
     FROM customer c
     ORDER BY rental_count DESC LIMIT 100) tc
        CROSS JOIN
    (SELECT f.title,
            (SELECT COUNT(*)
             FROM rental r
                      INNER JOIN inventory i ON r.inventory_id = i.inventory_id
             WHERE i.film_id = f.film_id
               AND r.rental_date >= '2023-01-01'
               AND r.rental_date < '2023-02-01') AS rental_count
     FROM film f
     ORDER BY rental_count DESC LIMIT 100) tf
        INNER JOIN
    (SELECT c.first_name, c.last_name, f.title, r.rental_date, p.amount
     FROM customer c
              INNER JOIN rental r ON c.customer_id = r.customer_id
              INNER JOIN payment p ON r.rental_id = p.rental_id
              INNER JOIN inventory i ON r.inventory_id = i.inventory_id
              INNER JOIN film f ON i.film_id = f.film_id
     WHERE r.rental_date >= '2023-01-01' AND r.rental_date < '2023-02-01') cf
    ON tc.first_name = cf.first_name
        AND tc.last_name = cf.last_name
        AND tf.title = cf.title
ORDER BY tc.rental_count DESC,
         tf.rental_count DESC,
         cf.rental_date ASC;
-- BEFORE INDEXES
-- 1)
-- Planning Time: 4.858 ms
-- Execution Time: 4408.479 ms

-- 2)
-- Planning Time: 2.763 ms
-- Execution Time: 620.026 ms

-- AFTER INDEXES
-- Planning Time: 3.516 ms
-- Execution Time: 404.979 ms


-- GroupAggregate  (cost=193669.21..193724.14 rows=16 width=100) (actual time=451.383..454.405 rows=16 loops=1)
--   Group Key: c.name
--   ->  Sort  (cost=193669.21..193687.45 rows=7298 width=74) (actual time=451.143..452.074 rows=14596 loops=1)
--         Sort Key: c.name
--         Sort Method: quicksort  Memory: 1197kB
--         ->  Hash Join  (cost=438.63..193200.92 rows=7298 width=74) (actual time=6.445..445.650 rows=14596 loops=1)
--               Hash Cond: (fc.category_id = c.category_id)
--               ->  Nested Loop  (cost=437.27..193175.33 rows=7298 width=8) (actual time=6.417..441.690 rows=14596 loops=1)
--                     Join Filter: (i.film_id = fc.film_id)
--                     ->  Hash Join  (cost=436.98..192784.04 rows=7298 width=12) (actual time=6.396..427.795 rows=14596 loops=1)
--                           Hash Cond: (r.rental_id = p.rental_id)
--                           ->  Nested Loop  (cost=0.57..192204.46 rows=8022 width=10) (actual time=0.789..413.391 rows=16044 loops=1)
--                                 ->  Nested Loop  (cost=0.29..190939.98 rows=2290 width=10) (actual time=0.770..394.975 rows=4581 loops=1)
--                                       ->  Seq Scan on inventory i  (cost=0.00..70.81 rows=4581 width=6) (actual time=0.004..0.589 rows=4581 loops=1)
--                                       ->  Memoize  (cost=0.29..199.18 rows=1 width=4) (actual time=0.086..0.086 rows=1 loops=4581)
--                                             Cache Key: i.film_id
--                                             Cache Mode: logical
--                                             Hits: 3623  Misses: 958  Evictions: 0  Overflows: 0  Memory Usage: 96kB
--                                             ->  Index Only Scan using film_pkey on film f  (cost=0.28..199.17 rows=1 width=4) (actual time=0.407..0.407 rows=1 loops=958)
--                                                   Index Cond: (film_id = i.film_id)
--                                                   Filter: (NOT (SubPlan 1))
--                                                   Heap Fetches: 958
--                                                   SubPlan 1
--                                                     ->  GroupAggregate  (cost=198.80..198.83 rows=1 width=14) (actual time=0.404..0.404 rows=0 loops=958)
--                                                           Group Key: c_1.first_name
--                                                           Filter: (count(*) > 2)
--                                                           Rows Removed by Filter: 0
--                                                           ->  Sort  (cost=198.80..198.81 rows=1 width=6) (actual time=0.402..0.402 rows=0 loops=958)
--                                                                 Sort Key: c_1.first_name
--                                                                 Sort Method: quicksort  Memory: 25kB
--                                                                 ->  Nested Loop  (cost=11.65..198.79 rows=1 width=6) (actual time=0.395..0.400 rows=0 loops=958)
--                                                                       ->  Nested Loop  (cost=11.37..190.49 rows=1 width=10) (actual time=0.387..0.399 rows=0 loops=958)
--                                                                             ->  Hash Join  (cost=11.09..186.51 rows=6 width=12) (actual time=0.228..0.391 rows=3 loops=958)
--                                                                                   Hash Cond: ((c_1.first_name)::text = (a.first_name)::text)
--                                                                                   ->  Nested Loop  (cost=4.59..179.82 rows=18 width=8) (actual time=0.179..0.386 rows=17 loops=958)
--                                                                                         ->  Nested Loop  (cost=4.32..174.49 rows=18 width=4) (actual time=0.176..0.355 rows=17 loops=958)
--                                                                                               ->  Seq Scan on inventory i1  (cost=0.00..82.26 rows=5 width=6) (actual time=0.153..0.299 rows=5 loops=958)
--                                                                                                     Filter: (film_id = f.film_id)
--                                                                                                     Rows Removed by Filter: 4576
--                                                                                               ->  Bitmap Heap Scan on rental r2  (cost=4.32..18.41 rows=4 width=6) (actual time=0.004..0.006 rows=4 loops=4581)
--                                                                                                     Recheck Cond: (inventory_id = i1.inventory_id)
--                                                                                                     Heap Blocks: exact=16036
--                                                                                                     ->  Bitmap Index Scan on idx_fk_inventory_id  (cost=0.00..4.32 rows=4 width=0) (actual time=0.002..0.002 rows=4 loops=4581)
--                                                                                                           Index Cond: (inventory_id = i1.inventory_id)
--                                                                                         ->  Index Scan using customer_pkey on customer c_1  (cost=0.28..0.30 rows=1 width=10) (actual time=0.001..0.001 rows=1 loops=16044)
--                                                                                               Index Cond: (customer_id = r2.customer_id)
--                                                                                   ->  Hash  (cost=4.00..4.00 rows=200 width=10) (actual time=0.092..0.092 rows=200 loops=1)
--                                                                                         Buckets: 1024  Batches: 1  Memory Usage: 17kB
--                                                                                         ->  Seq Scan on actor a  (cost=0.00..4.00 rows=200 width=10) (actual time=0.007..0.033 rows=200 loops=1)
--                                                                             ->  Index Only Scan using film_actor_pkey on film_actor fa  (cost=0.28..0.64 rows=1 width=4) (actual time=0.002..0.002 rows=0 loops=2986)
--                                                                                   Index Cond: ((actor_id = a.actor_id) AND (film_id = f.film_id))
--                                                                                   Heap Fetches: 0
--                                                                       ->  Index Scan using film_pkey on film f1  (cost=0.28..8.29 rows=1 width=4) (actual time=0.003..0.003 rows=0 loops=65)
--                                                                             Index Cond: (film_id = f.film_id)
-- "                                                                            Filter: (rating = ANY ('{PG-13,NC-17}'::mpaa_rating[]))"
--                                                                             Rows Removed by Filter: 1
--                                 ->  Index Scan using idx_fk_inventory_id on rental r  (cost=0.29..0.51 rows=4 width=8) (actual time=0.002..0.003 rows=4 loops=4581)
--                                       Index Cond: (inventory_id = i.inventory_id)
--                           ->  Hash  (cost=253.96..253.96 rows=14596 width=10) (actual time=5.594..5.594 rows=14596 loops=1)
--                                 Buckets: 16384  Batches: 1  Memory Usage: 756kB
--                                 ->  Seq Scan on payment p  (cost=0.00..253.96 rows=14596 width=10) (actual time=0.010..2.305 rows=14596 loops=1)
--                     ->  Memoize  (cost=0.29..0.39 rows=1 width=4) (actual time=0.000..0.001 rows=1 loops=14596)
--                           Cache Key: f.film_id
--                           Cache Mode: logical
--                           Hits: 13638  Misses: 958  Evictions: 0  Overflows: 0  Memory Usage: 98kB
--                           ->  Index Only Scan using film_category_pkey on film_category fc  (cost=0.28..0.38 rows=1 width=4) (actual time=0.003..0.003 rows=1 loops=958)
--                                 Index Cond: (film_id = f.film_id)
--                                 Heap Fetches: 958
--               ->  Hash  (cost=1.16..1.16 rows=16 width=72) (actual time=0.016..0.017 rows=16 loops=1)
--                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                     ->  Seq Scan on category c  (cost=0.00..1.16 rows=16 width=72) (actual time=0.009..0.011 rows=16 loops=1)
-- Planning Time: 3.261 ms
-- Execution Time: 454.762 ms
