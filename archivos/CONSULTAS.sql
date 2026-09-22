-- Consultas de Examen.md. Ejecutar en psql con ON_ERROR_STOP=1.
SET search_path TO sst, public;

-- Básicas 1–15
-- B01
SELECT tenant_id,identification,name,contact_email,phone,tenant_size_id,municipality_id,is_active,created_at,updated_at FROM tenants ORDER BY tenant_id;
-- B02
SELECT name,contact_email,phone FROM tenants ORDER BY name;
-- B03
SELECT first_name,last_name,email FROM persons ORDER BY person_id;
-- B04
SELECT person_id,first_name,last_name,email FROM persons WHERE is_active ORDER BY person_id;
-- B05: cambiar Andes por el criterio indicado.
SELECT tenant_id,name FROM tenants WHERE name ILIKE '%Andes%' ORDER BY tenant_id;
-- B06
SELECT country_id,name FROM countries ORDER BY name;
-- B07: país 1 = Colombia.
SELECT department_id,name FROM departments WHERE country_id=1 ORDER BY name;
-- B08: departamento 1 = Antioquia.
SELECT municipality_id,name FROM municipalities WHERE department_id=1 ORDER BY name;
-- B09
SELECT position_id,tenant_id,description FROM positions ORDER BY description,position_id;
-- B10
SELECT person_id,first_name,last_name FROM persons WHERE tenant_id=1 ORDER BY person_id;
-- B11
SELECT tenant_id,name FROM tenants WHERE is_active ORDER BY tenant_id;
-- B12
SELECT tenant_id,name,created_at FROM tenants WHERE created_at >= '2026-01-01' AND created_at < '2026-04-01' ORDER BY created_at;
-- B13
SELECT tenant_size_id,description FROM tenant_sizes ORDER BY tenant_size_id;
-- B14
SELECT system_id,code,description FROM type_system_sst ORDER BY system_id;
-- B15
SELECT module_id,title,description,display_order FROM modules ORDER BY system_id,display_order;

