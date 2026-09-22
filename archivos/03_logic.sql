SET search_path TO sst, public;

CREATE VIEW vw_tenant_persons AS
SELECT t.tenant_id,t.name AS tenant_name,p.person_id,p.first_name,p.last_name,
       p.email,po.description AS position_name
FROM tenants t LEFT JOIN persons p ON p.tenant_id=t.tenant_id
LEFT JOIN positions po ON (po.tenant_id,po.position_id)=(p.tenant_id,p.position_id);

CREATE VIEW vw_tenant_geography AS
SELECT t.tenant_id,t.name AS tenant_name,m.name AS municipality_name,
       d.name AS department_name,c.name AS country_name
FROM tenants t JOIN municipalities m ON m.municipality_id=t.municipality_id
JOIN departments d ON d.department_id=m.department_id
JOIN countries c ON c.country_id=d.country_id;

CREATE VIEW vw_tenant_modules AS
SELECT t.tenant_id,t.name AS tenant_name,m.module_id,m.title AS module_title,
       s.code AS system_code,tm.is_enabled
FROM tenant_modules tm JOIN tenants t ON t.tenant_id=tm.tenant_id
JOIN modules m ON m.module_id=tm.module_id
JOIN type_system_sst s ON s.system_id=m.system_id;

CREATE VIEW vw_tenant_stage_templates AS
SELECT t.tenant_id,t.name AS tenant_name,st.stage_id,st.name AS stage_name,
       COUNT(tt.tenanttemplate_id) AS template_count
FROM tenants t CROSS JOIN phva_stages st
LEFT JOIN tenanttemplates tt ON tt.tenant_id=t.tenant_id AND tt.stage_id=st.stage_id
GROUP BY t.tenant_id,t.name,st.stage_id,st.name;

CREATE VIEW vw_tenant_position_persons AS
SELECT t.tenant_id,t.name AS tenant_name,po.position_id,
       po.description AS position_name,COUNT(p.person_id) AS person_count
FROM positions po JOIN tenants t ON t.tenant_id=po.tenant_id
LEFT JOIN persons p ON p.tenant_id=po.tenant_id AND p.position_id=po.position_id
GROUP BY t.tenant_id,t.name,po.position_id,po.description;

CREATE VIEW vw_tenant_overview AS
SELECT t.tenant_id,t.name AS tenant_name,
       (SELECT COUNT(*) FROM persons p WHERE p.tenant_id=t.tenant_id) AS person_count,
       (SELECT COUNT(*) FROM tenant_modules tm WHERE tm.tenant_id=t.tenant_id AND tm.is_enabled) AS module_count,
       (SELECT COUNT(*) FROM tenanttemplates tt WHERE tt.tenant_id=t.tenant_id) AS template_count,
       (SELECT COUNT(*) FROM tenantsystems ts WHERE ts.tenant_id=t.tenant_id) AS system_count
FROM tenants t;

CREATE VIEW vw_document_summary AS
SELECT t.tenant_id,t.name AS tenant_name,
       COUNT(tt.tenanttemplate_id) AS total_docs,
       COUNT(tt.tenanttemplate_id) FILTER (WHERE tt.status='finalizado') AS finalized_docs,
       COUNT(tt.tenanttemplate_id) FILTER (WHERE tt.status='borrador') AS draft_docs,
       COUNT(tt.tenanttemplate_id) FILTER (WHERE tt.status='no_iniciado') AS unstarted_docs,
       COUNT(tt.tenanttemplate_id) FILTER (WHERE tt.status<>'finalizado') AS pending_docs,
       COALESCE(ROUND(100.0*COUNT(tt.tenanttemplate_id) FILTER (WHERE tt.status='finalizado')
         /NULLIF(COUNT(tt.tenanttemplate_id),0),2),0) AS compliance_pct
FROM tenants t LEFT JOIN tenanttemplates tt ON tt.tenant_id=t.tenant_id
GROUP BY t.tenant_id,t.name;

CREATE VIEW vm_template_sst_docs_summary AS
SELECT t.tenant_id,t.name AS tenant_name,COUNT(tt.tenanttemplate_id) AS total_docs,
       COUNT(tt.tenanttemplate_id) FILTER (WHERE tt.status='finalizado') AS finalized_docs,
       COUNT(tt.tenanttemplate_id) FILTER (WHERE tt.status<>'finalizado') AS pending_docs,
       COALESCE(ROUND(100.0*COUNT(tt.tenanttemplate_id) FILTER (WHERE tt.status='finalizado')
         /NULLIF(COUNT(tt.tenanttemplate_id),0),2),0) AS compliance_pct
