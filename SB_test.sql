
use smart_buildingsdb;

call insert_client(999, 'Marcos', 'Rua 123, Lx', 999999999);

call insert_instalation(123, 'Rua do Caralho 33', 999, 'casa');
call insert_instalation(124, 'Rua do Hugo, 69', 999, 'fab');

call insert_contract(123, "2021-01-01", "2025-01-01", 1000, 2);
call insert_contract(124, "2022-01-01", "2026-01-01", 1200, 3);

call insert_receipt(1);

call insert_device_info('M809', 'fridge', 'utility', 5);
call install_device(123, 'M809', "2024-01-01");



