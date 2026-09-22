# Resultados de las 60 consultas

Resultados capturados de la carga inicial en PostgreSQL 16.15. Los criterios de ejemplo se indican en `CONSULTAS.sql`.

### Basica 01

**SQL comprobado**

```sql
SELECT tenant_id,identification,name,contact_email,phone,tenant_size_id,municipality_id,is_active,created_at,updated_at FROM tenants ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | identification | name | contact_email | phone | tenant_size_id | municipality_id | is_active | created_at | updated_at
1 | 900001 | Andes Seguros | contacto@andes.example | 6040000001 | 2 | 1 | t | 2026-01-10 00:00:00+00 | 2026-09-18 22:14:38.056018+00
2 | 900002 | Rutas del Norte | info@rutas.example | 6040000002 | 3 | 1 | t | 2026-02-15 00:00:00+00 | 2026-09-18 22:14:38.056018+00
3 | 900003 | Clínica Central | hola@clinica.example | 6010000003 | 4 | 3 | t | 2026-03-20 00:00:00+00 | 2026-09-18 22:14:38.056018+00
4 | 900004 | Taller Inactivo | contacto@taller.example |  | 1 | 2 | f | 2026-04-05 00:00:00+00 | 2026-09-18 22:14:38.056018+00
5 | 900005 | Empresa Nueva | info@nueva.example |  | 1 | 4 | t | 2026-05-01 00:00:00+00 | 2026-09-18 22:14:38.056018+00
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 02

**SQL comprobado**

```sql
SELECT name,contact_email,phone FROM tenants ORDER BY name;
```

**Resultado real**

```text
name | contact_email | phone
Andes Seguros | contacto@andes.example | 6040000001
Clínica Central | hola@clinica.example | 6010000003
Empresa Nueva | info@nueva.example | 
Rutas del Norte | info@rutas.example | 6040000002
Taller Inactivo | contacto@taller.example | 
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 03

**SQL comprobado**

```sql
SELECT first_name,last_name,email FROM persons ORDER BY person_id;
```

**Resultado real**

```text
first_name | last_name | email
Ana | Pérez | ana@andes.example
Luis | Gómez | luis@andes.example
Eva | Rojas | eva@andes.example
Sara | Díaz | sara@rutas.example
Juan | León | juan@rutas.example
Marta | Gil | marta@clinica.example
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 04

**SQL comprobado**

```sql
SELECT person_id,first_name,last_name,email FROM persons WHERE is_active ORDER BY person_id;
```

**Resultado real**

```text
person_id | first_name | last_name | email
1 | Ana | Pérez | ana@andes.example
2 | Luis | Gómez | luis@andes.example
3 | Eva | Rojas | eva@andes.example
4 | Sara | Díaz | sara@rutas.example
6 | Marta | Gil | marta@clinica.example
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 05

**SQL comprobado**

```sql
SELECT tenant_id,name FROM tenants WHERE name ILIKE '%Andes%' ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | name
1 | Andes Seguros
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 06

**SQL comprobado**

```sql
SELECT country_id,name FROM countries ORDER BY name;
```

**Resultado real**

```text
country_id | name
1 | Colombia
2 | Ecuador
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 07

**SQL comprobado**

```sql
SELECT department_id,name FROM departments WHERE country_id=1 ORDER BY name;
```

**Resultado real**

```text
department_id | name
1 | Antioquia
2 | Cundinamarca
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 08

**SQL comprobado**

```sql
SELECT municipality_id,name FROM municipalities WHERE department_id=1 ORDER BY name;
```

**Resultado real**

```text
municipality_id | name
2 | Envigado
1 | Medellín
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 09

**SQL comprobado**

```sql
SELECT position_id,tenant_id,description FROM positions ORDER BY description,position_id;
```

**Resultado real**

```text
position_id | tenant_id | description
1 | 1 | Analista SST
5 | 3 | Analista SST
3 | 2 | Conductor
2 | 1 | Coordinador
4 | 2 | Coordinador
6 | 4 | Operario
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 10

**SQL comprobado**

```sql
SELECT person_id,first_name,last_name FROM persons WHERE tenant_id=1 ORDER BY person_id;
```

**Resultado real**

```text
person_id | first_name | last_name
1 | Ana | Pérez
2 | Luis | Gómez
3 | Eva | Rojas
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 11

