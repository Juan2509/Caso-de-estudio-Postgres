# Trazabilidad de vistas, funciones, procedimientos y triggers

Fuente: `Examen.md`, secciones 4–7. Las definiciones **completas y ejecutables** están en `init/03_logic.sql`; los datos necesarios en `init/02_data.sql`. `docs/VERIFICACION.sql` ejecuta las pruebas citadas dentro de `BEGIN ... ROLLBACK`. Los resultados siguientes se observaron en PostgreSQL 16.15, tanto en el esquema `sst` como en una instalación temporal desde cero. Los IDs de ejemplo corresponden a la carga inicial.

## Vistas y vista materializada

| Examen | Objeto SQL | Prueba de uso | Resultado comprobado |
| --- | --- | --- | --- |
| V1 | `vw_tenant_persons` | `SELECT COUNT(*) FROM sst.vw_tenant_persons;` | 8 filas: 6 personas y 2 empresas sin personas |
| V2 | `vw_tenant_geography` | `SELECT COUNT(*) FROM sst.vw_tenant_geography;` | 5 empresas con municipio, departamento y país |
| V3 | `vw_tenant_modules` | `SELECT COUNT(*) FROM sst.vw_tenant_modules;` | 14 asignaciones de módulos |
| V4 | `vw_tenant_stage_templates` | `SELECT COUNT(*) FROM sst.vw_tenant_stage_templates;` | 20 filas: 5 empresas × 4 etapas |
| V5 | `vw_tenant_position_persons` | `SELECT COUNT(*) FROM sst.vw_tenant_position_persons;` | 6 cargos, incluidos los no ocupados |
| A25 | `vw_tenant_overview` | `SELECT tenant_id,person_count,module_count,template_count,system_count FROM sst.vw_tenant_overview ORDER BY tenant_id;` | 5 empresas; Andes: 3, 6, 6, 2 |
| A10/A23 | `vw_document_summary` | `SELECT tenant_id,total_docs,finalized_docs,compliance_pct FROM sst.vw_document_summary ORDER BY tenant_id;` | Andes 6/3/50 %, Rutas 3/1/33.33 %, Clínica 2/2/100 % |
| A22/A24 | `vm_template_sst_docs_summary`, `vm_template_pesv_docs_summary` | `SELECT COUNT(*) FROM sst.vm_template_sst_docs_summary;` y consulta análoga de PESV | 5 filas cada una |
| V6/V8 | `mv_tenant_document_summary` | `SELECT tenant_id,total_docs FROM sst.mv_tenant_document_summary WHERE tenant_id=2;` | 3 documentos iniciales; índice único por `tenant_id` e índice por porcentaje |
| V7 | `REFRESH MATERIALIZED VIEW sst.mv_tenant_document_summary` | Asignar temporalmente una plantilla a empresa 2 y refrescar | 3 antes, 4 después; se revierte toda la prueba |

`V6–V8` son los enunciados de vista materializada, actualización e índices. El índice único por `tenant_id` es útil para seguimiento de una empresa y permite un refresco concurrente en condiciones admitidas por PostgreSQL; el índice de porcentaje sirve a rankings y filtros de cumplimiento. La vista materializada no se actualiza sola.

## Funciones almacenadas

| Examen | Función | Prueba `SELECT` | Resultado comprobado |
| --- | --- | --- | --- |
| F1 | `fn_person_count` | `SELECT sst.fn_person_count(1);` | 3 |
| F2 | `fn_compliance` | `SELECT sst.fn_compliance(1);` | 50.00 |
| F3 | `fn_has_module` | `SELECT sst.fn_has_module(1,1);` | `true` |
| F4 | `fn_person_name` | `SELECT sst.fn_person_name(1);` | `Ana Pérez` |
| F5 | `fn_stage_template_count` | `SELECT sst.fn_stage_template_count(1,1);` | 2 |
| F6 | `fn_modules` | `SELECT module_id,module_title,system_code FROM sst.fn_modules(1);` | 6 filas |
| F7 | `fn_persons_with_positions` | `SELECT person_id,full_name,position_name FROM sst.fn_persons_with_positions(1);` | 3 filas |
| F8 | `fn_compliance_level` | `SELECT sst.fn_compliance_level(3);` | `alto` |

## Procedimientos almacenados

Los `CALL` que modifican datos se ensayan en transacciones reversibles. Antes de un cambio o borrado, `docs/VERIFICACION.sql` selecciona las filas afectadas.

