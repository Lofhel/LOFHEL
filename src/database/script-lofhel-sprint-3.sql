-- Arquivo de apoio, caso você queira criar tabelas como as aqui criadas para a API funcionar.
-- Você precisa executar os comandos no banco de dados para criar as tabelas,
-- ter este arquivo aqui não significa que a tabela em seu BD estará como abaixo !!

/*
comandos para executar no mysql
*/
/*

CREATE USER 'apiLofhelWeb'@'localhost' IDENTIFIED BY 'Urubu100$';
GRANT INSERT, UPDATE, SELECT ON lofhel.* TO 'apiLofhelWeb'@'localhost';
FLUSH PRIVILEGES;
*/

CREATE DATABASE Lofhel;
USE Lofhel;
show tables;


CREATE TABLE Endereco (
    idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    uf CHAR(2) NOT NULL,
    cidade VARCHAR(60) NOT NULL,
    logradouro VARCHAR(70) NOT NULL,
    bairro VARCHAR(70) NOT NULL,
    numero INT NOT NULL,
    cep CHAR(9) NOT NULL,
    complemento VARCHAR(80)
);

CREATE TABLE Vinicola (
    idVinicola INT PRIMARY KEY AUTO_INCREMENT,
    nomeFantasia VARCHAR(60) NOT NULL,
    razaoSocial VARCHAR(45) NOT NULL,
    cnpj VARCHAR(15) NOT NULL UNIQUE,  
    fkEndereco INT DEFAULT NULL,
    CONSTRAINT fkEnderecoVinicola FOREIGN KEY (fkEndereco) REFERENCES Endereco(idEndereco)
);
-- Tabela de Permissão
CREATE TABLE Permissao (
    idPermissao INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(50) NOT NULL UNIQUE
);
-- Tabela de Cargo
CREATE TABLE Cargo (
    idCargo INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,           
    fkVinicola INT NOT NULL,              
    CONSTRAINT fkVinicolaCargo FOREIGN KEY (FKVinicola) REFERENCES Vinicola(idVinicola)
);

CREATE TABLE CargoPermissao (
    fkCargo INT,
    fkPermissao INT NOT NULL,
    CONSTRAINT pkComposta PRIMARY KEY (fkCargo, fkPermissao), 
    CONSTRAINT fkCargoPermissao FOREIGN KEY (fkCargo) REFERENCES Cargo(idCargo),
    CONSTRAINT fkPermissaoCargo FOREIGN KEY (fkPermissao) REFERENCES Permissao(idPermissao)
);

-- Tabela de Funcionário
CREATE TABLE Funcionario (
    idFuncionario INT PRIMARY KEY AUTO_INCREMENT,
    nomeFuncionario VARCHAR(100) NOT NULL,  
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(100) NOT NULL,         
    fkRepresentante INT,               
    telefone VARCHAR(20) NOT NULL,          
    fkVinicola INT NOT NULL,
    fkCargo INT,
    CONSTRAINT fkRepresentanteFuncionario FOREIGN KEY (fkRepresentante) REFERENCES Funcionario(idFuncionario),
    CONSTRAINT fkVinicolaFuncionario FOREIGN KEY (fkVinicola) REFERENCES Vinicola(idVinicola),
    CONSTRAINT fkCargoFuncionario FOREIGN KEY (fkCargo) REFERENCES Cargo(idCargo)
);





-- Tabela de Grupo de Vinho (corrigido de sensors)
CREATE TABLE GrupoVinho (
    idGrupoVinho INT PRIMARY KEY AUTO_INCREMENT,
    classe VARCHAR(40) NOT NULL,
    temperaturaMax FLOAT NOT NULL,
    temperaturaMin FLOAT NOT NULL, 
    umidadeMax FLOAT NOT NULL,
    umidadeMin FLOAT NOT NULL
);
desc GrupoVinho;
alter table GrupoVinho add column umidadeMax int not null;
alter table GrupoVinho add column umidadeMin int not null;
select * from GrupoVinho;
INSERT INTO GrupoVinho (classe, temperaturaMin, temperaturaMax, umidadeMin, umidadeMax)
VALUES 
('Vinho Gelado', 4, 6, 65, 75),
('Vinho Frio', 8.5, 11.5, 65, 75),
('Vinho Adega', 13.75, 15.25, 65, 75),
('Vinho Fresco', 17, 19, 65, 75);

