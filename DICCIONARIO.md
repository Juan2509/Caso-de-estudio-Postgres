# Diccionario fisico de datos

Generado desde el catalogo de PostgreSQL 16 del esquema `sst`. `NULL: SI` indica que el campo admite valores nulos. Las restricciones exactas aparecen despues de las columnas.

## countries

Paises

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| country_id | bigint | NO | IDENTITY |
| name | text | NO |  |

## departments

Departamentos o regiones

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| department_id | bigint | NO | IDENTITY |
| country_id | bigint | NO |  |
| name | text | NO |  |

## editing_locks

Bloqueos de edicion

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| lock_id | bigint | NO | IDENTITY |
| tenanttemplate_id | bigint | NO |  |
| person_id | bigint | NO |  |
| expires_at | timestamp with time zone | NO |  |
| is_active | boolean | NO | true |
| created_at | timestamp with time zone | NO | CURRENT_TIMESTAMP |

## evaluations

Evaluaciones por modulo

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| evaluation_id | bigint | NO | IDENTITY |
| module_id | bigint | NO |  |
| title | text | NO |  |
| description | text | SI |  |

## formats_sst

Formatos por modulo

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| format_id | bigint | NO | IDENTITY |
| module_id | bigint | NO |  |
| title | text | NO |  |

## modules

Modulos por sistema

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| module_id | bigint | NO | IDENTITY |
| system_id | bigint | NO |  |
| title | text | NO |  |
| description | text | NO |  |
| display_order | integer | NO |  |

## municipalities

Municipios o ciudades

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| municipality_id | bigint | NO | IDENTITY |
| department_id | bigint | NO |  |
| name | text | NO |  |

## persons

Personas y su cargo actual

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| person_id | bigint | NO | IDENTITY |
| tenant_id | bigint | NO |  |
| position_id | bigint | NO |  |
| identification | text | NO |  |
| first_name | text | NO |  |
| last_name | text | NO |  |
| email | text | NO |  |
| is_active | boolean | NO | true |
| created_at | timestamp with time zone | NO | CURRENT_TIMESTAMP |
| updated_at | timestamp with time zone | NO | CURRENT_TIMESTAMP |

## phva_stages

Etapas Planear, Hacer, Verificar y Actuar

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| stage_id | bigint | NO | IDENTITY |
| code | text | NO |  |
| name | text | NO |  |
| display_order | integer | NO |  |

## positions

Cargos por organizacion

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| position_id | bigint | NO | IDENTITY |
| tenant_id | bigint | NO |  |
| description | text | NO |  |

## templates

Plantillas base por formato

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| template_id | bigint | NO | IDENTITY |
| format_id | bigint | NO |  |
| title | text | NO |  |

## tenant_audit

Historial de cambios principales de organizacion

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| audit_id | bigint | NO | IDENTITY |
| tenant_id | bigint | NO |  |
| changed_at | timestamp with time zone | NO | CURRENT_TIMESTAMP |
| changed_by | text | NO | CURRENT_USER |
| old_name | text | NO |  |
| new_name | text | NO |  |
| old_email | text | NO |  |
| new_email | text | NO |  |
| old_is_active | boolean | NO |  |
| new_is_active | boolean | NO |  |

## tenant_modules

Modulos habilitados por organizacion

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| tenant_id | bigint | NO |  |
| module_id | bigint | NO |  |
| is_enabled | boolean | NO | true |
| enabled_at | timestamp with time zone | NO | CURRENT_TIMESTAMP |

## tenant_sizes

Tamanos de empresa

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| tenant_size_id | bigint | NO | IDENTITY |
| description | text | NO |  |

## tenants

Organizaciones

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| tenant_id | bigint | NO | IDENTITY |
| identification | text | NO |  |
| name | text | NO |  |
| contact_email | text | NO |  |
| phone | text | SI |  |
| tenant_size_id | bigint | NO |  |
| municipality_id | bigint | NO |  |
| is_active | boolean | NO | true |
| created_at | timestamp with time zone | NO | CURRENT_TIMESTAMP |
| updated_at | timestamp with time zone | NO | CURRENT_TIMESTAMP |

## tenantsystems

Sistemas habilitados por organizacion

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| tenant_id | bigint | NO |  |
| system_id | bigint | NO |  |
| enabled_at | timestamp with time zone | NO | CURRENT_TIMESTAMP |

## tenanttemplates

Documentos asignados y su estado

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| tenanttemplate_id | bigint | NO | IDENTITY |
| tenant_id | bigint | NO |  |
| template_id | bigint | NO |  |
| stage_id | bigint | NO |  |
| status | text | NO | 'no_iniciado'::text |
| assigned_at | timestamp with time zone | NO | CURRENT_TIMESTAMP |
| updated_at | timestamp with time zone | NO | CURRENT_TIMESTAMP |
| updated_by | text | SI |  |

