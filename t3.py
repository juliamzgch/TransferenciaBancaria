import pyodbc

connection_string = (
    r"DRIVER={ODBC Driver 17 for SQL Server};"
    r"SERVER=PMW-L05N41H611\SQLEXPRESS;"
    r"DATABASE=ATV3;"
    r"UID=sa;"
    r"PWD=1234"
)
conn = pyodbc.connect(connection_string)

cursor = conn.cursor()

menu = '1 - Consultar saldo \n' \
       '2 - Realizar uma transferência\n' \
       'O que você deseja realizar? '
print(menu)
escolha = int(input())

if escolha == 1:
    idOrigem = int(input("Digite o ID da conta: "))
    query = 'SELECT saldo FROM Contas WHERE idConta = ?'
    cursor.execute(query, (idOrigem, ))
    results = cursor.fetchone()
    if results:
        saldo = results[0]
        print (f'Saldo da conta {idOrigem}: R${float(saldo)}')
    else:
        print("Conta não encontrada!")
    

elif escolha == 2:
    mensagem = ''
    idOrigem = int(input("Digite o ID da conta de origem: "))
    idDestino = int(input("Digite o ID da conta de destino: "))
    valor = float(input("Digite o valor da transferência: "))
    query = "SET NOCOUNT ON ; EXEC sp_RealizarTransferencia ?, ?, ?, ?"
    cursor.execute(query, (idOrigem, idDestino, valor, mensagem))
    conn.commit()
    mensagem = cursor.fetchone()
    print(mensagem)

else:
    print("Escolha inválida")

cursor.close()
conn.close()