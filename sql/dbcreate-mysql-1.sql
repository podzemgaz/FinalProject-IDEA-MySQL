-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema st4db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `st4db` ;

-- -----------------------------------------------------
-- Schema st4db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `st4db` ;
USE `st4db` ;

-- -----------------------------------------------------
-- Table `st4db`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `st4db`.`category` (
  `id` INT NOT NULL,
  `name` VARCHAR(10) COLLATE 'utf8mb3_bin' NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB;

INSERT INTO category VALUES(1, 'Hot dishes'); -- горячие блюда
INSERT INTO category VALUES(2, 'Starters'); -- закуски
INSERT INTO category VALUES(3, 'Desserts'); -- десерт
INSERT INTO category VALUES(4, 'Beverages'); -- напитки
-- -----------------------------------------------------
-- Table `st4db`.`menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `st4db`.`menu` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) COLLATE 'utf8mb3_bin' NOT NULL,
  `price` INT NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_menu_categories1_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `fk_menu_categories1`
    FOREIGN KEY (`category_id`)
    REFERENCES `st4db`.`category` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1;

-- горячие блюда
INSERT INTO menu VALUES(DEFAULT, 'Borsch', 210, 1); -- 1 (order id)
INSERT INTO menu VALUES(DEFAULT, 'Kharcho', 210, 1); -- 2
INSERT INTO menu VALUES(DEFAULT, 'Solyanka', 250, 1); -- 3
-- напитки
INSERT INTO menu VALUES(DEFAULT, 'Juice', 70, 4); -- 4
INSERT INTO menu VALUES(DEFAULT, 'Tea', 50, 4); -- 5
INSERT INTO menu VALUES(DEFAULT, 'Coffee', 100, 4); -- 6
-- закуски
INSERT INTO menu VALUES(DEFAULT, 'Salmon salad', 250, 2); -- 7
INSERT INTO menu VALUES(DEFAULT, 'Fish plate', 200, 2); -- 8
-- десерт        
INSERT INTO menu VALUES(DEFAULT, 'Fruit plate', 160, 3); -- 9
INSERT INTO menu VALUES(DEFAULT, 'Strawberries and cream', 260, 3); -- 10

-- -----------------------------------------------------
-- Table `st4db`.`role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `st4db`.`role` (
  `id` INT NOT NULL,
  `name` VARCHAR(10) COLLATE 'utf8mb3_bin' NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB;

-- this two commands insert data into roles table
-- --------------------------------------------------------------
-- ATTENTION!!!
-- we use ENUM as the Role entity, so the numeration must started 
-- from 0 with the step equaled to 1
-- --------------------------------------------------------------
INSERT INTO role VALUES(0, 'admin');
INSERT INTO role VALUES(1, 'client');

-- -----------------------------------------------------
-- Table `st4db`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `st4db`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `login` VARCHAR(20) COLLATE 'utf8mb3_bin' NOT NULL,
  `password` VARCHAR(20) COLLATE 'utf8mb3_bin' NOT NULL,
  `first_name` VARCHAR(20) COLLATE 'utf8mb3_bin' NOT NULL,
  `last_name` VARCHAR(20) COLLATE 'utf8mb3_bin' NOT NULL,
  `role_id` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `login` (`login` ASC) VISIBLE,
  INDEX `fk_user_role_idx` (`role_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_role`
    FOREIGN KEY (`role_id`)
    REFERENCES `st4db`.`role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 1;

-- id = 1
INSERT INTO user VALUES(DEFAULT, 'admin', 'admin', 'Ivan', 'Ivanov', 0);
-- id = 2
INSERT INTO user VALUES(DEFAULT, 'client', 'client', 'Petr', 'Petrov', DEFAULT);
-- id = 3
INSERT INTO user VALUES(DEFAULT, 'петров', 'петров', 'Иван', 'Петров', DEFAULT);

-- -----------------------------------------------------
-- Table `st4db`.`status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `st4db`.`status` (
  `id` INT NOT NULL,
  `name` VARCHAR(10) COLLATE 'utf8mb3_bin' NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- --------------------------------------------------------------
-- ATTENTION!!!
-- we use ENUM as the Status entity, so the numeration must started 
-- from 0 with the step equaled to 1
-- --------------------------------------------------------------
INSERT INTO status VALUES(0, 'opened');
INSERT INTO status VALUES(1, 'confirmed');
INSERT INTO status VALUES(2, 'paid');
INSERT INTO status VALUES(3, 'closed');

-- -----------------------------------------------------
-- Table `st4db`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `st4db`.`order` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `bill` INT NOT NULL DEFAULT '0',
  `user_id` INT NOT NULL,
  `status_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_order_user1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_order_status1_idx` (`status_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `st4db`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_status1`
    FOREIGN KEY (`status_id`)
    REFERENCES `st4db`.`status` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1;

-- bill = 0; user_id=2; status_id=0
INSERT INTO `order` VALUES(DEFAULT, 0, 2, 0);
-- bill = 0; user_id=2; status_id=3
INSERT INTO `order` VALUES(DEFAULT, 0, 2, 3);

-- -----------------------------------------------------
-- Table `st4db`.`order_has_menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `st4db`.`order_has_menu` (
  `order_id` INT NOT NULL,
  `menu_id` INT NOT NULL,
  PRIMARY KEY (`order_id`, `menu_id`),
  INDEX `fk_order_has_menu_menu1_idx` (`menu_id` ASC) VISIBLE,
  INDEX `fk_order_has_menu_order1_idx` (`order_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_has_menu_order1`
    FOREIGN KEY (`order_id`)
    REFERENCES `st4db`.`order` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_has_menu_menu1`
    FOREIGN KEY (`menu_id`)
    REFERENCES `st4db`.`menu` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

INSERT INTO order_has_menu VALUES(1, 1);
INSERT INTO order_has_menu VALUES(1, 7);
INSERT INTO order_has_menu VALUES(1, 5);

INSERT INTO order_has_menu VALUES(2, 1);
INSERT INTO order_has_menu VALUES(2, 7);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
