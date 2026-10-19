# Pruebas de Privilegios de Usuarios

## Integrantes

- Andres

---

En este documento se prueba que los tres roles del sistema (`rol_gestor_torneo`, `rol_analista_deportivo` y `rol_auditor_torneo`) tienen exactamente los privilegios definidos en `roles_privilegios_mundial.sql`.

## 1. Usuarios y roles

| Usuario | Rol asignado | Permisos esperados |
| :--- | :--- | :--- |
| `IS101005` | Administrador (propietario de las tablas) | Control total |
| `IS101005` | `rol_gestor_torneo` | `SELECT`, `INSERT`, `UPDATE` en las 17 tablas operativas; `SELECT` en `BITACORA_CAMBIOS`; sin `DELETE` ni cambios de estructura |
| `IS101005` | `rol_analista_deportivo` | `SELECT` en 15 tablas; `INSERT` y `UPDATE` en `SUCESO_ENCUENTRO`, `RENDIMIENTO_JUGADOR` y `NOVEDAD_ENCUENTRO`; sin acceso a `INTEGRANTE`, `CREDENCIAL_MEDIOS` ni `BITACORA_CAMBIOS` |
| `IS101005` | `rol_auditor_torneo` | `SELECT` en 16 tablas, incluida `BITACORA_CAMBIOS`; sin acceso a `INTEGRANTE` ni `CREDENCIAL_MEDIOS`; sin escritura |

Las tablas están en el esquema `IS101005`. Cada bloque de pruebas empieza con el `GRANT` del rol y termina con el `REVOKE` y la limpieza de los datos de prueba.

**Antes de probar:** el usuario de prueba debe reconectarse (o ejecutar `SET ROLE nombre_del_rol;`) después de recibir el rol, porque Oracle no activa un rol nuevo en una sesión que ya estaba abierta.

**Resultado esperado de los rechazos:** cuando el usuario tiene algún privilegio sobre la tabla pero no el que necesita (por ejemplo, `INSERT` con solo `SELECT`), Oracle responde `ORA-01031`. Cuando no tiene ningún privilegio sobre la tabla, normalmente responde `ORA-00942`, aunque algunos servidores muestran `ORA-01031`; cualquiera de los dos prueba que el acceso fue denegado.

---

## 3. Pruebas del Gestor del torneo (`rol_gestor_torneo`)

Debe poder consultar, insertar y modificar en todas las tablas operativas, consultar la bitácora y nada más: no puede borrar registros, no puede escribir en la bitácora y no puede cambiar la estructura de las tablas.

**Preparación (usuario `IS101005`):**

```sql
GRANT rol_gestor_torneo TO IS101005;
```

### Prueba 1: Lectura autorizada

**Usuario:** `IS101005`  
**Acción:** Consultar la tabla `ENCUENTRO`.

```sql
SELECT * FROM IS101005.ENCUENTRO;
```

**Resultado esperado:** La consulta se ejecuta y muestra los registros de la tabla.

**Resultado obtenido:** 

**Estado:** 
---

### Prueba 2: Lectura de datos personales

**Usuario:** `IS101005`  
**Acción:** Consultar la tabla `INTEGRANTE` (solo este rol tiene acceso).

```sql
SELECT * FROM IS101005.INTEGRANTE;
```

**Resultado esperado:** La consulta se ejecuta y muestra los registros de la tabla.

**Resultado obtenido:**

**Estado:**

---

### Prueba 3: INSERT autorizado

**Usuario:** `IS101005`  
**Acción:** Insertar una federación de prueba en `ENTE_FUTBOLISTICO`.

```sql
INSERT INTO IS101005.ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre)
VALUES (777, 'Federacion de Prueba', 'FEDERACION_NACIONAL', 'Colombia', 1);

COMMIT;
```

**Resultado esperado:** `1 row inserted.`

**Resultado obtenido:**

**Estado:**

---

### Prueba 4: UPDATE autorizado

**Usuario:** `IS101005`  
**Acción:** Modificar la federación de prueba.

```sql
UPDATE IS101005.ENTE_FUTBOLISTICO
SET nombre = 'Federacion de Prueba Actualizada'
WHERE id_organizacion = 777;

COMMIT;
```

**Resultado esperado:** `1 row updated.`

**Resultado obtenido:**

**Estado:**

---

### Prueba 5: DELETE no autorizado

**Usuario:** `IS101005`  
**Acción:** Intentar eliminar la federación de prueba.

```sql
DELETE FROM IS101005.ENTE_FUTBOLISTICO WHERE id_organizacion = 777;
```

**Resultado esperado:** `ORA-01031: insufficient privileges`

**Resultado obtenido:** 

**Estado:** 

---

### Prueba 6: Lectura de la bitácora

**Usuario:** `IS101005`  
**Acción:** Consultar la tabla `BITACORA_CAMBIOS`.

```sql
SELECT * FROM IS101005.BITACORA_CAMBIOS;
```

**Resultado esperado:** La consulta se ejecuta y muestra los registros de la tabla.

