import sqlitecloud
import csv

conn = sqlitecloud.connect("sqlitecloud://ctccla0bsk.g6.sqlite.cloud:8860/bd?apikey=CiZfNAzGw9AS1ubWDvbTLVdaWGuZBqraTzVrVxoQoeE")
cur = conn.execute('''SELECT *
                    FROM FACTURAS, FACTURA_DETALLES, PRODUCTOS, ESTADOS_FACTURA, DIRECCIONES AS DIR_FAC, LOCALIDADES, PROVINCIAS, CLIENTES, TELEFONOS, SEGMENTOS_CLIENTE, DIRECCIONES AS DIR_CLI
                    WHERE FACTURAS.FACTURA_ID = FACTURA_DETALLES.FACTURA_ID 
                    AND FACTURA_DETALLES.PRODUCTO_ID = PRODUCTOS.PRODUCTO_ID
                    AND FACTURAS.ESTADO_FACTURA_ID = ESTADOS_FACTURA.ESTADO_FACTURA_ID
                    AND FACTURAS.DIRECCION_ID = DIR_FAC.DIRECCION_ID
                    AND DIR_FAC.LOCALIDAD_ID = LOCALIDADES.LOCALIDAD_ID
                    AND LOCALIDADES.PROVINCIA_ID = PROVINCIAS.PROVINCIA_ID
                    AND FACTURAS.CLIENTE_ID = CLIENTES.CLIENTE_ID
                    AND CLIENTES.CLIENTE_ID = TELEFONOS.CLIENTE_ID
                    AND CLIENTES.SEGMENTO_CLIENTE = SEGMENTOS_CLIENTE.SEGMENTO_CLIENTE_ID
                    AND CLIENTES.DIRECCION_ID = DIR_CLI.DIRECCION_ID
                    ORDER BY FACTURAS.FACTURA_ID, FACTURA_DETALLES.FACTURA_DETALLE_ID;''')
lista = []
for row in cur:
  lista.append(list(row))
print(lista)
with open('/Users/ppando/Materias/data/materias/base-datos/exa/exportacion_python.csv', 'w') as f:
  write = csv.writer(f, delimiter=';')
  write.writerows(lista)