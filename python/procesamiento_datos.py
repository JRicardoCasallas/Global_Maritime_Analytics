import pandas as pd

pd.set_option('display.max_columns', None)
pd.set_option('display.width', 1000)
pd.set_option('display.max_colwidth', None)

print("========================================================")
print(" PROYECTO: Global_Maritime_Analytics. (Python)")
print("========================================================\n")

# 1. CREACIÓN DE LAS 4 TABLAS DE DIMENSIÓN
df_buques = pd.DataFrame({
    'id_buque': [1, 2],
    'nombre_buque': ['Hanjin Cartagena', 'MSC Bogota Express'],
    'tipo_nave': ['Porta contenedores', 'Porta contenedores'],
    'capacidad_teu': [4500, 8200]
})

df_puertos = pd.DataFrame({
    'id_puerto': [10, 20, 30],
    'nombre_puerto': ['Sociedad Puerto Industrial de Aguadulce', 'Port of Miami', 'Port of Rotterdam'],
    'ciudad': ['Buenaventura', 'Miami', 'Rotterdam'],
    'pais': ['Colombia', 'Estados Unidos', 'Paises Bajos']
})

df_clientes = pd.DataFrame({
    'id_cliente': [100, 200],
    'nombre_empresa': ['Global Trading Corp', 'Andean Export S.A.S.'],
    'sector_industrial': ['Alimentos', 'Textil / Manufactura']
})

df_cargas = pd.DataFrame({
    'id_tipo_carga': [1, 2],
    'descripcion_carga': ['Dry (Contenedor Seco)', 'Reefer (Refrigerado)']
})

# 2. CREACIÓN DE LA TABLA DE HECHOS (Operaciones / Fletes)
df_operaciones = pd.DataFrame({
    'id_operacion': [5001, 5002, 5003],
    'id_buque': [1, 2, 1],
    'id_puerto_origen': [10, 10, 10],
    'id_puerto_destino': [20, 30, 20],
    'id_cliente': [100, 200, 100],
    'id_tipo_carga': [2, 1, 2],
    'costo_flete': [125000.00, 240000.50, 132000.00],
    'peso_toneladas': [24.50, 42.00, 28.00],
    'fecha_zarpe': ['2026-06-01', '2026-06-05', '2026-06-12']
})

df_operaciones['fecha_zarpe'] = pd.to_datetime(df_operaciones['fecha_zarpe'])

print(">> Tablas cargadas exitosamente en memoria con Pandas.\n")

# 3. PROCESO DE CRUCE (Equivalente a los JOIN de SQL)
df_resultado = pd.merge(df_operaciones, df_buques, on='id_buque', how='inner')
df_resultado = pd.merge(df_resultado, df_clientes, on='id_cliente', how='inner')
df_resultado = pd.merge(df_resultado, df_cargas, on='id_tipo_carga', how='inner')

df_resultado = pd.merge(df_resultado, df_puertos, left_on='id_puerto_origen', right_on='id_puerto', how='inner')
df_resultado = df_resultado.rename(columns={'nombre_puerto': 'puerto_salida'}).drop(columns=['id_puerto', 'ciudad', 'pais'])

df_resultado = pd.merge(df_resultado, df_puertos, left_on='id_puerto_destino', right_on='id_puerto', how='inner')
df_resultado = df_resultado.rename(columns={'nombre_puerto': 'puerto_llegada'}).drop(columns=['id_puerto', 'ciudad', 'pais'])

# 4. FILTRADO Y AGRUPAMIENTO
df_filtrado = df_resultado[df_resultado['fecha_zarpe'] >= '2026-01-01']

df_agrupado = df_filtrado.groupby([
    'nombre_buque', 
    'nombre_empresa', 
    'descripcion_carga', 
    'puerto_salida', 
    'puerto_llegada'
]).agg(
    total_viajes=('id_operacion', 'count'),
    total_toneladas_movidas=('peso_toneladas', 'sum'),
    ingreso_total_fletes=('costo_flete', 'sum')
).reset_index()

df_final = df_agrupado.sort_values(by='ingreso_total_fletes', ascending=False)

# 5. IMPRESIÓN DEL REPORTE (AHORA SÍ, AL FINAL)
print("========================================================")
print(" REPORTE ANALÍTICO MAESTRO GENERADO POR PYTHON (PANDAS)")
print("========================================================")

for index, row in df_final.iterrows():
    print(f" Buque: {row['nombre_buque']}")
    print(f" Cliente: {row['nombre_empresa']}")
    print(f" Carga: {row['descripcion_carga']}")
    print(f" Ruta: {row['puerto_salida']} ---> {row['puerto_llegada']}")
    print(f" Viajes: {row['total_viajes']} | Toneladas: {row['total_toneladas_movidas']} | Ingresos: ${row['ingreso_total_fletes']:,.2f}")
    print("--------------------------------------------------------")