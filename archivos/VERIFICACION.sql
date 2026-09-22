-- Se ejecuta después de los tres scripts, dentro de BEGIN ... ROLLBACK.
SET search_path TO sst, public;
DO $$
BEGIN
  IF (SELECT COUNT(*) FROM information_schema.tables
      WHERE table_schema=current_schema() AND table_type='BASE TABLE')<>18
     OR (SELECT COUNT(*) FROM pg_class cl JOIN pg_namespace n ON n.oid=cl.relnamespace
      WHERE n.nspname=current_schema() AND cl.relkind='v')<>9
     OR (SELECT COUNT(*) FROM pg_class cl JOIN pg_namespace n ON n.oid=cl.relnamespace
      WHERE n.nspname=current_schema() AND cl.relkind='m')<>1
     OR (SELECT COUNT(*) FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace
      WHERE n.nspname=current_schema() AND p.prokind='p')<>14
     OR (SELECT COUNT(*) FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace
      WHERE n.nspname=current_schema() AND p.prokind='f' AND p.proname LIKE 'fn_%')<>8 THEN
    RAISE EXCEPTION 'Catálogo incompleto';
  END IF;
  IF EXISTS(SELECT 1 FROM information_schema.columns
      WHERE table_schema=current_schema() AND table_name='editing_locks'
        AND column_name='tenant_id')
     OR EXISTS(SELECT 1 FROM information_schema.columns
      WHERE table_schema=current_schema() AND table_name='tenanttemplates'
        AND column_name IN ('system_id','module_id','format_id'))
     OR NOT EXISTS(SELECT 1 FROM pg_constraint con
      WHERE con.conrelid=(current_schema()||'.positions')::regclass
        AND con.contype='p'
        AND pg_get_constraintdef(con.oid)='PRIMARY KEY (tenant_id, position_id)') THEN
    RAISE EXCEPTION 'Modelo físico distinto del modelo relacional 4FN';
  END IF;
  RAISE NOTICE 'OK: catálogo físico, 18 tablas y claves del modelo 4FN';
  IF (SELECT COUNT(*) FROM tenants)<>5 OR (SELECT COUNT(*) FROM persons)<>6
     OR (SELECT COUNT(*) FROM tenanttemplates)<>11 THEN
    RAISE EXCEPTION 'Cantidades de muestra inesperadas';
  END IF;
  IF (SELECT compliance_pct FROM vw_document_summary WHERE tenant_id=1)<>50
     OR (SELECT compliance_pct FROM vw_document_summary WHERE tenant_id=2)<>33.33
     OR (SELECT compliance_pct FROM vw_document_summary WHERE tenant_id=3)<>100 THEN
    RAISE EXCEPTION 'Indicadores incorrectos';
  END IF;
  IF (SELECT COUNT(*) FROM vw_tenant_persons)<>8
     OR (SELECT COUNT(*) FROM vw_tenant_geography)<>5
     OR (SELECT COUNT(*) FROM vw_tenant_modules)<>14
     OR (SELECT COUNT(*) FROM vw_tenant_stage_templates)<>20
     OR (SELECT COUNT(*) FROM vw_tenant_position_persons)<>6
     OR (SELECT COUNT(*) FROM vw_tenant_overview)<>5
     OR (SELECT COUNT(*) FROM vw_document_summary)<>5
     OR (SELECT COUNT(*) FROM vm_template_sst_docs_summary)<>5
     OR (SELECT COUNT(*) FROM vm_template_pesv_docs_summary)<>5
     OR (SELECT COUNT(*) FROM mv_tenant_document_summary)<>5 THEN
    RAISE EXCEPTION 'Vistas incompletas o incorrectas';
  END IF;
  RAISE NOTICE 'OK: 9 vistas y 1 vista materializada';
  IF fn_person_count(1)<>3 OR fn_compliance(1)<>50 OR NOT fn_has_module(1,1)
     OR fn_person_name(1)<>'Ana Pérez' OR fn_stage_template_count(1,1)<>2
     OR fn_compliance_level(3)<>'alto' THEN
    RAISE EXCEPTION 'Funciones escalares incorrectas';
  END IF;
  IF (SELECT COUNT(*) FROM fn_modules(1))<>6
     OR (SELECT COUNT(*) FROM fn_persons_with_positions(1))<>3 THEN
    RAISE EXCEPTION 'Funciones tabulares incorrectas';
  END IF;
  RAISE NOTICE 'OK: 8 funciones de consulta';
  BEGIN
    INSERT INTO persons(tenant_id,position_id,identification,first_name,last_name,email)
    VALUES(4,6,'999','Prueba','Inactiva','prueba@ejemplo.test');
    RAISE EXCEPTION 'Se permitió persona en organización inactiva';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN
    IF SQLERRM='Se permitió persona en organización inactiva' THEN RAISE; END IF;
  END;
  BEGIN
    INSERT INTO persons(tenant_id,position_id,identification,first_name,last_name,email)
    VALUES(1,3,'998','Prueba','Cargo','cargo@ejemplo.test');
    RAISE EXCEPTION 'Se permitió cargo de otra organización';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN
    IF SQLERRM='Se permitió cargo de otra organización' THEN RAISE; END IF;
  END;
  BEGIN
    INSERT INTO tenant_modules(tenant_id,module_id) VALUES(1,1);
    RAISE EXCEPTION 'Se permitió módulo duplicado';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN
    IF SQLERRM='Se permitió módulo duplicado' THEN RAISE; END IF;
  END;
  BEGIN
    INSERT INTO tenanttemplates(tenant_id,template_id,stage_id)
    VALUES(4,1,1);
    RAISE EXCEPTION 'Se permitió plantilla en organización inactiva';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN
    IF SQLERRM='Se permitió plantilla en organización inactiva' THEN RAISE; END IF;
  END;
  BEGIN
    INSERT INTO editing_locks(tenanttemplate_id,person_id,expires_at)
    VALUES(1,4,CURRENT_TIMESTAMP+INTERVAL '10 minutes');
    RAISE EXCEPTION 'Se permitió bloqueo de persona de otra organización';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN
    IF SQLERRM='Se permitió bloqueo de persona de otra organización' THEN RAISE; END IF;
  END;
  BEGIN
    PERFORM tenant_id,name FROM tenants WHERE tenant_id=1;
    DELETE FROM tenants WHERE tenant_id=1;
    RAISE EXCEPTION 'Se permitió borrar organización con personas';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN
    IF SQLERRM='Se permitió borrar organización con personas' THEN RAISE; END IF;
  END;
  BEGIN
    PERFORM system_id,code FROM type_system_sst WHERE system_id=1;
    DELETE FROM type_system_sst WHERE system_id=1;
    RAISE EXCEPTION 'Se permitió borrar sistema utilizado';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN
    IF SQLERRM='Se permitió borrar sistema utilizado' THEN RAISE; END IF;
  END;
  BEGIN
    PERFORM module_id,title FROM modules WHERE module_id=1;
    DELETE FROM modules WHERE module_id=1;
    RAISE EXCEPTION 'Se permitió borrar módulo asignado';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN
    IF SQLERRM='Se permitió borrar módulo asignado' THEN RAISE; END IF;
  END;
  BEGIN
    PERFORM tenant_id,module_id FROM tenant_modules WHERE tenant_id=1 AND module_id=1;
    DELETE FROM tenant_modules WHERE tenant_id=1 AND module_id=1;
    RAISE EXCEPTION 'Se permitió retirar módulo con documentos';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN
    IF SQLERRM='Se permitió retirar módulo con documentos' THEN RAISE; END IF;
  END;
  RAISE NOTICE 'OK: rechazos de integridad y aislamiento';
