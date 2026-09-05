-- ========================================================
-- PROYECTO: Maritime Analytics Pro - NAVEMAR S.A.S. (Modelo BI)
-- ========================================================

-- DIMENSIÓN 1: Buques (Flota)
CREATE TABLE buques (
    id_buque INT PRIMARY KEY,
    nombre_buque VARCHAR(100),
    tipo_nave VARCHAR(50),
    capacidad_teu INT
);

-- DIMENSIÓN 2: Puertos (Logística Portuaria)
CREATE TABLE puertos (
    id_puerto INT PRIMARY KEY,
    nombre_puerto VARCHAR(100),
    ciudad VARCHAR(50),
    pais VARCHAR(50)
);

-- DIMENSIÓN 3: Clientes / Navieras (Comercial)
CREATE TABLE clientes_navieras (
    id_cliente INT PRIMARY KEY,
    nombre_empresa VARCHAR(100),
    sector_industrial VARCHAR(50)
);

-- DIMENSIÓN 4: Tipos de Carga (Operaciones)
CREATE TABLE tipos_carga (
    id_tipo_carga INT PRIMARY KEY,
    descripcion_carga VARCHAR(50) -- 'Dry (Seco)', 'Reefer (Refrigerado)', 'Bulk (Granel)'
);

-- TABLA DE HECHOS: Operaciones / Fletes (Transaccional)
CREATE TABLE operaciones (
    id_operacion INT PRIMARY KEY,
    id_buque INT,
    id_puerto_origen INT,
    id_puerto_destino INT,
    id_cliente INT,
    id_tipo_carga INT,
    costo_flete DECIMAL(12,2),
    peso_toneladas DECIMAL(10,2),
    fecha_zarpe DATE,
    FOREIGN KEY (id_buque) REFERENCES buques(id_buque),
    FOREIGN KEY (id_puerto_origen) REFERENCES puertos(id_puerto),
    FOREIGN KEY (id_puerto_destino) REFERENCES puertos(id_puerto),
    FOREIGN KEY (id_cliente) REFERENCES clientes_navieras(id_cliente),
    FOREIGN KEY (id_tipo_carga) REFERENCES tipos_carga(id_tipo_carga)
);

-- ========================================================
-- INSERCIÓN DE DATOS DE PRUEBA (Simulación Real)
-- ========================================================
INSERT INTO buques VALUES (1, 'Hanjin Cartagena', 'Porta contenedores', 4500);
INSERT INTO buques VALUES (2, 'MSC Bogota Express', 'Porta contenedores', 8200);

INSERT INTO puertos VALUES (10, 'Sociedad Puerto Industrial de Aguadulce', 'Buenaventura', 'Colombia');
INSERT INTO puertos VALUES (20, 'Port of Miami', 'Miami', 'Estados Unidos');
INSERT INTO puertos VALUES (30, 'Port of Rotterdam', 'Rotterdam', 'Paises Bajos');

INSERT INTO clientes_navieras VALUES (100, 'Global Trading Corp', 'Alimentos');
INSERT INTO clientes_navieras VALUES (200, 'Andean Export S.A.S.', 'Textil / Manufactura');

INSERT INTO tipos_carga VALUES (1, 'Dry (Contenedor Seco)');
INSERT INTO tipos_carga VALUES (2, 'Reefer (Refrigerado)');

-- Inserción de operaciones cruzando todas las dimensiones
INSERT INTO operaciones VALUES (5001, 1, 10, 20, 100, 2, 125000.00, 24.50, '2026-06-01');
INSERT INTO operaciones VALUES (5002, 2, 10, 30, 200, 1, 240000.50, 42.00, '2026-06-05');
INSERT INTO operaciones VALUES (5003, 1, 10, 20, 100, 2, 132000.00, 28.00, '2026-06-12');

-- ========================================================
-- CONSULTA ANALÍTICA MAESTRA (Preparada para Power BI)
-- Cruza las 5 tablas para obtener un reporte gerencial completo
-- ========================================================
SELECT 
    b.nombre_buque,
    c.nombre_empresa AS cliente_naviera,
    tc.descripcion_carga,
    p_origen.nombre_puerto AS puerto_salida,
    p_destino.nombre_puerto AS puerto_llegada,
    COUNT(o.id_operacion) AS total_viajes,
    SUM(o.peso_toneladas) AS total_toneladas_movidas,
    SUM(o.costo_flete) AS ingreso_total_fletes
FROM operaciones o
JOIN buques b ON o.id_buque = b.id_buque
JOIN clientes_navieras c ON o.id_cliente = c.id_cliente
JOIN tipos_carga tc ON o.id_tipo_carga = tc.id_tipo_carga
JOIN puertos p_origen ON o.id_puerto_origen = p_origen.id_puerto
JOIN puertos p_destino ON o.id_puerto_destino = p_destino.id_puerto
WHERE o.fecha_zarpe >= '2026-01-01'
GROUP BY 
    b.nombre_buque, 
    c.nombre_empresa, 
    tc.descripcion_carga, 
    p_origen.nombre_puerto, 
    p_destino.nombre_puerto
ORDER BY ingreso_total_fletes DESC;