-- Tabela de Armazém
CREATE TABLE Armazem (
    idArmazem INT PRIMARY KEY AUTO_INCREMENT,
    nomeArmazem VARCHAR(60) NOT NULL,    
    descricao VARCHAR(100),
    fkVinicola INT NOT NULL,
    fkGrupoVinho INT NOT NULL,
    CONSTRAINT fkVinicolaArmazem FOREIGN KEY (fkVinicola) REFERENCES Vinicola(idVinicola),
    CONSTRAINT fkGrupoVinhoArmazem FOREIGN KEY (fkGrupoVinho) REFERENCES GrupoVinho(idGrupoVinho)
);



-- Tabela de Sensor
CREATE TABLE Sensor (
    idSensor INT PRIMARY KEY AUTO_INCREMENT,
    nomeSerial CHAR(12) NOT NULL UNIQUE, 
    fkArmazem INT NOT NULL,
    CONSTRAINT fkArmazemSensor FOREIGN KEY (fkArmazem) REFERENCES Armazem(idArmazem)
);

-- Tabela de Registro
CREATE TABLE Registro (
    idRegistro INT PRIMARY KEY AUTO_INCREMENT,
    temperatura FLOAT NOT NULL,
    umidade FLOAT NOT NULL,
    dataHora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fkSensor INT NOT NULL,
   CONSTRAINT fkSensorRegistro  FOREIGN KEY (fkSensor) REFERENCES Sensor(idSensor)
);
alter table Armazem add column fkGrupoVinho int ;
alter table Armazem add constraint fkArmazemGrupo FOREIGN key (fkGrupoVinho) references GrupoVinho (idGrupoVinho);
select * from Endereco;
select * from Vinicola;
select * from Armazem;
update Armazem set fkGrupoVinho = 1 Where idArmazem = 1;
update Armazem set fkGrupoVinho = 2 Where idArmazem = 2;
update Armazem set fkGrupoVinho = 3 Where idArmazem = 3;
update Armazem set fkGrupoVinho = 4 Where idArmazem = 4;
update Armazem set fkGrupoVinho = 2 Where idArmazem = 5;
select * from Cargo;
select * from Permissao;
select * from CargoPermissao;
select * from Funcionario;
select * from GrupoVinho;
select * from Sensor;
select * from Registro;
alter table cargo rename column nome to nomeCargo;


-- permissoes padroes do sistema por enquanto são esses
insert into Permissao (codigo) values 
('acessar_dashboard'),
('gerenciar_armazens'), 
('gerenciar_funcionarios'),
('gerar_relatorios');
select * from Vinicola;
insert into Vinicola values 
	(1,'Maria Vinicola', 'MariaS.A.', '100200300102456', null, null); 
select * from Armazem;
insert into Armazem values
	(1, 'Armazem 1', 'Vinhos delicados', 1);
-- estes inserts tem q ser feitos na hora do cadastro
update funcionario set fkCargo = 1 where idFuncionario = 1;
insert into Cargo values
	(default, 'Representante Legal', 1);
    
insert into CargoPermissao (fkCargo, fkPermissao) values
	(1,1), 
    (1,2), 
    (1,3), 
    (1,4);

-- cadastro de vinicola e devido representate legal
-- inserts e selects para a api no total 4 inserts na hora do cadastro ou seja 4 requisições  seguindo uma ordem para pegar FKs exemplo: var fkVinicola = resultadoVinicola.insertId;
INSERT INTO Vinicola (nomeFantasia, razaoSocial, cnpj) VALUES ('${nomeFantasia}', '${razaoSocial}', '${cnpj}'); -- ja foi
INSERT INTO Cargo (nome, fkVinicola) VALUES ('Representante Legal', '${fkVinicola}');
INSERT INTO CargoPermissao (fkCargo, fkPermissao) VALUES 
	('${fkCargo}', 1),
	('${fkCargo}', 2),
	('${fkCargo}', 3),
	('${fkCargo}', 4);