END $$;

-- position_id solo es clave dentro de su organización; este caso detecta JOIN incompleto.
INSERT INTO positions(position_id,tenant_id,description)
VALUES(1,2,'Auxiliar con ID local repetido');
DO $$
BEGIN
  IF (SELECT COUNT(*) FROM vw_tenant_persons WHERE tenant_id=1 AND person_id=1)<>1
     OR (SELECT COUNT(*) FROM fn_persons_with_positions(1))<>3 THEN
    RAISE EXCEPTION 'JOIN de cargo omitió tenant_id';
  END IF;
END $$;

CALL sp_enable_system(5,2);
CALL sp_assign_module(2,3);
CALL sp_assign_template(2,3,1,3,3);
DO $$
BEGIN
  BEGIN
    CALL sp_assign_template(2,3,1,3,3);
    RAISE EXCEPTION 'Se permitió asignación duplicada';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN
    IF SQLERRM='Se permitió asignación duplicada' THEN RAISE; END IF;
  END;
  BEGIN
    CALL sp_assign_template(2,3,1,3,4);
    RAISE EXCEPTION 'Se permitió plantilla con formato incompatible';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN
    IF SQLERRM='Se permitió plantilla con formato incompatible' THEN RAISE; END IF;
  END;
END $$;
CALL sp_assign_module(3,3);
SELECT tenant_id,module_id FROM tenant_modules WHERE tenant_id=3 AND module_id=3;
CALL sp_remove_module(3,3);
CALL sp_report_template_count(2);
CALL sp_report_compliance(2);
CALL sp_report_stage_docs(2,3);
SELECT tenant_id,contact_email,phone,updated_at,is_active FROM tenants WHERE tenant_id=5;
CALL sp_update_tenant_contact(5,'nuevo@ejemplo.test','555');
SELECT tenant_id,is_active FROM tenants WHERE tenant_id=5;
CALL sp_set_tenant_active(5,false);
SELECT tenant_id,module_id,is_enabled FROM tenant_modules WHERE tenant_id=5 AND is_enabled;
CALL sp_disable_inactive_modules(5);
SELECT person_id,tenant_id,position_id,updated_at FROM persons WHERE person_id=1;
CALL sp_change_person_position(1,1,2);
SELECT person_id,tenant_id,position_id,updated_at FROM persons WHERE person_id=6;
CALL sp_transfer_person(6,1,1);
CALL sp_register_tenant('900006','Nueva Prueba','nueva@ejemplo.test',NULL,1,1);
DO $$
DECLARE v_tenant_id bigint; v_position_id bigint;
BEGIN
  SELECT tenant_id INTO STRICT v_tenant_id FROM tenants WHERE identification='900006';
  INSERT INTO positions(tenant_id,description) VALUES(v_tenant_id,'Auxiliar')
  RETURNING position_id INTO v_position_id;
  CALL sp_register_person(v_tenant_id,v_position_id,'601','Sol','Prueba','sol@ejemplo.test');