**SQL comprobado**

```sql
SELECT tenant_id,name FROM tenants WHERE is_active ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | name
1 | Andes Seguros
2 | Rutas del Norte
3 | Clínica Central
5 | Empresa Nueva
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 12

**SQL comprobado**

```sql
SELECT tenant_id,name,created_at FROM tenants WHERE created_at >= '2026-01-01' AND created_at < '2026-04-01' ORDER BY created_at;
```

**Resultado real**

```text
tenant_id | name | created_at
1 | Andes Seguros | 2026-01-10 00:00:00+00
2 | Rutas del Norte | 2026-02-15 00:00:00+00
3 | Clínica Central | 2026-03-20 00:00:00+00
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 13

**SQL comprobado**

```sql
SELECT tenant_size_id,description FROM tenant_sizes ORDER BY tenant_size_id;
```

**Resultado real**

```text
tenant_size_id | description
1 | Micro
2 | Pequeña
3 | Mediana
4 | Grande
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 14

**SQL comprobado**

```sql
SELECT system_id,code,description FROM type_system_sst ORDER BY system_id;
```

**Resultado real**

```text
system_id | code | description
1 | SST | Seguridad y Salud en el Trabajo
2 | PESV | Plan Estratégico de Seguridad Vial
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Basica 15

**SQL comprobado**

```sql
SELECT module_id,title,description,display_order FROM modules ORDER BY system_id,display_order;
```

**Resultado real**

```text
module_id | title | description | display_order
1 | Política SST | Lineamientos de seguridad | 1
2 | Riesgos | Identificación y control | 2
3 | Auditoría SST | Verificación interna | 3
4 | Vehículos | Control de flota | 1
5 | Conductores | Formación vial | 2
6 | Seguimiento PESV | Indicadores viales | 3
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 01

**SQL comprobado**

```sql
SELECT p.person_id,CONCAT_WS(' ',p.first_name,p.last_name) AS full_name,t.name AS tenant_name FROM persons p JOIN tenants t ON t.tenant_id=p.tenant_id ORDER BY p.person_id;
```

**Resultado real**

```text
person_id | full_name | tenant_name
1 | Ana Pérez | Andes Seguros
2 | Luis Gómez | Andes Seguros
3 | Eva Rojas | Andes Seguros
4 | Sara Díaz | Rutas del Norte
5 | Juan León | Rutas del Norte
6 | Marta Gil | Clínica Central
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 02

**SQL comprobado**

```sql
SELECT p.person_id,CONCAT_WS(' ',p.first_name,p.last_name) AS full_name,po.description AS position_name FROM persons p JOIN positions po ON (po.tenant_id,po.position_id)=(p.tenant_id,p.position_id) ORDER BY p.person_id;
```

**Resultado real**

```text
person_id | full_name | position_name
1 | Ana Pérez | Analista SST
2 | Luis Gómez | Analista SST
3 | Eva Rojas | Coordinador
4 | Sara Díaz | Conductor
5 | Juan León | Conductor
6 | Marta Gil | Analista SST
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 03

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name,s.description AS tenant_size FROM tenants t JOIN tenant_sizes s ON s.tenant_size_id=t.tenant_size_id ORDER BY t.tenant_id;
```

**Resultado real**

```text
tenant_id | name | tenant_size
1 | Andes Seguros | Pequeña
2 | Rutas del Norte | Mediana
3 | Clínica Central | Grande
4 | Taller Inactivo | Micro
5 | Empresa Nueva | Micro
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 04

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,municipality_name,department_name,country_name FROM vw_tenant_geography ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | tenant_name | municipality_name | department_name | country_name
1 | Andes Seguros | Medellín | Antioquia | Colombia
2 | Rutas del Norte | Medellín | Antioquia | Colombia
3 | Clínica Central | Bogotá | Cundinamarca | Colombia
4 | Taller Inactivo | Envigado | Antioquia | Colombia
5 | Empresa Nueva | Quito | Pichincha | Ecuador
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 05

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name,COUNT(p.person_id) AS person_count FROM tenants t LEFT JOIN persons p ON p.tenant_id=t.tenant_id GROUP BY t.tenant_id,t.name ORDER BY t.tenant_id;
```

**Resultado real**

