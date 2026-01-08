CREATE DATABASE angels1;
USE angels1;

select * from evento;

alter table evento add column organizador varchar(50);


CREATE TABLE usuario ( --
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    senha VARCHAR(50) NOT NULL,
    sexo ENUM("masculino", "feminino") NOT NULL, -- o ENUM posibilita escolher opções já definidas
    cargo ENUM("usuario","membro","jogador","adm","coordenador-time","presidente","vice-presidente") NOT NULL,
    newsletter BOOLEAN NOT NULL DEFAULT FALSE -- true -> sim / false -> não para receber emails, e de não for marcado é false
);

-- Emanuel Henrique Marcinek Silva
INSERT INTO usuario(id, nome, email, telefone, 
senha, sexo, cargo, newsletter) VALUES
(1, "Giovanna", "giADM@gmail.com", 
"99 99999-9999", "1234", "feminino", "adm", TRUE),
(2, "Emanuel Henrique Marcinek Silva", "vicePresidenteAngel@gmail.com", 
"99 99999-9999", "1234", "masculino", "vice-presidente", TRUE),
(3, "Julio Miguel", "presidenteAngel@gmail.com", 
"99 99999-9999", "1234", "masculino", "presidente", TRUE);
insert into usuario (id, nome, email, telefone, 
senha, sexo, cargo, newsletter) values (4, "membro", "membro@gmail.com",
"99 99999-4567", "1234", "masculino", "jogador", TRUE);

SELECT * FROM usuario;

UPDATE usuario SET email = "giovannADM@gmail.com" WHERE id = 1;
UPDATE usuario SET senha = "12345" WHERE id = 2;
UPDATE usuario SET newsletter = FALSE WHERE id = 3;

DELETE FROM usuario WHERE id = 3;

SELECT id, nome, email, cargo FROM usuario;

CREATE TABLE administrador (
	id INT PRIMARY KEY,
    carteirinha VARCHAR(8),
    FOREIGN KEY (id) REFERENCES usuario(id) -- como é a clasificação de ususario tem ligação
);

INSERT INTO administrador(id, carteirinha) VALUES
(1, "90807040");

select * from administrador;

CREATE TABLE membro(
	id INT PRIMARY KEY,
    data_nasc DATE NOT NULL,
    carteirinha INT UNIQUE NOT NULL,
    status_membro BOOLEAN NOT NULL DEFAULT TRUE,
    curso VARCHAR(50) NOT NULL,
    horas_jogadas DECIMAL(5,2),
    id_administrador INT,
    FOREIGN KEY (id_administrador) REFERENCES administrador(id),
    FOREIGN KEY (id) REFERENCES usuario(id) -- como é a clasificação de ususario tem ligação
);

CREATE TABLE times (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) UNIQUE NOT NULL,
    data_criacao DATETIME NOT NULL,
    quant_integ INT NOT NULL
);

CREATE TABLE coordenador_time(
	id_coordenador INT,
    id_time INT,
    data_nasc DATE NOT NULL,
    carteirinha INT UNIQUE NOT NULL,
    status_membro BOOLEAN NOT NULL DEFAULT TRUE,
    curso VARCHAR(50) NOT NULL,
    id_administrador INT,
    FOREIGN KEY (id_administrador) REFERENCES administrador(id),
    FOREIGN KEY (id_coordenador) REFERENCES usuario(id), -- como é a clasificação de ususario tem ligação
    FOREIGN KEY (id_time) REFERENCES times(id),
    PRIMARY KEY(id_coordenador, id_time)
);

CREATE TABLE jogador (
	id_jogador INT,
    id_time INT,
    nome_time VARCHAR(50),
    data_nasc DATE NOT NULL,
    carteirinha INT UNIQUE NOT NULL,
    status_jogador BOOLEAN NOT NULL DEFAULT TRUE,
    curso VARCHAR(50) NOT NULL,
    horas_jogadas DECIMAL(5,2),
    tempo_no_time TIME,
    id_administrador INT,
    FOREIGN KEY (id_administrador) REFERENCES administrador(id),
    FOREIGN KEY (id_jogador) REFERENCES usuario(id), -- como é a clasificação de ususario tem ligação
    FOREIGN KEY (id_time) REFERENCES times(id),
    PRIMARY KEY(id_jogador, id_time)
);

insert into jogador (data, carteirinha, status_jogador, curso) values (2006, 992, "jogadro");

create view vw_jogador as select u.nome, j.curso from usuario u
inner join jogador j on u.id = j.id_jogador;

drop view vw_jogador;

select * from usuario;

select * from evento;

CREATE TABLE treino( --
	id INT AUTO_INCREMENT PRIMARY KEY,
    duracao TIME NOT NULL,
    data_hora DATETIME NOT NULL,
    local VARCHAR(50) NOT NULL,
    tipo_treino VARCHAR(255) NOT NULL
);

CREATE TABLE treino_usuario(
	id_usuario INT,
    id_treino INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id),
    FOREIGN KEY (id_treino) REFERENCES treino(id)
);

CREATE TABLE presenca_treino (
	id_usuario INT,
    id_treino INT,
    PRIMARY KEY (id_usuario, id_treino),
    presenca BOOLEAN NOT NULL DEFAULT TRUE,
    justif_falta VARCHAR(255),
    data_registro DATETIME NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id),
    FOREIGN KEY (id_treino) REFERENCES treino(id)
);

