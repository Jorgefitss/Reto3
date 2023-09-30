/* Con Base en las tablas de Clientes y Pedidos del primer reto:
   Usando INNER JOIN crear vistas que generen:
a. Clientes que no tienen pedido facturado */
   
CREATE OR REPLACE VIEW C_SIN_FACTURA AS
SELECT C.* 
FROM Pedidos P
INNER JOIN Clientes C
ON P.COD_CLIE = C.COD_CLIE
WHERE P.VAL_ESTA_PEDI<> 'FACTURADO';


/* b. Pedidos cuyo cliente no existe en la tabla Clientes*/

CREATE OR REPLACE VIEW P_NO_EXISTE AS
SELECT P.*
FROM Pedidos P
INNER JOIN Clientes C
ON P.COD_CLIE <> C.COD_CLIE;


/*	Crear vistas para mostrar:
a.	Acumulado de atributo VAL_MONT_SOLI agrupado por estado de Pedido, 
Región de aquellos pedidos facturados en junio, considerar para ello que el codigo de cliente exista en la tabla Cliente*/

CREATE OR REPLACE VIEW ACUMULADO_V AS
SELECT P.VAL_ESTA_PEDI, P.COD_REGI, SUM(P.VAL_MONT_SOLI) AS ACUMULADO
FROM Pedidos P 
INNER JOIN Clientes C
ON P.COD_CLIE = C.COD_CLIE 
WHERE P.VAL_ESTA_PEDI= 'FACTURADO' AND EXTRACT (MONTH FROM P.FEC_FACT) = 06
GROUP BY P.VAL_ESTA_PEDI, P.COD_REGI;


/*b. En base a la consulta anterior, mostrar una columna adicional que contenga el total de registros por cada agrupación 
y condicionar a que se muestre solo aquellos que tengan más de 500 registros agrupados*/

CREATE OR REPLACE VIEW ADICIONAL_V AS
SELECT P.VAL_ESTA_PEDI, P.COD_REGI, SUM(P.VAL_MONT_SOLI) AS ACUMULADO, COUNT(*) TOTALREGISTROS
FROM Pedidos P
INNER JOIN Clientes C
ON P.COD_CLIE = C.COD_CLIE
WHERE P.VAL_ESTA_PEDI='FACTURADO' AND EXTRACT (MONTH FROM P.FEC_FACT) = 6
GROUP BY P.VAL_ESTA_PEDI, P.COD_REGI
HAVING COUNT(*)>500;