```text
tenant_id | name | person_count
1 | Andes Seguros | 3
2 | Rutas del Norte | 2
3 | Clínica Central | 1
4 | Taller Inactivo | 0
5 | Empresa Nueva | 0
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 06

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name,COUNT(p.person_id) AS person_count FROM tenants t LEFT JOIN persons p ON p.tenant_id=t.tenant_id GROUP BY t.tenant_id,t.name HAVING COUNT(p.person_id)>1 ORDER BY person_count DESC;
```

**Resultado real**

```text
tenant_id | name | person_count
1 | Andes Seguros | 3
2 | Rutas del Norte | 2
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 07

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,module_id,module_title,system_code FROM vw_tenant_modules WHERE is_enabled ORDER BY tenant_id,module_id;
```

**Resultado real**

```text
tenant_id | tenant_name | module_id | module_title | system_code
1 | Andes Seguros | 1 | Política SST | SST
1 | Andes Seguros | 2 | Riesgos | SST
1 | Andes Seguros | 3 | Auditoría SST | SST
1 | Andes Seguros | 4 | Vehículos | PESV
1 | Andes Seguros | 5 | Conductores | PESV
1 | Andes Seguros | 6 | Seguimiento PESV | PESV
2 | Rutas del Norte | 1 | Política SST | SST
2 | Rutas del Norte | 2 | Riesgos | SST
2 | Rutas del Norte | 4 | Vehículos | PESV
2 | Rutas del Norte | 5 | Conductores | PESV
3 | Clínica Central | 1 | Política SST | SST
3 | Clínica Central | 2 | Riesgos | SST
5 | Empresa Nueva | 1 | Política SST | SST
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 08

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name,COUNT(tm.module_id) FILTER (WHERE tm.is_enabled) AS module_count FROM tenants t LEFT JOIN tenant_modules tm ON tm.tenant_id=t.tenant_id GROUP BY t.tenant_id,t.name ORDER BY t.tenant_id;
```

**Resultado real**

```text
tenant_id | name | module_count
1 | Andes Seguros | 6
2 | Rutas del Norte | 4
3 | Clínica Central | 2
4 | Taller Inactivo | 0
5 | Empresa Nueva | 1
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 09

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name,s.code,s.description FROM tenantsystems ts JOIN tenants t ON t.tenant_id=ts.tenant_id JOIN type_system_sst s ON s.system_id=ts.system_id ORDER BY t.tenant_id,s.system_id;
```

**Resultado real**

```text
tenant_id | name | code | description
1 | Andes Seguros | SST | Seguridad y Salud en el Trabajo
1 | Andes Seguros | PESV | Plan Estratégico de Seguridad Vial
2 | Rutas del Norte | SST | Seguridad y Salud en el Trabajo
2 | Rutas del Norte | PESV | Plan Estratégico de Seguridad Vial
3 | Clínica Central | SST | Seguridad y Salud en el Trabajo
4 | Taller Inactivo | SST | Seguridad y Salud en el Trabajo
5 | Empresa Nueva | SST | Seguridad y Salud en el Trabajo
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 10

**SQL comprobado**

```sql
SELECT m.module_id,m.title,s.code FROM modules m JOIN type_system_sst s ON s.system_id=m.system_id ORDER BY m.module_id;
```

**Resultado real**

```text
module_id | title | code
1 | Política SST | SST
2 | Riesgos | SST
3 | Auditoría SST | SST
4 | Vehículos | PESV
5 | Conductores | PESV
6 | Seguimiento PESV | PESV
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 11

**SQL comprobado**

```sql
SELECT f.format_id,f.title,m.title AS module_title FROM formats_sst f JOIN modules m ON m.module_id=f.module_id ORDER BY f.format_id;
```

**Resultado real**

