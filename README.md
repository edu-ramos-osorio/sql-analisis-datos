# Prácticas de SQL – Análisis de datos

Repositorio donde documento mi aprendizaje de SQL orientado a análisis de datos.
Cada consulta responde una pregunta de negocio e incluye lo que aprendí al resolverla.

**Autor:** Eduardo David Ramos Osorio · Estudiante de Arquitectura de Datos Empresariales (Cibertec)

## Proyecto: Base de datos de despachos

Base de datos en **SQL Server** que simula la operación de despachos de una empresa de colchones:
rutas de reparto, unidades (camiones y choferes) y pedidos con fechas, montos y estado de entrega.

| Tabla | Contenido |
|---|---|
| `Rutas` | 5 rutas por zona de Lima |
| `Unidades` | 4 camiones con chofer y capacidad |
| `Pedidos` | 15 pedidos con cliente, distrito, fechas, cantidad, monto y estado |

## Contenido

| Semana | Temas | Carpeta |
|---|---|---|
| 1 | SELECT, WHERE, NULL, LIKE, TOP, DATEDIFF, GROUP BY, HAVING, INNER JOIN, LEFT JOIN, anti-join | [semana-01-despachos](./semana-01-despachos) |
| 2 | CASE WHEN, subconsultas, CTE, manejo de NULL | *próximamente* |
| 3 | Funciones de ventana (ROW_NUMBER, RANK, LAG) | *próximamente* |

## Hallazgos del análisis (Semana 1)

- **Cumplimiento de entregas:** 11 de 15 pedidos entregados (73%).
- **Ruta Este:** es la que más colchones movió (28), pero 16 quedaron sin entregar.
- **Los pedidos reprogramados son los más grandes:** su monto promedio (4690) supera al de los entregados (3707).
- **Entregas más lentas:** 3 días, a Villa El Salvador y Puente Piedra.

## Cómo usarlo

1. Ejecutar `semana1_despachos.sql` en SQL Server Management Studio para crear la base de datos.
2. Abrir `semana1_consultas.sql` y ejecutar las consultas.

## Herramientas

SQL Server · SQL Server Management Studio · Git y GitHub
