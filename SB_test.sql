
use smart_buildingsdb;

call insert_client(999, 'Marcos', 'Rua 123, Lx', 999999999);

call insert_instalation(123, 'Rua do Caralho 33', 999, 'casa');
call insert_instalation(124, 'Rua do Hugo, 69', 999, 'fab');

call insert_contract(123, "2021-01-01", "2025-01-01", 1000, 2);
call insert_contract(124, "2022-01-01", "2026-01-01", 1200, 3);

call insert_receipt(1);

-- `install_device` (IN idInstallation_in INT, IN inst_date_in DATE, IN manRef_in VARCHAR(125), IN model_in VARCHAR(45), IN type_in VARCHAR(45))
call install_device(123, "2024-01-01", 'M809', 'sensor luz', 'luminosidade');
call install_device(123, "2024-01-01", 'F710', 'Lamps', 'actuator');

-- `insert_automation` (IN device_info_instalations_idInstalations_in INT, IN name_in VARCHAR(125), IN device_info_manufacturer_ref_in VARCHAR(125), IN con_in VARCHAR(45), IN check_value_in DECIMAL(7,2), IN device_info_manufacturer_ref1_in VARCHAR(125), IN action_in VARCHAR(45))
call insert_automation(123, "Day-mode",'M809', '<', 75, 'F710', 'ON');
call insert_automation(123, "Night-mode",'M809', '>', 150, 'F710', 'OFF');

UPDATE device_info
SET value=70
WHERE manufacturer_ref='M809' AND instalations_idInstalations=123;

UPDATE device_info
SET value=160
WHERE manufacturer_ref='M809' AND instalations_idInstalations=123;