```text
format_id | title | module_title
1 | Política | Política SST
2 | Matriz de riesgos | Riesgos
3 | Lista de auditoría | Auditoría SST
4 | Inspección vehicular | Vehículos
5 | Capacitación | Conductores
6 | Plan de mejora | Seguimiento PESV
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 12

**SQL comprobado**

```sql
SELECT m.module_id,m.title,COUNT(f.format_id) AS format_count FROM modules m LEFT JOIN formats_sst f ON f.module_id=m.module_id GROUP BY m.module_id,m.title ORDER BY m.module_id;
```

**Resultado real**

```text
module_id | title | format_count
1 | Política SST | 1
2 | Riesgos | 1
3 | Auditoría SST | 1
4 | Vehículos | 1
5 | Conductores | 1
6 | Seguimiento PESV | 1
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 13

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name,tpl.template_id,tpl.title FROM tenanttemplates tt JOIN tenants t ON t.tenant_id=tt.tenant_id JOIN templates tpl ON tpl.template_id=tt.template_id ORDER BY t.tenant_id,tpl.template_id;
```

**Resultado real**

```text
tenant_id | name | template_id | title
1 | Andes Seguros | 1 | Política anual
1 | Andes Seguros | 2 | Matriz inicial
1 | Andes Seguros | 3 | Informe de auditoría
1 | Andes Seguros | 4 | Control mensual
1 | Andes Seguros | 5 | Registro de formación
1 | Andes Seguros | 6 | Acciones correctivas
2 | Rutas del Norte | 1 | Política anual
2 | Rutas del Norte | 2 | Matriz inicial
2 | Rutas del Norte | 4 | Control mensual
3 | Clínica Central | 1 | Política anual
3 | Clínica Central | 2 | Matriz inicial
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 14

**SQL comprobado**

```sql
SELECT t.name AS tenant_name,tpl.title AS template_title,s.code AS system_code,st.name AS stage_name FROM tenanttemplates tt JOIN tenants t ON t.tenant_id=tt.tenant_id JOIN templates tpl ON tpl.template_id=tt.template_id JOIN formats_sst f ON f.format_id=tpl.format_id JOIN modules m ON m.module_id=f.module_id JOIN type_system_sst s ON s.system_id=m.system_id JOIN phva_stages st ON st.stage_id=tt.stage_id ORDER BY t.tenant_id,tpl.template_id;
```

**Resultado real**

```text
tenant_name | template_title | system_code | stage_name
Andes Seguros | Política anual | SST | Planear
Andes Seguros | Matriz inicial | SST | Hacer
Andes Seguros | Informe de auditoría | SST | Verificar
Andes Seguros | Control mensual | PESV | Planear
Andes Seguros | Registro de formación | PESV | Hacer
Andes Seguros | Acciones correctivas | PESV | Actuar
Rutas del Norte | Política anual | SST | Planear
Rutas del Norte | Matriz inicial | SST | Hacer
Rutas del Norte | Control mensual | PESV | Verificar
Clínica Central | Política anual | SST | Planear
Clínica Central | Matriz inicial | SST | Actuar
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 15

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name,COUNT(tt.tenanttemplate_id) AS template_count FROM tenants t LEFT JOIN tenanttemplates tt ON tt.tenant_id=t.tenant_id GROUP BY t.tenant_id,t.name ORDER BY t.tenant_id;
```

**Resultado real**

```text
tenant_id | name | template_count
1 | Andes Seguros | 6
2 | Rutas del Norte | 3
3 | Clínica Central | 2
4 | Taller Inactivo | 0
5 | Empresa Nueva | 0
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 16

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name FROM tenants t LEFT JOIN persons p ON p.tenant_id=t.tenant_id WHERE p.person_id IS NULL ORDER BY t.tenant_id;
```

**Resultado real**

```text
tenant_id | name
4 | Taller Inactivo
5 | Empresa Nueva
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 17

**SQL comprobado**

```sql
SELECT m.module_id,m.title FROM modules m LEFT JOIN tenant_modules tm ON tm.module_id=m.module_id WHERE tm.module_id IS NULL ORDER BY m.module_id;
```

**Resultado real**

```text
module_id | title
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 18

**SQL comprobado**

```sql
SELECT st.stage_id,st.name,COUNT(tt.tenanttemplate_id) AS template_count FROM phva_stages st LEFT JOIN tenanttemplates tt ON tt.stage_id=st.stage_id GROUP BY st.stage_id,st.name ORDER BY st.stage_id;
```

**Resultado real**

