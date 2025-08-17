import sqlitecloud

conn = sqlitecloud.connect("sqlitecloud://ctccla0bsk.g6.sqlite.cloud:8860/bd?apikey=CiZfNAzGw9AS1ubWDvbTLVdaWGuZBqraTzVrVxoQoeE")
conn.execute("INSERT INTO SEGMENTOS_CLIENTE (SEGMENTO_CLIENTE_NOMBRE, SEGMENTO_CLIENTE_BONIFICACION) VALUES ('frecuentes', 20);")
conn.execute("INSERT INTO SEGMENTOS_CLIENTE (SEGMENTO_CLIENTE_NOMBRE, SEGMENTO_CLIENTE_BONIFICACION) VALUES ('habituales', 5);")
conn.execute("INSERT INTO SEGMENTOS_CLIENTE (SEGMENTO_CLIENTE_NOMBRE, SEGMENTO_CLIENTE_BONIFICACION) VALUES ('ocasionales', 0);")
conn.close()