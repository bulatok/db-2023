DROP INDEX IF EXISTS inventory_film_id_idx,
    film_category_category_id_idx,
    category_category_id_idx,
    customer_customer_id_idx,
    rental_customer_id_idx,
    inventory_inventory_id_film_id_idx,
    film_film_id_rating_idx,
    film_actor_actor_id_film_id_idx,
    actor_actor_id_first_name_idx;


DROP INDEX IF EXISTS
    idx_rental_date;


DROP INDEX IF EXISTS idx_rental_last_update, idx_payment_payment_id;

DROP INDEX IF EXISTS
    idx_film_category_category_id,
    film_rating_idx,
    category_name_idx,
    film_category_category_id_idx,
    film_rate_desc_idx;