INSERT INTO Funcionario (nomeFuncionario, email,telefone, senha, fkVinicola, fkCargo) VALUES ('${nome}', '${email}', '${telefone}', '${senha}', '${fkVinicola}', '${fkCargo}'); -- completo ainda nao
INSERT INTO Funcionario (nomeFuncionario, email,telefone, senha, fkVinicola) VALUES ('${nome}', '${email}', '${telefone}', '${senha}', '${fkVinicola}'); -- ja foi

		-- 3 º usando group_concat mas ela nao passou 
create view vw_informacoes_login as
select f.idFuncionario, f.nomeFuncionario, f.email, f.telefone, f.fkCargo,
		v.idVinicola, v.nomeFantasia, 
			c.idCargo, c.nomeCargo,
    GROUP_CONCAT(DISTINCT cp.fkPermissao ) AS fkpermissoes
		from vinicola v join funcionario f on v.idVinicola = f.fkVinicola
			join cargo c on c.idCargo = f.fkCargo
				join cargoPermissao cp on cp.fkCargo = c.idCargo;
--  WHERE email = '${email}' AND senha = '${senha}';

-- agora dentro do site 
-- deshbord 
SELECT * FROM armazem  WHERE fkVinicola = 11;

select * from Funcionario;
select * from vinicola;
INSERT INTO Funcionario values
(1, 'Maria', 'maria@gmail.com', 'Urubu100$', null, '11946787175', 1, 1);

select * from Sensor;

CREATE VIEW vw_AlertaEmTempoReal AS
SELECT 
    r.idRegistro,
    r.dataHora,
    r.temperatura,
    r.umidade,
    s.nomeSerial AS sensor,
    a.nomeArmazem,
    gv.classe AS tipoVinho,
    s.fkArmazem,
    
    CASE 
        WHEN r.temperatura > gv.temperaturaMax THEN 'Temperatura Acima'
        WHEN r.temperatura < gv.temperaturaMin THEN 'Temperatura Abaixo'
        WHEN r.umidade > gv.umidadeMax THEN 'Umidade Acima'
        WHEN r.umidade < gv.umidadeMin THEN 'Umidade Abaixo'
        ELSE 'Normal'
    END AS statusAlerta
    
FROM Registro r
JOIN Sensor s ON r.fkSensor = s.idSensor
JOIN Armazem a ON s.fkArmazem = a.idArmazem
JOIN GrupoVinho gv ON a.fkGrupoVinho = gv.idGrupoVinho;
select * from vw_AlertaEmTempoReal;

CREATE VIEW vw_AlertasPersistentes AS
SELECT 
	fkArmazem,
    sensor,
    statusAlerta,
    MIN(dataHora) AS inicioAlerta,
    TIMESTAMPDIFF(MINUTE, MIN(dataHora), NOW()) AS minutosEmAlerta
    
FROM vw_AlertaEmTempoReal
WHERE statusAlerta <> 'Normal'
GROUP BY sensor, statusAlerta;
select * from vw_AlertasPersistentes;

select * from Sensor;
select count(s.idSensor) as total_sensores, 
	(select count(s.idSensor) from Sensor as s where statusSensor = 'Ativo' and s.fkArmazem = 2 ) as total_sensor_ativo, 
		(select count(s.idSensor) from Sensor as s where statusSensor = 'Inativo'  and s.fkArmazem = 2) as total_sensor_inativo
	from Sensor as s 
    join Armazem as a on s.fkArmazem = a.idArmazem 
    where a.idArmazem = 2;
    
select GrupoVinho.* from GrupoVinho 
	join Armazem on Armazem.fkGrupoVinho = GrupoVinho.idGrupoVinho 
    where Armazem.idArmazem = 1;
    
select * from Funcionario;