```text
stage_id | name | template_count
1 | Planear | 4
2 | Hacer | 3
3 | Verificar | 2
4 | Actuar | 2
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 19

**SQL comprobado**

```sql
SELECT m.municipality_id,m.name,COUNT(t.tenant_id) AS tenant_count FROM municipalities m LEFT JOIN tenants t ON t.municipality_id=m.municipality_id GROUP BY m.municipality_id,m.name ORDER BY m.municipality_id;
```

**Resultado real**

```text
municipality_id | name | tenant_count
1 | Medellín | 2
2 | Envigado | 1
3 | Bogotá | 1
4 | Quito | 1
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Intermedia 20

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,position_id,position_name,person_count FROM vw_tenant_position_persons ORDER BY tenant_id,position_id;
```

**Resultado real**

```text
tenant_id | tenant_name | position_id | position_name | person_count
1 | Andes Seguros | 1 | Analista SST | 2
1 | Andes Seguros | 2 | Coordinador | 1
2 | Rutas del Norte | 3 | Conductor | 2
2 | Rutas del Norte | 4 | Coordinador | 0
3 | Clínica Central | 5 | Analista SST | 1
4 | Taller Inactivo | 6 | Operario | 0
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 01

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,person_count FROM vw_tenant_overview ORDER BY person_count DESC,tenant_id LIMIT 1;
```

**Resultado real**

```text
tenant_id | tenant_name | person_count
1 | Andes Seguros | 3
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 02

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,person_count FROM vw_tenant_overview WHERE person_count>(SELECT AVG(person_count) FROM vw_tenant_overview) ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | tenant_name | person_count
1 | Andes Seguros | 3
2 | Rutas del Norte | 2
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 03

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name FROM tenants t WHERE EXISTS(SELECT 1 FROM modules m WHERE m.system_id=1) AND NOT EXISTS(SELECT 1 FROM modules m WHERE m.system_id=1 AND NOT EXISTS(SELECT 1 FROM tenant_modules tm WHERE tm.tenant_id=t.tenant_id AND tm.module_id=m.module_id AND tm.is_enabled)) ORDER BY t.tenant_id;
```

**Resultado real**

```text
tenant_id | name
1 | Andes Seguros
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 04

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name FROM tenants t WHERE EXISTS(SELECT 1 FROM tenant_modules tm WHERE tm.tenant_id=t.tenant_id AND tm.is_enabled) AND NOT EXISTS(SELECT 1 FROM tenanttemplates tt WHERE tt.tenant_id=t.tenant_id) ORDER BY t.tenant_id;
```

**Resultado real**

```text
tenant_id | name
5 | Empresa Nueva
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 05

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name FROM tenants t WHERE NOT EXISTS(SELECT 1 FROM phva_stages st WHERE NOT EXISTS(SELECT 1 FROM tenanttemplates tt WHERE tt.tenant_id=t.tenant_id AND tt.stage_id=st.stage_id)) ORDER BY t.tenant_id;
```

**Resultado real**

```text
tenant_id | name
1 | Andes Seguros
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 06

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,stage_id,stage_name,template_count FROM vw_tenant_stage_templates ORDER BY tenant_id,stage_id;
```

**Resultado real**

```text
tenant_id | tenant_name | stage_id | stage_name | template_count
1 | Andes Seguros | 1 | Planear | 2
1 | Andes Seguros | 2 | Hacer | 2
1 | Andes Seguros | 3 | Verificar | 1
1 | Andes Seguros | 4 | Actuar | 1
2 | Rutas del Norte | 1 | Planear | 1
2 | Rutas del Norte | 2 | Hacer | 1
2 | Rutas del Norte | 3 | Verificar | 1
2 | Rutas del Norte | 4 | Actuar | 0
3 | Clínica Central | 1 | Planear | 1
3 | Clínica Central | 2 | Hacer | 0
3 | Clínica Central | 3 | Verificar | 0
3 | Clínica Central | 4 | Actuar | 1
4 | Taller Inactivo | 1 | Planear | 0
4 | Taller Inactivo | 2 | Hacer | 0
4 | Taller Inactivo | 3 | Verificar | 0
4 | Taller Inactivo | 4 | Actuar | 0
5 | Empresa Nueva | 1 | Planear | 0
5 | Empresa Nueva | 2 | Hacer | 0
5 | Empresa Nueva | 3 | Verificar | 0
5 | Empresa Nueva | 4 | Actuar | 0
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 07

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name,COUNT(tt.tenanttemplate_id) FILTER (WHERE st.code='P') AS planear,COUNT(tt.tenanttemplate_id) FILTER (WHERE st.code='H') AS hacer,COUNT(tt.tenanttemplate_id) FILTER (WHERE st.code='V') AS verificar,COUNT(tt.tenanttemplate_id) FILTER (WHERE st.code='A') AS actuar FROM tenants t LEFT JOIN tenanttemplates tt ON tt.tenant_id=t.tenant_id LEFT JOIN phva_stages st ON st.stage_id=tt.stage_id GROUP BY t.tenant_id,t.name ORDER BY t.tenant_id;
```

**Resultado real**

```text
tenant_id | name | planear | hacer | verificar | actuar
1 | Andes Seguros | 2 | 2 | 1 | 1
2 | Rutas del Norte | 1 | 1 | 1 | 0
3 | Clínica Central | 1 | 0 | 0 | 1
4 | Taller Inactivo | 0 | 0 | 0 | 0
5 | Empresa Nueva | 0 | 0 | 0 | 0
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 08

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,stage_name,ROUND(100.0*template_count/NULLIF(SUM(template_count) OVER (PARTITION BY tenant_id),0),2) AS stage_pct FROM vw_tenant_stage_templates ORDER BY tenant_id,stage_id;
```

**Resultado real**

```text
tenant_id | tenant_name | stage_name | stage_pct
1 | Andes Seguros | Planear | 33.33
1 | Andes Seguros | Hacer | 33.33
1 | Andes Seguros | Verificar | 16.67
1 | Andes Seguros | Actuar | 16.67
2 | Rutas del Norte | Planear | 33.33
2 | Rutas del Norte | Hacer | 33.33
2 | Rutas del Norte | Verificar | 33.33
2 | Rutas del Norte | Actuar | 0.00
3 | Clínica Central | Planear | 50.00
3 | Clínica Central | Hacer | 0.00
3 | Clínica Central | Verificar | 0.00
3 | Clínica Central | Actuar | 50.00
4 | Taller Inactivo | Planear | 
4 | Taller Inactivo | Hacer | 
4 | Taller Inactivo | Verificar | 
4 | Taller Inactivo | Actuar | 
5 | Empresa Nueva | Planear | 
5 | Empresa Nueva | Hacer | 
5 | Empresa Nueva | Verificar | 
5 | Empresa Nueva | Actuar | 
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 09

