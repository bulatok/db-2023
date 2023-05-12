CREATE INDEX IF NOT EXISTS idx_film_category_category_id ON film_category (category_id);
CREATE INDEX IF NOT EXISTS film_rating_idx ON film USING hash (rating);
CREATE INDEX IF NOT EXISTS category_name_idx ON category USING hash (name);
CREATE INDEX IF NOT EXISTS film_rate_desc_idx ON film (rental_rate DESC, length);
CREATE INDEX IF NOT EXISTS film_category_category_id_idx ON film_category (category_id);


DROP INDEX IF EXISTS
    idx_film_category_category_id,
    film_rating_idx,
    category_name_idx,
    film_category_category_id_idx,
    film_rate_desc_idx;

EXPLAIN ANALYSE
SELECT f.film_id, f.title, f.release_year, f.rental_rate
FROM film AS f,
     film_category AS fc,
     category AS c
WHERE (f.rating = 'G' OR f.rating = 'PG')
  AND f.language_id = 1
  AND (c.name =
       'Horror' OR c.name = 'Action')
ORDER BY f.rental_rate DESC, f.length ASC, fc.category_id ASC

-- BEFORE INDEXES
-- 1)
--     Planning Time: 1.740 ms
--     Execution Time: 2502.065 ms
-- 2)
--     Planning Time: 0.155 ms
--     Execution Time: 2432.102 ms

-- AFTER INDEXES
--     Planning Time: 0.169 ms
--     Execution Time: 2332.281 ms

--     Sort  (cost=92206.11..93891.11 rows=674000 width=33) (actual time=2604.823..2839.698 rows=744000 loops=1)
-- "  Sort Key: f.rental_rate DESC, f.length, fc.category_id"
--   Sort Method: external merge  Disk: 33696kB
--   ->  Nested Loop  (cost=0.00..8523.85 rows=674000 width=33) (actual time=0.054..193.921 rows=744000 loops=1)
--         ->  Seq Scan on film_category fc  (cost=0.00..16.00 rows=1000 width=2) (actual time=0.021..0.664 rows=1000 loops=1)
--         ->  Materialize  (cost=0.00..84.54 rows=674 width=31) (actual time=0.000..0.061 rows=744 loops=1000)
--               ->  Nested Loop  (cost=0.00..81.17 rows=674 width=31) (actual time=0.027..0.954 rows=744 loops=1)
--                     ->  Seq Scan on film f  (cost=0.00..71.50 rows=337 width=31) (actual time=0.013..0.589 rows=372 loops=1)
--                           Filter: ((language_id = 1) AND ((rating = 'G'::mpaa_rating) OR (rating = 'PG'::mpaa_rating)))
--                           Rows Removed by Filter: 628
--                     ->  Materialize  (cost=0.00..1.25 rows=2 width=0) (actual time=0.000..0.000 rows=2 loops=372)
--                           ->  Seq Scan on category c  (cost=0.00..1.24 rows=2 width=0) (actual time=0.008..0.012 rows=2 loops=1)
--                                 Filter: (((name)::text = 'Horror'::text) OR ((name)::text = 'Action'::text))
--                                 Rows Removed by Filter: 14
-- Planning Time: 0.245 ms
-- Execution Time: 2926.046 ms