**Resultado obtenido:** 

**Estado:** 

---

### Prueba 7: INSERT no autorizado en la bitácora

**Usuario:** `IS101005`  
**Acción:** Intentar insertar un registro en `BITACORA_CAMBIOS`.

```sql
INSERT INTO IS101005.BITACORA_CAMBIOS (id_auditoria, id_persona, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora)
VALUES (999, NULL, 'TEST_USER', 'ENTE_FUTBOLISTICO', 777, 'INSERT', SYSTIMESTAMP);
```

**Resultado esperado:** `ORA-01031: insufficient privileges`

**Resultado obtenido:** 

**Estado:** 

---

### Prueba 8: Cambio de estructura no autorizado

**Usuario:** `IS101005`  
**Acción:** Intentar agregar una columna a una tabla.

```sql
ALTER TABLE IS101005.ENTE_FUTBOLISTICO ADD (observacion VARCHAR2(50));
```

**Resultado esperado:** `ORA-01031: insufficient privileges`

**Resultado obtenido:** 

**Estado:** 

---

**Limpieza (usuario `IS101005`):**

```sql
DELETE FROM IS101005.ENTE_FUTBOLISTICO WHERE id_organizacion = 777;
COMMIT;

REVOKE rol_gestor_torneo FROM USUARIO_COMPANERO;
```

### Conclusión del Gestor del torneo

Si las 8 pruebas quedan aprobadas, se confirma que `rol_gestor_torneo` tiene los privilegios definidos y ninguno más.

---

## 4. Pruebas del Analista deportivo (`rol_analista_deportivo`)

Debe poder consultar casi todo el modelo y escribir solo en `SUCESO_ENCUENTRO`, `RENDIMIENTO_JUGADOR` y `NOVEDAD_ENCUENTRO`. No modifica catálogos ni resultados, no borra registros y no accede a los datos personales ni a la bitácora.

**Preparación (usuario `IS101005`):**

```sql
GRANT rol_analista_deportivo TO USUARIO_COMPANERO;
```

### Prueba 1: Lectura autorizada

**Usuario:** `IS101005`  
**Acción:** Consultar la tabla `ENCUENTRO`.

```sql
SELECT * FROM IS101005.ENCUENTRO;
```

**Resultado esperado:** La consulta se ejecuta y muestra los registros de la tabla.

**Resultado obtenido:** 

**Estado:**

---

### Prueba 2: INSERT autorizado en tabla de estadísticas

**Usuario:** `IS101005`  
**Acción:** Insertar una novedad de prueba en `NOVEDAD_ENCUENTRO`.

```sql
INSERT INTO IS101005.NOVEDAD_ENCUENTRO (id_incidencia, id_partido, tipo, descripcion, minuto)
VALUES (777, 1, 'OTRA', 'Novedad de prueba del analista', 15);

COMMIT;
```

**Resultado esperado:** `1 row inserted.`

**Resultado obtenido:** 

**Estado:** 

---

### Prueba 3: UPDATE autorizado en tabla de estadísticas

**Usuario:** `IS101005`  
**Acción:** Modificar la novedad de prueba.

```sql
UPDATE IS101005.NOVEDAD_ENCUENTRO
SET descripcion = 'Novedad actualizada por el analista'
WHERE id_incidencia = 777;

COMMIT;
```

**Resultado esperado:** `1 row updated.`

**Resultado obtenido:** 

**Estado:**

---

### Prueba 4: DELETE no autorizado

**Usuario:** `IS101005`  
**Acción:** Intentar eliminar la novedad de prueba.

```sql
DELETE FROM IS101005.NOVEDAD_ENCUENTRO WHERE id_incidencia = 777;
```

**Resultado esperado:** `ORA-01031: insufficient privileges`

**Resultado obtenido:** 

**Estado:** 

---

### Prueba 5: INSERT no autorizado en un catálogo

**Usuario:** `IS101005`  
**Acción:** Intentar insertar una federación en `ENTE_FUTBOLISTICO`.

```sql
INSERT INTO IS101005.ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre)
VALUES (777, 'Federacion de Prueba', 'FEDERACION_NACIONAL', 'Colombia', 1);
```

**Resultado esperado:** `ORA-01031: insufficient privileges`

**Resultado obtenido:**

**Estado:**

---

### Prueba 6: UPDATE no autorizado sobre resultados

**Usuario:** `IS101005`  
**Acción:** Intentar modificar la asistencia de un partido.

```sql
UPDATE IS101005.ENCUENTRO
SET asistencia_registrada = 1
WHERE id_partido = 1;
```

**Resultado esperado:** `ORA-01031: insufficient privileges`

**Resultado obtenido:**

**Estado:**

---

### Prueba 7: SELECT no autorizado en datos personales

**Usuario:** `IS101005`  
**Acción:** Consultar la tabla `INTEGRANTE`.

```sql
SELECT * FROM IS101005.INTEGRANTE;
```