FROM tenants t LEFT JOIN (
  tenanttemplates tt JOIN templates tpl ON tpl.template_id=tt.template_id
  JOIN formats_sst f ON f.format_id=tpl.format_id
  JOIN modules m ON m.module_id=f.module_id AND m.system_id=1
) ON tt.tenant_id=t.tenant_id
GROUP BY t.tenant_id,t.name;

CREATE VIEW vm_template_pesv_docs_summary AS
SELECT t.tenant_id,t.name AS tenant_name,COUNT(tt.tenanttemplate_id) AS total_docs,
       COUNT(tt.tenanttemplate_id) FILTER (WHERE tt.status='finalizado') AS finalized_docs,
       COUNT(tt.tenanttemplate_id) FILTER (WHERE tt.status<>'finalizado') AS pending_docs,
       COALESCE(ROUND(100.0*COUNT(tt.tenanttemplate_id) FILTER (WHERE tt.status='finalizado')
         /NULLIF(COUNT(tt.tenanttemplate_id),0),2),0) AS compliance_pct
FROM tenants t LEFT JOIN (
  tenanttemplates tt JOIN templates tpl ON tpl.template_id=tt.template_id
  JOIN formats_sst f ON f.format_id=tpl.format_id
  JOIN modules m ON m.module_id=f.module_id AND m.system_id=2
) ON tt.tenant_id=t.tenant_id
GROUP BY t.tenant_id,t.name;

CREATE MATERIALIZED VIEW mv_tenant_document_summary AS
SELECT tenant_id,tenant_name,total_docs,finalized_docs,pending_docs,compliance_pct
FROM vw_document_summary;
CREATE UNIQUE INDEX mv_tenant_document_summary_tenant_idx
  ON mv_tenant_document_summary(tenant_id);
CREATE INDEX mv_tenant_document_summary_compliance_idx
  ON mv_tenant_document_summary(compliance_pct);

CREATE FUNCTION fn_person_count(p_tenant_id bigint) RETURNS bigint
LANGUAGE sql STABLE AS $$
  SELECT COUNT(*) FROM persons WHERE tenant_id=p_tenant_id
$$;
CREATE FUNCTION fn_compliance(p_tenant_id bigint) RETURNS numeric
LANGUAGE sql STABLE AS $$
  SELECT compliance_pct FROM vw_document_summary WHERE tenant_id=p_tenant_id
$$;
CREATE FUNCTION fn_has_module(p_tenant_id bigint,p_module_id bigint) RETURNS boolean
LANGUAGE sql STABLE AS $$
  SELECT EXISTS(SELECT 1 FROM tenant_modules
    WHERE tenant_id=p_tenant_id AND module_id=p_module_id AND is_enabled)
$$;
CREATE FUNCTION fn_person_name(p_person_id bigint) RETURNS text
LANGUAGE sql STABLE AS $$
  SELECT CONCAT_WS(' ',first_name,last_name) FROM persons WHERE person_id=p_person_id
$$;
CREATE FUNCTION fn_stage_template_count(p_tenant_id bigint,p_stage_id bigint) RETURNS bigint
LANGUAGE sql STABLE AS $$
  SELECT COUNT(*) FROM tenanttemplates WHERE tenant_id=p_tenant_id AND stage_id=p_stage_id
$$;
CREATE FUNCTION fn_modules(p_tenant_id bigint)
RETURNS TABLE(module_id bigint,module_title text,system_code text)
LANGUAGE sql STABLE AS $$
  SELECT m.module_id,m.title,s.code FROM tenant_modules tm
  JOIN modules m ON m.module_id=tm.module_id
  JOIN type_system_sst s ON s.system_id=m.system_id
  WHERE tm.tenant_id=p_tenant_id AND tm.is_enabled ORDER BY m.module_id
