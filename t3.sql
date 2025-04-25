CREATE TABLE Contas (
    idConta INT IDENTITY(1,1) PRIMARY KEY,
    titular VARCHAR(150),
    saldo MONEY
)

CREATE TABLE Transferencias (
    idTranferencia INT IDENTITY(1,1) PRIMARY KEY,
    idOrigem INT,
    idDestino INT,
    valorTransferencia MONEY,
    dataTransferencia DATETIME,
)


INSERT INTO Contas (titular, saldo) VALUES
('Alice Moreira', 1500.00),
('Bruno Silva', 2300.50),
('Carla Ferreira', 800.75),
('Diego Ramos', 1250.00),
('Eduarda Lima', 3000.00);

INSERT INTO Transferencias (idOrigem, idDestino, valorTransferencia, dataTransferencia)
VALUES
(1, 2, 200.00, '2020-02-14T14:00:32'),
(3, 1, 100.00, '2024-07-06T10:05:23'),
(4, 5, 500.00, '2022-04-03T09:08:56'),
(2, 3, 150.00, '2020-03-10T01:09:54');

ALTER PROCEDURE sp_RealizarTransferencia
        @idOrigem int,
        @idDestino int,
        @valor money,
		@mensagem varchar(100) OUTPUT
    AS
    BEGIN
        BEGIN TRANSACTION
        BEGIN TRY
            IF (SELECT saldo FROM Contas WHERE idConta = @idOrigem) >= @valor
            BEGIN
                UPDATE Contas SET saldo = saldo - @valor
                WHERE idConta = @idOrigem
                UPDATE Contas SET saldo = saldo + @valor
                WHERE idConta = @idDestino

                INSERT INTO Transferencias (idOrigem, idDestino, valorTransferencia, dataTransferencia)
                VALUES (@idOrigem, @idDestino, @valor, GETDATE())

                COMMIT 
                SET @mensagem = 'Transferência relizada com sucesso!';
            END
            ELSE
            BEGIN
                SET @mensagem = 'Saldo insuficiente!';
                ROLLBACK;
                RETURN;
            END
        END TRY
        BEGIN CATCH
            SET @mensagem = 'Erro na transação...';
            ROLLBACK;
            THROW;
        END CATCH
    END

