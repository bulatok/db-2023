CREATE TABLE orders
(
    orderId      INT,
    date         DATE,
    customerId   INT,
    customerName VARCHAR(15),
    city         VARCHAR(15),
    itemId       INT,
    itemName     VARCHAR(15),
    quantity     INT,
    price        REAL,
    PRIMARY KEY (orderId, customerId, itemId)
);

INSERT INTO orders
VALUES ('2301', '2011-02-23', '101', 'Martin', 'Prague', '3786', 'Net', '3', '35.00');
INSERT INTO orders
VALUES ('2301', '2011-02-23', '101', 'Martin', 'Prague', '4011', 'Racket', '6', '65.00');
INSERT INTO orders
VALUES ('2301', '2011-02-23', '101', 'Martin', 'Prague', '9132', 'Pack-3', '8', '4.75');
INSERT INTO orders
VALUES ('2302', '2012-02-25', '107', 'Herman', 'Madrid', '5794', 'Pack-6', '4', '5.00');
INSERT INTO orders
VALUES ('2303', '2011-11-27', '110', 'Pedro', 'Moscow', '4011', 'Racket', '2', '65.00');
INSERT INTO orders
VALUES ('2303', '2011-11-27', '110', 'Pedro', 'Moscow', '3141', 'Cover', '2', '10.00');

-- 1NF

-- 2NF
CREATE TABLE orders_items
(
    orderId  INT,
    itemId   INT,
    quantity INT,
    PRIMARY KEY (orderId, itemId)
);
INSERT INTO orders_items(orderId, itemId, quantity)
SELECT DISTINCT o.orderId, o.itemId, o.quantity
FROM orders AS o;

CREATE TABLE customers
(
    customerId   INT,
    customerName VARCHAR(15),
    city         VARCHAR(15),
    PRIMARY KEY (customerId)
);
INSERT INTO customers(customerId, customerName, city)
SELECT DISTINCT o.customerId, o.customerName, o.city
FROM orders AS o;

CREATE TABLE items
(
    itemId   INT,
    itemName VARCHAR(15),
    price    REAL,
    PRIMARY KEY (itemId)
);
INSERT INTO items(itemId, itemName, price)
SELECT DISTINCT o.itemId, o.itemName, o.price
FROM orders AS o;


CREATE TABLE orders_new
(
    orderId    INT,
    customerId INT,
    date       DATE
);
INSERT INTO orders_new(orderId, customerId, date)
SELECT DISTINCT o.orderId, o.customerId, o.date
FROM orders AS o;

DROP TABLE orders;

-- b

-- 1) Calculate the total amount to pay for the cheapest order
SELECT SUM(oi.quantity * i.price) as total
FROM orders_new
         JOIN orders_items oi on orders_new.orderId = oi.orderId
         JOIN items i on oi.itemId = i.itemId
GROUP BY oi.orderId
ORDER BY total
LIMIT 1;


-- 2) Obtain the customer name and city who purchased more items than the others
SELECT c.customerName, c.city
FROM customers c
WHERE c.customerId IN (SELECT orders_new.customerId
                       FROM orders_new
                                JOIN orders_items oi ON orders_new.orderId = oi.orderId
                                JOIN items i ON oi.itemId = i.itemId
                       GROUP BY oi.orderId, orders_new.customerId
                       ORDER BY SUM(oi.quantity) DESC
                       LIMIT 1)
