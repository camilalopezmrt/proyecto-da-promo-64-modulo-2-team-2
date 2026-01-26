# 🎵 Proyecto Módulo 2 – MusicStream

**Análisis de Popularidad de Canciones en la Era Digital – Proyecto Módulo 2**

Proyecto de análisis de datos musicales desarrollado por el Equipo 2 formado por **Camila López, Arantxa Barea, María Granero y Lorena Núñez**.  
El objetivo es estudiar la evolución de la popularidad de diferentes géneros, artistas, colaboraciones y tendencias globales utilizando datos de **Spotify** y **Last.fm** entre 2020 y 2024.

---

## 👥 Equipo y Roles

| Miembro | Rol | Tareas principales |
|------|-----|------------------|
| Camila López | Scrum Master / Data Analyst | Organización, tablero Kanban, definición de milestones, API Last.fm, extracción y limpieza de datos, desarrollo de queries SQL y revisión |
| María Granero | Data Analyst | API Spotify, extracción de datos, integración y validación de datasets, creación y carga de la base de datos, desarrollo de queries SQL y revisión |
| Arantxa Barea | Data Analyst | API Spotify, extracción de datos, integración y validación de datasets, creación y carga de la base de datos, desarrollo de queries SQL y revisión |
| Lorena Núñez | Data Analyst | API Last.fm, extracción de datos, apoyo en limpieza y desarrollo de queries SQL y revisión |

---

## 🎯 Objetivo del proyecto

Analizar la evolución de la música entre 2020 y 2024, centrándose en los géneros **pop, latin, indie y hip-hop**.

### Objetivos específicos
- Analizar la **popularidad media de cada género** a lo largo del tiempo  
- Identificar **artistas dominantes por género y año**  
- Estudiar **colaboraciones e hibridación entre géneros**  
- Explorar **tendencias globales** mediante tags, playcounts y oyentes  

---

## 🔄 Flujo general del proyecto

1. Extracción de datos desde las APIs de **Spotify** y **Last.fm** mediante Python.  
2. Limpieza, normalización y cruce de datos para crear datasets coherentes.  
3. Exportación de los datos a **CSV**.  
4. Volcado de los datasets en **MySQL Workbench** utilizando **SQLAlchemy**.  
5. Análisis de los datos mediante queries SQL.  
6. Obtención de insights sobre popularidad, tendencias y colaboraciones.  

---

## 🧠 Tecnologías y contenidos aplicados

### Python
- Consumo de APIs con `requests`
- Manejo de respuestas en formato JSON
- Manipulación de datos con **pandas**
- Control de errores con `try/except`
- Funciones personalizadas para parsing y limpieza
- Exportación de datos a CSV

### Bases de datos
- Diseño y carga de datos en **MySQL**
- Queries SQL para análisis exploratorio
- Integración Python–MySQL mediante **SQLAlchemy**

---

## 📒 Organización del código

El proyecto se estructura en **dos notebooks principales y scripts SQL**:

- **Notebook 1 – Extracción y limpieza de datos**  
  Incluye:
  - Llamadas a las APIs  
  - Procesamiento y limpieza de datos  
  - Normalización y matching entre fuentes  
  - Exportación de datasets finales a CSV  

- **Notebook 2 – Carga en MySQL y análisis SQL**  
  Incluye:
  - Lectura de los CSV generados  
  - Conexión con MySQL mediante SQLAlchemy  
  - Volcado de los datos a la base de datos    

- **SQL Scripts – Esquema y queries**  
  Incluye:
  - `Schema_RhythmIQ.sql`: creación completa de la base de datos y tablas
  - `Script_queries_RhythmIQ.sql`: todas las queries utilizadas para análisis y extracción de insights

---

## 🗂️ Estructura del repositorio

```text
proyecto-da-promo-64-modulo-2-team-2/   ← raíz del repo
├─ README.md
├─ .gitignore
├─ .env.example
└─ docs_equipo/
   ├─ Documentos_BBDD_queries/
   │  ├─ Exportación_resultados/
   │  ├─ Diagrama_entidad_relación_(DER).mwb
   │  ├─ Script_queries_RhythmIQ.sql
   │  └─ Schema_RhythmIQ.sql
   └─ Documentos_extracción_datos/
      ├─ dataset_spotify_tracks.csv
      ├─ dataset_unificado.csv
      ├─ df_lastfm.csv
      ├─ maestro_artistas.csv
      ├─ Fase1_Extracción_datos.ipynb
      └─ Fase2_Manipulación_carga_datos.ipynb
```

