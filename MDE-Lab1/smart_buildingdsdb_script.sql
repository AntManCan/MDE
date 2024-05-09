-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema smart_buildingsdb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `smart_buildingsdb` ;

-- -----------------------------------------------------
-- Schema smart_buildingsdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `smart_buildingsdb` DEFAULT CHARACTER SET utf8mb4 ;
USE `smart_buildingsdb` ;

-- -----------------------------------------------------
-- Table `client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `client` (
  `NIF` INT NOT NULL,
  `name` VARCHAR(125) NOT NULL,
  `address` VARCHAR(125) NOT NULL,
  `phone` INT NOT NULL,
  PRIMARY KEY (`NIF`),
  UNIQUE INDEX `NIF_UNIQUE` (`NIF` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `service_package`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `service_package` (
  `idService_Package` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `device_num_max` INT NOT NULL,
  PRIMARY KEY (`idService_Package`),
  UNIQUE INDEX `idService_Package_UNIQUE` (`idService_Package` ASC),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contracts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `contracts` (
  `idContracts` INT NOT NULL AUTO_INCREMENT,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `monthly_price` DECIMAL(7,2) NOT NULL,
  `Service_Package_idService_Package` INT NOT NULL,
  PRIMARY KEY (`idContracts`),
  INDEX `fk_Contracts_Service_Package1_idx` (`Service_Package_idService_Package` ASC),
  UNIQUE INDEX `idContracts_UNIQUE` (`idContracts` ASC),
  CONSTRAINT `fk_Contracts_Service_Package1`
    FOREIGN KEY (`Service_Package_idService_Package`)
    REFERENCES `service_package` (`idService_Package`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `instalations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `instalations` (
  `idInstalations` INT NOT NULL,
  `address` VARCHAR(125) NOT NULL,
  `Client_NIF` INT NOT NULL,
  `Contracts_idContracts` INT NULL,
  `inst_type` VARCHAR(45) NOT NULL,
  `device_num` INT NOT NULL,
  PRIMARY KEY (`idInstalations`),
  INDEX `fk_Instalations_Client_idx` (`Client_NIF` ASC),
  INDEX `fk_Instalations_Contracts1_idx` (`Contracts_idContracts` ASC),
  UNIQUE INDEX `address_UNIQUE` (`address` ASC),
  CONSTRAINT `fk_Instalations_Client`
    FOREIGN KEY (`Client_NIF`)
    REFERENCES `client` (`NIF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Instalations_Contracts1`
    FOREIGN KEY (`Contracts_idContracts`)
    REFERENCES `contracts` (`idContracts`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `receipts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `receipts` (
  `idReceipts` INT NOT NULL AUTO_INCREMENT,
  `emission_date` DATE NOT NULL,
  `package` VARCHAR(45) NOT NULL,
  `is_paid` TINYINT NOT NULL,
  `contracts_idContracts` INT NOT NULL,
  PRIMARY KEY (`idReceipts`),
  UNIQUE INDEX `idReceipts_UNIQUE` (`idReceipts` ASC),
  INDEX `fk_receipts_contracts1_idx` (`contracts_idContracts` ASC),
  CONSTRAINT `fk_receipts_contracts1`
    FOREIGN KEY (`contracts_idContracts`)
    REFERENCES `contracts` (`idContracts`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `device_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `device_info` (
  `inst_date` DATETIME NULL,
  `is_ON` TINYINT NULL,
  `manufacturer_ref` VARCHAR(125) NOT NULL,
  `model` VARCHAR(45) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `value` DECIMAL(7,2) NULL,
  `instalations_idInstalations` INT NOT NULL,
  PRIMARY KEY (`manufacturer_ref`, `instalations_idInstalations`),
  INDEX `fk_device_info_instalations1_idx` (`instalations_idInstalations` ASC),
  CONSTRAINT `fk_device_info_instalations1`
    FOREIGN KEY (`instalations_idInstalations`)
    REFERENCES `instalations` (`idInstalations`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `automation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `automation` (
  `device_info_instalations_idInstalations` INT NOT NULL,
  `name` VARCHAR(125) NOT NULL,
  `device_info_manufacturer_ref` VARCHAR(125) NOT NULL,
  `con` VARCHAR(45) NULL,
  `check_value` DECIMAL(7,2) NULL,
  `device_info_manufacturer_ref1` VARCHAR(125) NOT NULL,
  `action` VARCHAR(45) NULL,
  INDEX `fk_automation_device_info1_idx` (`device_info_manufacturer_ref` ASC, `device_info_instalations_idInstalations` ASC),
  PRIMARY KEY (`name`),
  INDEX `fk_automation_device_info2_idx` (`device_info_manufacturer_ref1` ASC),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  CONSTRAINT `fk_automation_device_info1`
    FOREIGN KEY (`device_info_manufacturer_ref` , `device_info_instalations_idInstalations`)
    REFERENCES `device_info` (`manufacturer_ref` , `instalations_idInstalations`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_automation_device_info2`
    FOREIGN KEY (`device_info_manufacturer_ref1`)
    REFERENCES `device_info` (`manufacturer_ref`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `automation_record`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `automation_record` (
  `idAutomation_record` INT NOT NULL AUTO_INCREMENT,
  `time_of` DATETIME NOT NULL,
  `automation_name` VARCHAR(125) NOT NULL,
  `actuator_man_ref` VARCHAR(125) NOT NULL,
  `state_triggered` VARCHAR(45) NOT NULL,
  `device_info_instalations_idInstalations` INT NOT NULL,
  `device_value` DECIMAL(7,2) NULL,
  PRIMARY KEY (`idAutomation_record`),
  INDEX `fk_automation_record_automation1_idx` (`automation_name` ASC),
  INDEX `fk_automation_record_device_info1_idx` (`device_info_instalations_idInstalations` ASC),
  CONSTRAINT `fk_automation_record_automation1`
    FOREIGN KEY (`automation_name`)
    REFERENCES `automation` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_automation_record_device_info1`
    FOREIGN KEY (`device_info_instalations_idInstalations`)
    REFERENCES `device_info` (`instalations_idInstalations`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `smart_buildingsdb` ;

-- -----------------------------------------------------
-- Placeholder table for view `client_installations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `client_installations` (`name` INT, `client_address` INT, `instalation_code` INT, `instalation_address` INT);

-- -----------------------------------------------------
-- procedure insert_contract
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `insert_contract` (IN idInstalation_in INT, IN start_date_in DATE, IN end_date_in DATE, IN monthly_price_in DECIMAL(7,2), IN idService_Package_in INT)
BEGIN
	INSERT INTO contracts(start_date, end_date, monthly_price, Service_Package_idService_Package)
	values(start_date_in, end_date_in, monthly_price_in, idService_Package_in);
    
    UPDATE instalations i 
    SET i.Contracts_idContracts=last_insert_id()
    WHERE idInstalation_in=i.idInstalations;
    
    -- SELECT * FROM contracts WHERE contracts.idContracts=last_insert_id();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insert_client
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `insert_client` (IN NIF_in INT, IN name_in VARCHAR(125), IN address_in VARCHAR(125), IN phone_in INT)
BEGIN
	insert into client(NIF, name, address, phone)
	VALUES(NIF_in, name_in, address_in, phone_in);
    
    -- SELECT * FROM client WHERE client.NIF=NIF_in; 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insert_instalation
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `insert_instalation` (IN idInstalations_in INT, IN address_in VARCHAR(125), IN client_NIF_in INT, IN type_in VARCHAR(45))
BEGIN
	INSERT INTO instalations(idInstalations, address, Client_NIF, inst_type, device_num)
	values(idInstalations_in, address_in, client_NIF_in, type_in, 0);
    
    -- SELECT * FROM instalations WHERE instalations.idInstalations=idInstalations_in;    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insert_receipt
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `insert_receipt` (IN idContract_in INT)
BEGIN
	DECLARE current_day DATE;
    DECLARE pkg_name VARCHAR(45);
    
    SET current_day = NOW();
    
    call select_contract_pkg(idContract_in, @pkg_num, pkg_name);

	INSERT INTO receipts(emission_date, package, is_paid, contracts_idContracts)
	values(current_day, pkg_name, 0, idContract_in);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_contract
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `delete_contract` (IN contract_id INT)
BEGIN
	DECLARE installation_no INT;
    
	set installation_no = (SELECT i.idInstalations
		FROM instalations i
        WHERE i.Contracts_idContracts = contract_id );
        
	call uninstall_devices(installation_no);
    
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure uninstall_devices
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `uninstall_devices` (IN installation_no INT)
BEGIN
	-- DELETE d.device_info_manufacturer_ref
		-- FROM device_inst d
		-- WHERE instalations_idInstalations = installation_no;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure select_contract_pkg
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `select_contract_pkg` (IN idContract_in INT, OUT pkg_device_num INT, OUT pkg_name VARCHAR(45))
BEGIN
	DECLARE pkg_id INT;
    
    SET pkg_id = (SELECT c.Service_Package_idService_Package
		FROM contracts c
		WHERE c.idContracts = idContract_in);
        
	SET pkg_device_num = (SELECT p.device_num_max
		FROM service_package p
        WHERE p.idService_Package = pkg_id);
    
	SET pkg_name = (SELECT p.name
		FROM service_package p
        WHERE p.idService_Package = pkg_id);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure install_device
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `install_device` (IN idInstallation_in INT, IN inst_date_in DATE, IN manRef_in VARCHAR(125), IN model_in VARCHAR(45), IN type_in VARCHAR(45))
BEGIN
	DECLARE inst_devices_num INT;
    DECLARE contract_devices_max INT;
    DECLARE contract_id INT;
    
    SET contract_id = (SELECT i.Contracts_idContracts
		FROM instalations i
		WHERE i.idInstalations=idInstallation_in);
    
    call select_contract_pkg(contract_id, contract_devices_max, @trash);
    
    SET inst_devices_num = (SELECT i.device_num
		FROM instalations i
		WHERE i.idInstalations=idInstallation_in);
    
    IF (inst_devices_num < contract_devices_max OR contract_devices_max=0) THEN
		INSERT INTO device_info(inst_date, is_ON, manufacturer_ref, model, type, value, instalations_idInstalations)
		values(inst_date_in, FALSE, manRef_in, model_in, type_in, 0, idInstallation_in);
        
        UPDATE instalations i
        SET i.device_num=+1
        WHERE idInstallation_in=i.idInstalations;
	ELSE
        signal sqlstate '45000' set message_text = 'Contract does not allow more devices!';
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insert_automation
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `insert_automation` (IN device_info_instalations_idInstalations_in INT, IN name_in VARCHAR(125), IN device_info_manufacturer_ref_in VARCHAR(125), IN con_in VARCHAR(45), IN check_value_in DECIMAL(7,2), IN device_info_manufacturer_ref1_in VARCHAR(125), IN action_in VARCHAR(45))
BEGIN
	INSERT INTO automation(name, con, check_value, action, device_info_manufacturer_ref, device_info_instalations_idInstalations, device_info_manufacturer_ref1)
    values(name_in, con_in, check_value_in, action_in, device_info_manufacturer_ref_in, device_info_instalations_idInstalations_in, device_info_manufacturer_ref1_in);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_device_info_state
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `update_device_info_state` (IN idInstalations_in INT, IN man_ref_in VARCHAR(125), IN auto_action_in VARCHAR(45))
BEGIN
	UPDATE device_info
    SET is_ON = IF(auto_action_in='ON', TRUE, FALSE)
    WHERE manufacturer_ref=man_ref_in AND instalations_idInstalations=idInstalations_in;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insert_auto_record
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `insert_auto_record` (IN auto_name_in VARCHAR(125), IN idInstalations_in INT, IN device_value_in DECIMAL(7,2))
BEGIN
	DECLARE current_day DATETIME;
    DECLARE act_man_ref VARCHAR(125);
    DECLARE state_trig VARCHAR(45);
    
    SET current_day = NOW();
    SET act_man_ref = (SELECT a.device_info_manufacturer_ref1 FROM automation a
		WHERE a.name=auto_name_in);
	SET state_trig = (SELECT a.action FROM automation a
		WHERE a.name=auto_name_in);
	
    INSERT INTO automation_record(time_of, automation_name, actuator_man_ref, state_triggered, device_info_instalations_idInstalations, device_value)
    values(current_day, auto_name_in, act_man_ref, state_trig, idInstalations_in, device_value_in);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure view_clients_with_installation_type
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `view_clients_with_installation_type` (IN inst_type_in VARCHAR(45))
BEGIN
	-- Visualizar os dados de cliente cujas instalações sejam de uma determinada tipologia.
    SELECT c.NIF, c.name, c.address, c.phone, i.idInstalations AS Installation_ID, i.inst_type AS Installation_type
    FROM client c
    INNER JOIN instalations i ON c.NIF=i.Client_NIF AND i.inst_type=inst_type_in
    ORDER BY c.name ASC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure view_clients_with_service
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `view_clients_with_service` (IN service_pack_in VARCHAR(45))
BEGIN
	-- Visualizar os clientes que tenham contratado um determinado pacote/serviço.
    DECLARE s_pack_id INT;
    SET s_pack_id = (SELECT idService_Package
		FROM service_package WHERE name=service_pack_in);
    
	SELECT c.NIF, c.name, c.address, c.phone
    FROM client c
    INNER JOIN instalations i ON i.Client_NIF=c.NIF 
    INNER JOIN contracts con ON con.idContracts=i.Contracts_idContracts AND con.Service_Package_idService_Package=s_pack_id
	ORDER BY c.name ASC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure view_devices_installed_date
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `view_devices_installed_date` (IN idInstallation_in INT, IN start_date datetime, IN end_date datetime)
BEGIN
	-- Visualizar todos os dispositivos instalados numa dada instalação dentro de um intervalo de tempo.
    SELECT d.manufacturer_ref, d.inst_date
    FROM device_info d
    WHERE d.instalations_idInstalations=idInstallation_in AND d.inst_date>=start_date AND d.inst_date<=end_date
    ORDER BY d.inst_date DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure view_installations_with_auto_in_time
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `view_installations_with_auto_in_time` (IN start_date datetime, IN end_date datetime)
BEGIN
	-- Visualizar as instalações com automações, dentro de um intervalo de tempo.
	SELECT device_info_instalations_idInstalations AS installation_ID, automation_name, time_of
    FROM automation_record WHERE time_of>=start_date AND time_of<=end_date
    ORDER BY time_of DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure pay_receipt
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `pay_receipt` (IN idReceipt_in INT)
BEGIN
	IF (SELECT is_paid FROM receipts WHERE idReceipts=idReceipt_in)=TRUE THEN
		signal sqlstate '45000' set message_text = 'Receipt already paid!';
	END IF;
    
    UPDATE receipts
    SET is_paid = TRUE
    WHERE idReceipts=idReceipt_in;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure contract_avg_paid
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `contract_avg_paid` (IN idContract_in INT, IN start_date datetime, IN end_date DATETIME)
BEGIN
	DECLARE count_paid INT;
    DECLARE count_total INT;
    DECLARE avg_pay DECIMAL(7,2);
    
    SET count_paid = (SELECT COUNT(*) FROM receipts r 
    INNER JOIN contracts c
    WHERE c.idContracts=r.contracts_idContracts AND r.is_paid=TRUE AND r.emission_date>=start_date AND r.emission_date<=end_date);
    
    SET count_total = (SELECT COUNT(*) FROM receipts r 
    INNER JOIN contracts c
    WHERE c.idContracts=r.contracts_idContracts AND r.emission_date>=start_date AND r.emission_date<=end_date);
    
	SET avg_pay = (SELECT monthly_price FROM contracts WHERE idContracts=idContract_in)*count_paid/count_total;
	SELECT avg_pay;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_everything
-- -----------------------------------------------------

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE PROCEDURE `delete_everything` ()
BEGIN
	DELETE FROM automation_record;
	DELETE FROM automation;
	DELETE FROM receipts;
	DELETE FROM device_info;
	DELETE FROM instalations;
	DELETE FROM contracts;
	DELETE FROM service_package;
	DELETE FROM client;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `client_installations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `client_installations`;
USE `smart_buildingsdb`;
CREATE OR REPLACE VIEW `client_installations` AS
SELECT name, c.address AS client_address, idInstalations as instalation_code, i.address AS instalation_address
FROM client c
INNER JOIN instalations i on c.NIF = i.Client_NIF
ORDER BY
	name ASC;
USE `smart_buildingsdb`;

DELIMITER $$
USE `smart_buildingsdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `smart_buildingsdb`.`contracts_BEFORE_INSERT` BEFORE INSERT ON `contracts` FOR EACH ROW
BEGIN
	IF NOT EXISTS(SELECT * FROM service_package) THEN
		INSERT INTO service_package(idService_Package, name, device_num_max)
		values	(1, 'low', 2),
			(2, 'high', 4),
			(3, 'pro', 0);
	END IF;
END$$

USE `smart_buildingsdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `smart_buildingsdb`.`receipts_BEFORE_UPDATE` BEFORE UPDATE ON `receipts` FOR EACH ROW
BEGIN
	DECLARE current_day DATE;
    
    SET current_day = NOW();
    IF (date(NEW.emission_date) < current_day) THEN
		signal sqlstate '45000' set message_text = 'Date cannot be earlier than current date!';
	END IF;
END$$

USE `smart_buildingsdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `smart_buildingsdb`.`device_info_AFTER_UPDATE` AFTER UPDATE ON `device_info` FOR EACH ROW
BEGIN
	-- automations:
    DECLARE auto_name VARCHAR(125);
    DECLARE con_sign VARCHAR(45);
    DECLARE auto_value DECIMAL(7,2);
    DECLARE man_ref_act VARCHAR(45);
    DECLARE auto_action VARCHAR(45);
    DECLARE c INT;
    
    SET c = (SELECT COUNT(*) FROM automation a
	WHERE a.device_info_instalations_idInstalations=NEW.instalations_idInstalations
	AND a.device_info_manufacturer_ref=NEW.manufacturer_ref);
    IF (c!=0)
	THEN
		-- get automation name from automation 
		SET auto_name = (SELECT a.name FROM automation a
			WHERE a.device_info_instalations_idInstalations=NEW.instalations_idInstalations
			AND a.device_info_manufacturer_ref=NEW.manufacturer_ref);
		-- get condition sign from automation
        SET con_sign = (SELECT a.con FROM automation a
			WHERE a.device_info_instalations_idInstalations=NEW.instalations_idInstalations
			AND a.device_info_manufacturer_ref=NEW.manufacturer_ref);
		-- get value from automation
		SET auto_value = (SELECT a.check_value FROM automation a
			WHERE a.device_info_instalations_idInstalations=NEW.instalations_idInstalations
			AND a.device_info_manufacturer_ref=NEW.manufacturer_ref);
		-- get actuator's man_ref from automation
		SET man_ref_act = (SELECT a.device_info_manufacturer_ref1 FROM automation a
			WHERE a.device_info_instalations_idInstalations=NEW.instalations_idInstalations
			AND a.device_info_manufacturer_ref=NEW.manufacturer_ref);
		-- get action from automation
		SET auto_action = (SELECT a.action FROM automation a
			WHERE a.device_info_instalations_idInstalations=NEW.instalations_idInstalations
			AND a.device_info_manufacturer_ref=NEW.manufacturer_ref);
		-- operations
        CASE con_sign
			WHEN '<' THEN
				IF (NEW.value < auto_value) THEN
					call insert_auto_record(auto_name, NEW.instalations_idInstalations,NEW.value);
					-- SET @disable_trigger = 1;
                    -- SET NEW.is_ON = IF(auto_action='ON', TRUE, FALSE);
					-- SET @disable_trigger = NULL;
                END IF;
			WHEN '>' THEN
				IF (NEW.value > auto_value) THEN
					call insert_auto_record(auto_name, NEW.instalations_idInstalations, NEW.value);
				END IF;
		END CASE;
    
    END IF;
	
    
    -- night-mode
    -- o desligamento de luzes pode ajustar automaticamente o termostato
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
