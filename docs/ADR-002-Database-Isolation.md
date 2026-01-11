# ADR-002: Database Isolation and Schema Strategy

**Fecha:** 2026-01-11  
**Estado:** Propuesta  
**Responsable:** Aiden / Atlas

---

## 1. Contexto
El proyecto AI Operations Control Layer residirá en la misma instancia de Supabase que el núcleo de ICOFounder. Para proteger la integridad de los datos operacionales de Atlas (tablas como `projects`, `notes`, `brain_versions`, etc.), es imperativo establecer una barrera de aislamiento técnica y administrativa.

## 2. Decisión
Adoptaremos una estrategia de **aislamiento por esquema lógico**.
- Se creará un esquema dedicado llamado `ai_ops_control_layer`.
- Se prohibirá terminantemente cualquier operación (Lectura/Escritura/Referencia) sobre el esquema `public` o tablas core protegidas.
- Se implementará un modelo de seguridad basado en un rol de servicio específico para este esquema (cuando la infraestructura lo permita) y RLS (Row Level Security).

## 3. Alternativas consideradas
- **Opción A: Instancia de Supabase Independiente** — Ventajas: Aislamiento físico total. Desventajas: Mayor costo, complejidad en la gestión de secretos duplicados.
- **Opción B: Uso del esquema Public con prefijos** — Ventajas: Simplicidad inicial. Desventajas: Alto riesgo de errores humanos, dificultad para aplicar políticas de seguridad granulares por proyecto.

## 4. Consecuencias
- **Beneficios**: Seguridad robusta, facilidad de despliegue mediante migraciones independientes, escalabilidad sin riesgos para el core.
- **Riesgos**: Requiere que todos los scripts y Workers especifiquen explícitamente el esquema en sus consultas.

## 5. Seguimiento
- [ ] Creación del esquema `ai_ops_control_layer`.
- [ ] Creación de tablas autorizadas: `ai_ops_tenants`, `ai_ops_projects`, `ai_ops_policies`, `ai_ops_memory`, `ai_ops_audits`, `ai_ops_executions`, `ai_ops_api_usage`.
- [ ] Configuración de RLS en todas las nuevas tablas.

---

**Relacionado con:** Fase 0 / Arquitectura de Datos / Supabase