-- Intermedias 1–20
-- I01
SELECT p.person_id,CONCAT_WS(' ',p.first_name,p.last_name) AS full_name,t.name AS tenant_name FROM persons p JOIN tenants t ON t.tenant_id=p.tenant_id ORDER BY p.person_id;
-- I02
SELECT p.person_id,CONCAT_WS(' ',p.first_name,p.last_name) AS full_name,po.description AS position_name FROM persons p JOIN positions po ON (po.tenant_id,po.position_id)=(p.tenant_id,p.position_id) ORDER BY p.person_id;
-- I03
SELECT t.tenant_id,t.name,s.description AS tenant_size FROM tenants t JOIN tenant_sizes s ON s.tenant_size_id=t.tenant_size_id ORDER BY t.tenant_id;
-- I04
SELECT tenant_id,tenant_name,municipality_name,department_name,country_name FROM vw_tenant_geography ORDER BY tenant_id;
-- I05
SELECT t.tenant_id,t.name,COUNT(p.person_id) AS person_count FROM tenants t LEFT JOIN persons p ON p.tenant_id=t.tenant_id GROUP BY t.tenant_id,t.name ORDER BY t.tenant_id;
-- I06: umbral = 1.
SELECT t.tenant_id,t.name,COUNT(p.person_id) AS person_count FROM tenants t LEFT JOIN persons p ON p.tenant_id=t.tenant_id GROUP BY t.tenant_id,t.name HAVING COUNT(p.person_id)>1 ORDER BY person_count DESC;
-- I07
SELECT tenant_id,tenant_name,module_id,module_title,system_code FROM vw_tenant_modules WHERE is_enabled ORDER BY tenant_id,module_id;
-- I08
SELECT t.tenant_id,t.name,COUNT(tm.module_id) FILTER (WHERE tm.is_enabled) AS module_count FROM tenants t LEFT JOIN tenant_modules tm ON tm.tenant_id=t.tenant_id GROUP BY t.tenant_id,t.name ORDER BY t.tenant_id;
-- I09
SELECT t.tenant_id,t.name,s.code,s.description FROM tenantsystems ts JOIN tenants t ON t.tenant_id=ts.tenant_id JOIN type_system_sst s ON s.system_id=ts.system_id ORDER BY t.tenant_id,s.system_id;
-- I10
SELECT m.module_id,m.title,s.code FROM modules m JOIN type_system_sst s ON s.system_id=m.system_id ORDER BY m.module_id;
-- I11
SELECT f.format_id,f.title,m.title AS module_title FROM formats_sst f JOIN modules m ON m.module_id=f.module_id ORDER BY f.format_id;
-- I12
SELECT m.module_id,m.title,COUNT(f.format_id) AS format_count FROM modules m LEFT JOIN formats_sst f ON f.module_id=m.module_id GROUP BY m.module_id,m.title ORDER BY m.module_id;
-- I13
SELECT t.tenant_id,t.name,tpl.template_id,tpl.title FROM tenanttemplates tt JOIN tenants t ON t.tenant_id=tt.tenant_id JOIN templates tpl ON tpl.template_id=tt.template_id ORDER BY t.tenant_id,tpl.template_id;
-- I14
SELECT t.name AS tenant_name,tpl.title AS template_title,s.code AS system_code,st.name AS stage_name FROM tenanttemplates tt JOIN tenants t ON t.tenant_id=tt.tenant_id JOIN templates tpl ON tpl.template_id=tt.template_id JOIN formats_sst f ON f.format_id=tpl.format_id JOIN modules m ON m.module_id=f.module_id JOIN type_system_sst s ON s.system_id=m.system_id JOIN phva_stages st ON st.stage_id=tt.stage_id ORDER BY t.tenant_id,tpl.template_id;
-- I15
SELECT t.tenant_id,t.name,COUNT(tt.tenanttemplate_id) AS template_count FROM tenants t LEFT JOIN tenanttemplates tt ON tt.tenant_id=t.tenant_id GROUP BY t.tenant_id,t.name ORDER BY t.tenant_id;
-- I16
SELECT t.tenant_id,t.name FROM tenants t LEFT JOIN persons p ON p.tenant_id=t.tenant_id WHERE p.person_id IS NULL ORDER BY t.tenant_id;
-- I17
SELECT m.module_id,m.title FROM modules m LEFT JOIN tenant_modules tm ON tm.module_id=m.module_id WHERE tm.module_id IS NULL ORDER BY m.module_id;
-- I18
SELECT st.stage_id,st.name,COUNT(tt.tenanttemplate_id) AS template_count FROM phva_stages st LEFT JOIN tenanttemplates tt ON tt.stage_id=st.stage_id GROUP BY st.stage_id,st.name ORDER BY st.stage_id;
-- I19
SELECT m.municipality_id,m.name,COUNT(t.tenant_id) AS tenant_count FROM municipalities m LEFT JOIN tenants t ON t.municipality_id=m.municipality_id GROUP BY m.municipality_id,m.name ORDER BY m.municipality_id;
-- I20
SELECT tenant_id,tenant_name,position_id,position_name,person_count FROM vw_tenant_position_persons ORDER BY tenant_id,position_id;

