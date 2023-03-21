DROP FUNCTION get_addresses();
CREATE OR REPLACE FUNCTION get_addresses() RETURNS SETOF VARCHAR(50) AS
$$
        SELECT t.address
        FROM address AS t
        WHERE t.address LIKE '%11%' AND t.city_id BETWEEN 400 AND 600;
$$
    LANGUAGE SQL;

SELECT * FROM get_addresses();
-- 1145 Vilnius Manor
-- 1191 Tandil Drive
-- 1133 Rizhao Avenue
-- 1176 Southend-on-Sea Manor
-- 1411 Lillydale Drive
-- 1121 Loja Avenue
-- 117 Boa Vista Way
-- 1103 Bilbays Parkway
-- 1192 Tongliao Street
-- 114 Jalib al-Shuyukh Manor
-- 1197 Sokoto Boulevard
-- 1152 al-Qatif Lane
-- 1101 Bucuresti Boulevard
-- 1103 Quilmes Boulevard


ALTER TABLE address ADD COLUMN longitude FLOAT;
ALTER TABLE address ADD COLUMN latitude FLOAT;