-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema pizzeria-don-picolo
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `pizzeria-don-picolo` ;

-- -----------------------------------------------------
-- Schema pizzeria-don-picolo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria-don-picolo` DEFAULT CHARACTER SET utf8mb3 ;
USE `pizzeria-don-picolo` ;

-- -----------------------------------------------------
-- Table `pizzeria-don-picolo`.`cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria-don-picolo`.`cliente` ;

CREATE TABLE IF NOT EXISTS `pizzeria-don-picolo`.`cliente` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE INDEX `correo_UNIQUE` (`correo` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 27
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pizzeria-don-picolo`.`pizza`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria-don-picolo`.`pizza` ;

CREATE TABLE IF NOT EXISTS `pizzeria-don-picolo`.`pizza` (
  `id_pizza` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `tamaño` ENUM('pequeña', 'mediana', 'familiar') NOT NULL,
  `precio_base` DECIMAL(10,2) NOT NULL,
  `tipo` ENUM('vegetariana', 'especial', 'clasica') NOT NULL,
  PRIMARY KEY (`id_pizza`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pizzeria-don-picolo`.`pedido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria-don-picolo`.`pedido` ;

CREATE TABLE IF NOT EXISTS `pizzeria-don-picolo`.`pedido` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `fecha_hora` DATETIME NOT NULL,
  `medio_pago` ENUM('efectivo', 'tarjeta', 'app') NOT NULL,
  `total_pedido` DECIMAL(10,2) NOT NULL,
  `estado_pedido` ENUM('pendiente', 'en_preparacion', 'entregado', 'cancelado') NOT NULL,
  `id_cliente_pk` INT NOT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `pedido_fk_1_idx` (`id_cliente_pk` ASC) VISIBLE,
  CONSTRAINT `pedido_fk_1`
    FOREIGN KEY (`id_cliente_pk`)
    REFERENCES `pizzeria-don-picolo`.`cliente` (`id_cliente`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pizzeria-don-picolo`.`detalle_pedido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria-don-picolo`.`detalle_pedido` ;

CREATE TABLE IF NOT EXISTS `pizzeria-don-picolo`.`detalle_pedido` (
  `id_detalle` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `precio_unitario` DECIMAL(10,2) NOT NULL,
  `id_pizza_fk` INT NOT NULL,
  `id_pedido_fk` INT NOT NULL,
  PRIMARY KEY (`id_detalle`),
  INDEX `detalle_pedido_fk_1_idx` (`id_pizza_fk` ASC) VISIBLE,
  INDEX `detalle_pedido_fk_2_idx` (`id_pedido_fk` ASC) VISIBLE,
  CONSTRAINT `detalle_pedido_fk_1`
    FOREIGN KEY (`id_pizza_fk`)
    REFERENCES `pizzeria-don-picolo`.`pizza` (`id_pizza`),
  CONSTRAINT `detalle_pedido_fk_2`
    FOREIGN KEY (`id_pedido_fk`)
    REFERENCES `pizzeria-don-picolo`.`pedido` (`id_pedido`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pizzeria-don-picolo`.`repartidores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria-don-picolo`.`repartidores` ;

CREATE TABLE IF NOT EXISTS `pizzeria-don-picolo`.`repartidores` (
  `id_repartidores` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `zona_asignada` VARCHAR(45) NOT NULL,
  `estado` ENUM('disponible', 'no_disponible') NOT NULL,
  PRIMARY KEY (`id_repartidores`))
ENGINE = InnoDB
AUTO_INCREMENT = 17
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pizzeria-don-picolo`.`domicilio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria-don-picolo`.`domicilio` ;

CREATE TABLE IF NOT EXISTS `pizzeria-don-picolo`.`domicilio` (
  `id_domicilio` INT NOT NULL AUTO_INCREMENT,
  `hora_salida` DATETIME NOT NULL,
  `hora_entrega` DATETIME NOT NULL,
  `distancia` DECIMAL(5,2) NOT NULL,
  `costo_envio` DECIMAL(10,2) NOT NULL,
  `id_repartidores_fk` INT NOT NULL,
  `id_pedido_fk` INT NOT NULL,
  PRIMARY KEY (`id_domicilio`, `id_pedido_fk`),
  INDEX `domicilio_fk_2_idx` (`id_repartidores_fk` ASC) VISIBLE,
  INDEX `fk_domicilio_pedido1_idx` (`id_pedido_fk` ASC) VISIBLE,
  CONSTRAINT `domicilio_fk_2`
    FOREIGN KEY (`id_repartidores_fk`)
    REFERENCES `pizzeria-don-picolo`.`repartidores` (`id_repartidores`),
  CONSTRAINT `fk_domicilio_pedido1`
    FOREIGN KEY (`id_pedido_fk`)
    REFERENCES `pizzeria-don-picolo`.`pedido` (`id_pedido`))
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pizzeria-don-picolo`.`historial_precios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria-don-picolo`.`historial_precios` ;

CREATE TABLE IF NOT EXISTS `pizzeria-don-picolo`.`historial_precios` (
  `id_historial` INT NOT NULL AUTO_INCREMENT,
  `id_pizza` INT NOT NULL,
  `precio_anterior` DECIMAL(10,2) NOT NULL,
  `precio_nuevo` DECIMAL(10,2) NOT NULL,
  `fecha_cambio` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_historial`),
  INDEX `fk_historial_pizza` (`id_pizza` ASC) VISIBLE,
  CONSTRAINT `fk_historial_pizza`
    FOREIGN KEY (`id_pizza`)
    REFERENCES `pizzeria-don-picolo`.`pizza` (`id_pizza`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pizzeria-don-picolo`.`ingredientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria-don-picolo`.`ingredientes` ;

CREATE TABLE IF NOT EXISTS `pizzeria-don-picolo`.`ingredientes` (
  `id_ingrediente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `stock` INT NOT NULL,
  `disponibilidad` INT NOT NULL,
  `stock_minimo` INT NULL DEFAULT '5',
  `costo_unitario` DECIMAL(10,2) NULL DEFAULT '0.00',
  PRIMARY KEY (`id_ingrediente`))
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `pizzeria-don-picolo`.`pizza_ingredientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria-don-picolo`.`pizza_ingredientes` ;

CREATE TABLE IF NOT EXISTS `pizzeria-don-picolo`.`pizza_ingredientes` (
  `id_pizza_ingredientes` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `id_pizza_pk` INT NOT NULL,
  `id_ingrediente_pk` INT NOT NULL,
  PRIMARY KEY (`id_pizza_ingredientes`),
  INDEX `pizza_ingredientes_fk_1_idx` (`id_pizza_pk` ASC) VISIBLE,
  INDEX `pizza_ingredientes_fk_2_idx` (`id_ingrediente_pk` ASC) VISIBLE,
  CONSTRAINT `pizza_ingredientes_fk_1`
    FOREIGN KEY (`id_pizza_pk`)
    REFERENCES `pizzeria-don-picolo`.`pizza` (`id_pizza`),
  CONSTRAINT `pizza_ingredientes_fk_2`
    FOREIGN KEY (`id_ingrediente_pk`)
    REFERENCES `pizzeria-don-picolo`.`ingredientes` (`id_ingrediente`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
