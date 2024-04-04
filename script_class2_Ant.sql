use smart_buildingsdb;

-- delete from client where NIF=999;

insert into client(NIF, name, adress, phone)
values(999, 'Marcos', 'Rua 123, Lx', 999999999),
	(123, 'Ton', 'Av. 123, Lx', 999999991),
    (456, 'Rod', 'City 123, Lx', 999999992),
    (789, 'Jonh', 'Ass 123, Lx', 999999994),
    (321, 'Ggg', 'ugh 123, Lx', 999999993);
    
    
SELECT name, c.adress, idInstalations as instalation_code, i.address
FROM client c
INNER JOIN instalations i on c.NIF = i.Client_NIF
ORDER BY
	name ASC;
    