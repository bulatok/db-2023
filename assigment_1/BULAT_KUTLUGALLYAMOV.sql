-- 1
CREATE INDEX IF NOT EXISTS inventory_film_id_idx ON inventory (film_id); -- (store_id, film_id) exists
CREATE INDEX IF NOT EXISTS film_category_category_id_idx ON film_category (category_id);
CREATE INDEX IF NOT EXISTS category_category_id_idx ON category (category_id);
CREATE INDEX IF NOT EXISTS customer_customer_id_idx ON customer (customer_id);
CREATE INDEX IF NOT EXISTS rental_customer_id_idx ON rental (customer_id);
CREATE INDEX IF NOT EXISTS inventory_inventory_id_film_id_idx ON inventory (inventory_id, film_id); -- (store_id, film_id) exists
CREATE INDEX IF NOT EXISTS film_actor_actor_id_film_id_idx ON film_actor (actor_id, film_id); -- (film_id) exists
CREATE INDEX IF NOT EXISTS actor_actor_id_first_name_idx ON actor (actor_id, first_name);
CREATE INDEX IF NOT EXISTS film_rating_idx ON film USING hash (rating);
CREATE INDEX IF NOT EXISTS film_film_id_idx ON film USING hash (film_id);
CREATE INDEX IF NOT EXISTS customer_customer_id_idx ON customer USING hash (customer_id);
CREATE INDEX IF NOT EXISTS rental_customer_id_idx ON rental USING hash (customer_id);
CREATE INDEX IF NOT EXISTS rental_inventory_id_idx ON rental USING hash (inventory_id);
CREATE INDEX IF NOT EXISTS inventory_inventory_id_idx ON inventory USING hash (inventory_id);
CREATE INDEX IF NOT EXISTS film_actor_film_id_idx ON film_actor USING hash (film_id);
CREATE INDEX IF NOT EXISTS actor_actor_id_idx ON actor USING hash (actor_id);
CREATE INDEX IF NOT EXISTS film_actor_actor_id_idx ON film_actor USING hash (actor_id);
CREATE INDEX IF NOT EXISTS actor_first_name_idx ON actor USING hash (first_name);
CREATE INDEX IF NOT EXISTS customerv_first_name_idx ON customer USING hash (first_name);

-- 2
CREATE INDEX IF NOT EXISTS idx_rental_date ON rental (rental_date);
CREATE INDEX IF NOT EXISTS payment_rental_id_idx ON payment (rental_id);

-- 3
CREATE INDEX IF NOT EXISTS idx_rental_rental_id_staff_id_last_update ON rental (rental_id, staff_id, last_update);
CREATE INDEX IF NOT EXISTS idx_payment_rental_id_payment_date ON payment (rental_id, payment_date);
CREATE INDEX IF NOT EXISTS idx_customer_customer_id_active ON customer (customer_id);
CREATE INDEX IF NOT EXISTS idx_rental_last_update ON rental(last_update);

-- 4
CREATE INDEX IF NOT EXISTS idx_film_category_category_id ON film_category (category_id);
CREATE INDEX IF NOT EXISTS film_rating_idx ON film USING hash (rating);
CREATE INDEX IF NOT EXISTS category_name_idx ON category USING hash (name);
CREATE INDEX IF NOT EXISTS film_rate_desc_idx ON film (rental_rate DESC, length);
CREATE INDEX IF NOT EXISTS film_category_category_id_idx ON film_category (category_id);
