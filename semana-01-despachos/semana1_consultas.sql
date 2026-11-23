-- =====================================================================
-- PRÁCTICA SQL - SEMANA 1 | Base de datos: Despachos (SQL Server)
-- Autor: Eduardo David Ramos Osorio
-- Temas: SELECT, WHERE, NULL, IN, BETWEEN, LIKE, TOP, DISTINCT,
--        DATEDIFF, funciones de agregado, GROUP BY, HAVING,
--        INNER JOIN, LEFT JOIN y anti-join
-- Para crear la base de datos, ejecutar antes: semana1_despachos.sql
-- =====================================================================

USE Despachos;
GO

-- =====================================================================
-- DÍA 1: FILTROS Y ORDENAMIENTO
-- =====================================================================

-- PREGUNTA 1: Pedidos con estado 'Entregado'
SELECT *
FROM Pedidos
WHERE estado = 'Entregado';
-- Resultado: 11 pedidos


-- PREGUNTA 2: Cliente, distrito y monto de pedidos mayores a 3000,
--             ordenados de mayor a menor monto
SELECT cliente, distrito, monto
FROM Pedidos
WHERE monto > 3000
ORDER BY monto DESC;
-- Aprendizaje: SQL ejecuta en este orden: FROM > WHERE > GROUP BY > HAVING > SELECT > ORDER BY.
-- Por eso un alias creado en el SELECT no se puede usar en el WHERE, pero sí en el ORDER BY.


-- PREGUNTA 3: Pedidos que todavía no tienen fecha de entrega
SELECT *
FROM Pedidos
WHERE fecha_entrega IS NULL;
-- Aprendizaje: NULL significa "valor desconocido". La comparación "= NULL" nunca es verdadera
-- y devuelve 0 filas sin dar error. Se usa IS NULL / IS NOT NULL.


-- PREGUNTA 4: Pedidos de los distritos Los Olivos, Comas o Independencia (dos formas)
SELECT *
FROM Pedidos
WHERE distrito IN ('Los Olivos', 'Comas', 'Independencia');

SELECT *
FROM Pedidos
WHERE distrito = 'Los Olivos' OR distrito = 'Comas' OR distrito = 'Independencia';
-- Aprendizaje: IN es más corto y legible cuando se compara una columna con varios valores.
-- Si se mezcla OR con AND, SQL evalúa primero el AND: hay que usar paréntesis.


-- PREGUNTA 5: Pedidos realizados entre el 5 y el 10 de noviembre de 2026
SELECT *
FROM Pedidos
WHERE fecha_pedido BETWEEN '2026-11-05' AND '2026-11-10';
-- Aprendizaje: BETWEEN incluye ambos extremos y funciona bien con columnas DATE.
-- Si la columna es DATETIME (con hora), deja afuera las horas del último día.
-- Forma segura para cualquier tipo de fecha:
--   WHERE fecha_pedido >= '2026-11-05' AND fecha_pedido < '2026-11-11'


-- PREGUNTA 6: Clientes cuyo nombre empieza con "Tienda" o "Hotel"
SELECT *
FROM Pedidos
WHERE cliente LIKE 'Tienda%' OR cliente LIKE 'Hotel%';
-- Aprendizaje: % = cualquier cantidad de caracteres, _ = exactamente un carácter.
-- No existe "LIKE IN (...)": con varios patrones se usa OR.


-- PREGUNTA 7: Los 3 pedidos con mayor cantidad de colchones
SELECT TOP 3 *
FROM Pedidos
ORDER BY cantidad DESC;
-- Aprendizaje: TOP sin ORDER BY devuelve filas en orden arbitrario.
-- TOP 3 WITH TIES incluye los empates. En MySQL/PostgreSQL se usa LIMIT 3.


-- PREGUNTA 8: Distritos sin repetir, en orden alfabético
SELECT DISTINCT distrito
FROM Pedidos
ORDER BY distrito ASC;
-- Aprendizaje: DISTINCT aplica a todas las columnas del SELECT.
-- Para contar sin listar: SELECT COUNT(DISTINCT distrito) FROM Pedidos;


-- PREGUNTA 9 (reto): Pedidos entregados que tardaron más de 1 día en entregarse
SELECT id_pedido, cliente, fecha_pedido, fecha_entrega,
       DATEDIFF(DAY, fecha_pedido, fecha_entrega) AS dias_entrega
FROM Pedidos
WHERE estado = 'Entregado'
  AND DATEDIFF(DAY, fecha_pedido, fecha_entrega) > 1
ORDER BY dias_entrega DESC;
-- Aprendizaje: en el WHERE se repite el cálculo (el alias aún no existe);
-- en el ORDER BY sí se puede usar el alias.


-- =====================================================================
-- DÍA 2: FUNCIONES DE AGREGADO, GROUP BY Y HAVING
-- =====================================================================

-- PREGUNTA 10: Total de pedidos y monto total vendido
SELECT COUNT(*)   AS total_pedidos,
       SUM(monto) AS monto_total
FROM Pedidos;
-- Resultado: 15 pedidos | 52000.00
-- Aprendizaje: siempre poner alias a los cálculos (si no, aparece "No column name").
-- COUNT(*) cuenta filas; COUNT(columna) cuenta solo valores que no son NULL.


-- PREGUNTA 11: Cantidad de pedidos por estado
SELECT estado, COUNT(*) AS total_pedidos
FROM Pedidos
GROUP BY estado
ORDER BY total_pedidos DESC, estado ASC;
-- Aprendizaje: un segundo criterio en el ORDER BY desempata y hace el orden predecible.