**SQL comprobado**

```sql
WITH ranked AS (SELECT tenant_id,tenant_name,stage_name,template_count,DENSE_RANK() OVER (PARTITION BY tenant_id ORDER BY template_count DESC) AS rank_no FROM vw_tenant_stage_templates) SELECT tenant_id,tenant_name,stage_name,template_count FROM ranked WHERE rank_no=1 AND template_count>0 ORDER BY tenant_id,stage_name;
```

**Resultado real**

```text
tenant_id | tenant_name | stage_name | template_count
1 | Andes Seguros | Hacer | 2
1 | Andes Seguros | Planear | 2
2 | Rutas del Norte | Hacer | 1
2 | Rutas del Norte | Planear | 1
2 | Rutas del Norte | Verificar | 1
3 | Clínica Central | Actuar | 1
3 | Clínica Central | Planear | 1
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 10

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,total_docs,finalized_docs,compliance_pct FROM vw_document_summary ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | tenant_name | total_docs | finalized_docs | compliance_pct
1 | Andes Seguros | 6 | 3 | 50.00
2 | Rutas del Norte | 3 | 1 | 33.33
3 | Clínica Central | 2 | 2 | 100.00
4 | Taller Inactivo | 0 | 0 | 0
5 | Empresa Nueva | 0 | 0 | 0
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 11

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,compliance_pct FROM vw_document_summary WHERE compliance_pct<(SELECT AVG(compliance_pct) FROM vw_document_summary) ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | tenant_name | compliance_pct
2 | Rutas del Norte | 33.33
4 | Taller Inactivo | 0
5 | Empresa Nueva | 0
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 12

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,compliance_pct,CASE WHEN compliance_pct<50 THEN 'bajo' WHEN compliance_pct<80 THEN 'medio' ELSE 'alto' END AS level FROM vw_document_summary ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | tenant_name | compliance_pct | level
1 | Andes Seguros | 50.00 | medio
2 | Rutas del Norte | 33.33 | bajo
3 | Clínica Central | 100.00 | alto
4 | Taller Inactivo | 0 | bajo
5 | Empresa Nueva | 0 | bajo
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 13

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,compliance_pct,DENSE_RANK() OVER (ORDER BY compliance_pct DESC) AS rank_no FROM vw_document_summary ORDER BY rank_no,tenant_id;
```

