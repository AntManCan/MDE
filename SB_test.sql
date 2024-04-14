
use smart_buildingsdb;

call insert_client(999, 'Marcos', 'Rua 123, Lx', 999999999);
call insert_client(111, 'Toin', 'Rua FFF', 999999999);
call insert_client(222, 'Jul', 'Rua AAA', 999999999);

call insert_instalation(123, 'Rua do Caralho 33', 999, 'casa');
call insert_instalation(124, 'Rua do Hugo, 69', 999, 'fab');
call insert_instalation(125, 'Rua do Cu, 420', 999, 'fab');
call insert_instalation(126, 'Rua 80085', 111, 'fab');
call insert_instalation(127, 'Rua 1234', 222, 'fab');

call insert_contract(123, "2021-01-01", "2025-01-01", 1000, 2);
call insert_contract(124, "2022-01-01", "2026-01-01", 1200, 3);
call insert_contract(126, "2022-01-01", "2026-01-01", 1200, 1);
call insert_contract(127, "2022-01-01", "2026-01-01", 1200, 3);

call insert_receipt(1);
call insert_receipt(1);
call insert_receipt(1);
call insert_receipt(1);

-- `install_device` (IN idInstallation_in INT, IN inst_date_in DATE, IN manRef_in VARCHAR(125), IN model_in VARCHAR(45), IN type_in VARCHAR(45))
call install_device(123, "2024-01-01", 'M809', 'sensor luz', 'luminosidade');
call install_device(123, "2024-01-02", 'F710', 'Lamps', 'actuator');
call install_device(123, "2024-01-03", 'T555', 'Fridge', 'actuator');
call install_device(124, "2024-01-01", 'r567', 'Thermostat', 'Temperature');
call install_device(124, "2024-01-01", 'h672', 'AC', 'actuator');

-- `insert_automation` (IN device_info_instalations_idInstalations_in INT, IN name_in VARCHAR(125), IN device_info_manufacturer_ref_in VARCHAR(125), IN con_in VARCHAR(45), IN check_value_in DECIMAL(7,2), IN device_info_manufacturer_ref1_in VARCHAR(125), IN action_in VARCHAR(45))
call insert_automation(123, "Day-mode",'M809', '<', 75, 'F710', 'ON');
call insert_automation(124, "AC on",'r567', '>', 150, 'h672', 'ON');

UPDATE device_info
SET value=70
WHERE manufacturer_ref='M809' AND instalations_idInstalations=123;

UPDATE device_info
SET value=180
WHERE manufacturer_ref='M809' AND instalations_idInstalations=123;

UPDATE device_info
SET value=180
WHERE manufacturer_ref='r567' AND instalations_idInstalations=124;

-- `view_clients_with_installation_type` (IN inst_type_in VARCHAR(45))
call view_clients_with_installation_type('fab');

-- `view_clients_with_service` (IN service_pack_in VARCHAR(45))
call view_clients_with_service('Pro');

-- `view_devices_installed_date` (IN idInstallation_in INT, IN start_date datetime, IN end_date datetime)
call view_devices_installed_date(123, "2024-01-02", "2024-01-03");

-- `view_installations_with_auto_in_time` (IN start_date datetime, IN end_date datetime)
call view_installations_with_auto_in_time("2024-01-02", "2025-01-02");

-- `pay_receipt` (IN idReceipt_in INT)
call pay_receipt(1);
call pay_receipt(2);

-- `contract_avg_paid` (IN idContract_in INT, IN start_date datetime, IN end_date DATETIME)
call contract_avg_paid(1, "2024-01-02", "2025-01-03");