$$;
CREATE FUNCTION fn_persons_with_positions(p_tenant_id bigint)
RETURNS TABLE(person_id bigint,full_name text,position_name text)
LANGUAGE sql STABLE AS $$
  SELECT p.person_id,CONCAT_WS(' ',p.first_name,p.last_name),po.description
  FROM persons p JOIN positions po ON (po.tenant_id,po.position_id)=(p.tenant_id,p.position_id)
  WHERE p.tenant_id=p_tenant_id ORDER BY p.person_id
$$;
CREATE FUNCTION fn_compliance_level(p_tenant_id bigint) RETURNS text
LANGUAGE sql STABLE AS $$
  SELECT CASE WHEN compliance_pct<50 THEN 'bajo'
              WHEN compliance_pct<80 THEN 'medio' ELSE 'alto' END
  FROM vw_document_summary WHERE tenant_id=p_tenant_id
$$;

CREATE PROCEDURE sp_register_tenant(p_identification text,p_name text,p_email text,
  p_phone text,p_size_id bigint,p_municipality_id bigint)
LANGUAGE plpgsql AS $$
BEGIN
  IF EXISTS(SELECT 1 FROM tenants WHERE identification=p_identification) THEN
    RAISE EXCEPTION 'Organización con identificación % ya existe',p_identification;
  END IF;
  INSERT INTO tenants(identification,name,contact_email,phone,tenant_size_id,municipality_id)
  VALUES(p_identification,p_name,p_email,p_phone,p_size_id,p_municipality_id);
END $$;

CREATE PROCEDURE sp_register_person(p_tenant_id bigint,p_position_id bigint,p_identification text,
  p_first_name text,p_last_name text,p_email text)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO persons(tenant_id,position_id,identification,first_name,last_name,email)
  VALUES(p_tenant_id,p_position_id,p_identification,p_first_name,p_last_name,p_email);
END $$;

CREATE PROCEDURE sp_set_tenant_active(p_tenant_id bigint,p_active boolean)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE tenants SET is_active=p_active WHERE tenant_id=p_tenant_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Organización % no existe',p_tenant_id; END IF;
END $$;

CREATE PROCEDURE sp_assign_module(p_tenant_id bigint,p_module_id bigint)
LANGUAGE plpgsql AS $$
DECLARE v_system_id bigint;
BEGIN
  SELECT system_id INTO STRICT v_system_id FROM modules WHERE module_id=p_module_id;
  IF EXISTS(SELECT 1 FROM tenant_modules WHERE tenant_id=p_tenant_id AND module_id=p_module_id) THEN
    RAISE EXCEPTION 'Módulo % ya asignado a organización %',p_module_id,p_tenant_id;
  END IF;
  INSERT INTO tenant_modules(tenant_id,module_id)
  VALUES(p_tenant_id,p_module_id);
END $$;

CREATE PROCEDURE sp_enable_system(p_tenant_id bigint,p_system_id bigint)
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO tenantsystems(tenant_id,system_id) VALUES(p_tenant_id,p_system_id)
  ON CONFLICT (tenant_id,system_id) DO NOTHING;
END $$;

CREATE PROCEDURE sp_assign_template(p_tenant_id bigint,p_template_id bigint,p_system_id bigint,
  p_stage_id bigint,p_format_id bigint)
LANGUAGE plpgsql AS $$
DECLARE v_module_id bigint;
BEGIN
  SELECT f.module_id INTO STRICT v_module_id FROM formats_sst f
  JOIN templates tpl ON tpl.format_id=f.format_id
  WHERE f.format_id=p_format_id AND tpl.template_id=p_template_id;
  IF NOT EXISTS(SELECT 1 FROM modules WHERE module_id=v_module_id AND system_id=p_system_id) THEN
    RAISE EXCEPTION 'El formato no pertenece al sistema %',p_system_id;
  END IF;
  INSERT INTO tenanttemplates(tenant_id,template_id,stage_id)
  VALUES(p_tenant_id,p_template_id,p_stage_id);
EXCEPTION
  WHEN unique_violation THEN RAISE EXCEPTION 'Plantilla % ya asignada a organización %',p_template_id,p_tenant_id;
  WHEN no_data_found THEN RAISE EXCEPTION 'Plantilla % y formato % incompatibles',p_template_id,p_format_id;
  WHEN foreign_key_violation THEN RAISE EXCEPTION 'Asignación incompatible: organización, sistema, módulo, formato o etapa';
END $$;

