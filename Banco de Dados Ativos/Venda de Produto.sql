DROP SEQUENCE seq_tbVendas;
DROP TRIGGER trg_AjustaSaldo;

DROP DATABASE Aula5;
CREATE DATABASE Aula5;
USE Aula5;
CREATE TABLE tbSaldos
(
	PRODUTO			VARCHAR(10),
	SALDO_INICIAL	NUMERIC(10),
	SALDO_FINAL		NUMERIC(10),
	DATA_ULT_MOV	DATETIME
);
GO

INSERT INTO tbSaldos (PRODUTO,SALDO_INICIAL,SALDO_FINAL, DATA_ULT_MOV)
	VALUES ('Produto A', 0,100, GETDATE()); 
GO

SELECT * FROM tbSaldos;


CREATE TABLE tbVendas
(
	ID_VENDAS	INT,
	PRODUTO		VARCHAR(10),
	QUANTIDADE	INT,
	DATA		DATETIME
);
GO

CREATE SEQUENCE seq_tbVendas
	AS NUMERIC
	START WITH 1
	INCREMENT BY 1;


CREATE TABLE tbHistoricoVendas
(
	PRODUTO		VARCHAR(10),
	QUANTIDADE	INT,
	DATA_VENDA	DATETIME
);
GO

--Trigger de atualização de saldos de saldo
CREATE TRIGGER trg_AjustaSaldo
ON tbVendas
FOR INSERT
AS
BEGIN
	DECLARE @QUANTIDADE		INT,
			@DATA			DATETIME,
			@PRODUTO		VARCHAR(10)

	SELECT @DATA = DATA, @QUANTIDADE = QUANTIDADE, @PRODUTO = PRODUTO FROM INSERTED

	UPDATE tbSaldos
		SET SALDO_FINAL = SALDO_FINAL - @QUANTIDADE,
			DATA_ULT_MOV = @DATA
	WHERE PRODUTO = @PRODUTO;

	INSERT INTO tbHistoricoVendas(PRODUTO, QUANTIDADE, DATA_VENDA)
		VALUES (@PRODUTO, @QUANTIDADE, @DATA);
END
GO
-- Foram vendidos 2 unidades do produto A
INSERT INTO tbVendas(ID_VENDAS, PRODUTO, QUANTIDADE, DATA)
	VALUES (NEXT VALUE FOR seq_tbVendas, 'Produto A', 5, GETDATE());
--Verificamos a venda realizada
SELECT * FROM tbVendas;
-- Isso gera uma remoção do estoque
SELECT * FROM tbSaldos;
--Também gera um histório desta movimentação
SELECT * FROM tbHistoricoVendas;

-- Foram vendidos 50 unidades do produto A
INSERT INTO tbVendas(ID_VENDAS, PRODUTO, QUANTIDADE, DATA)
	VALUES (NEXT VALUE FOR seq_tbVendas, 'Produto A', 50, GETDATE());
--Verificando a venda realizada
SELECT * FROM tbVendas;
-- Isso gera uma remoção do estoque
SELECT * FROM tbSaldos;
--Também gera um histório desta movimentação
SELECT * FROM tbHistoricoVendas;