DROP FUNCTION retrievecustomers;

CREATE OR REPLACE FUNCTION retrievecustomers(start INT, till INT) RETURNS SETOF customer AS
$$
BEGIN
    IF ($1 < 0 OR $1 > 600) THEN
        RAISE EXCEPTION 'start value % is invalid (must be in 0 and 600)', start;
    ELSIF ($2 < 0 OR $2 > 600) THEN
        RAISE EXCEPTION 'till value % is invalid (must be in 0 and 600)', till;
    END IF;
    RETURN QUERY
        SELECT *
        FROM customer
        WHERE customer_id BETWEEN $1 AND $2;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM retrievecustomers(10, 40)