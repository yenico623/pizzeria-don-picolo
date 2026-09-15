/*
Funcion 1:
Función para calcular el total de un pedido (sumando precios de pizzas + costo de envío + IVA).
*/

DROP FUNCTION IF EXISTS calcular_total_pedido;
DELIMITER //
CREATE FUNCTION calcular_total_pedido(p_id_pedido INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
reads sql data
BEGIN
DECLARE v_subtotal DECIMAL (10,2) DEFAULT 0.00;
DECLARE v_costo_domicilio DECIMAL(10,2) DEFAULT 0.00;
DECLARE v_total_pagar DECIMAL(10,2) DEFAULT 0.00;

SELECT IFNULL(SUM(cantidad * precio_unitario),0.00)
INTO v_subtotal
FROM detalle_pedido
WHERE id_pedido_fk = p_id_pedido;

SELECT IFNULL(costo_envio, 0.00)
INTO v_costo_domicilio
FROM domicilio
WHERE id_pedido_fk = p_id_pedido;

SET v_total_pagar = (v_subtotal + v_costo_domicilio)*1.19;
RETURN v_total_pagar;
END //
DELIMITER ;
-- PRUEBAS DE EJECUCION
-- Prueba 1: Pedido N° 6 (Tiene 1 Hawaiana de 35,000 + Envío de 5,000 = 40,000 * 1.19 = 47,600)
SELECT calcular_total_pedido(6) AS total_pedido_6;

-- Prueba 2: Pedido N° 9 (Tiene 1 Pepperoni de 45,000 + Envío de 7,000 = 52,000 * 1.19 = 61,880)
SELECT calcular_total_pedido(9) AS total_pedido_9;

-- Prueba 3: Pedido N° 8 (Tiene 1 Margarita de 22,000, sin domicilio registrado = 22,000 * 1.19 = 26,180)
SELECT calcular_total_pedido(8) AS total_pedido_8;

/*
 Funcion 2: 
 Función para calcular la ganancia neta diaria (ventas - costos de ingredientes).
 */

DROP FUNCTION IF EXISTS calcular_ganancia_neta;
DELIMITER //
CREATE FUNCTION calcular_ganancia_neta(p_fecha DATE)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
DECLARE v_ingresos DECIMAL(10,2) DEFAULT 0.00;
DECLARE v_costo_ingredientes DECIMAL(10,2) DEFAULT 0.00;

SELECT IFNULL(SUM(total_pedido), 0.00)
INTO v_ingresos
FROM pedido
WHERE DATE(fecha_hora) = p_fecha AND estado_pedido != 'cancelado';

SELECT IFNULL(SUM(dp.cantidad * pi.cantidad * i.costo_unitario), 0.00)
INTO v_costo_ingredientes
FROM detalle_pedido dp
JOIN pedido p ON dp.id_pedido_fk = p.id_pedido
JOIN pizza_ingredientes pi ON dp.id_pizza_fk = pi.id_pizza_pk
JOIN ingredientes i ON pi.id_ingrediente_pk = i.id_ingrediente
WHERE DATE(p.fecha_hora) = p_fecha AND p.estado_pedido != 'cancelado';

RETURN (v_ingresos - v_costo_ingredientes);
END //
DELIMITER ;
-- PRUEBA 1: Día con ventas 
SELECT calcular_ganancia_neta('2026-09-01') AS ganancia_01_sep;

-- PRUEBA 2: Otro día con ventas registradas 
SELECT calcular_ganancia_neta('2026-09-02') AS ganancia_02_sep;

-- PRUEBA 3: Día sin ventas 
SELECT calcular_ganancia_neta('2026-09-15') AS ganancia_dia_sin_ventas;



/*
Prodecimiento: 
Procedimiento para cambiar automáticamente el estado del pedido a “entregado” cuando se registre la hora de entrega.
*/

DROP PROCEDURE IF EXISTS cambiar_estado_pedido;
DELIMITER //
CREATE PROCEDURE cambiar_estado_pedido(IN p_id_pedido INT)
BEGIN
DECLARE v_repartidor_id INT;

UPDATE pedido 
SET estado_pedido = 'entregado' 
WHERE id_pedido = p_id_pedido;

IF EXISTS (SELECT 1 FROM domicilio WHERE id_pedido_fk = p_id_pedido) THEN
UPDATE domicilio 
SET hora_entrega = NOW() 
WHERE id_pedido_fk = p_id_pedido;

ELSE
SELECT id_repartidores INTO v_repartidor_id FROM repartidores LIMIT 1;
INSERT INTO domicilio (hora_salida, hora_entrega, distancia, costo_envio,id_repartidores_fk, id_pedido_fk )
VALUES (NOW(), NOW(), 0.0, 0.00, v_repartidor_id,  p_id_pedido );
END IF;
END //
DELIMITER ;

-- PRUEBAS PROCEDIMIENTO
SELECT p.id_pedido, p.estado_pedido, d.hora_entrega 
FROM pedido p 
LEFT JOIN domicilio d ON p.id_pedido = d.id_pedido_fk 
WHERE p.id_pedido = 10;

CALL cambiar_estado_pedido(10);

SELECT * FROM PEDIDO;