END $$;
INSERT INTO editing_locks(tenanttemplate_id,person_id,expires_at)
VALUES(1,1,CURRENT_TIMESTAMP-INTERVAL '1 minute');
INSERT INTO editing_locks(tenanttemplate_id,person_id,expires_at)
VALUES(1,1,CURRENT_TIMESTAMP+INTERVAL '10 minutes');
DO $$
BEGIN
  BEGIN
    INSERT INTO editing_locks(tenanttemplate_id,person_id,expires_at)
    VALUES(1,1,CURRENT_TIMESTAMP+INTERVAL '20 minutes');
    RAISE EXCEPTION 'Se permitió doble bloqueo activo';
  EXCEPTION WHEN unique_violation THEN NULL;
  END;
  BEGIN
    UPDATE persons SET tenant_id=2,position_id=1 WHERE person_id=1;
    RAISE EXCEPTION 'Se permitio trasladar persona con bloqueo';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN
    IF SQLERRM='Se permitio trasladar persona con bloqueo' THEN RAISE; END IF;
  END;
  BEGIN
    UPDATE tenanttemplates SET tenant_id=5 WHERE tenanttemplate_id=1;
    RAISE EXCEPTION 'Se permitio trasladar documento con bloqueo';
  EXCEPTION WHEN SQLSTATE 'P0001' THEN
    IF SQLERRM='Se permitio trasladar documento con bloqueo' THEN RAISE; END IF;
  END;
END $$;
SELECT tenanttemplate_id,status,updated_at,updated_by FROM tenanttemplates WHERE tenanttemplate_id=3;
UPDATE tenanttemplates SET status='finalizado' WHERE tenanttemplate_id=3;
SELECT tenanttemplate_id,tenant_id,template_id FROM tenanttemplates WHERE tenanttemplate_id=11;
DELETE FROM tenanttemplates WHERE tenanttemplate_id=11;