**Resultado real**

```text
tenant_id | tenant_name | compliance_pct | rank_no
3 | Clínica Central | 100.00 | 1
1 | Andes Seguros | 50.00 | 2
2 | Rutas del Norte | 33.33 | 3
4 | Taller Inactivo | 0 | 4
5 | Empresa Nueva | 0 | 4
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 14

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,compliance_pct,ROUND(compliance_pct-AVG(compliance_pct) OVER (),2) AS difference_from_average FROM vw_document_summary ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | tenant_name | compliance_pct | difference_from_average
1 | Andes Seguros | 50.00 | 13.33
2 | Rutas del Norte | 33.33 | -3.34
3 | Clínica Central | 100.00 | 63.33
4 | Taller Inactivo | 0 | -36.67
5 | Empresa Nueva | 0 | -36.67
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 15

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,finalized_docs,SUM(finalized_docs) OVER (ORDER BY tenant_id) AS cumulative_finalized FROM vw_document_summary ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | tenant_name | finalized_docs | cumulative_finalized
1 | Andes Seguros | 3 | 3
2 | Rutas del Norte | 1 | 4
3 | Clínica Central | 2 | 6
4 | Taller Inactivo | 0 | 6
5 | Empresa Nueva | 0 | 6
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 16

**SQL comprobado**

```sql
SELECT a.tenant_id AS tenant_a,a.name AS name_a,b.tenant_id AS tenant_b,b.name AS name_b FROM tenants a JOIN tenants b ON a.municipality_id=b.municipality_id AND a.tenant_size_id<>b.tenant_size_id AND a.tenant_id<b.tenant_id ORDER BY a.tenant_id,b.tenant_id;
```

**Resultado real**

```text
tenant_a | name_a | tenant_b | name_b
1 | Andes Seguros | 2 | Rutas del Norte
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 17

**SQL comprobado**

```sql
WITH occupation AS (SELECT po.tenant_id,po.position_id,COUNT(p.person_id) AS occupants FROM positions po LEFT JOIN persons p ON (p.tenant_id,p.position_id)=(po.tenant_id,po.position_id) GROUP BY po.tenant_id,po.position_id), ranked AS (SELECT tenant_id,position_id,occupants,AVG(occupants) OVER (PARTITION BY tenant_id) AS average_occupants FROM occupation) SELECT p.person_id,p.first_name,p.last_name,r.occupants,r.average_occupants FROM persons p JOIN ranked r ON (r.tenant_id,r.position_id)=(p.tenant_id,p.position_id) WHERE r.occupants>r.average_occupants ORDER BY p.person_id;
```

**Resultado real**

```text
person_id | first_name | last_name | occupants | average_occupants
1 | Ana | Pérez | 2 | 1.5000000000000000
2 | Luis | Gómez | 2 | 1.5000000000000000
4 | Sara | Díaz | 2 | 1.00000000000000000000
5 | Juan | León | 2 | 1.00000000000000000000
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 18

**SQL comprobado**

```sql
WITH counts AS (SELECT t.tenant_id,t.name,COUNT(p.person_id) AS person_count FROM tenants t LEFT JOIN persons p ON p.tenant_id=t.tenant_id GROUP BY t.tenant_id,t.name) SELECT tenant_id,name,person_count FROM counts WHERE person_count>(SELECT AVG(person_count) FROM counts) ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | name | person_count
1 | Andes Seguros | 3
2 | Rutas del Norte | 2
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 19

**SQL comprobado**

```sql
WITH summary AS (SELECT tenant_id,tenant_name,module_count,template_count,person_count FROM vw_tenant_overview) SELECT tenant_id,tenant_name,module_count,template_count,person_count FROM summary ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | tenant_name | module_count | template_count | person_count
1 | Andes Seguros | 6 | 6 | 3
2 | Rutas del Norte | 4 | 3 | 2
3 | Clínica Central | 2 | 2 | 1
4 | Taller Inactivo | 0 | 0 | 0
5 | Empresa Nueva | 1 | 0 | 0
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 20

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name,st.name AS missing_stage FROM tenants t CROSS JOIN phva_stages st WHERE NOT EXISTS(SELECT 1 FROM tenanttemplates tt WHERE tt.tenant_id=t.tenant_id AND tt.stage_id=st.stage_id) ORDER BY t.tenant_id,st.stage_id;
```