## type_system_sst

Tipos de sistema SST/PESV

| Columna | Tipo PostgreSQL | NULL | Predeterminado |
| --- | --- | --- | --- |
| system_id | bigint | NO | IDENTITY |
| code | text | NO |  |
| description | text | NO |  |

## Restricciones del catalogo

| Tabla | Restriccion | Definicion |
| --- | --- | --- |
| countries | countries_name_key | UNIQUE (name) |
| countries | countries_pkey | PRIMARY KEY (country_id) |
| departments | departments_country_id_fkey | FOREIGN KEY (country_id) REFERENCES sst.countries(country_id) |
| departments | departments_country_id_name_key | UNIQUE (country_id, name) |
| departments | departments_pkey | PRIMARY KEY (department_id) |
| editing_locks | editing_locks_person_id_fkey | FOREIGN KEY (person_id) REFERENCES sst.persons(person_id) |
| editing_locks | editing_locks_pkey | PRIMARY KEY (lock_id) |
| editing_locks | editing_locks_tenanttemplate_id_fkey | FOREIGN KEY (tenanttemplate_id) REFERENCES sst.tenanttemplates(tenanttemplate_id) |
| evaluations | evaluations_module_id_fkey | FOREIGN KEY (module_id) REFERENCES sst.modules(module_id) |
| evaluations | evaluations_module_id_title_key | UNIQUE (module_id, title) |
| evaluations | evaluations_pkey | PRIMARY KEY (evaluation_id) |
| formats_sst | formats_sst_module_id_fkey | FOREIGN KEY (module_id) REFERENCES sst.modules(module_id) |
| formats_sst | formats_sst_module_id_title_key | UNIQUE (module_id, title) |
| formats_sst | formats_sst_pkey | PRIMARY KEY (format_id) |
| modules | modules_display_order_check | CHECK ((display_order > 0)) |
| modules | modules_pkey | PRIMARY KEY (module_id) |
| modules | modules_system_id_display_order_key | UNIQUE (system_id, display_order) |
| modules | modules_system_id_fkey | FOREIGN KEY (system_id) REFERENCES sst.type_system_sst(system_id) |
| modules | modules_system_id_title_key | UNIQUE (system_id, title) |
| municipalities | municipalities_department_id_fkey | FOREIGN KEY (department_id) REFERENCES sst.departments(department_id) |
| municipalities | municipalities_department_id_name_key | UNIQUE (department_id, name) |
| municipalities | municipalities_pkey | PRIMARY KEY (municipality_id) |
| persons | persons_pkey | PRIMARY KEY (person_id) |
| persons | persons_tenant_id_email_key | UNIQUE (tenant_id, email) |
| persons | persons_tenant_id_fkey | FOREIGN KEY (tenant_id) REFERENCES sst.tenants(tenant_id) |
| persons | persons_tenant_id_identification_key | UNIQUE (tenant_id, identification) |
| persons | persons_tenant_id_position_id_fkey | FOREIGN KEY (tenant_id, position_id) REFERENCES sst.positions(tenant_id, position_id) |
| phva_stages | phva_stages_code_check | CHECK ((code = ANY (ARRAY['P'::text, 'H'::text, 'V'::text, 'A'::text]))) |
| phva_stages | phva_stages_code_key | UNIQUE (code) |
| phva_stages | phva_stages_display_order_check | CHECK (((display_order >= 1) AND (display_order <= 4))) |
| phva_stages | phva_stages_display_order_key | UNIQUE (display_order) |
| phva_stages | phva_stages_name_key | UNIQUE (name) |
| phva_stages | phva_stages_pkey | PRIMARY KEY (stage_id) |
| positions | positions_pkey | PRIMARY KEY (tenant_id, position_id) |
| positions | positions_position_id_check | CHECK ((position_id > 0)) |
| positions | positions_tenant_id_description_key | UNIQUE (tenant_id, description) |
| positions | positions_tenant_id_fkey | FOREIGN KEY (tenant_id) REFERENCES sst.tenants(tenant_id) |
| templates | templates_format_id_fkey | FOREIGN KEY (format_id) REFERENCES sst.formats_sst(format_id) |
| templates | templates_format_id_title_key | UNIQUE (format_id, title) |
| templates | templates_pkey | PRIMARY KEY (template_id) |
| tenant_audit | tenant_audit_pkey | PRIMARY KEY (audit_id) |
| tenant_modules | tenant_modules_pkey | PRIMARY KEY (tenant_id, module_id) |
| tenant_sizes | tenant_sizes_description_key | UNIQUE (description) |
| tenant_sizes | tenant_sizes_pkey | PRIMARY KEY (tenant_size_id) |
| tenants | tenants_identification_key | UNIQUE (identification) |
| tenants | tenants_municipality_id_fkey | FOREIGN KEY (municipality_id) REFERENCES sst.municipalities(municipality_id) |
| tenants | tenants_pkey | PRIMARY KEY (tenant_id) |
| tenants | tenants_tenant_size_id_fkey | FOREIGN KEY (tenant_size_id) REFERENCES sst.tenant_sizes(tenant_size_id) |
| tenantsystems | tenantsystems_pkey | PRIMARY KEY (tenant_id, system_id) |
| tenantsystems | tenantsystems_system_id_fkey | FOREIGN KEY (system_id) REFERENCES sst.type_system_sst(system_id) |
| tenantsystems | tenantsystems_tenant_id_fkey | FOREIGN KEY (tenant_id) REFERENCES sst.tenants(tenant_id) |
| tenanttemplates | tenanttemplates_pkey | PRIMARY KEY (tenanttemplate_id) |
| tenanttemplates | tenanttemplates_stage_id_fkey | FOREIGN KEY (stage_id) REFERENCES sst.phva_stages(stage_id) |
| tenanttemplates | tenanttemplates_status_check | CHECK ((status = ANY (ARRAY['no_iniciado'::text, 'borrador'::text, 'finalizado'::text]))) |
| tenanttemplates | tenanttemplates_tenant_id_template_id_key | UNIQUE (tenant_id, template_id) |
| type_system_sst | type_system_sst_code_key | UNIQUE (code) |
| type_system_sst | type_system_sst_pkey | PRIMARY KEY (system_id) |