-- PREGUNTA 12: Colchones enviados por ruta
SELECT id_ruta, SUM(cantidad) AS total_colchones
FROM Pedidos
GROUP BY id_ruta
ORDER BY total_colchones DESC, id_ruta ASC;
-- Aprendizaje: GROUP BY solo agrupa lo que existe en la tabla; la Ruta 5 (sin pedidos)
-- no aparece. Para incluirla se necesita LEFT JOIN (ver pregunta 17).


-- PREGUNTA 13: Monto promedio, mínimo y máximo por estado
SELECT estado,
       CAST(AVG(monto) AS DECIMAL(10,2)) AS monto_promedio,
       MIN(monto)           AS monto_minimo,
       MAX(monto)           AS monto_maximo
FROM Pedidos
GROUP BY estado;
-- Aprendizaje: toda columna del SELECT que no esté dentro de una función de agregado
-- debe ir en el GROUP BY (si no: error Msg 8120).
-- ROUND(AVG(monto), 2) redondea pero deja ceros sobrantes (3707.270000);
-- CAST(... AS DECIMAL(10,2)) muestra exactamente 2 decimales (3707.27).


-- PREGUNTA 14: Clientes con más de 1 pedido
SELECT cliente, COUNT(*) AS total_pedidos
FROM Pedidos
GROUP BY cliente
HAVING COUNT(*) > 1
ORDER BY total_pedidos DESC, cliente ASC;
-- Aprendizaje: WHERE filtra filas ANTES de agrupar; HAVING filtra grupos DESPUÉS de agrupar
-- y puede usar funciones de agregado. En el ORDER BY, la primera columna manda.


-- PREGUNTA 15: Rutas con más de 8000 en pedidos entregados
SELECT id_ruta, SUM(monto) AS monto_entregado
FROM Pedidos
WHERE estado = 'Entregado'
GROUP BY id_ruta
HAVING SUM(monto) > 8000
ORDER BY monto_entregado DESC;
-- Aprendizaje: WHERE y HAVING en la misma consulta, cada uno en su momento.


-- =====================================================================
-- DÍA 3: JOIN
-- =====================================================================

-- PREGUNTA 16: Cada pedido con el nombre de su ruta y el chofer que lo llevó
SELECT p.id_pedido, p.cliente, r.nombre_ruta, u.chofer, p.estado
FROM Pedidos AS p
INNER JOIN Rutas AS r
    ON p.id_ruta = r.id_ruta
INNER JOIN Unidades AS u
    ON p.id_unidad = u.id_unidad
ORDER BY p.id_pedido;
-- Aprendizaje: INNER JOIN une tablas por una columna en común y devuelve solo las coincidencias.
-- Los alias de tabla (p, r, u) indican de qué tabla viene cada columna.


-- PREGUNTA 17: Todas las rutas con su cantidad de pedidos (incluida Callao con 0)
SELECT r.nombre_ruta, COUNT(p.id_pedido) AS total_pedidos
FROM Rutas AS r
LEFT JOIN Pedidos AS p
    ON r.id_ruta = p.id_ruta
GROUP BY r.nombre_ruta
ORDER BY total_pedidos DESC;
-- Aprendizaje: LEFT JOIN trae todas las filas de la tabla izquierda; si no hay coincidencia,
-- las columnas de la derecha quedan en NULL.
-- Versión INCORRECTA: COUNT(*) cuenta la fila de Callao (con NULL) y da 1.
-- Con LEFT JOIN se cuenta una columna de la tabla derecha, nunca COUNT(*).


-- PREGUNTA 18: Rutas que no tienen ningún pedido (anti-join)
SELECT r.nombre_ruta
FROM Rutas AS r
LEFT JOIN Pedidos AS p
    ON r.id_ruta = p.id_ruta
WHERE p.id_pedido IS NULL;
-- Resultado: Ruta Callao
-- Aprendizaje: LEFT JOIN + WHERE clave_de_la_derecha IS NULL = registros sin coincidencia.
-- Se filtra por la clave primaria porque nunca es NULL en un registro real.
-- Uso real: clientes que nunca compraron, productos sin ventas, choferes sin despachos.


-- PREGUNTA 19: Pedidos y colchones entregados por chofer
SELECT u.chofer,
       COUNT(p.id_pedido) AS pedidos_entregados,
       SUM(p.cantidad)    AS colchones_entregados
FROM Pedidos AS p
INNER JOIN Unidades AS u
    ON p.id_unidad = u.id_unidad
WHERE p.estado = 'Entregado'
GROUP BY u.chofer
ORDER BY colchones_entregados DESC;
-- Aprendizaje: COUNT cuenta filas, SUM suma valores. Si dos columnas dan los mismos
-- números, sospechar: hay que verificar que los resultados tengan sentido.


-- =====================================================================
-- HALLAZGOS DEL ANÁLISIS
-- =====================================================================
-- 1. Cumplimiento: 11 de 15 pedidos entregados (73%); 4 sin entregar (27%).
-- 2. Ruta Este: es la que más colchones movió (28), pero 16 no se entregaron
--    y quedó fuera del grupo de rutas con más de 8000 entregados.
-- 3. Los pedidos reprogramados tienen el monto promedio más alto (4690),
--    por encima de los entregados (3707.27): se reprograman los pedidos más grandes.
-- 4. Las entregas más lentas (3 días) fueron a Villa El Salvador y Puente Piedra.
-- 5. La Ruta Callao no tiene pedidos registrados.