CREATE TABLE jogo (
	id INT AUTO_INCREMENT PRIMARY KEY,
    data_hora_inicio DATETIME NOT NULL,
    data_hora_fim DATETIME NOT NULL,
    duracao TIME NOT NULL,
    local VARCHAR(50) NOT NULL,
    adversario VARCHAR(50),
    tipo_jogo VARCHAR(255) NOT NULL,
    ponto_clube INT UNSIGNED,
    ponto_adversario INT UNSIGNED,
    observacoes VARCHAR(255)
);

CREATE TABLE jogo_usuario (
	id_usuario INT,
    id_jogo INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id),
    FOREIGN KEY (id_jogo) REFERENCES jogo(id)
);

CREATE TABLE presenca_jogo (
	id_usuario INT,
    id_jogo INT,
    PRIMARY KEY (id_usuario, id_jogo),
    presenca BOOLEAN NOT NULL DEFAULT TRUE,
    justif_falta VARCHAR(255),
    data_registro DATETIME NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id),
    FOREIGN KEY (id_jogo) REFERENCES jogo(id)
);

create TABLE evento (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    local VARCHAR(50) NOT NULL,
    data DATE NOT NULL,
    hora time not null,
    duracao TIME NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

select * from evento;

alter table evento add column hora time not null;

alter table evento drop column hora;



insert into evento values (2, 'jogo', 'quadra coberta', '2025-05-12 13:00:00', '04:00:00', 'é isso ai', 1);

delete from evento where id = 1;

CREATE TABLE presenca_evento (
	id_usuario INT,
    id_evento INT,
    PRIMARY KEY (id_usuario, id_evento),
    presenca BOOLEAN NOT NULL DEFAULT TRUE,
    justif_falta VARCHAR(255),
    data_registro DATETIME NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id),
    FOREIGN KEY (id_evento) REFERENCES evento(id)
);

CREATE TABLE pedido (
	id INT AUTO_INCREMENT PRIMARY KEY,
    data_compra DATETIME NOT NULL,
    valor_total DECIMAL(10, 2) UNSIGNED NOT NULL,
    status VARCHAR(50) NOT NULL,
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

CREATE TABLE produto (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) UNSIGNED NOT NULL,
    estoque INT UNSIGNED NOT NULL,
    categoria VARCHAR(255) NOT NULL,
    id_administrador INT,
    FOREIGN KEY (id_administrador) REFERENCES administrador(id)
);

CREATE TABLE item_pedido (
	id_pedido INT,
    id_produto INT,
    PRIMARY KEY (id_pedido, id_produto),
    quantidade INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id),
    FOREIGN KEY (id_produto) REFERENCES produto(id)
);

CREATE TABLE notificacao (
	id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    objetivo VARCHAR(200) NOT NULL,
    conteudo VARCHAR(1000) NOT NULL,
    data_public DATE NOT NULL,
    id_adm INT,
    id_coordenador INT,
    FOREIGN KEY (id_adm) REFERENCES administrador(id),
    FOREIGN KEY (id_coordenador) REFERENCES coordenador_time(id_coordenador)
);

-- Exercícios

-- VIEW

drop view usuario_view;

Create view us as select nome, telefone, cargo from usuario where id < 5;

select * from administrador;

select * from us;

update administrador set carteirinha = "null" where id = 1;

drop trigger tg;

DELIMITER $$

CREATE TRIGGER tg AFTER UPDATE ON administrador

FOR EACH ROW BEGIN

	update usuario set nome = "Giovanna123466" where id = 1;

END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp (IN id_ad int)
begin

	SELECT u.nome, adm.carteirinha from usuario u
    inner join administrador adm on u.id = adm.id
    where u.id = id_ad;

end $$

DELIMITER ;

CALL sp (1);

select id, nome, COUNT(*) as total_usuarios from usuario
group by id;



DELIMITER $$

CREATE TRIGGER tg_adm AFTER INSERT ON usuario

FOR EACH ROW
BEGIN

IF usuario(cargo) = "adm" THEN
INSERT INTO administrador(id, carteirinha) values (usuario.id, "12345678");
END IF;
END $$

DELIMITER ;



-- Exercicios

drop trigger tg_usu_adm;

DELIMITER $$

Create trigger tg_usu_adm after insert on usuario

for each row
begin

insert into administrador values (new.id, new.telefone);

end $$

DELIMITER ;

select * from administrador;

insert into usuario values (5, 'teste', 'teste@gmail.com', '888888', '1234', 'masculino', 'usuario', TRUE);

--

DELIMITER $$

CREATE PROCEDURE pr_teste (in cargo varchar(100))
BEGIN
IF cargo = 'adm' THEN

select u.nome, adm.carteirinha from usuario u
inner join administrador adm on u.id = adm.id;

END IF;
END $$

DELIMITER ;

CALL pr_teste ('adm');


CREATE VIEW vw_usuario_adm as select nome, COUNT(id) from usuario where id < 8
group by id;

drop view vw_usuario_adm;

select * from vw_usuario_adm;


-- exercicios

create view vw_jogadores as select nome.u, id.j from usuario u
inner join jogador j on id.u = id.jogador;