CREATE PROCEDURE sp_change_person_position(p_person_id bigint,p_tenant_id bigint,p_position_id bigint)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE persons SET position_id=p_position_id WHERE person_id=p_person_id AND tenant_id=p_tenant_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Persona % no pertenece a organización %',p_person_id,p_tenant_id; END IF;
END $$;

CREATE PROCEDURE sp_transfer_person(p_person_id bigint,p_target_tenant_id bigint,p_target_position_id bigint)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE persons SET tenant_id=p_target_tenant_id,position_id=p_target_position_id
  WHERE person_id=p_person_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Persona % no existe',p_person_id; END IF;
END $$;

CREATE PROCEDURE sp_disable_inactive_modules(p_tenant_id bigint)
LANGUAGE plpgsql AS $$
BEGIN
  IF NOT EXISTS(SELECT 1 FROM tenants WHERE tenant_id=p_tenant_id AND NOT is_active) THEN
    RAISE EXCEPTION 'La organización % debe estar inactiva',p_tenant_id;
  END IF;
  UPDATE tenant_modules SET is_enabled=false WHERE tenant_id=p_tenant_id AND is_enabled;
END $$;

CREATE PROCEDURE sp_remove_module(p_tenant_id bigint,p_module_id bigint)
LANGUAGE plpgsql AS $$
BEGIN
  IF EXISTS(SELECT 1 FROM tenanttemplates tt
    JOIN templates tpl ON tpl.template_id=tt.template_id
    JOIN formats_sst f ON f.format_id=tpl.format_id
    WHERE tt.tenant_id=p_tenant_id AND f.module_id=p_module_id) THEN
    RAISE EXCEPTION 'El módulo tiene plantillas dependientes';
  END IF;
  DELETE FROM tenant_modules WHERE tenant_id=p_tenant_id AND module_id=p_module_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Asignación inexistente'; END IF;
END $$;

CREATE PROCEDURE sp_report_template_count(p_tenant_id bigint)
LANGUAGE plpgsql AS $$
DECLARE v_count bigint;
BEGIN
  SELECT COUNT(*) INTO v_count FROM tenanttemplates WHERE tenant_id=p_tenant_id;
  RAISE NOTICE 'Plantillas de organización %: %',p_tenant_id,v_count;
END $$;

CREATE PROCEDURE sp_report_compliance(p_tenant_id bigint)
LANGUAGE plpgsql AS $$
DECLARE v_pct numeric;
BEGIN
  SELECT compliance_pct INTO STRICT v_pct FROM vw_document_summary WHERE tenant_id=p_tenant_id;
  RAISE NOTICE 'Cumplimiento de organización %: % por ciento',p_tenant_id,v_pct;
END $$;

CREATE FUNCTION trg_touch_updated_at() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at=clock_timestamp();
  RETURN NEW;
END $$;
CREATE TRIGGER tenants_touch BEFORE UPDATE ON tenants
FOR EACH ROW EXECUTE FUNCTION trg_touch_updated_at();
CREATE TRIGGER persons_touch BEFORE UPDATE ON persons
FOR EACH ROW EXECUTE FUNCTION trg_touch_updated_at();
CREATE TRIGGER tenanttemplates_touch BEFORE UPDATE ON tenanttemplates
FOR EACH ROW EXECUTE FUNCTION trg_touch_updated_at();

CREATE FUNCTION trg_validate_person() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP='UPDATE' AND NEW.tenant_id IS DISTINCT FROM OLD.tenant_id
     AND EXISTS(SELECT 1 FROM editing_locks WHERE person_id=OLD.person_id) THEN
    RAISE EXCEPTION 'No se puede trasladar una persona con bloqueos de edicion';
  END IF;
  IF NOT EXISTS(SELECT 1 FROM tenants WHERE tenant_id=NEW.tenant_id AND is_active) THEN
    RAISE EXCEPTION 'No se permite asociar personas a una organización inactiva';
  END IF;
  IF NOT EXISTS(SELECT 1 FROM positions
    WHERE position_id=NEW.position_id AND tenant_id=NEW.tenant_id) THEN
    RAISE EXCEPTION 'El cargo no pertenece a la organización';
  END IF;
  RETURN NEW;
END $$;
CREATE TRIGGER persons_validate BEFORE INSERT OR UPDATE OF tenant_id,position_id ON persons
FOR EACH ROW EXECUTE FUNCTION trg_validate_person();

