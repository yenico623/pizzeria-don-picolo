# 🍕 Pizzería Don Piccolo - Sistema de Gestión de Base de Datos

## 📝 Descripción del Proyecto

Este proyecto consiste en el diseño e implementación de un sistema de base de datos relacional para la **Pizzería Don Piccolo**, desarrollado en **MySQL / MariaDB**. El sistema permite gestionar de manera integral el flujo operativo del negocio: registro de clientes, catálogo de productos (pizzas e ingredientes), control automatizado de inventario, procesamiento de pedidos, logística de domicilios, auditoría de precios y monitoreo de repartidores.

La arquitectura incluye lógica de negocio avanzada mediante procedimientos almacenados, funciones deterministas, disparadores (triggers) para automatización en tiempo real y vistas analíticas para la toma de decisiones.

---

## 🗄️ Explicación de las Tablas y Relaciones

El modelo relacional se compone de 9 tablas interconectadas que garantizan la integridad referencial del sistema:

### Tablas Principales

* **`cliente`**: Almacena los datos personales y de contacto de los clientes (`id_cliente`, `nombre`, `telefono`, `direccion`, `correo`).
* **`repartidores`**: Registra la información de los domiciliarios y su estado operativo (`id_repartidores`, `nombre`, `telefono`, `estado`).
* **`pizza`**: Catálogo de productos disponibles con su precio base (`id_pizza`, `nombre`, `precio_base`).
* **`ingredientes`**: Control de inventario físico de insumos y umbrales de reabastecimiento (`id_ingrediente`, `nombre`, `stock`, `stock_minimo`, `costo_unitario`).

### Tablas de Relación y Transacciones

* **`pizza_ingredientes`**: Tabla intermedia (N:M) que define la receta de cada pizza, asociando ingredientes y cantidades requeridas (`id_pizza_pk`, `id_ingrediente_pk`, `cantidad`).
* **`pedido`**: Cabecera de la transacción de compra asociada a un cliente (`id_pedido`, `fecha_hora`, `estado_pedido`, `total_pedido`, `id_cliente_pk`).
* **`detalle_pedido`**: Desglose (1:N) de los productos solicitados en un pedido (`id_detalle`, `cantidad`, `precio_unitario`, `id_pizza_fk`, `id_pedido_fk`).
* **`domicilio`**: Control logístico del envío, vinculado a un pedido y a un repartidor (`id_domicilio`, `hora_salida`, `hora_entrega`, `distancia`, `costo_envio`, `id_repartidores_fk`, `id_pedido_fk`).
* **`historial_precios`**: Tabla de auditoría alimentada por triggers para registrar cambios en las tarifas de las pizzas (`id_historial`, `id_pizza`, `precio_anterior`, `precio_nuevo`, `fecha_cambio`).

---
🚀 Instrucciones para Ejecutar el Script
Requisitos Previos
Tener instalado MySQL Server (v8.0 o superior) o MariaDB.

MySQL Workbench o cliente CLI de MySQL.

Orden de Ejecución
Para garantizar que las dependencias de claves foráneas y objetos PL/SQL se creen correctamente, ejecuta los archivos del repositorio en el siguiente orden estricto:

1. database.sql: Crea la base de datos pizzeria-don-picolo y la estructura DDL de las tablas con sus restricciones.

2. insercion_de_datos.sql: Pobla la base de datos con los registros de prueba (DML).

3. funciones.sql: Compila las funciones de cálculo de totales y ganancias netas, junto con el procedimiento de actualización de estado.

4. triggers.sql: Activa los disparadores automáticos para el control de stock, auditoría e inventario.

5. vistas.sql: Genera las vistas del sistema para el resumen de clientes, desempeño de repartidores y alertas de stock.

6. consultas.sql: Contiene el set de consultas analíticas para verificación y reportes.
