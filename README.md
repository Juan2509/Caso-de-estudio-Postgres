# Entregable: base de datos SST/PESV

Proyecto académico para PostgreSQL 16. Esta carpeta contiene el servidor Docker, el modelo, los scripts SQL, las consultas, los resultados y las pruebas necesarias para revisar el trabajo. No incluye contraseñas, apuntes de clase, migraciones históricas ni guías de estudio.

## Contenido

| Archivo | Contenido |
| --- | --- |
| `compose.yaml` y `.env.example` | Levantan PostgreSQL 16 en Docker con una clave elegida en el otro PC |
| `init/01_schema.sql` | Esquema `sst`, 18 tablas, claves, restricciones e índices |
| `init/02_data.sql` | Datos de ejemplo de cinco organizaciones |
| `init/03_logic.sql` | 9 vistas, 1 vista materializada, 8 funciones, 14 procedimientos y 15 triggers |
| `docs/MODELOS.md` | Modelos lógico, relacional y físico; diagrama; justificación de 4FN |
| `docs/modelo relacional.sql` | DDL para importar el diagrama en DrawSQL |
| `docs/DICCIONARIO.md` | Columnas, restricciones e índices del catálogo real |
| `docs/CONSULTAS.sql` | 60 consultas del examen, numeradas |
| `docs/RESULTADOS_CONSULTAS.md` | Resultado de cada consulta con los datos de ejemplo |
| `docs/TRAZABILIDAD_OBJETOS.md` | Objeto, prueba y resultado para vistas, funciones, procedimientos y triggers |
| `docs/VERIFICACION.sql` | Pruebas reversibles de datos, objetos e integridad |

## Ejecutar todo en otro PC con Docker

Instale Docker Desktop y asegúrese de que esté abierto. Copie **toda** esta carpeta al otro PC. Abra PowerShell dentro de `entregable` y siga estos pasos. No hace falta instalar `psql` en Windows: viene dentro del contenedor PostgreSQL.

1. Cree su configuración privada y cambie la clave de ejemplo por una propia. Mantenga las demás líneas si va a usar los comandos tal como aparecen abajo.

   ```powershell
   Copy-Item .env.example .env
   notepad .env
   ```

2. Inicie PostgreSQL. **En la primera creación del volumen**, Docker ejecuta automáticamente y en orden `01_schema.sql`, `02_data.sql` y `03_logic.sql`. Espere a que aparezca `healthy`.

   ```powershell
   docker compose up -d
   docker compose ps
   ```

Si la comprobación posterior no devuelve 5, revise `docker compose logs postgres` para ver el error de inicialización. No borre el volumen ni repita los scripts antes de identificar la causa.

3. Compruebe que se cargaron las cinco empresas y ejecute las consultas y pruebas. Los comandos siguientes usan el usuario y la base del `.env.example`; si los cambió, ajuste `-U` y `-d`.

   ```powershell
   docker compose exec -T postgres psql -U bkseducate -d bkddb -X -v ON_ERROR_STOP=1 -c "SELECT COUNT(tenant_id) FROM sst.tenants;"
   docker compose exec -T postgres psql -U bkseducate -d bkddb -X -v ON_ERROR_STOP=1 -f /work/docs/CONSULTAS.sql
   docker compose exec -T postgres psql -U bkseducate -d bkddb -X -v ON_ERROR_STOP=1 -c "BEGIN" -f /work/docs/VERIFICACION.sql -c "ROLLBACK"
   ```

La primera comprobación debe devolver **5**. La prueba hace cambios temporales y los revierte. PostgreSQL queda disponible en `localhost:5434`, o en el puerto que haya escrito en `.env`. Puede abrir esa conexión desde pgAdmin u otro cliente SQL. `docker compose stop` detiene el servidor sin borrar sus datos; `docker compose start` lo reanuda. Una vez creado el volumen, los scripts `init` **no se ejecutan de nuevo** al reiniciar.

La [guía oficial de Docker para PostgreSQL](https://docs.docker.com/guides/postgresql/) documenta la carga de scripts en `/docker-entrypoint-initdb.d` solo cuando el directorio de datos está vacío. En este equipo se validaron los SQL con PostgreSQL 16; la ejecución de Docker Compose en un segundo PC queda por comprobar allí, porque Docker no está disponible en esta terminal.

## Si ya existe PostgreSQL 16 en el otro PC

Use una base que aún no tenga el esquema `sst`, sitúese en esta carpeta y ajuste host, puerto, usuario y base. Este camino requiere `psql` en Windows. No ejecute esta carga manual después de iniciar el contenedor anterior, porque Docker ya la hizo.

```powershell
psql -h localhost -p 5433 -U bkseducate -d bkddb -W -X -v ON_ERROR_STOP=1 -1 -f init/01_schema.sql -f init/02_data.sql -f init/03_logic.sql
```

`-1` hace la carga en una sola transacción; ante un error la revierte. Para consultar y verificar después:

```powershell
psql -h localhost -p 5433 -U bkseducate -d bkddb -W -X -v ON_ERROR_STOP=1 -f docs/CONSULTAS.sql
psql -h localhost -p 5433 -U bkseducate -d bkddb -W -X -v ON_ERROR_STOP=1 -c "BEGIN" -f docs/VERIFICACION.sql -c "ROLLBACK"
```

Las consultas y sus salidas comprobadas están en `docs/RESULTADOS_CONSULTAS.md`. El modelo y la explicación de 4FN están en `docs/MODELOS.md`.

Las capturas del modelo relacional en `docs/MODELOS.md` están alojadas en enlaces externos; el mismo documento incluye un diagrama Mermaid y el SQL de DrawSQL como respaldo. Las capturas no se descargaron porque el servidor de imágenes no respondió desde este entorno.
