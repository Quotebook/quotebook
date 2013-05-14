SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `quotebook` ;
CREATE SCHEMA IF NOT EXISTS `quotebook` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `quotebook` ;

-- -----------------------------------------------------
-- Table `quotebook`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quotebook`.`users` ;

CREATE  TABLE IF NOT EXISTS `quotebook`.`users` (
  `user_id` BIGINT(20) NOT NULL AUTO_INCREMENT ,
  `user_email` VARCHAR(100) NOT NULL ,
  `user_password` VARCHAR(100) NOT NULL ,
  `user_fname` VARCHAR(100) NULL ,
  `user_lname` VARCHAR(100) NULL ,
  `user_pic` VARCHAR(255) NULL ,
  `user_registration` DATETIME NULL ,
  `role_id` INT NOT NULL ,
  PRIMARY KEY (`user_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quotebook`.`books`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quotebook`.`books` ;

CREATE  TABLE IF NOT EXISTS `quotebook`.`books` (
  `book_id` BIGINT(20) NOT NULL AUTO_INCREMENT ,
  `book_name` VARCHAR(100) NOT NULL ,
  `book_description` VARCHAR(255) NULL ,
  `book_registration` DATETIME NULL ,
  PRIMARY KEY (`book_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quotebook`.`quotes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quotebook`.`quotes` ;

CREATE  TABLE IF NOT EXISTS `quotebook`.`quotes` (
  `quote_id` BIGINT(20) NOT NULL AUTO_INCREMENT ,
  `book_id` BIGINT(20) NOT NULL ,
  `speaker_id` BIGINT(20) NOT NULL ,
  `author_id` BIGINT(20) NOT NULL ,
  `quote` VARCHAR(255) NOT NULL ,
  `quote_context` VARCHAR(255) NULL ,
  `multi_quote_id` BIGINT(20) NULL ,
  `quote_datetime` DATETIME NULL ,
  `quote_registration` DATETIME NULL ,
  PRIMARY KEY (`quote_id`) ,
  INDEX `qb_id_idx` (`book_id` ASC) ,
  INDEX `user_id_idx` (`speaker_id` ASC) ,
  INDEX `quote_id_idx` (`multi_quote_id` ASC) ,
  CONSTRAINT `book_id`
    FOREIGN KEY (`book_id` )
    REFERENCES `quotebook`.`books` (`book_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `speaker_id`
    FOREIGN KEY (`speaker_id` )
    REFERENCES `quotebook`.`users` (`user_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `author_id`
    FOREIGN KEY (`author_id` )
    REFERENCES `quotebook`.`users` (`user_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `quote_id`
    FOREIGN KEY (`multi_quote_id` )
    REFERENCES `quotebook`.`quotes` (`quote_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quotebook`.`memberships`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quotebook`.`memberships` ;

CREATE  TABLE IF NOT EXISTS `quotebook`.`memberships` (
  `user_id` BIGINT(20) NOT NULL ,
  `book_id` BIGINT(20) NOT NULL ,
  `member_id` INT NOT NULL ,
  INDEX `qb_id_idx` (`book_id` ASC) ,
  INDEX `user_id_idx` (`user_id` ASC) ,
  PRIMARY KEY (`user_id`, `book_id`) ,
  CONSTRAINT `memb_book_id`
    FOREIGN KEY (`book_id` )
    REFERENCES `quotebook`.`books` (`book_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `memb_user_id`
    FOREIGN KEY (`user_id` )
    REFERENCES `quotebook`.`users` (`user_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `quotebook` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