CREATE FUNCTION trg_validate_module() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF EXISTS(SELECT 1 FROM tenant_modules
    WHERE tenant_id=NEW.tenant_id AND module_id=NEW.module_id) THEN
    RAISE EXCEPTION 'Módulo ya asignado';
  END IF;
  IF NOT EXISTS(SELECT 1 FROM modules m JOIN tenantsystems ts ON ts.system_id=m.system_id
    WHERE m.module_id=NEW.module_id AND ts.tenant_id=NEW.tenant_id) THEN
    RAISE EXCEPTION 'El sistema del módulo no está habilitado';
  END IF;
  RETURN NEW;
END $$;
CREATE TRIGGER tenant_modules_no_duplicate BEFORE INSERT ON tenant_modules
FOR EACH ROW EXECUTE FUNCTION trg_validate_module();

CREATE FUNCTION trg_validate_template() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP='UPDATE' AND NEW.tenant_id IS DISTINCT FROM OLD.tenant_id
     AND EXISTS(SELECT 1 FROM editing_locks WHERE tenanttemplate_id=OLD.tenanttemplate_id) THEN
    RAISE EXCEPTION 'No se puede trasladar un documento con bloqueos de edicion';
  END IF;
  IF NOT EXISTS(SELECT 1 FROM tenants WHERE tenant_id=NEW.tenant_id AND is_active) THEN
    RAISE EXCEPTION 'No se permite asignar plantillas a una organización inactiva';
  END IF;
  IF NOT EXISTS(SELECT 1 FROM templates tpl
    JOIN formats_sst f ON f.format_id=tpl.format_id
    JOIN modules m ON m.module_id=f.module_id
    JOIN tenantsystems ts ON ts.tenant_id=NEW.tenant_id AND ts.system_id=m.system_id
    JOIN tenant_modules tm ON tm.tenant_id=NEW.tenant_id AND tm.module_id=m.module_id
    WHERE tpl.template_id=NEW.template_id AND tm.is_enabled) THEN
    RAISE EXCEPTION 'La plantilla requiere módulo y sistema habilitados';
  END IF;
  RETURN NEW;
END $$;
CREATE TRIGGER tenanttemplates_validate BEFORE INSERT OR UPDATE OF tenant_id,template_id ON tenanttemplates
FOR EACH ROW EXECUTE FUNCTION trg_validate_template();

CREATE FUNCTION trg_protect_tenant_module() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF EXISTS(SELECT 1 FROM tenanttemplates tt JOIN templates tpl ON tpl.template_id=tt.template_id
    JOIN formats_sst f ON f.format_id=tpl.format_id
    WHERE tt.tenant_id=OLD.tenant_id AND f.module_id=OLD.module_id) THEN
    RAISE EXCEPTION 'El módulo tiene plantillas dependientes';
  END IF;
  RETURN OLD;
END $$;
CREATE TRIGGER tenant_modules_protect BEFORE DELETE ON tenant_modules
FOR EACH ROW EXECUTE FUNCTION trg_protect_tenant_module();

CREATE FUNCTION trg_protect_tenant() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF EXISTS(SELECT 1 FROM persons WHERE tenant_id=OLD.tenant_id) THEN
    RAISE EXCEPTION 'No se puede eliminar organización con personas';
  END IF;
  RETURN OLD;
END $$;
CREATE TRIGGER tenants_protect BEFORE DELETE ON tenants
FOR EACH ROW EXECUTE FUNCTION trg_protect_tenant();

CREATE FUNCTION trg_protect_system() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF EXISTS(SELECT 1 FROM tenantsystems WHERE system_id=OLD.system_id) THEN
    RAISE EXCEPTION 'Sistema SST utilizado por organizaciones';
  END IF;
  RETURN OLD;
END $$;
CREATE TRIGGER systems_protect BEFORE DELETE ON type_system_sst
FOR EACH ROW EXECUTE FUNCTION trg_protect_system();

CREATE FUNCTION trg_protect_module() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF EXISTS(SELECT 1 FROM tenant_modules WHERE module_id=OLD.module_id) THEN
    RAISE EXCEPTION 'Módulo asignado a organizaciones';
  END IF;
  RETURN OLD;
END $$;
CREATE TRIGGER modules_protect BEFORE DELETE ON modules
FOR EACH ROW EXECUTE FUNCTION trg_protect_module();

