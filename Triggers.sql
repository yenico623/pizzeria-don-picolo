USE `pizzeria-don-picolo`;

/*
Trigger 1: Trigger de actualización automática de stock de ingredientes cuando se realiza un pedido
*/
DROP TRIGGER IF EXISTS descontar_stock_ingredientes;
DELIMITER //
CREATE TRIGGER descontar_stock_ingredientes
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
UPDATE ingredientes i
JOIN pizza_ingredientes pi ON i.id_ingrediente = pi.id_ingrediente_pk
SET i.stock = i.stock - (pi.cantidad * NEW.cantidad)
WHERE pi.id_pizza_pk = NEW.id_pizza_fk;
END //
DELIMITER ;

-- PRUEBA
SELECT i.nombre, i.stock 
FROM ingredientes i
JOIN pizza_ingredientes pi ON i.id_ingrediente = pi.id_ingrediente_pk
WHERE pi.id_pizza_pk = 1;

INSERT INTO detalle_pedido (cantidad, precio_unitario, id_pizza_fk, id_pedido_fk)
SELECT 2, 35000.00, 1, id_pedido 
FROM pedido 
LIMIT 1;

/*
Trigger 2: Trigger de auditoría que registre en una tabla historial_precios cada vez que se modifique el precio de una pizza.
*/
DROP TRIGGER IF EXISTS auditoria_precio;
DELIMITER //
CREATE TRIGGER auditoria_precio
AFTER UPDATE ON pizza
FOR EACH ROW
BEGIN
IF OLD.precio_base <> NEW.precio_base THEN
INSERT INTO historial_precios (id_pizza, precio_anterior, precio_nuevo, fecha_cambio)
VALUES (OLD.id_pizza, OLD.precio_base, NEW.precio_base, NOW());
END IF;
END //
DELIMITER ;

-- PRUEBAS
UPDATE pizza SET precio_base = 34000.00 WHERE id_pizza = 1;
SELECT * FROM historial_precios;

/*
Trigger 3: 
Trigger para marcar repartidor como “disponible” nuevamente cuando termina un domicilio.
*/


DROP TRIGGER IF EXISTS marcar_repartidor;
DELIMITER //
CREATE TRIGGER marcar_repartidor
AFTER UPDATE ON pedido
FOR EACH ROW
BEGIN
IF OLD.estado_pedido <> NEW.estado_pedido AND NEW.estado_pedido = 'entregado' THEN
UPDATE repartidores r
JOIN domicilio d ON r.id_repartidores = d.id_repartidores_fk
SET r.estado = 'disponible'
WHERE d.id_pedido_fk = NEW.id_pedido;
END IF;
END //

DELIMITER ;

-- PRUEBAS

SELECT id_repartidores, nombre, estado FROM repartidores;

UPDATE pedido p
JOIN domicilio d ON p.id_pedido = d.id_pedido_fk
SET p.estado_pedido = 'pendiente'
WHERE d.id_repartidores_fk = 9; 


UPDATE repartidores SET estado = 'no_disponible' WHERE id_repartidores = 9;

UPDATE pedido p
JOIN domicilio d ON p.id_pedido = d.id_pedido_fk
SET p.estado_pedido = 'entregado'
WHERE d.id_repartidores_fk = 9;

SELECT id_repartidores, nombre, estado FROM repartidores WHERE id_repartidores = 10;