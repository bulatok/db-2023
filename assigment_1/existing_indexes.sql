CREATE INDEX film_fulltext_idx ON film USING gist (fulltext);
CREATE INDEX idx_actor_last_name ON actor USING btree (last_name);
CREATE INDEX idx_fk_address_id ON customer USING btree (address_id);
CREATE INDEX idx_fk_city_id ON address USING btree (city_id);
CREATE INDEX idx_fk_country_id ON city USING btree (country_id);
CREATE INDEX idx_fk_customer_id ON payment USING btree (customer_id);
CREATE INDEX idx_fk_film_id ON film_actor USING btree (film_id);
CREATE INDEX idx_fk_inventory_id ON rental USING btree (inventory_id);
CREATE INDEX idx_fk_language_id ON film USING btree (language_id);
CREATE INDEX idx_fk_rental_id ON payment USING btree (rental_id);
CREATE INDEX idx_fk_staff_id ON payment USING btree (staff_id);
CREATE INDEX idx_fk_store_id ON customer USING btree (store_id);
CREATE INDEX idx_last_name ON customer USING btree (last_name);
CREATE INDEX idx_store_id_film_id ON inventory USING btree (store_id, film_id);
CREATE INDEX idx_title ON film USING btree (title);

DROP INDEX film_fulltext_idx,
    idx_actor_last_name,
    idx_fk_address_id,
    idx_fk_city_id,
    idx_fk_country_id,
    idx_fk_customer_id,
    idx_fk_film_id,
    idx_fk_inventory_id,
    idx_fk_language_id,
    idx_fk_rental_id,
    idx_fk_staff_id,
    idx_fk_store_id,
    idx_last_name,
    idx_store_id_film_id,
    idx_title;