CREATE FUNCTION trg_validate_compliance() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE v_pct numeric; v_tenant_id bigint;
BEGIN
  IF TG_OP='DELETE' THEN v_tenant_id:=OLD.tenant_id;
  ELSE v_tenant_id:=NEW.tenant_id; END IF;
  SELECT compliance_pct INTO v_pct FROM vw_document_summary
  WHERE tenant_id=v_tenant_id;
  IF v_pct < 0 OR v_pct > 100 THEN
    RAISE EXCEPTION 'Porcentaje de cumplimiento fuera de 0 a 100';
  END IF;
  RETURN NULL;
END $$;
CREATE TRIGGER tenanttemplates_compliance AFTER INSERT OR UPDATE OR DELETE ON tenanttemplates
FOR EACH ROW EXECUTE FUNCTION trg_validate_compliance();

CREATE FUNCTION trg_audit_tenant() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF ROW(OLD.name,OLD.contact_email,OLD.phone,OLD.is_active)
     IS DISTINCT FROM ROW(NEW.name,NEW.contact_email,NEW.phone,NEW.is_active) THEN
    INSERT INTO tenant_audit(tenant_id,changed_by,old_name,new_name,old_email,new_email,
      old_is_active,new_is_active)
    VALUES(OLD.tenant_id,CURRENT_USER,OLD.name,NEW.name,OLD.contact_email,NEW.contact_email,
      OLD.is_active,NEW.is_active);
  END IF;
  RETURN NEW;
END $$;
CREATE TRIGGER tenants_audit AFTER UPDATE ON tenants
FOR EACH ROW EXECUTE FUNCTION trg_audit_tenant();

CREATE FUNCTION trg_template_editor() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_by=CURRENT_USER;
  RETURN NEW;
END $$;
CREATE TRIGGER tenanttemplates_editor BEFORE UPDATE ON tenanttemplates
FOR EACH ROW EXECUTE FUNCTION trg_template_editor();

CREATE FUNCTION trg_expire_editing_locks() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  UPDATE editing_locks SET is_active=false WHERE is_active AND expires_at<=CURRENT_TIMESTAMP;
  RETURN NEW;
END $$;
CREATE TRIGGER editing_locks_expire BEFORE INSERT ON editing_locks
FOR EACH STATEMENT EXECUTE FUNCTION trg_expire_editing_locks();

CREATE FUNCTION trg_validate_editing_lock() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM persons p JOIN tenanttemplates tt ON tt.tenant_id=p.tenant_id
    WHERE p.person_id=NEW.person_id AND tt.tenanttemplate_id=NEW.tenanttemplate_id
  ) THEN
    RAISE EXCEPTION 'La persona y el documento deben pertenecer a la misma organización';
  END IF;
  RETURN NEW;
END $$;
CREATE TRIGGER editing_locks_validate
BEFORE INSERT OR UPDATE OF person_id,tenanttemplate_id ON editing_locks
FOR EACH ROW EXECUTE FUNCTION trg_validate_editing_lock();

CREATE PROCEDURE sp_report_stage_docs(p_tenant_id bigint,p_stage_id bigint)
LANGUAGE plpgsql AS $$
DECLARE v_count bigint;
BEGIN
  SELECT COUNT(*) INTO v_count FROM tenanttemplates
  WHERE tenant_id=p_tenant_id AND stage_id=p_stage_id;
  RAISE NOTICE 'Documentos de organización %, etapa %: %',p_tenant_id,p_stage_id,v_count;
END $$;

CREATE PROCEDURE sp_update_tenant_contact(p_tenant_id bigint,p_email text,p_phone text)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE tenants SET contact_email=p_email,phone=p_phone,updated_at=CURRENT_TIMESTAMP
  WHERE tenant_id=p_tenant_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Organización % no existe',p_tenant_id; END IF;
END $$;

-- Las rutinas deben resolver sus tablas incluso si el cliente usa public como search_path.
DO $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT p.oid::regprocedure::text AS signature,p.prokind
    FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace
    WHERE n.nspname='sst' AND p.prokind IN ('f','p')
  LOOP
    EXECUTE format('ALTER %s %s SET search_path TO sst, public',
      CASE WHEN r.prokind='p' THEN 'PROCEDURE' ELSE 'FUNCTION' END,r.signature);
  END LOOP;
END $$;
