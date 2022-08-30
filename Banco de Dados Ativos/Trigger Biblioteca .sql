Use Biblioteca;
/*
Utilizando a Base de Dados criada no exemplo da Bilioteca
Vamos aplicas os coneitos de Triggers vistos em aula 
*/
--Criando o meu primeiro Triiger com AFTER
CREATE TRIGGER teste_trigger_after
ON dbo.Editora
AFTER INSERT
AS
PRINT 'Olá Mundo';

-- Inserindo um valor para ativação do trigger
INSERT INTO Editora (nome) VALUES ('EDITORA10');

-- Verificando se a inserção foi realizada
Select * From Editora;

--Removendo o primero Trigger criado
DROP TRIGGER teste_trigger_after;

-- Criando um Trigger para manipular outras tabelas
CREATE TRIGGER trigger_after
ON Editora
AFTER INSERT
AS
INSERT INTO Autor VALUES ('Juca da SIlva','Brasileiro')
INSERT INTO Livro VALUES('B2312','Mais um Juca no Brasil',1995,6,1)

-- Inserindo um registro apra ativação do trigger acima
INSERT INTO Editora (nome) VALUES ('EDITORA11');

--Verificando as alterações realizadas
Select * from editora;
Select * from autor;
Select * from Livro;

-- Ao invés de inserir um novo valor na talba Autor , exibe uma mensagem
CREATE TRIGGER teste_trigger_insteafof
ON Autor
INSTEAD OF INSERT
AS
PRINT 'Olá de novo! Não Inserir o registro desta vez!';

-- Ao tentar realizar a inserção o trigger acima é disparado
INSERT INTO Autor VALUES ('Judas','Brasileiro');

-- Verificando se o valor foi ou não inserido no Banco de Dados
Select * from Autor;

-- Desabilita um trigger específico de uma tablea
ALTER TABLE Editora
DISABLE TRIGGER trigger_after

--Verificar a existência de triggers em uma tabela especifica
EXEC sp_helptrigger @tabname=Editora

-- Verifica a existencia de trigger em todo o banco
USE Biblioteca;
SELECT *
FROM sys.triggers
WHERE is_disabled = 0 OR  is_disabled = 1;

--Trigger com base em comandos DML em consultas específicas
CREATE TRIGGER trigger_after_autores
ON Autor
AFTER INSERT,UPDATE
AS
IF UPDATE (nome)
	BEGIN
		PRINT 'O nome foi alterado'
	END
ELSE
	BEGIN
		PRINT 'Nome não foi modificado'
	END

--Mudando o nome do autor para verificar o trigger - mensagem de alteração no nome foi exibida
UPDATE Autor
SET nome = 'Joao da Silveira'
WHERE id = 7

--Mensagem a nascionalidade do Autor o trigger deve mostrar uma mensagem dizendo que o nome 
--do altor não foi alterado.
UPDATE Autor
SET nacionalidade = 'Uruguaio'
WHERE id = 7

--Ativando Trigger recursivos no meu Banco de Dados
ALTER DATABASE Biblioteca
SET RECURSIVE_TRIGGERS ON

--Criando tabela para trigger recursivo
CREATE TABLE Trigger_recursivo
(
	codigo INT PRIMARY KEY
);

--Criação do Trigger recursivo
CREATE TRIGGER trigger_rec 
ON Trigger_recursivo
AFTER INSERT
AS
DECLARE @cod INT
SELECT
@cod = MAX(codigo)
FROM Trigger_recursivo
IF @cod < 10
	BEGIN 
		INSERT INTO Trigger_recursivo 
		SELECT MAX(codigo) + 1 FROM Trigger_recursivo
	END
ELSE
	BEGIN
		PRINT 'Trigger Recursivo Finalizado'
	END
--Verificando a funcionalidade do nosso Trigger recursivo
SELECT * from Trigger_recursivo;
--NADA MUDOU, precisamos realizar uma inserção para que o trigger seja ativado
INSERT INTO Trigger_recursivo VALUES (1);
--Verificando novamente a tabela
SELECT * from Trigger_recursivo;