| Examen | Procedimiento | Prueba ejecutada en `VERIFICACION.sql` | Resultado comprobado |
| --- | --- | --- | --- |
| P1 | `sp_register_tenant` | Registrar identificación `900006` | Nueva organización consultable por identificación |
| P2 | `sp_register_person` | Registrar identificación `601` en cargo nuevo | Persona consultable por identificación |
| P3 | `sp_set_tenant_active` | Desactivar empresa 5 | `is_active=false`; auditoría de estado |
| P4 | `sp_assign_module` | Asignar módulo 3 a empresa 2 | Pareja `(2,3)` presente; el duplicado se rechaza |
| P5 | `sp_enable_system` | Habilitar sistema 2 a empresa 5 | Pareja `(5,2)` presente |
| P6 | `sp_assign_template` | Asignar plantilla 3, sistema 1, etapa 3, formato 3 a empresa 2 | Documentos de empresa 2 pasan de 3 a 4 |
| P7 | `sp_change_person_position` | Cambiar persona 1 al cargo 2 | `position_id=2` |
| P8 | `sp_transfer_person` | Trasladar persona 6 a empresa 1, cargo 1 | `tenant_id=1` |
| P9 | `sp_disable_inactive_modules` | Desactivar empresa 5 y sus módulos | Módulo `(5,1)` deshabilitado |
| P10 | `sp_remove_module` | Asignar y luego retirar módulo `(3,3)` sin plantillas | La asignación deja de existir; con plantillas se rechaza |
| P11 | `sp_report_template_count` | `CALL sst.sp_report_template_count(2);` tras P6 | `NOTICE: Plantillas de organización 2: 4` |
| P12 | `sp_report_compliance` | `CALL sst.sp_report_compliance(2);` tras P6 | `NOTICE: ... 25.00 por ciento` |
| P13 | `sp_report_stage_docs` | `CALL sst.sp_report_stage_docs(2,3);` tras P6 | `NOTICE: ... etapa 3: 2` |
| P14 | `sp_update_tenant_contact` | Cambiar correo y teléfono de empresa 5 | Ambos campos y `updated_at` cambian; queda auditoría |
| P15 | Manejo de excepciones de `sp_assign_template` | Repetir asignación y usar formato incompatible | Dos errores controlados con mensaje específico; no hay fila extra |

## Triggers

Algunos enunciados comparten trigger porque la misma operación cumple dos reglas. Las pruebas negativas verifican el mensaje de rechazo y fallan si la operación se permite. Se ejecutan dentro de una transacción con `ROLLBACK`.

| Examen | Trigger y función asociada | Operación de prueba | Resultado comprobado |
| --- | --- | --- | --- |
| T1 | `tenants_touch` / `trg_touch_updated_at` | Actualizar contacto de empresa 5 | `updated_at` posterior al inicio de la transacción |
| T2 | `persons_touch` / `trg_touch_updated_at` | Cambiar cargo de persona 1 | `updated_at` posterior al inicio de la transacción |
| T3 | `persons_validate` / `trg_validate_person` | Insertar persona en empresa 4 inactiva | Rechazado |
| T4 | `tenant_modules_no_duplicate` / `trg_validate_module` | Insertar de nuevo módulo `(1,1)` | Rechazado |
| T5 | `tenanttemplates_validate` / `trg_validate_template` | Asignar plantilla a empresa 4 inactiva | Rechazado |
| T6 | `persons_validate` / `trg_validate_person` | Dar a empresa 1 un cargo de empresa 2 | Rechazado |
| T7 | `tenanttemplates_touch` / `trg_touch_updated_at` | Cambiar estado de plantilla asignada 3 | `updated_at` posterior al inicio de la transacción |
| T8 | `tenants_protect` / `trg_protect_tenant` | Borrar empresa 1 con personas | Rechazado |
| T9 | `systems_protect` / `trg_protect_system` | Borrar sistema 1 habilitado | Rechazado |
| T10 | `modules_protect` / `trg_protect_module` | Borrar módulo 1 asignado | Rechazado |
| T11 | `tenanttemplates_compliance` / `trg_validate_compliance` | Insertar, actualizar y borrar asignaciones | El indicador queda entre 0 y 100; la fórmula también impide exceder el rango |
| T12 | `tenants_audit` / `trg_audit_tenant` | Cambiar correo de empresa 5 | Evento con correo anterior y nuevo |
| T13 | `tenants_audit` / `trg_audit_tenant` | Desactivar empresa 5 | Evento con `old_is_active=true`, `new_is_active=false` |
| T14 | `tenanttemplates_editor` / `trg_template_editor` | Cambiar plantilla asignada 3 | `updated_by=CURRENT_USER` |
| T15 | `editing_locks_expire` / `trg_expire_editing_locks` | Insertar bloqueo vencido y después uno nuevo | Uno inactivo y uno activo |

Dos triggers adicionales mantienen integridad del modelo: `tenant_modules_protect` impide retirar un módulo con documentos asignados, y `editing_locks_validate` impide bloquear un documento con una persona de otra organización. `persons_validate` y `tenanttemplates_validate` también rechazan traslados que separarían un bloqueo existente de su persona o documento; `VERIFICACION.sql` prueba ambos rechazos. El índice parcial `editing_locks_one_active_idx` impide dos bloqueos activos simultáneos del mismo documento.

El ejercicio T11 pide validar un porcentaje calculado. Como la fórmula es `100 × finalizados / total` y `finalizados ≤ total`, un dato válido no puede producir más de 100; el trigger exigido está implementado, pero la restricción de estados y la fórmula ya garantizan ese rango. Esta es una redundancia pedagógica explícita, no una razón para guardar el porcentaje como columna duplicada.