---

## ▶️ Pasos para configurar

### 1. Requisitos
- Python 3.9+
- MySQL Workbench
- Librerías principales:
  - `pandas`
  - `requests`
  - `spotipy`
  - `sqlalchemy`
  - `pymysql`
  - `python-dotenv`  

---

### 2. Configuración de variables de entorno (APIs y seguridad)

Para evitar exponer credenciales en un repositorio público, las claves de las APIs no se incluyen en el repo. En su lugar, se utiliza un archivo de variables de entorno `.env` local.

### Archivo de ejemplo `.env.example`
```bash
# -----------------------------------------------------------------------------------------------------------------------
# ARCHIVO DE EJEMPLO DE VARIABLES DE ENTORNO
# -----------------------------------------------------------------------------------------------------------------------
# Copiar este archivo a .env y rellenar con tus propias claves de API.
# -----------------------------------------------------------------------------------------------------------------------

# Clave de API de Spotify
spotipy_api_key=TU_API_KEY

# Client Secret de Spotify
spotipy_client_secret=TU_CLIENT_SECRET

# Clave de API de Last.fm
lastfm_api_key=TU_LASTFM_KEY
```

### Pasos para configurar

1. Copiar `.env.example` a `.env` en la raíz del proyecto:
```bash
   # Linux / Mac
   cp .env.example .env
   
   # Windows
   copy .env.example .env
```

2. Abrir `.env` y rellenar con tus propias claves de API. Ejemplo:
```
   spotipy_api_key=abcd1234
   spotipy_client_secret=efgh5678
   lastfm_api_key=ijkl9012
```

* Ejecutar los notebooks normalmente; el código cargará las variables con `python-dotenv` y `os.getenv()`.

⚠️**Cada persona debe crear su propio `.env` con sus credenciales. El archivo `.env` no se sube al repositorio, solo `.env.example`.**

---

### 3. Seguridad de credenciales (MySQL)

Para evitar exponer credenciales en un repositorio público, la conexión a MySQL se realiza mediante variables locales.
```python
# Ejemplo de configuración de variables locales para MySQL
mysql_user = "tu_usuario"
mysql_password = "tu_contraseña"
mysql_host = "localhost"
```

Cada persona puede configurar sus propios valores localmente sin que queden expuestos en el repositorio.

## 4. Ejecución

1. Descargar los CSV ya generados (dataset_unificado.csv y maestro_artistas.csv)
2. Configurar .env con las claves de API propias
3. Ejecutar Notebook de extracción y limpieza
4. Ejecutar Notebook de carga a MySQL
5. Analizar los datos ejecutando las queries mediante el Script_queries_RhythmIQ.sql

---

### 4. Ejecución

```bash
# 1. Descargar los CSV ya generados (dataset_unificado.csv y maestro_artistas.csv)
# 2. Configurar .env con las claves de API propias
# 3. Ejecutar Notebook de extracción y limpieza
# 4. Ejecutar Notebook de carga a MySQL
# 5. Analizar los datos ejecutando las queries mediante el Script_queries_RhythmIQ.sql

```

---

## 🧪 Pruebas y control de errores

| Escenario | Manejo |
|---------|--------|
| Track no encontrado en Last.fm | Se captura el error y el proceso continúa |
| Track sin tags | Se devuelve una lista vacía |
| Diferentes formatos de URL | Se parsean correctamente |
| Inconsistencias entre fuentes | Normalización de nombres |
| Gran volumen de datos | Guardado parcial y control de progreso |

---

## 🚀 Posibles mejoras futuras

- Paralelización de llamadas a APIs para reducir tiempos de extracción  
- Inclusión de más géneros y subgéneros  
- Análisis de tendencias emergentes  
- Automatización completa del pipeline de datos  
- Ampliación de visualizaciones interactivas en Tableau  

---

## 🎤 Presentación del proyecto

La presentación incluye:
- Contexto y objetivos del proyecto  
- Flujo completo de extracción y limpieza de datos  
- Ejemplo de carga y query en MySQL  
- Visualizaciones y principales insights obtenidos  

---

## 📄 Licencia

Proyecto académico desarrollado en el marco del bootcamp de **Adalab**.  
Uso educativo.

**Autores:**  
Camila López · Arantxa Barea · María Granero · Lorena Núñez