## Indices del catalogo

| Tabla | Indice | Definicion |
| --- | --- | --- |
| countries | countries_name_key | CREATE UNIQUE INDEX countries_name_key ON sst.countries USING btree (name) |
| countries | countries_pkey | CREATE UNIQUE INDEX countries_pkey ON sst.countries USING btree (country_id) |
| departments | departments_country_id_name_key | CREATE UNIQUE INDEX departments_country_id_name_key ON sst.departments USING btree (country_id, name) |
| departments | departments_pkey | CREATE UNIQUE INDEX departments_pkey ON sst.departments USING btree (department_id) |
| editing_locks | editing_locks_expiry_idx | CREATE INDEX editing_locks_expiry_idx ON sst.editing_locks USING btree (expires_at) WHERE is_active |
| editing_locks | editing_locks_one_active_idx | CREATE UNIQUE INDEX editing_locks_one_active_idx ON sst.editing_locks USING btree (tenanttemplate_id) WHERE is_active |
| editing_locks | editing_locks_pkey | CREATE UNIQUE INDEX editing_locks_pkey ON sst.editing_locks USING btree (lock_id) |
| evaluations | evaluations_module_id_title_key | CREATE UNIQUE INDEX evaluations_module_id_title_key ON sst.evaluations USING btree (module_id, title) |
| evaluations | evaluations_pkey | CREATE UNIQUE INDEX evaluations_pkey ON sst.evaluations USING btree (evaluation_id) |
| formats_sst | formats_sst_module_id_title_key | CREATE UNIQUE INDEX formats_sst_module_id_title_key ON sst.formats_sst USING btree (module_id, title) |
| formats_sst | formats_sst_pkey | CREATE UNIQUE INDEX formats_sst_pkey ON sst.formats_sst USING btree (format_id) |
| modules | modules_pkey | CREATE UNIQUE INDEX modules_pkey ON sst.modules USING btree (module_id) |
| modules | modules_system_id_display_order_key | CREATE UNIQUE INDEX modules_system_id_display_order_key ON sst.modules USING btree (system_id, display_order) |
| modules | modules_system_id_title_key | CREATE UNIQUE INDEX modules_system_id_title_key ON sst.modules USING btree (system_id, title) |
| municipalities | municipalities_department_id_name_key | CREATE UNIQUE INDEX municipalities_department_id_name_key ON sst.municipalities USING btree (department_id, name) |
| municipalities | municipalities_pkey | CREATE UNIQUE INDEX municipalities_pkey ON sst.municipalities USING btree (municipality_id) |
| mv_tenant_document_summary | mv_tenant_document_summary_compliance_idx | CREATE INDEX mv_tenant_document_summary_compliance_idx ON sst.mv_tenant_document_summary USING btree (compliance_pct) |
| mv_tenant_document_summary | mv_tenant_document_summary_tenant_idx | CREATE UNIQUE INDEX mv_tenant_document_summary_tenant_idx ON sst.mv_tenant_document_summary USING btree (tenant_id) |
| persons | persons_pkey | CREATE UNIQUE INDEX persons_pkey ON sst.persons USING btree (person_id) |
| persons | persons_position_idx | CREATE INDEX persons_position_idx ON sst.persons USING btree (tenant_id, position_id) |
| persons | persons_tenant_id_email_key | CREATE UNIQUE INDEX persons_tenant_id_email_key ON sst.persons USING btree (tenant_id, email) |
| persons | persons_tenant_id_identification_key | CREATE UNIQUE INDEX persons_tenant_id_identification_key ON sst.persons USING btree (tenant_id, identification) |
| phva_stages | phva_stages_code_key | CREATE UNIQUE INDEX phva_stages_code_key ON sst.phva_stages USING btree (code) |
| phva_stages | phva_stages_display_order_key | CREATE UNIQUE INDEX phva_stages_display_order_key ON sst.phva_stages USING btree (display_order) |
| phva_stages | phva_stages_name_key | CREATE UNIQUE INDEX phva_stages_name_key ON sst.phva_stages USING btree (name) |
| phva_stages | phva_stages_pkey | CREATE UNIQUE INDEX phva_stages_pkey ON sst.phva_stages USING btree (stage_id) |
| positions | positions_pkey | CREATE UNIQUE INDEX positions_pkey ON sst.positions USING btree (tenant_id, position_id) |
| positions | positions_tenant_id_description_key | CREATE UNIQUE INDEX positions_tenant_id_description_key ON sst.positions USING btree (tenant_id, description) |
| templates | templates_format_id_title_key | CREATE UNIQUE INDEX templates_format_id_title_key ON sst.templates USING btree (format_id, title) |
| templates | templates_pkey | CREATE UNIQUE INDEX templates_pkey ON sst.templates USING btree (template_id) |
| tenant_audit | tenant_audit_pkey | CREATE UNIQUE INDEX tenant_audit_pkey ON sst.tenant_audit USING btree (audit_id) |
| tenant_audit | tenant_audit_tenant_idx | CREATE INDEX tenant_audit_tenant_idx ON sst.tenant_audit USING btree (tenant_id, changed_at DESC) |
| tenant_modules | tenant_modules_module_idx | CREATE INDEX tenant_modules_module_idx ON sst.tenant_modules USING btree (module_id) |
| tenant_modules | tenant_modules_pkey | CREATE UNIQUE INDEX tenant_modules_pkey ON sst.tenant_modules USING btree (tenant_id, module_id) |
| tenant_sizes | tenant_sizes_description_key | CREATE UNIQUE INDEX tenant_sizes_description_key ON sst.tenant_sizes USING btree (description) |
| tenant_sizes | tenant_sizes_pkey | CREATE UNIQUE INDEX tenant_sizes_pkey ON sst.tenant_sizes USING btree (tenant_size_id) |
| tenants | tenants_identification_key | CREATE UNIQUE INDEX tenants_identification_key ON sst.tenants USING btree (identification) |
| tenants | tenants_municipality_idx | CREATE INDEX tenants_municipality_idx ON sst.tenants USING btree (municipality_id) |
| tenants | tenants_pkey | CREATE UNIQUE INDEX tenants_pkey ON sst.tenants USING btree (tenant_id) |
| tenants | tenants_size_idx | CREATE INDEX tenants_size_idx ON sst.tenants USING btree (tenant_size_id) |
| tenantsystems | tenantsystems_pkey | CREATE UNIQUE INDEX tenantsystems_pkey ON sst.tenantsystems USING btree (tenant_id, system_id) |
| tenantsystems | tenantsystems_system_idx | CREATE INDEX tenantsystems_system_idx ON sst.tenantsystems USING btree (system_id) |
| tenanttemplates | tenanttemplates_pkey | CREATE UNIQUE INDEX tenanttemplates_pkey ON sst.tenanttemplates USING btree (tenanttemplate_id) |
| tenanttemplates | tenanttemplates_stage_idx | CREATE INDEX tenanttemplates_stage_idx ON sst.tenanttemplates USING btree (tenant_id, stage_id) |
| tenanttemplates | tenanttemplates_status_idx | CREATE INDEX tenanttemplates_status_idx ON sst.tenanttemplates USING btree (tenant_id, status) |
| tenanttemplates | tenanttemplates_tenant_id_template_id_key | CREATE UNIQUE INDEX tenanttemplates_tenant_id_template_id_key ON sst.tenanttemplates USING btree (tenant_id, template_id) |
| type_system_sst | type_system_sst_code_key | CREATE UNIQUE INDEX type_system_sst_code_key ON sst.type_system_sst USING btree (code) |
| type_system_sst | type_system_sst_pkey | CREATE UNIQUE INDEX type_system_sst_pkey ON sst.type_system_sst USING btree (system_id) |