DO $$
BEGIN
  IF NOT EXISTS(SELECT 1 FROM tenant_audit WHERE tenant_id=5 AND old_is_active AND NOT new_is_active)
     OR NOT EXISTS(SELECT 1 FROM tenant_audit WHERE tenant_id=5 AND new_email='nuevo@ejemplo.test') THEN
    RAISE EXCEPTION 'Auditoría de organización incorrecta';
  END IF;
  IF (SELECT is_enabled FROM tenant_modules WHERE tenant_id=5 AND module_id=1)
     OR (SELECT position_id FROM persons WHERE person_id=1)<>2
     OR (SELECT tenant_id FROM persons WHERE person_id=6)<>1 THEN
    RAISE EXCEPTION 'Procedimientos de actualización incorrectos';
  END IF;
  IF NOT EXISTS(SELECT 1 FROM tenantsystems WHERE tenant_id=5 AND system_id=2)
     OR NOT EXISTS(SELECT 1 FROM tenant_modules WHERE tenant_id=2 AND module_id=3)
     OR EXISTS(SELECT 1 FROM tenant_modules WHERE tenant_id=3 AND module_id=3)
     OR NOT EXISTS(SELECT 1 FROM tenanttemplates WHERE tenant_id=2 AND template_id=3)
     OR NOT EXISTS(SELECT 1 FROM tenants WHERE identification='900006')
     OR NOT EXISTS(SELECT 1 FROM persons WHERE identification='601') THEN
    RAISE EXCEPTION 'Procedimientos de alta y asignación incorrectos';
  END IF;
  IF NOT EXISTS(SELECT 1 FROM tenants WHERE tenant_id=5 AND contact_email='nuevo@ejemplo.test'
      AND NOT is_active AND updated_at>CURRENT_TIMESTAMP)
     OR NOT EXISTS(SELECT 1 FROM persons WHERE person_id=1 AND updated_at>CURRENT_TIMESTAMP)
     OR NOT EXISTS(SELECT 1 FROM tenanttemplates WHERE tenanttemplate_id=3
      AND updated_at>CURRENT_TIMESTAMP) THEN
    RAISE EXCEPTION 'Triggers de updated_at incorrectos';
  END IF;
  IF (SELECT total_docs FROM mv_tenant_document_summary WHERE tenant_id=2)<>3 THEN
    RAISE EXCEPTION 'La vista materializada no conserva la instantánea esperada';
  END IF;
  IF (SELECT COUNT(*) FROM editing_locks WHERE tenanttemplate_id=1 AND is_active)<>1
     OR (SELECT COUNT(*) FROM editing_locks WHERE tenanttemplate_id=1 AND NOT is_active)<>1 THEN
    RAISE EXCEPTION 'Vencimiento de bloqueos incorrecto';
  END IF;
  IF (SELECT status FROM tenanttemplates WHERE tenanttemplate_id=3)<>'finalizado'
     OR (SELECT updated_by FROM tenanttemplates WHERE tenanttemplate_id=3)<>CURRENT_USER
     OR EXISTS(SELECT 1 FROM tenanttemplates WHERE tenanttemplate_id=11) THEN
    RAISE EXCEPTION 'Auditoría o eliminación de plantilla incorrecta';
  END IF;
  IF EXISTS(SELECT 1 FROM vw_document_summary WHERE compliance_pct<0 OR compliance_pct>100) THEN
    RAISE EXCEPTION 'Porcentaje fuera de rango';
  END IF;
  IF (SELECT COUNT(*) FROM pg_trigger tg JOIN pg_class cl ON cl.oid=tg.tgrelid
      JOIN pg_namespace n ON n.oid=cl.relnamespace
      WHERE n.nspname=current_schema() AND NOT tg.tgisinternal)<>15 THEN
    RAISE EXCEPTION 'No existen los 15 triggers esperados';
  END IF;
  RAISE NOTICE 'OK: 14 procedimientos, incluyendo excepciones y avisos';
  RAISE NOTICE 'OK: 15 triggers, fechas, auditoría, rechazos y bloqueos';
END $$;
REFRESH MATERIALIZED VIEW mv_tenant_document_summary;
DO $$
BEGIN
  IF (SELECT total_docs FROM mv_tenant_document_summary WHERE tenant_id=2)<>4 THEN
    RAISE EXCEPTION 'REFRESH no actualizó la vista materializada';
  END IF;
  RAISE NOTICE 'OK: REFRESH MATERIALIZED VIEW refleja 4 documentos';
END $$;
