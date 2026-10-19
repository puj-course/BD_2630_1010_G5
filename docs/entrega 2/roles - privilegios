# Definición de Roles y Privilegios

## Integrantes

- Andres Gomez

---

## 1. Introducción

Este documento define los tres roles de acceso del modelo de la Copa Mundial (18 tablas) y los privilegios que recibe cada uno. El script `roles_privilegios_mundial.sql` implementa exactamente lo que se describe aquí.

Criterios aplicados en los tres roles:

1. **Mínimo privilegio:** cada rol recibe solo lo que necesita para su función.
2. **Separación de funciones:** quien gestiona el torneo, quien analiza los resultados y quien audita son perfiles distintos.
3. **Sin DELETE para ningún rol:** el modelo usa `ON DELETE CASCADE` en 6 relaciones (todo lo que cuelga de `ENCUENTRO`), por lo que un solo borrado puede eliminar muchos registros. El historial se conserva.
4. **Sin permisos de estructura:** ningún rol puede crear, alterar ni eliminar tablas (`CREATE`, `ALTER`, `DROP`). Eso corresponde al propietario del esquema.
5. **Datos personales por vistas:** `INTEGRANTE` (fecha de nacimiento, nacionalidad) y `CREDENCIAL_MEDIOS` solo se exponen a analista y auditor mediante vistas que ocultan columnas.

| Rol | Función | Alcance |
|---|---|---|
| `rol_gestor_torneo` | Administrar la operación del torneo | Lectura, inserción y modificación en 17 tablas; lectura de la bitácora |
| `rol_analista_deportivo` | Analizar resultados y registrar estadísticas | Lectura general; escritura en 3 tablas de estadísticas e incidencias |
| `rol_auditor_torneo` | Verificar la información y el historial | Solo lectura, incluida la bitácora |

**Convenciones de las tablas:** `Sí` = permiso otorgado; `No` = sin permiso; `Parcial (vista)` = solo a través de una vista con columnas ocultas.

---

## 2. Gestor del torneo (`rol_gestor_torneo`)

**Propósito:** Administrar la operación completa del torneo.

| Tabla | Consultar | Insertar | Modificar | Eliminar | Observación |
|---|---|---|---|---|---|
| `TORNEO_MUNDIAL` | Sí | Sí | Sí | No | Sin DELETE: el historial de ediciones no se borra. |
| `PAIS_ANFITRION` | Sí | Sí | Sí | No |  |
| `LOCALIDAD` | Sí | Sí | Sí | No |  |
| `RECINTO_DEPORTIVO` | Sí | Sí | Sí | No |  |
| `FASE_TORNEO` | Sí | Sí | Sí | No |  |
| `ENTE_FUTBOLISTICO` | Sí | Sí | Sí | No |  |
| `EQUIPO_NACIONAL` | Sí | Sí | Sí | No |  |
| `INTEGRANTE` | Sí | Sí | Sí | No | Contiene datos personales; el gestor los administra. |
| `PLANTEL_EQUIPO` | Sí | Sí | Sí | No |  |
| `ENCUENTRO` | Sí | Sí | Sí | No | Sin DELETE: borrar un partido eliminaría en cascada participantes, árbitros, sucesos, rendimiento, novedades y boletos. |
| `PARTICIPANTE_ENCUENTRO` | Sí | Sí | Sí | No |  |
| `TERNA_ARBITRAL` | Sí | Sí | Sí | No |  |
| `SUCESO_ENCUENTRO` | Sí | Sí | Sí | No |  |
| `RENDIMIENTO_JUGADOR` | Sí | Sí | Sí | No |  |
| `NOVEDAD_ENCUENTRO` | Sí | Sí | Sí | No |  |
| `BOLETO` | Sí | Sí | Sí | No |  |
| `CREDENCIAL_MEDIOS` | Sí | Sí | Sí | No |  |
| `BITACORA_CAMBIOS` | Sí | No | No | No | Solo lectura: la escriben los procesos de auditoría. |

**Resumen:** consulta directa en 18 tablas, consulta parcial por vista en 0, escritura (insertar y modificar) en 17, eliminación en 0.

