# 🚢 Dashboard Logístico y Modelo de Datos -![alt text](image.png).

## 📋 Descripción del Proyecto
Solución analítica y de Business Intelligence desarrollada para optimizar la visualización y el seguimiento de operaciones marítimas, control de fletes, rutas y asignación de buques para la empresa **Global_Maritime_Analytics**

El proyecto implementa un flujo automatizado de datos desde bases relacionales hasta la capa de visualización ejecutiva.

## 🏗️ Arquitectura y Modelo de Datos
Se diseñó e implementó un **Modelo Estrella (Star Schema)** riguroso para garantizar el rendimiento y la integridad analítica:
- **Tabla de Hechos (`Fact_Operaciones`)**: Almacena las transacciones operativas, costos de flete, pesos y métricas de carga.
- **Tablas de Dimensión**:
  - `Dimension_Buques`: Gestión de flota y capacidades (TEUs).
  - `Dimension_Clientes`: Segmentación y datos corporativos.
  - `Dimension_Puertos`: Orígenes y destinos logísticos (relación doble con la tabla de hechos).
  - `Dimension_Tipos_Carga`: Clasificación de mercancías.

## 🔄 Flujo Automatizado (Data Pipeline)
1. Ingesta de datos operacionales en Excel estructurado.
2. Modelado de relaciones y transformaciones con **Power Query**.
3. Capa semántica con medidas optimizadas en **DAX**.
4. Actualización en vivo con un solo clic (`Esquema y datos`).

## 🛠️ Tecnologías Utilizadas
- **Python / SQL**: Estructuración y validación inicial de datos.
- **Excel**: Fuente transaccional operativa.
- **Power BI Desktop**: Modelado relacional, DAX y visualización de datos.
## 📄 Documentación Completa
Puedes consultar el [Manual Técnico y de Usuario en PDF](Manual_Tecnico_Global_Maritime_Analytics.pdf) para conocer a detalle la arquitectura, el diccionario de datos y la guía de operación del sistema.

