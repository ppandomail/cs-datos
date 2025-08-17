import sqlitecloud

conn = sqlitecloud.connect("sqlitecloud://ctccla0bsk.g6.sqlite.cloud:8860/bd?apikey=CiZfNAzGw9AS1ubWDvbTLVdaWGuZBqraTzVrVxoQoeE")
conn.execute("INSERT INTO ESTADOS_FACTURA (ESTADO_FACTURA_DESCRIPCION) VALUES ('ingresada');")
conn.execute("INSERT INTO ESTADOS_FACTURA (ESTADO_FACTURA_DESCRIPCION) VALUES ('en preparacion');")
conn.execute("INSERT INTO ESTADOS_FACTURA (ESTADO_FACTURA_DESCRIPCION) VALUES ('entregada');")
conn.close()