use smart_buildingsdb;

-- delete from client where NIF=999;

insert into client(NIF, name, adress, phone)
values(999, 'Marcos', 'Rua 123, Lx', 999999999),
	(123, 'Ton', 'Av. 123, Lx', 999999991),
    (456, 'Rod', 'City 123, Lx', 999999992),
    (789, 'Jonh', 'Ass 123, Lx', 999999994),
    (321, 'Ggg', 'ugh 123, Lx', 999999993);
    
INSERT INTO service_package(idService_Package, name)
values(1, 'Low');
    
INSERT INTO contracts(start_date, duration, cost, Service_Package_idService_Package)
values("2020-01-01", 12, 100, 1);

INSERT INTO instalations(idInstalations, address, Client_NIF, Contracts_idContracts)
values(123, 'Rua A', 999, 1);
    
SELECT name, c.adress AS client_address, idInstalations as instalation_code, i.address AS instalation_address
FROM client c
INNER JOIN instalations i on c.NIF = i.Client_NIF
ORDER BY
	name ASC;
    