**Resultado real**

```text
tenant_id | name | missing_stage
2 | Rutas del Norte | Actuar
3 | Clínica Central | Hacer
3 | Clínica Central | Verificar
4 | Taller Inactivo | Planear
4 | Taller Inactivo | Hacer
4 | Taller Inactivo | Verificar
4 | Taller Inactivo | Actuar
5 | Empresa Nueva | Planear
5 | Empresa Nueva | Hacer
5 | Empresa Nueva | Verificar
5 | Empresa Nueva | Actuar
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 21

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name,MAX(tt.updated_at) AS last_template_update FROM tenants t LEFT JOIN tenanttemplates tt ON tt.tenant_id=t.tenant_id GROUP BY t.tenant_id,t.name ORDER BY t.tenant_id;
```

**Resultado real**

```text
tenant_id | name | last_template_update
1 | Andes Seguros | 2026-09-18 22:14:38.056018+00
2 | Rutas del Norte | 2026-09-18 22:14:38.056018+00
3 | Clínica Central | 2026-09-18 22:14:38.056018+00
4 | Taller Inactivo | 
5 | Empresa Nueva | 
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 22

**SQL comprobado**

```sql
SELECT t.tenant_id,t.name,s.pending_docs AS sst_pending,p.pending_docs AS pesv_pending FROM tenants t JOIN vm_template_sst_docs_summary s ON s.tenant_id=t.tenant_id JOIN vm_template_pesv_docs_summary p ON p.tenant_id=t.tenant_id WHERE s.pending_docs+p.pending_docs>0 ORDER BY t.tenant_id;
```

**Resultado real**

```text
tenant_id | name | sst_pending | pesv_pending
1 | Andes Seguros | 1 | 2
2 | Rutas del Norte | 1 | 1
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 23

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,total_docs,finalized_docs,draft_docs,unstarted_docs,pending_docs,compliance_pct FROM vw_document_summary ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | tenant_name | total_docs | finalized_docs | draft_docs | unstarted_docs | pending_docs | compliance_pct
1 | Andes Seguros | 6 | 3 | 2 | 1 | 3 | 50.00
2 | Rutas del Norte | 3 | 1 | 1 | 1 | 2 | 33.33
3 | Clínica Central | 2 | 2 | 0 | 0 | 0 | 100.00
4 | Taller Inactivo | 0 | 0 | 0 | 0 | 0 | 0
5 | Empresa Nueva | 0 | 0 | 0 | 0 | 0 | 0
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 24

**SQL comprobado**

```sql
SELECT s.tenant_id,s.tenant_name,s.compliance_pct AS sst_pct,p.compliance_pct AS pesv_pct,ABS(s.compliance_pct-p.compliance_pct) AS difference_pct FROM vm_template_sst_docs_summary s JOIN vm_template_pesv_docs_summary p ON p.tenant_id=s.tenant_id WHERE s.total_docs>0 AND p.total_docs>0 AND ABS(s.compliance_pct-p.compliance_pct)>10 ORDER BY s.tenant_id;
```

**Resultado real**

```text
tenant_id | tenant_name | sst_pct | pesv_pct | difference_pct
1 | Andes Seguros | 66.67 | 33.33 | 33.34
2 | Rutas del Norte | 50.00 | 0.00 | 50.00
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

### Avanzada 25

**SQL comprobado**

```sql
SELECT tenant_id,tenant_name,person_count,module_count,template_count,system_count FROM vw_tenant_overview ORDER BY tenant_id;
```

**Resultado real**

```text
tenant_id | tenant_name | person_count | module_count | template_count | system_count
1 | Andes Seguros | 3 | 6 | 6 | 2
2 | Rutas del Norte | 2 | 4 | 3 | 2
3 | Clínica Central | 1 | 2 | 2 | 1
4 | Taller Inactivo | 0 | 0 | 0 | 1
5 | Empresa Nueva | 0 | 1 | 0 | 1
```

**Idea para el examen:** identifique las tablas y cambie el criterio, la agrupacion o el umbral que pida el enunciado.

