/*
CONSULTAS
*/

/*
Consulta 1: Clientes con pedidos entre dos fechas (BETWEEN).
*/
SELECT DISTINCT c.id_cliente, c.nombre, c.correo
FROM cliente c
JOIN pedido p ON c.id_cliente = p.id_cliente_pk
WHERE p.fecha_hora BETWEEN '2026-09-01 00:00:00' AND '2026-09-15 23:59:59';
 
 /*
 Pizzas más vendidas (GROUP BY y COUNT).
 */
SELECT p.nombre, COUNT(dp.id_pizza_fk) AS cantidad_vendida
FROM detalle_pedido dp
JOIN pizza p ON dp.id_pizza_fk = p.id_pizza
GROUP BY p.id_pizza, p.nombre
ORDER BY cantidad_vendida DESC;

/*
Pedidos por repartidor (JOIN).
*/
SELECT r.id_repartidores, r.nombre, COUNT(d.id_pedido_fk) AS total_pedidos
FROM repartidores r
JOIN domicilio d ON r.id_repartidores = d.id_repartidores_fk
GROUP BY r.id_repartidores, r.nombre
ORDER BY total_pedidos DESC;

/*
Promedio de entrega por zona (AVG y JOIN).
*/
SELECT d.distancia, AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS promedio_minutos
FROM domicilio d
WHERE d.hora_salida IS NOT NULL 
AND d.hora_entrega IS NOT NULL
AND TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega) BETWEEN 1 AND 180
GROUP BY d.distancia
ORDER BY d.distancia ASC;

/*
Clientes que gastaron más de un monto (HAVING)
*/
SELECT c.id_cliente, c.nombre, SUM(p.total_pedido) AS total_gastado
FROM cliente c
JOIN pedido p ON c.id_cliente = p.id_cliente_pk
GROUP BY c.id_cliente, c.nombre
HAVING total_gastado > 50000
ORDER BY total_gastado DESC;

/*
Búsqueda por coincidencia parcial de nombre de pizza (LIKE).
*/
SELECT id_pizza, nombre, precio_base
FROM pizza
WHERE nombre LIKE '%Especial%';

/*
Subconsulta para obtener los clientes frecuentes (más de 5 pedidos mensuales).
*/
SELECT c.id_cliente, c.nombre, c.correo
FROM cliente c
WHERE c.id_cliente IN (
SELECT p.id_cliente_pk
FROM pedido p
WHERE p.fecha_hora >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
GROUP BY p.id_cliente_pk
HAVING COUNT(p.id_pedido) >= 1
);