-- Avanzadas 1–25
-- A01
SELECT tenant_id,tenant_name,person_count FROM vw_tenant_overview ORDER BY person_count DESC,tenant_id LIMIT 1;
-- A02: promedio incluye empresas sin personas.
SELECT tenant_id,tenant_name,person_count FROM vw_tenant_overview WHERE person_count>(SELECT AVG(person_count) FROM vw_tenant_overview) ORDER BY tenant_id;
-- A03: sistema 1 = SST.
SELECT t.tenant_id,t.name FROM tenants t WHERE EXISTS(SELECT 1 FROM modules m WHERE m.system_id=1) AND NOT EXISTS(SELECT 1 FROM modules m WHERE m.system_id=1 AND NOT EXISTS(SELECT 1 FROM tenant_modules tm WHERE tm.tenant_id=t.tenant_id AND tm.module_id=m.module_id AND tm.is_enabled)) ORDER BY t.tenant_id;
-- A04
SELECT t.tenant_id,t.name FROM tenants t WHERE EXISTS(SELECT 1 FROM tenant_modules tm WHERE tm.tenant_id=t.tenant_id AND tm.is_enabled) AND NOT EXISTS(SELECT 1 FROM tenanttemplates tt WHERE tt.tenant_id=t.tenant_id) ORDER BY t.tenant_id;
-- A05
SELECT t.tenant_id,t.name FROM tenants t WHERE NOT EXISTS(SELECT 1 FROM phva_stages st WHERE NOT EXISTS(SELECT 1 FROM tenanttemplates tt WHERE tt.tenant_id=t.tenant_id AND tt.stage_id=st.stage_id)) ORDER BY t.tenant_id;
-- A06
SELECT tenant_id,tenant_name,stage_id,stage_name,template_count FROM vw_tenant_stage_templates ORDER BY tenant_id,stage_id;
-- A07
SELECT t.tenant_id,t.name,COUNT(tt.tenanttemplate_id) FILTER (WHERE st.code='P') AS planear,COUNT(tt.tenanttemplate_id) FILTER (WHERE st.code='H') AS hacer,COUNT(tt.tenanttemplate_id) FILTER (WHERE st.code='V') AS verificar,COUNT(tt.tenanttemplate_id) FILTER (WHERE st.code='A') AS actuar FROM tenants t LEFT JOIN tenanttemplates tt ON tt.tenant_id=t.tenant_id LEFT JOIN phva_stages st ON st.stage_id=tt.stage_id GROUP BY t.tenant_id,t.name ORDER BY t.tenant_id;
-- A08
SELECT tenant_id,tenant_name,stage_name,ROUND(100.0*template_count/NULLIF(SUM(template_count) OVER (PARTITION BY tenant_id),0),2) AS stage_pct FROM vw_tenant_stage_templates ORDER BY tenant_id,stage_id;
-- A09
WITH ranked AS (SELECT tenant_id,tenant_name,stage_name,template_count,DENSE_RANK() OVER (PARTITION BY tenant_id ORDER BY template_count DESC) AS rank_no FROM vw_tenant_stage_templates) SELECT tenant_id,tenant_name,stage_name,template_count FROM ranked WHERE rank_no=1 AND template_count>0 ORDER BY tenant_id,stage_name;
-- A10
SELECT tenant_id,tenant_name,total_docs,finalized_docs,compliance_pct FROM vw_document_summary ORDER BY tenant_id;
-- A11
SELECT tenant_id,tenant_name,compliance_pct FROM vw_document_summary WHERE compliance_pct<(SELECT AVG(compliance_pct) FROM vw_document_summary) ORDER BY tenant_id;
-- A12
SELECT tenant_id,tenant_name,compliance_pct,CASE WHEN compliance_pct<50 THEN 'bajo' WHEN compliance_pct<80 THEN 'medio' ELSE 'alto' END AS level FROM vw_document_summary ORDER BY tenant_id;
-- A13
SELECT tenant_id,tenant_name,compliance_pct,DENSE_RANK() OVER (ORDER BY compliance_pct DESC) AS rank_no FROM vw_document_summary ORDER BY rank_no,tenant_id;
-- A14
SELECT tenant_id,tenant_name,compliance_pct,ROUND(compliance_pct-AVG(compliance_pct) OVER (),2) AS difference_from_average FROM vw_document_summary ORDER BY tenant_id;
-- A15: acumulado por ID de organización.
SELECT tenant_id,tenant_name,finalized_docs,SUM(finalized_docs) OVER (ORDER BY tenant_id) AS cumulative_finalized FROM vw_document_summary ORDER BY tenant_id;
-- A16
SELECT a.tenant_id AS tenant_a,a.name AS name_a,b.tenant_id AS tenant_b,b.name AS name_b FROM tenants a JOIN tenants b ON a.municipality_id=b.municipality_id AND a.tenant_size_id<>b.tenant_size_id AND a.tenant_id<b.tenant_id ORDER BY a.tenant_id,b.tenant_id;
-- A17
WITH occupation AS (SELECT po.tenant_id,po.position_id,COUNT(p.person_id) AS occupants FROM positions po LEFT JOIN persons p ON (p.tenant_id,p.position_id)=(po.tenant_id,po.position_id) GROUP BY po.tenant_id,po.position_id), ranked AS (SELECT tenant_id,position_id,occupants,AVG(occupants) OVER (PARTITION BY tenant_id) AS average_occupants FROM occupation) SELECT p.person_id,p.first_name,p.last_name,r.occupants,r.average_occupants FROM persons p JOIN ranked r ON (r.tenant_id,r.position_id)=(p.tenant_id,p.position_id) WHERE r.occupants>r.average_occupants ORDER BY p.person_id;
-- A18
WITH counts AS (SELECT t.tenant_id,t.name,COUNT(p.person_id) AS person_count FROM tenants t LEFT JOIN persons p ON p.tenant_id=t.tenant_id GROUP BY t.tenant_id,t.name) SELECT tenant_id,name,person_count FROM counts WHERE person_count>(SELECT AVG(person_count) FROM counts) ORDER BY tenant_id;
-- A19
WITH summary AS (SELECT tenant_id,tenant_name,module_count,template_count,person_count FROM vw_tenant_overview) SELECT tenant_id,tenant_name,module_count,template_count,person_count FROM summary ORDER BY tenant_id;
-- A20
SELECT t.tenant_id,t.name,st.name AS missing_stage FROM tenants t CROSS JOIN phva_stages st WHERE NOT EXISTS(SELECT 1 FROM tenanttemplates tt WHERE tt.tenant_id=t.tenant_id AND tt.stage_id=st.stage_id) ORDER BY t.tenant_id,st.stage_id;
-- A21
SELECT t.tenant_id,t.name,MAX(tt.updated_at) AS last_template_update FROM tenants t LEFT JOIN tenanttemplates tt ON tt.tenant_id=t.tenant_id GROUP BY t.tenant_id,t.name ORDER BY t.tenant_id;
-- A22
SELECT t.tenant_id,t.name,s.pending_docs AS sst_pending,p.pending_docs AS pesv_pending FROM tenants t JOIN vm_template_sst_docs_summary s ON s.tenant_id=t.tenant_id JOIN vm_template_pesv_docs_summary p ON p.tenant_id=t.tenant_id WHERE s.pending_docs+p.pending_docs>0 ORDER BY t.tenant_id;
-- A23
SELECT tenant_id,tenant_name,total_docs,finalized_docs,draft_docs,unstarted_docs,pending_docs,compliance_pct FROM vw_document_summary ORDER BY tenant_id;
-- A24: diferencia mayor a 10 puntos; solo empresas con documentos en ambos sistemas.
SELECT s.tenant_id,s.tenant_name,s.compliance_pct AS sst_pct,p.compliance_pct AS pesv_pct,ABS(s.compliance_pct-p.compliance_pct) AS difference_pct FROM vm_template_sst_docs_summary s JOIN vm_template_pesv_docs_summary p ON p.tenant_id=s.tenant_id WHERE s.total_docs>0 AND p.total_docs>0 AND ABS(s.compliance_pct-p.compliance_pct)>10 ORDER BY s.tenant_id;
-- A25
SELECT tenant_id,tenant_name,person_count,module_count,template_count,system_count FROM vw_tenant_overview ORDER BY tenant_id;
