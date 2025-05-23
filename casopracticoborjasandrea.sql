--ANDREA LIZETH BORJAS LORENZANO. 
--CASO PRÁCTICO; SQL. 


--B.

Select * from menu_items;

--Encontrar el numero de articulos en el menu.
SELECT COUNT(*) AS total_articulos
FROM menu_items;
--¿Cual es el artículo menos caro y el más caro en el menú?
--menos caro
SELECT item_name,price
FROM menu_items
ORDER BY price ASC 
LIMIT 1; 
--más caro
SELECT item_name,price
FROM menu_items
ORDER BY price DESC 
LIMIT 1; 
--Respuesta completa.
(SELECT 'Menos caro' AS type, item_name,price
FROM menu_items
ORDER BY price ASC
LIMIT 1)
UNION
(SELECT 'Mas caro' AS type, item_name,price
FROM menu_items
ORDER BY price DESC
LIMIT 1);
--¿Cuantos platos americanos hay en el menu?
SELECT COUNT (*) AS total_platos_americanos
FROM menu_items
WHERE category ILIKE 'American';

--¿Cual es el precio promedio de los platos?
SELECT AVG(price) AS precio_promedio
FROM menu_items;
--C.

Select * from order_details;

--¿Cuántos pedidos únicos se realizaron en total?
Select COUNT(*) AS pedidos_unicos
FROM order_details;
--¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?
SELECT order_id, COUNT(*) AS total_articulos
FROM order_details
GROUP BY order_id
ORDER BY total_articulos DESC
LIMIT 5; 
--¿Cuándo se realizó el primer pedido y el último pedido?
SELECT 
MIN(order_date) AS primer_pedido,
MAX(order_date) AS ultimo_pedido
FROM order_details;

--¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?
SELECT COUNT(DISTINCT order_id) AS total_pedidos
FROM order_details
WHERE order_date BETWEEN '2023-01-01' AND '2023-01-05';
--D.
-- Realizar un left join entre order_details y menu_items con el identificador
-- item_id(tabla order_details) y menu_item_id(tabla menu_items).
SELECT 
od.order_details_id,
od.order_id,
od.order_date,
od.order_time,
od.item_id,
mi.menu_item_id,
mi.item_name,
mi.category,
mi.price
FROM order_details od
LEFT JOIN menu_items mi 
ON od.item_id = mi.menu_item_id;

--E.
--Una vez que hayas explorado los datos en las tablas correspondientes y respondido las
-- preguntas planteadas, realiza un análisis adicional utilizando este join entre las tablas. El
-- objetivo es identificar 5 puntos clave que puedan ser de utilidad para los dueños del
-- restaurante en el lanzamiento de su nuevo menú. Para ello, crea tus propias consultas y
-- utiliza los resultados obtenidos para llegar a estas conclusiones.

--1.Artículos más vendidos del menú. Top 5.
--Se logra observar que los artículos más vendidos del menú son: 
--Hamburger, Edamame, Korean Beef Bowl, Cheeseburger y French Fries. 
SELECT
mi.item_name,
mi.category,
COUNT(*) AS veces_vendido
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name, mi.category
ORDER BY veces_vendido DESC
LIMIT 5;
--2.Total de ingresos generados por cada artículo.
--Se logra observar que en el total de ingresos generados por artículo
--quien más genera ingresos es Korean Beef Bowl, Spaghetti & Meatballs,
--Tofu Pad Thai, Cheeseburger, y Hamburguer considerando los primeros 5. 
SELECT 
mi.item_name,
mi.category,
COUNT(*) AS cantidad_vendida,
COALESCE(MI.PRICE,0) AS precio_unitario,
COUNT(*) * COALESCE (mi.price,0) AS ingreso_total
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name, mi.category, mi.price
ORDER BY ingreso_total DESC
LIMIT 5;
--3.Pedidos por categoría del menú. 
--Es importante mencionar que la categoría más solicitada 
--considerando el total de artículos es Asian, Italian, Mexican, 
--y por último American. 
SELECT
mi.category,
COUNT(*) AS total_articulos
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
WHERE mi.category IS NOT NULL
GROUP BY mi.category
ORDER BY total_articulos DESC;

--4.Artículos del menú con menor número de ventas. 
--Se logra observar que el menor número de ventas, 
--Fue Chicken Tacos, continuando con Poststickers, Cheese Lasagna, Steak Tacos, 
-- y Cheese Quesadillas, siendo los 5 artículos menos vendidos. 
SELECT 
mi.item_name,
mi.category,
COUNT(od.item_id) AS cantidad_vendida
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
Where mi.item_name IS NOT NULL
GROUP BY mi.item_name, mi.category
ORDER BY cantidad_vendida ASC
LIMIT 5;

--5.Tendencias de venta por fecha con más ingresos.
--Permite observar el día con mayor ingresos que fue 
--el '2023-02-01', continuando con el '2023-03-17',
--el '2023-01-08',el '2023-03-13', el '2023-02-27'.
--Siendo las 5 fechas con mayor venta. 
SELECT 
od.order_date,
SUM(mi.price) AS ingresos_totales
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id =mi.menu_item_id
WHERE od.order_date IS NOT NULL
GROUP BY od.order_date
ORDER BY ingresos_totales DESC
LIMIT 5;