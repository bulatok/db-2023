DROP INDEX IF EXISTS customer_name_idx, customer_address_idx;

-- Explore the generated data and try to query it on pgAdmin (or your
-- preferred tool)
SELECT customer.name
FROM customer;

-- Using explain capture the time that take to fetch the data
EXPLAIN ANALYSE
SELECT customer.name
FROM customer;

-- Create single-column b-tree and hash indexes on the previously created
-- table using any fields you like (but different fields for each!)
CREATE INDEX customer_name_idx ON customer (name);
CREATE INDEX customer_address_idx ON customer (address);

-- Using explain shows the elapsed time and the cost and compared with the
--     results obtained before the index creation.
EXPLAIN ANALYSE
SELECT *
FROM customer;

-- Is there any difference? Which queries are faster? (If you can’t see the
-- difference try to increase the generated data to 1M)

-- Summary
-- without one Planning Time: 0.035 ms | Execution Time: 105.819 ms
-- with index Planning Time: 0.285 ms  | Execution Time: 55.080 ms
-- we see that querying with indexes is two time faster