create table juegos(
	id_juego int(3) primary key,
	nombre varchar(30),
	tipo varchar(15),
	min_jugadores int(1),
	max_jugadores int(2),
);
insert into juegos values(001,'Catan','Recursos',2,4);
insert into juegos values(202,'Carcasonne','Losetas',2,6);
insert into juegos values(301,'Unbroken','Supervivencia',1,1);
insert into juegos values(415,'Masiones de la locura','Tablero/Rol',1,5);
insert into juegos values(589,'Jungle Speed','Agilidad visual',2,99);
insert into juegos values(645,'Mysterium','Deducción',2,7);
insert into juegos values(733,'Aventureros al tren','Familiar',2,5);