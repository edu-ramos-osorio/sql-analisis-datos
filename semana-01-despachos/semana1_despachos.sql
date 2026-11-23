-- ============================================
-- SEMANA 1 - Base de datos de práctica: DESPACHOS
-- Ejecuta todo este script en SQL Server (SSMS) con F5
-- ============================================

CREATE DATABASE Despachos;
GO
USE Despachos;
GO

CREATE TABLE Rutas (
    id_ruta     INT PRIMARY KEY,
    nombre_ruta VARCHAR(50),
    zona        VARCHAR(20)
);

CREATE TABLE Unidades (
    id_unidad   INT PRIMARY KEY,
    placa       VARCHAR(10),
    chofer      VARCHAR(50),
    capacidad   INT            -- cantidad máxima de colchones
);

CREATE TABLE Pedidos (
    id_pedido      INT PRIMARY KEY,
    cliente        VARCHAR(50),
    distrito       VARCHAR(30),
    id_ruta        INT FOREIGN KEY REFERENCES Rutas(id_ruta),
    id_unidad      INT FOREIGN KEY REFERENCES Unidades(id_unidad),
    fecha_pedido   DATE,
    fecha_entrega  DATE,          -- NULL = todavía no entregado
    cantidad       INT,
    monto          DECIMAL(10,2),
    estado         VARCHAR(20)    -- Entregado / Pendiente / Reprogramado
);

INSERT INTO Rutas VALUES
(1, 'Ruta Norte', 'Lima Norte'),
(2, 'Ruta Sur',   'Lima Sur'),
(3, 'Ruta Este',  'Lima Este'),
(4, 'Ruta Centro','Lima Centro'),
(5, 'Ruta Callao','Callao');

INSERT INTO Unidades VALUES
(1, 'ABC-123', 'Carlos Quispe',  20),
(2, 'BCD-456', 'Luis Mendoza',   15),
(3, 'CDE-789', 'Jorge Salazar',  25),
(4, 'DEF-321', 'Miguel Torres',  10);

INSERT INTO Pedidos VALUES
(101, 'Tienda Sueño Feliz',  'Los Olivos',    1, 1, '2026-11-02', '2026-11-03', 8,  4200.00, 'Entregado'),
(102, 'Hogar Plus',          'Comas',         1, 1, '2026-11-02', '2026-11-04', 5,  2650.00, 'Entregado'),
(103, 'Descanso Total',      'Chorrillos',    2, 2, '2026-11-03', '2026-11-05', 6,  3100.00, 'Entregado'),
(104, 'María López',         'San Juan de Lurigancho', 3, 3, '2026-11-03', NULL, 1, 890.00, 'Pendiente'),
(105, 'Muebles Rivera',      'Ate',           3, 3, '2026-11-04', '2026-11-06', 12, 6400.00, 'Entregado'),
(106, 'Hotel Miraflores',    'Miraflores',    4, 4, '2026-11-04', '2026-11-05', 10, 7500.00, 'Entregado'),
(107, 'José Ramírez',        'Independencia', 1, 2, '2026-11-05', NULL, 2, 1580.00, 'Reprogramado'),
(108, 'Tienda Sueño Feliz',  'Los Olivos',    1, 1, '2026-11-06', '2026-11-07', 7,  3650.00, 'Entregado'),
(109, 'Colchones del Sur',   'Villa El Salvador', 2, 2, '2026-11-06', '2026-11-09', 9, 4500.00, 'Entregado'),
(110, 'Ana Torres',          'Surco',         2, 4, '2026-11-07', NULL, 1, 950.00, 'Pendiente'),
(111, 'Hogar Plus',          'Comas',         1, 3, '2026-11-09', '2026-11-10', 4,  2100.00, 'Entregado'),
(112, 'Hostal Lima Centro',  'Cercado de Lima', 4, 4, '2026-11-10', '2026-11-11', 6, 3300.00, 'Entregado'),
(113, 'Muebles Rivera',      'Ate',           3, 3, '2026-11-10', NULL, 15, 7800.00, 'Reprogramado'),
(114, 'Pedro Gutiérrez',     'Puente Piedra', 1, 1, '2026-11-11', '2026-11-14', 1, 780.00, 'Entregado'),
(115, 'Descanso Total',      'Chorrillos',    2, 2, '2026-11-12', '2026-11-13', 5,  2600.00, 'Entregado');

-- Comprueba que todo cargó bien:
SELECT * FROM Rutas;
SELECT * FROM Unidades;
SELECT * FROM Pedidos;

