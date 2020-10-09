-- 1) 
 SELECT name FROM users WHERE id IN (SELECT user_id FROM orders);

-- 2) 
SELECT products.name AS product_name, catalogs.name AS product_type 
  FROM products 
  LEFT JOIN catalogs 
    ON products.catalog_id = catalogs.id;

-- 3) 
SELECT flights.id, flights.from, flights.to
  FROM flights
  LEFT JOIN cities
    ON cities.label = flights.from
  LEFT JOIN cities as c
    ON c.label = flights.to