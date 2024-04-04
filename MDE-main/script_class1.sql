/* 1 - table ,,,*/
/*
create table student(
	st_number		integer,
    st_name			varchar(127),
    address			varchar(255),
    postal_code		varchar(10),
    city			varchar(64),
    st_email		varchar(64)
);
drop table	student;

describe student;

insert into student(st_number, st_name,  city)
values				(8001, 'Marques Marcus', 'Lisboa');

insert into student(st_number, st_name,  city)
values				(8002, 'Paul MuaddDibb', 'Arrakis');

insert into student(st_number, st_name,  city)
values				(8003, 'Feyd Rautha', 'Gieidi Prime');

insert into student(st_number, st_name,  city)
values				(8004, 'Alia the Blade', 'Arrakis');

insert into student(st_number, st_name,  city)
values				(8005, 'Leto II', 'Universe');

select * from student;

select st_number, city
from student;

select * from student where st_number='8001';

update student
set postal_code='1000', address='Rua do Caralho, 69 2D', st_email='weee@wow.pt'
where st_number='8001';

delete from student where st_number='8001';

alter table student
	add constraint st_number_null_ctrl check (st_number is not null);
    
insert into student( st_name,  city)
values				( 'Marques Marcus', 'Lisboa');

alter table student
	add constraint st_number_unique unique (st_number);
    
insert into student(st_number, st_name,  city)
values				('8001', 'Marques Marcus', 'Lisboa');

create table unit_student(
	st_number		integer,
    unit_name		varchar(127),
    grade			integer
);

alter table unit_student
	add constraint st_number_null_ctrl check (st_number is not null);
    
alter table unit_student
	drop constraint st_number_unique;

alter table unit_student
	add constraint unit_name_null_ctrl check (unit_name is not null);
    
drop table unit_student;    

alter table unit_student
	add constraint grade_bounds check (grade between 0 and 20);

insert into unit_student(st_number, unit_name,  grade)
values				('8001', 'LEEC', '20');

insert into unit_student( unit_name,  grade)
values				( 'LEEC', '20');

insert into unit_student(st_number, unit_name,  grade)
values				('8002', '', '20');

insert into unit_student(st_number, unit_name,  grade)
values				('8003', 'LEEC', '21');

insert into unit_student(st_number, unit_name,  grade)
values				('8003', 'LEEC', '-1');

insert into unit_student(st_number, unit_name,  grade)
values				('8003', 'LEEC', '15');
    
insert into unit_student(st_number, unit_name,  grade)
values				('8002', 'AM4', '9');

insert into unit_student(st_number, unit_name,  grade)
values				('8002', 'AM4', '12');

insert into unit_student(st_number, unit_name,  grade)
values				('8002', 'F3', '9');

insert into unit_student(st_number,  grade)
values				('8002',  '9');

select * from unit_student;

alter table student
	add annual_fee decimal(5,2);
    
alter table student
	modify annual_fee decimal(5,2) default 750.00;

describe student;

alter table student
	add average_grade decimal(2,2);
    
update student
set annual_fee='750.00';

select * from student;

alter table student
	modify average_grade decimal(5,2);
    
update student
set average_grade='13.50';

update student
set average_grade='18.50'
where st_name='Paul MuaddDibb';

update student
set annual_fee=annual_fee*'0.5'
where average_grade>='18';

drop table student;
drop table unit_student;
*/

create table department(
	id	int	auto_increment primary key,
    name	varchar(128),
    dep_code	varchar(64) unique,
    creation_date	date not null
);

insert into department(name, dep_code, creation_date)
values("DEEC", "123ABC", "1998-01-01");

insert into department(name, dep_code, creation_date)
values("DI", "123FGD", "1992-01-01");

insert into department(name, dep_code, creation_date)
values("DM", "123uytD", "1990-01-01");

insert into department(name, dep_code, creation_date)
values("DCR", "123fgh", "1995-01-01");

insert into department(name, dep_code, creation_date)
values("DMat", "123jkl", "1999-01-01");

create table course(
	id int auto_increment primary key,
    id_department int,
    name varchar(128),
    course_code varchar(64),
    creation_date date,
    foreign key (id_department) references department(id)
);

insert into course(id_department, name, course_code, creation_date)
values(1, "Licenciatura em Eletro", "qwerty", "1998-01-01");

insert into course(id_department, name, course_code, creation_date)
values(1, "Licenciatura em energias", "yututut", "1995-01-01");

insert into course(id_department, name, course_code, creation_date)
values(2, "Licenciatura em info", "ddd666", "1992-01-01");

create table student(
	id int auto_increment primary key,
    id_course int,
    name varchar(128),
    number int unique,
    address varchar(225),
    city varchar(64),
    enroll_date date,
    constraint FK_student_id_course foreign key (id_course) references course(id)
);

insert into student(id_course, name, number, address, city, enroll_date)
values (1, "Marques M", 666777, "Rua C", "Almada", "2020-01-01");

insert into student(id_course, name, number, address, city, enroll_date)
values (2, "Paulo M", 678900, "Arrakeen", "Dune", "2021-01-01");

create table unit(
	id int auto_increment primary key,
    id_department int,
    name varchar(128),
    credits int,
    constraint FK_unit_id_department foreign key (id_department) references department(id),
    constraint credits_bounds check (credits between 3 and 6)
);

insert into unit(id_department, name, credits)
values (5, "AMIV", 6);

insert into unit(id_department, name, credits)
values (4, "DCM", 6);

insert into unit(id_department, name, credits)
values (4, "EA", 3);

insert into unit(id_department, name, credits)
values (3, "MMM", 6);

insert into unit(id_department, name, credits)
values (3, "MQ", 6);

insert into unit(id_department, name, credits)
values (2, "PM", 6);

insert into unit(id_department, name, credits)
values (2, "PC", 3);

insert into unit(id_department, name, credits)
values (1, "MDE", 6);

insert into unit(id_department, name, credits)
values (1, "CEE", 6);

create table student_unit(
	id int auto_increment primary key,
    student_id int,
    unit_id int,
    start_date date,
    end_date date,
    grade int,
    constraint start_date_ctrl check (start_date is not null),
    constraint grade_bounds check (grade between 0 and 20),
    constraint FK_student_unit_student_id foreign key (student_id) references student(id),
    constraint FK_student_unit_unit_id foreign key (unit_id) references unit(id)
);

insert into student_unit(student_id, unit_id, start_date, end_date, grade)
values (1, 1, "2020-01-01", "2023-01-01", 10);

insert into student_unit(student_id, unit_id, start_date, end_date, grade)
values (1, 7, "2020-01-01", null, 20);

insert into student_unit(student_id, unit_id, start_date, end_date, grade)
values (2, 8, "2020-01-01", null, 15);

-- Show the units enrolled by a specific student
select s.number, s.name, u.name, su.grade, u.credits
from student s, unit u, student_unit su
where s.id='1' and su.student_id=s.id and su.unit_id=u.id;

-- Sum all unit credits from a specific student
select s.number, s.name, SUM(u.credits)
from student s, unit u, student_unit su
where s.id='1' and su.student_id=s.id and su.unit_id=u.id;