**Resultado esperado:** `ORA-00942: table or view does not exist` (en algunos servidores aparece `ORA-01031: insufficient privileges`)

**Resultado obtenido:** 

**Estado:**

---

### Prueba 8: SELECT no autorizado en la bitácora

**Usuario:** `IS101005`  
**Acción:** Consultar la tabla `BITACORA_CAMBIOS`.

```sql
SELECT * FROM IS101005.BITACORA_CAMBIOS;
```

**Resultado esperado:** `ORA-00942: table or view does not exist` (en algunos servidores aparece `ORA-01031: insufficient privileges`)

**Resultado obtenido:**

**Estado:**

---

**Limpieza (usuario `IS101005`):**

```sql
DELETE FROM IS101005.NOVEDAD_ENCUENTRO WHERE id_incidencia = 777;
COMMIT;

REVOKE rol_analista_deportivo FROM USUARIO_COMPANERO;
```

### Conclusión del Analista deportivo

Si las 8 pruebas quedan aprobadas, se confirma que `rol_analista_deportivo` tiene los privilegios definidos y ninguno más.

---

## 5. Pruebas del Auditor (`rol_auditor_torneo`)

Debe poder consultar las tablas del torneo y la bitácora, sin modificar nada. No accede a `INTEGRANTE` ni a `CREDENCIAL_MEDIOS` por contener datos personales.

**Preparación (usuario `IS101005`):**

```sql
GRANT rol_auditor_torneo TO USUARIO_COMPANERO;
```

### Prueba 1: Lectura de la bitácora

**Usuario:** `IS101005`  
**Acción:** Consultar la tabla `BITACORA_CAMBIOS` (la tabla pensada para este rol).

```sql
SELECT * FROM IS101005.BITACORA_CAMBIOS;
```

**Resultado esperado:** La consulta se ejecuta y muestra los registros de la tabla.

**Resultado obtenido:**

**Estado:**

---

### Prueba 2: Lectura autorizada

**Usuario:** `IS101005`  
**Acción:** Consultar la tabla `ENCUENTRO`.

```sql
SELECT * FROM IS101005.ENCUENTRO;
```

**Resultado esperado:** La consulta se ejecuta y muestra los registros de la tabla.

**Resultado obtenido:** 

**Estado:**

---

### Prueba 3: INSERT no autorizado

**Usuario:** `IS101005`  
**Acción:** Intentar insertar una novedad en `NOVEDAD_ENCUENTRO`.

```sql
INSERT INTO IS101005.NOVEDAD_ENCUENTRO (id_incidencia, id_partido, tipo, descripcion, minuto)
VALUES (777, 1, 'OTRA', 'Novedad de prueba del analista', 15);
```

**Resultado esperado:** `ORA-01031: insufficient privileges`

**Resultado obtenido:** 

**Estado:**

---

### Prueba 4: UPDATE no autorizado

**Usuario:** `IS101005`  
**Acción:** Intentar modificar la asistencia de un partido.

```sql
UPDATE IS101005.ENCUENTRO
SET asistencia_registrada = 1
WHERE id_partido = 1;
```

**Resultado esperado:** `ORA-01031: insufficient privileges`

**Resultado obtenido:**

**Estado:**

---

### Prueba 5: DELETE no autorizado

**Usuario:** `IS101005`  
**Acción:** Intentar eliminar una novedad.

```sql
DELETE FROM IS101005.NOVEDAD_ENCUENTRO WHERE id_incidencia = 1;
```

**Resultado esperado:** `ORA-01031: insufficient privileges`

**Resultado obtenido:**

**Estado:** 

---

### Prueba 6: SELECT no autorizado en datos personales

**Usuario:** `IS101005`  
**Acción:** Consultar la tabla `INTEGRANTE`.

```sql
SELECT * FROM IS101005.INTEGRANTE;
```

**Resultado esperado:** `ORA-00942: table or view does not exist` (en algunos servidores aparece `ORA-01031: insufficient privileges`)

**Resultado obtenido:**

**Estado:**

---

### Prueba 7: SELECT no autorizado en credenciales

**Usuario:** `IS101005`  
**Acción:** Consultar la tabla `CREDENCIAL_MEDIOS`.

```sql
SELECT * FROM IS101005.CREDENCIAL_MEDIOS;
```

**Resultado esperado:** `ORA-00942: table or view does not exist` (en algunos servidores aparece `ORA-01031: insufficient privileges`)

**Resultado obtenido:**

**Estado:**

---

**Limpieza (usuario `IS101005`):**

```sql
REVOKE rol_auditor_torneo FROM IS101005;
```

### Conclusión del Auditor

Si las 7 pruebas quedan aprobadas, se confirma que `rol_auditor_torneo` tiene los privilegios definidos y ninguno más.

---

## 6. Resumen de resultados

| Rol | Pruebas | Aprobadas |
|---|---:|---:|
| `rol_gestor_torneo` | 8 | |
| `rol_analista_deportivo` | 8 | |
| `rol_auditor_torneo` | 7 | |
| **Total** | **23** | |
