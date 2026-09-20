SET search_path TO sst, public;

INSERT INTO countries (country_id, name) VALUES (1,'Colombia'),(2,'Ecuador');
INSERT INTO departments (department_id,country_id,name) VALUES
  (1,1,'Antioquia'),(2,1,'Cundinamarca'),(3,2,'Pichincha');
INSERT INTO municipalities (municipality_id,department_id,name) VALUES
  (1,1,'Medellín'),(2,1,'Envigado'),(3,2,'Bogotá'),(4,3,'Quito');
INSERT INTO tenant_sizes (tenant_size_id,description) VALUES
  (1,'Micro'),(2,'Pequeña'),(3,'Mediana'),(4,'Grande');
INSERT INTO type_system_sst (system_id,code,description) VALUES
  (1,'SST','Seguridad y Salud en el Trabajo'),(2,'PESV','Plan Estratégico de Seguridad Vial');
INSERT INTO phva_stages (stage_id,code,name,display_order) VALUES
  (1,'P','Planear',1),(2,'H','Hacer',2),(3,'V','Verificar',3),(4,'A','Actuar',4);

INSERT INTO tenants (tenant_id,identification,name,contact_email,phone,tenant_size_id,municipality_id,is_active,created_at) VALUES
  (1,'900001','Andes Seguros','contacto@andes.example','6040000001',2,1,true,'2026-01-10'),
  (2,'900002','Rutas del Norte','info@rutas.example','6040000002',3,1,true,'2026-02-15'),
  (3,'900003','Clínica Central','hola@clinica.example','6010000003',4,3,true,'2026-03-20'),
  (4,'900004','Taller Inactivo','contacto@taller.example',NULL,1,2,false,'2026-04-05'),
  (5,'900005','Empresa Nueva','info@nueva.example',NULL,1,4,true,'2026-05-01');

INSERT INTO positions (position_id,tenant_id,description) VALUES
  (1,1,'Analista SST'),(2,1,'Coordinador'),(3,2,'Conductor'),
  (4,2,'Coordinador'),(5,3,'Analista SST'),(6,4,'Operario');
INSERT INTO persons (person_id,tenant_id,position_id,identification,first_name,last_name,email,is_active) VALUES
  (1,1,1,'101','Ana','Pérez','ana@andes.example',true),
  (2,1,1,'102','Luis','Gómez','luis@andes.example',true),
  (3,1,2,'103','Eva','Rojas','eva@andes.example',true),
  (4,2,3,'201','Sara','Díaz','sara@rutas.example',true),
  (5,2,3,'202','Juan','León','juan@rutas.example',false),
  (6,3,5,'301','Marta','Gil','marta@clinica.example',true);

INSERT INTO modules (module_id,system_id,title,description,display_order) VALUES
  (1,1,'Política SST','Lineamientos de seguridad',1),
  (2,1,'Riesgos','Identificación y control',2),
  (3,1,'Auditoría SST','Verificación interna',3),
  (4,2,'Vehículos','Control de flota',1),
  (5,2,'Conductores','Formación vial',2),
  (6,2,'Seguimiento PESV','Indicadores viales',3);
INSERT INTO formats_sst (format_id,module_id,title) VALUES
  (1,1,'Política'),(2,2,'Matriz de riesgos'),(3,3,'Lista de auditoría'),
  (4,4,'Inspección vehicular'),(5,5,'Capacitación'),(6,6,'Plan de mejora');
INSERT INTO templates (template_id,format_id,title) VALUES
  (1,1,'Política anual'),(2,2,'Matriz inicial'),(3,3,'Informe de auditoría'),
  (4,4,'Control mensual'),(5,5,'Registro de formación'),(6,6,'Acciones correctivas');
INSERT INTO evaluations (evaluation_id,module_id,title,description) VALUES
  (1,2,'Evaluación de riesgos','Instrumento inicial'),
  (2,5,'Evaluación de conducción','Instrumento vial');

INSERT INTO tenantsystems (tenant_id,system_id) VALUES
  (1,1),(1,2),(2,1),(2,2),(3,1),(4,1),(5,1);
INSERT INTO tenant_modules (tenant_id,module_id,is_enabled) VALUES
  (1,1,true),(1,2,true),(1,3,true),(1,4,true),(1,5,true),(1,6,true),
  (2,1,true),(2,2,true),(2,4,true),(2,5,true),
  (3,1,true),(3,2,true),(4,1,false),(5,1,true);
INSERT INTO tenanttemplates
  (tenanttemplate_id,tenant_id,template_id,stage_id,status) VALUES
  (1,1,1,1,'finalizado'),(2,1,2,2,'finalizado'),
  (3,1,3,3,'borrador'),(4,1,4,1,'finalizado'),
  (5,1,5,2,'borrador'),(6,1,6,4,'no_iniciado'),
  (7,2,1,1,'finalizado'),(8,2,2,2,'borrador'),
  (9,2,4,3,'no_iniciado'),(10,3,1,1,'finalizado'),
  (11,3,2,4,'finalizado');

-- Las identidades siguen a los identificadores de ejemplo especificados arriba.
SELECT setval(pg_get_serial_sequence('sst.countries','country_id'),2);
SELECT setval(pg_get_serial_sequence('sst.departments','department_id'),3);
SELECT setval(pg_get_serial_sequence('sst.municipalities','municipality_id'),4);
SELECT setval(pg_get_serial_sequence('sst.tenant_sizes','tenant_size_id'),4);
SELECT setval(pg_get_serial_sequence('sst.type_system_sst','system_id'),2);
SELECT setval(pg_get_serial_sequence('sst.phva_stages','stage_id'),4);
SELECT setval(pg_get_serial_sequence('sst.tenants','tenant_id'),5);
SELECT setval(pg_get_serial_sequence('sst.positions','position_id'),6);
SELECT setval(pg_get_serial_sequence('sst.persons','person_id'),6);
SELECT setval(pg_get_serial_sequence('sst.modules','module_id'),6);
SELECT setval(pg_get_serial_sequence('sst.formats_sst','format_id'),6);
SELECT setval(pg_get_serial_sequence('sst.templates','template_id'),6);
SELECT setval(pg_get_serial_sequence('sst.evaluations','evaluation_id'),2);
SELECT setval(pg_get_serial_sequence('sst.tenanttemplates','tenanttemplate_id'),11);
