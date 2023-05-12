CREATE INDEX IF NOT EXISTS idx_rental_last_update ON rental(last_update);
CREATE INDEX IF NOT EXISTS idx_customer_id_rental ON rental USING hash(customer_id);
CREATE INDEX IF NOT EXISTS idx_customer_id_customer ON customer USING hash(customer_id);
CREATE INDEX IF NOT EXISTS idx_rental_id_rental ON rental USING hash(rental_id);
CREATE INDEX IF NOT EXISTS idx_payment_payment_id ON payment USING hash(rental_id);

drop index idx_rental_last_update, idx_customer_id_rental,
    idx_customer_id_customer, idx_rental_id_rental, idx_payment_payment_id;
DROP INDEX IF EXISTS idx_rental_last_update,idx_payment_payment_id;


CREATE INDEX idx_rental_rental_id_staff_id_last_update ON rental (rental_id, staff_id, last_update);
CREATE INDEX idx_payment_rental_id_payment_date ON payment (rental_id, payment_date);
CREATE INDEX idx_customer_customer_id_active ON customer (customer_id);
CREATE INDEX IF NOT EXISTS idx_rental_last_update ON rental(last_update);


EXPLAIN ANALYSE
SELECT r1.staff_id, p1.payment_date, r1.rental_id
FROM rental r1,
     payment p1
WHERE r1.rental_id = p1.rental_id
  AND NOT EXISTS (SELECT 1
                  FROM rental r2,
                       customer c
                  WHERE r2.customer_id = c.customer_id
                    AND active = 1
                    AND r2.last_update > r1.last_update);

-- BEFORE INDEXES
-- 1)
-- Planning Time: 3.283 ms
-- Execution Time: 27565.321 ms
-- 2)
-- Planning Time: 0.414 ms
-- Execution Time: 33683.080 ms

-- AFTER INDEXES
-- Planning Time: 0.596 ms
-- Execution Time: 32.373 ms

-- Nested Loop Anti Join  (cost=534.78..2284549.49 rows=9731 width=14) (actual time=8915.110..28056.653 rows=1 loops=1)
--   Join Filter: (r2.last_update > r1.last_update)
--   Rows Removed by Join Filter: 200448775
--   ->  Hash Join  (cost=510.99..803.28 rows=14596 width=22) (actual time=5.200..37.333 rows=14596 loops=1)
--         Hash Cond: (p1.rental_id = r1.rental_id)
--         ->  Seq Scan on payment p1  (cost=0.00..253.96 rows=14596 width=12) (actual time=0.009..9.281 rows=14596 loops=1)
--         ->  Hash  (cost=310.44..310.44 rows=16044 width=14) (actual time=5.172..5.173 rows=16044 loops=1)
--               Buckets: 16384  Batches: 1  Memory Usage: 881kB
--               ->  Seq Scan on rental r1  (cost=0.00..310.44 rows=16044 width=14) (actual time=0.005..2.409 rows=16044 loops=1)
--   ->  Materialize  (cost=23.79..454.85 rows=15642 width=8) (actual time=0.000..0.802 rows=13734 loops=14596)
--         ->  Hash Join  (cost=23.79..376.64 rows=15642 width=8) (actual time=0.230..5.890 rows=15640 loops=1)
--               Hash Cond: (r2.customer_id = c.customer_id)
--               ->  Seq Scan on rental r2  (cost=0.00..310.44 rows=16044 width=10) (actual time=0.012..1.576 rows=16044 loops=1)
--               ->  Hash  (cost=16.49..16.49 rows=584 width=4) (actual time=0.204..0.205 rows=584 loops=1)
--                     Buckets: 1024  Batches: 1  Memory Usage: 29kB
--                     ->  Seq Scan on customer c  (cost=0.00..16.49 rows=584 width=4) (actual time=0.007..0.119 rows=584 loops=1)
--                           Filter: (active = 1)
--                           Rows Removed by Filter: 15
-- Planning Time: 0.373 ms
-- Execution Time: 28056.891 ms