**Justificación:** Es el rol con más permisos porque administra la operación completa: ediciones, sedes, fases, equipos, plantel, partidos, boletos y credenciales. No recibe `DELETE` porque, con las políticas `RESTRICT` y `CASCADE` del modelo, eliminar registros puede romper el historial o borrar en cascada información del partido. Las correcciones se hacen con `UPDATE`. Tampoco puede escribir en `BITACORA_CAMBIOS`, para que ningún usuario altere su propia trazabilidad.

---

## 3. Analista deportivo (`rol_analista_deportivo`)

**Propósito:** Consultar los datos del torneo y registrar las estadísticas y las incidencias de los partidos.

| Tabla | Consultar | Insertar | Modificar | Eliminar | Observación |
|---|---|---|---|---|---|
| `TORNEO_MUNDIAL` | Sí | No | No | No |  |
| `PAIS_ANFITRION` | Sí | No | No | No |  |
| `LOCALIDAD` | Sí | No | No | No |  |
| `RECINTO_DEPORTIVO` | Sí | No | No | No |  |
| `FASE_TORNEO` | Sí | No | No | No |  |
| `ENTE_FUTBOLISTICO` | Sí | No | No | No |  |
| `EQUIPO_NACIONAL` | Sí | No | No | No |  |
| `INTEGRANTE` | Parcial (vista) | No | No | No | Vista `V_INTEGRANTE_ANALISIS`: sin fecha de nacimiento. |
| `PLANTEL_EQUIPO` | Sí | No | No | No |  |
| `ENCUENTRO` | Sí | No | No | No |  |
| `PARTICIPANTE_ENCUENTRO` | Sí | No | No | No |  |
| `TERNA_ARBITRAL` | Sí | No | No | No |  |
| `SUCESO_ENCUENTRO` | Sí | Sí | Sí | No | Registra goles, tarjetas y sustituciones. |
| `RENDIMIENTO_JUGADOR` | Sí | Sí | Sí | No | Registra y corrige las estadísticas por jugador. |
| `NOVEDAD_ENCUENTRO` | Sí | Sí | Sí | No | Registra incidencias del partido. |
| `BOLETO` | Sí | No | No | No |  |
| `CREDENCIAL_MEDIOS` | Parcial (vista) | No | No | No | Vista `V_CREDENCIAL_RESUMEN`: sin persona ni fecha de emisión. |
| `BITACORA_CAMBIOS` | No | No | No | No | Sin acceso: es información de auditoría. |

**Resumen:** consulta directa en 15 tablas, consulta parcial por vista en 2, escritura (insertar y modificar) en 3, eliminación en 0.

**Justificación:** Necesita consultar casi todo el modelo para cruzar resultados, plantel y fases, y por eso tiene lectura general. Escribe únicamente en `SUCESO_ENCUENTRO`, `RENDIMIENTO_JUGADOR` y `NOVEDAD_ENCUENTRO`, que son las tablas donde se registran las estadísticas y las incidencias; no modifica catálogos ni resultados oficiales (`ENCUENTRO`, `PARTICIPANTE_ENCUENTRO`). Ve `INTEGRANTE` sin fecha de nacimiento y `CREDENCIAL_MEDIOS` sin datos de la persona. No accede a la bitácora.

---

## 4. Auditor (`rol_auditor_torneo`)

**Propósito:** Revisar información histórica y la trazabilidad de los cambios sin alterar nada.

| Tabla | Consultar | Insertar | Modificar | Eliminar | Observación |
|---|---|---|---|---|---|
| `TORNEO_MUNDIAL` | Sí | No | No | No |  |
| `PAIS_ANFITRION` | Sí | No | No | No |  |
| `LOCALIDAD` | Sí | No | No | No |  |
| `RECINTO_DEPORTIVO` | Sí | No | No | No |  |
| `FASE_TORNEO` | Sí | No | No | No |  |
| `ENTE_FUTBOLISTICO` | Sí | No | No | No |  |
| `EQUIPO_NACIONAL` | Sí | No | No | No |  |
| `INTEGRANTE` | Parcial (vista) | No | No | No | Vista `V_INTEGRANTE_BASICO`: solo identificador y nombre. |
| `PLANTEL_EQUIPO` | Sí | No | No | No |  |
| `ENCUENTRO` | Sí | No | No | No |  |
| `PARTICIPANTE_ENCUENTRO` | Sí | No | No | No |  |
| `TERNA_ARBITRAL` | Sí | No | No | No |  |
| `SUCESO_ENCUENTRO` | Sí | No | No | No |  |
| `RENDIMIENTO_JUGADOR` | Sí | No | No | No |  |
| `NOVEDAD_ENCUENTRO` | Sí | No | No | No |  |
| `BOLETO` | Sí | No | No | No |  |
| `CREDENCIAL_MEDIOS` | Parcial (vista) | No | No | No | Vista `V_CREDENCIAL_RESUMEN`: sin persona ni fecha de emisión. |
| `BITACORA_CAMBIOS` | Sí | No | No | No | Tabla pensada para este rol: usuario, fecha, valores anterior y nuevo. |

