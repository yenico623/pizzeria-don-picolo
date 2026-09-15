/*
VISTAS
*/

/*
Vista de resumen de pedidos por cliente (nombre del cliente, cantidad de pedidos, total gastado).
*/
CREATE OR REPLACE VIEW vista_resumen_cliente AS
SELECT c.id_cliente, c.nombre, COUNT(p.id_pedido) AS cantidad_pedidos, SUM(p.total_pedido) AS total_gastado
FROM cliente c
JOIN pedido p ON c.id_cliente = p.id_cliente_pk
GROUP BY c.id_cliente, c.nombre;

-- PRUEBA
SELECT * FROM vista_resumen_cliente;

/*
Vista de desempeño de repartidores (número de entregas, tiempo promedio, zona).
*/
CREATE OR REPLACE VIEW vista_desempeno_repartidores AS
SELECT r.id_repartidores, r.nombre, COUNT(d.id_pedido_fk) AS numero_entregas, AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS tiempo_promedio_minutos, d.distancia
FROM repartidores r
JOIN domicilio d ON r.id_repartidores = d.id_repartidores_fk
WHERE d.hora_salida IS NOT NULL 
AND d.hora_entrega IS NOT NULL
AND TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega) BETWEEN 1 AND 180
GROUP BY r.id_repartidores, r.nombre, d.distancia;

-- PUERBA
SELECT * FROM vista_desempeno_repartidores;

/*
Vista de stock de ingredientes por debajo del mínimo permitido.
*/
CREATE OR REPLACE VIEW vista_ingredientes_bajo_stock AS
SELECT id_ingrediente, nombre, stock, stock_minimo
FROM ingredientes
WHERE stock < stock_minimo;

SELECT * FROM vista_ingredientes_bajo_stock;