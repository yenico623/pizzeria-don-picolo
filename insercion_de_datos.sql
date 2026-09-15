
USE `pizzeria-don-picolo`;

-- 1. INSERCIÓN DE CLIENTES
INSERT INTO cliente (nombre, telefono, direccion, correo) VALUES
('Carlos Mendoza', '3151234567', 'Calle 35 #12-45, Cabecera', 'carlos.mendoza@email.com'),
('Laura Gómez', '3189876543', 'Carrera 27 #45-10, Real de Minas', 'laura.gomez@email.com'),
('Andrés Rodríguez', '3005551234', 'Calle 10 #15-30, Cañaveral', 'andres.r@email.com'),
('Diana Martínez', '3124448899', 'Carrera 33 #52-05, Altos de Cabecera', 'diana.m@email.com'),
('Javier Torres', '3176663322', 'Calle 50 #22-18, Centro', 'javier.torres@email.com');

desc cliente;
select * from cliente;

-- 2. INSERCIÓN DE REPARTIDORES
INSERT INTO repartidores (nombre, zona_asignada, estado) VALUES
('Juan Pérez', 'Cabecera', 'disponible'),
('Mateo Silva', 'Cañaveral', 'disponible'),
('Santiago Ruíz', 'Centro', 'no_disponible'),
('Camilo Vargas', 'Real de Minas', 'disponible');

desc repartidores;
select * from repartidores;

-- 3. INSERCIÓN DE INGREDIENTES
INSERT INTO ingredientes (nombre, stock, disponibilidad) VALUES
('Queso Mozzarella', 50, 1),
('Salsa de Tomate', 40, 1),
('Pepperoni', 30, 1),
('Jamón', 25, 1),
('Champiñones', 15, 1),
('Pimentón', 20, 1),
('Masa Tradicional', 60, 1),
('Piña', 0, 0); -- Ingrediente agotado para probar lógica de stock

desc ingredientes;
select * from ingredientes;


-- 4. INSERCIÓN DE PIZZAS
INSERT INTO pizza (nombre, tamaño, precio_base, tipo) VALUES
('Hawaiana Especial', 'mediana', 35000.00, 'especial'),
('Pepperoni Suprema', 'familiar', 45000.00, 'clasica'),
('Vegetariana Huerta', 'mediana', 32000.00, 'vegetariana'),
('Margarita Clásica', 'pequeña', 22000.00, 'clasica'),
('Cuatro Estaciones', 'familiar', 48000.00, 'especial');

desc pizza;
select * from pizza;

-- 5. INSERCIÓN DE RECETAS (pizza_ingredientes)
INSERT INTO pizza_ingredientes (id_pizza_pk, id_ingrediente_pk, cantidad) VALUES
(1, 1, 2), -- Hawaiana usa Mozzarella
(1, 2, 1), -- Hawaiana usa Salsa
(1, 4, 1), -- Hawaiana usa Jamón
(2, 1, 3), -- Pepperoni Suprema usa Mozzarella
(2, 2, 1), -- Pepperoni Suprema usa Salsa
(2, 3, 2), -- Pepperoni Suprema usa Pepperoni
(3, 1, 2), -- Vegetariana usa Mozzarella
(3, 2, 1), -- Vegetariana usa Salsa
(3, 5, 2), -- Vegetariana usa Champiñones
(3, 6, 1); -- Vegetariana usa Pimentón

desc pizza_ingredientes;
select *  from pizza_ingredientes;

-- 6. INSERCIÓN DE PEDIDOS
INSERT INTO pedido (fecha_hora, medio_pago, total_pedido, estado_pedido, id_cliente_pk) VALUES
('2026-09-01 19:30:00', 'efectivo', 35000.00, 'entregado', 1),
('2026-09-02 20:15:00', 'tarjeta', 45000.00, 'entregado', 2),
('2026-09-03 13:00:00', 'app', 32000.00, 'entregado', 3),
('2026-09-05 21:10:00', 'efectivo', 22000.00, 'en_preparación', 1),
('2026-09-08 18:45:00', 'tarjeta', 48000.00, 'pendiente', 4);

desc pedido;
select * from pedido;

-- 7. INSERCIÓN EN DETALLE_PEDIDO

ALTER TABLE detalle_pedido CHANGE COLUMN id_cliente_fk id_pedido_fk INT NOT NULL;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM detalle_pedido;
INSERT INTO detalle_pedido (cantidad, precio_unitario, id_pedido_fk, id_pizza_fk) VALUES
(1, 35000.00, 6, 1),
(1, 45000.00, 9, 2),
(1, 32000.00, 7, 3),
(1, 22000.00, 8, 4),
(1, 48000.00, 10, 5);

ALTER TABLE detalle_pedido DROP FOREIGN KEY detalle_pedido_fk_2;

ALTER TABLE detalle_pedido 
ADD CONSTRAINT fk_detalle_pedido_pedido 
FOREIGN KEY (id_pedido_fk) REFERENCES pedido(id_pedido);


SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 1;

desc detalle_pedido;
select * from detalle_pedido;

-- 8. INSERCIÓN EN DOMICILIOS
ALTER TABLE domicilio CHANGE COLUMN pedido_id_pedido id_pedido_fk INT NOT NULL;

INSERT INTO domicilio (hora_salida, hora_entrega, distancia, costo_envio, id_pedido_fk, id_repartidores_fk) VALUES
('2026-09-01 19:40:00', '2026-09-01 20:05:00', 3.50, 5000.00, 6, 9),
('2026-09-02 20:25:00', '2026-09-02 20:50:00', 5.20, 7000.00, 9, 10),
('2026-09-03 13:10:00', '2026-09-03 13:30:00', 2.10, 4000.00, 7, 11);

desc domicilio;
select *  from domicilio;