**Resumen:** consulta directa en 16 tablas, consulta parcial por vista en 2, escritura (insertar y modificar) en 0, eliminación en 0.

**Justificación:** Consulta todo el modelo para contrastar la información y detectar inconsistencias, y no puede cambiar nada. `BITACORA_CAMBIOS` está pensada para este rol: permite ver quién hizo cada cambio, cuándo, sobre qué registro y con qué valores anterior y nuevo. Por privacidad ve `INTEGRANTE` solo con identificador y nombre (sin nacionalidad ni fecha de nacimiento) y `CREDENCIAL_MEDIOS` sin datos de la persona.

---

## 5. Vistas de protección de datos sensibles

| Vista | Tabla base | Columnas visibles | Columnas ocultas | Roles con acceso |
|---|---|---|---|---|
| `V_INTEGRANTE_ANALISIS` | `INTEGRANTE` | `id_persona`, `nombre_completo`, `nacionalidad` | `fecha_de_nacimiento` | `rol_analista_deportivo` |
| `V_INTEGRANTE_BASICO` | `INTEGRANTE` | `id_persona`, `nombre_completo` | `nacionalidad`, `fecha_de_nacimiento` | `rol_auditor_torneo` |
| `V_CREDENCIAL_RESUMEN` | `CREDENCIAL_MEDIOS` | `id_acreditacion`, `id_edicion`, `medio_comunicacio`, `tipo_acreditacion`, `estado` | `id_persona`, `fecha_emision` | `rol_analista_deportivo`, `rol_auditor_torneo` |

Los roles analista y auditor no tienen `SELECT` sobre `INTEGRANTE` ni `CREDENCIAL_MEDIOS`: solo sobre estas vistas. El propietario del esquema crea y mantiene las vistas.

---

## 6. Matriz comparativa

| Tabla | Gestor | Analista | Auditor |
|---|---|---|---|
| `TORNEO_MUNDIAL` | Consulta + escritura | Consulta | Consulta |
| `PAIS_ANFITRION` | Consulta + escritura | Consulta | Consulta |
| `LOCALIDAD` | Consulta + escritura | Consulta | Consulta |
| `RECINTO_DEPORTIVO` | Consulta + escritura | Consulta | Consulta |
| `FASE_TORNEO` | Consulta + escritura | Consulta | Consulta |
| `ENTE_FUTBOLISTICO` | Consulta + escritura | Consulta | Consulta |
| `EQUIPO_NACIONAL` | Consulta + escritura | Consulta | Consulta |
| `INTEGRANTE` | Consulta + escritura | Vista | Vista |
| `PLANTEL_EQUIPO` | Consulta + escritura | Consulta | Consulta |
| `ENCUENTRO` | Consulta + escritura | Consulta | Consulta |
| `PARTICIPANTE_ENCUENTRO` | Consulta + escritura | Consulta | Consulta |
| `TERNA_ARBITRAL` | Consulta + escritura | Consulta | Consulta |
| `SUCESO_ENCUENTRO` | Consulta + escritura | Consulta + escritura | Consulta |
| `RENDIMIENTO_JUGADOR` | Consulta + escritura | Consulta + escritura | Consulta |
| `NOVEDAD_ENCUENTRO` | Consulta + escritura | Consulta + escritura | Consulta |
| `BOLETO` | Consulta + escritura | Consulta | Consulta |
| `CREDENCIAL_MEDIOS` | Consulta + escritura | Vista | Vista |
| `BITACORA_CAMBIOS` | Consulta | Sin acceso | Consulta |

---
