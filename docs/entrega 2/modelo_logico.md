# Modelo Lógico Ampliado

## 1. Introducción

Este documento describe el modelo lógico de la Entrega 2 del proyecto **Sistema de Información para la Gestión Integral de la Copa Mundial de la FIFA**. Cada entidad se presenta con su identificador, sus atributos, sus relaciones y las reglas que la gobiernan. El modelo coincide con el modelo relacional implementado en Oracle 19c (`ddl_mundial.sql`).

El modelo contiene **18 entidades** y **28 relaciones**. Las relaciones muchos a muchos se resuelven con cuatro entidades asociativas (`PLANTEL_EQUIPO`, `PARTICIPANTE_ENCUENTRO`, `TERNA_ARBITRAL` y `RENDIMIENTO_JUGADOR`) y las jerarquías se representan con autorrelaciones.

| N.º | Entidad | Nombre lógico | Grupo funcional |
|---:|---|---|---|
| 1 | `TORNEO_MUNDIAL` | Torneo mundial | Organización del torneo |
| 2 | `PAIS_ANFITRION` | País anfitrión | Organización del torneo |
| 3 | `LOCALIDAD` | Localidad | Organización del torneo |
| 4 | `RECINTO_DEPORTIVO` | Recinto deportivo | Organización del torneo |
| 5 | `FASE_TORNEO` | Fase del torneo | Competencia deportiva |
| 6 | `ENTE_FUTBOLISTICO` | Ente futbolístico | Selecciones, jugadores y cuerpo técnico |
| 7 | `EQUIPO_NACIONAL` | Equipo nacional | Competencia deportiva |
| 8 | `INTEGRANTE` | Integrante | Selecciones, jugadores y cuerpo técnico |
| 9 | `PLANTEL_EQUIPO` | Plantel del equipo | Selecciones, jugadores y cuerpo técnico |
| 10 | `ENCUENTRO` | Encuentro | Competencia deportiva |
| 11 | `PARTICIPANTE_ENCUENTRO` | Participante de encuentro | Competencia deportiva |
| 12 | `TERNA_ARBITRAL` | Terna arbitral | Arbitraje |
| 13 | `SUCESO_ENCUENTRO` | Suceso del encuentro | Estadísticas de juego |
| 14 | `RENDIMIENTO_JUGADOR` | Rendimiento del jugador | Estadísticas de juego |
| 15 | `NOVEDAD_ENCUENTRO` | Novedad del encuentro | Logística, público, medios e incidencias |
| 16 | `BOLETO` | Boleto | Logística, público, medios e incidencias |
| 17 | `CREDENCIAL_MEDIOS` | Credencial de medios | Logística, público, medios e incidencias |
| 18 | `BITACORA_CAMBIOS` | Bitácora de cambios | Auditoría |

---

## 2. Convenciones del modelo

| Elemento | Convención |
|---|---|
| **PK** | Identificador de la entidad. En todas las entidades es un entero subrogado de una sola columna. |
| **FK** | Atributo que referencia el identificador de otra entidad. |
| **UK** | Atributo o combinación de atributos que no puede repetirse (identificador alterno). |
| **Obligatorio** | `Sí` = `NOT NULL`; `No` = admite valor nulo. |
| **Cardinalidad** | `1:N` = una ocurrencia del padre se relaciona con varias del hijo. `0..1` indica que la relación es opcional del lado del hijo (la FK admite nulos). |
| **Política de borrado** | `RESTRICT` (no permite borrar al padre con hijos), `CASCADE` (borra los hijos) o `SET NULL` (deja la referencia en nulo). Oracle no tiene `ON UPDATE`; como los identificadores son subrogados e inmutables, no se requiere. |

---

## 3. Descripción de las entidades

### 3.1. TORNEO_MUNDIAL

**Torneo mundial.** Representa cada edición de la Copa Mundial registrada en el sistema. Es la entidad raíz de la que cuelgan las sedes, las fases y las acreditaciones.

**Identificador:** `id_edicion`

**Identificadores alternos (UK):** `anio` (`anio`)

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_edicion` | `INTEGER` | Sí | PK | — |
| 2 | `anio` | `NUMBER` | Sí | UK | — |
| 3 | `nombre` | `VARCHAR2(100 CHAR)` | Sí | — | — |
| 4 | `lema` | `VARCHAR2(200 CHAR)` | No | — | — |
| 5 | `fecha_inicio` | `DATE` | Sí | — | — |
| 6 | `fecha_fin` | `DATE` | Sí | — | — |

**Relaciones**

- `TORNEO_MUNDIAL` **tiene** `PAIS_ANFITRION` — `1:N`.
- `TORNEO_MUNDIAL` **cuenta con** `FASE_TORNEO` — `1:N`.
- `TORNEO_MUNDIAL` **acredita a** `CREDENCIAL_MEDIOS` — `1:N`.

**Reglas**

*Implementadas en el DDL:*

- `UNIQUE` `anio` sobre (anio).
- `CHECK` `edicion_fechas`: `fecha_fin > fecha_inicio`.

*Descripción funcional:*

- Cada edición se identifica de forma única por su año.
- La fecha de fin debe ser posterior a la de inicio.

### 3.2. PAIS_ANFITRION

**País anfitrión.** Cada país que actúa como sede de una edición. Una edición puede tener varios países anfitriones.

**Identificador:** `id_sede`

**Identificadores alternos (UK):** `Unique_Keyv1` (`pais`, `id_edicion`)

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_sede` | `INTEGER` | Sí | PK | — |
| 2 | `id_edicion` | `INTEGER` | Sí | FK, UK | `TORNEO_MUNDIAL`(id_edicion) |
| 3 | `pais` | `VARCHAR2(80 CHAR)` | Sí | UK | — |

**Relaciones**

- `TORNEO_MUNDIAL` **tiene** `PAIS_ANFITRION` — `1:N`, vía `id_edicion`; borrado `RESTRICT`.
- `PAIS_ANFITRION` **posee** `LOCALIDAD` — `1:N`.

**Reglas**

*Implementadas en el DDL:*

- `UNIQUE` `Unique_Keyv1` sobre (pais, id_edicion).

*Descripción funcional:*

- Un mismo país no puede repetirse como anfitrión dentro de la misma edición.

### 3.3. LOCALIDAD

**Localidad.** Ciudad anfitriona perteneciente a un país anfitrión.

**Identificador:** `id_ciudad`

**Identificadores alternos (UK):** `Unique_Key` (`id_sede`, `nombre`)

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_ciudad` | `INTEGER` | Sí | PK | — |
| 2 | `id_sede` | `INTEGER` | Sí | FK, UK | `PAIS_ANFITRION`(id_sede) |
| 3 | `nombre` | `VARCHAR2(80 CHAR)` | Sí | UK | — |

**Relaciones**

- `PAIS_ANFITRION` **posee** `LOCALIDAD` — `1:N`, vía `id_sede`; borrado `RESTRICT`.
- `LOCALIDAD` **dispone de** `RECINTO_DEPORTIVO` — `1:N`.

**Reglas**

*Implementadas en el DDL:*

- `UNIQUE` `Unique_Key` sobre (id_sede, nombre).

*Descripción funcional:*

- El nombre de la ciudad no puede repetirse dentro del mismo país anfitrión.

### 3.4. RECINTO_DEPORTIVO

**Recinto deportivo.** Estadio donde se disputan los encuentros; pertenece a una localidad.

**Identificador:** `id_estadio`

**Identificadores alternos (UK):** `Unique_Keyv4` (`nombre`, `id_ciudad`)

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_estadio` | `INTEGER` | Sí | PK | — |
| 2 | `id_ciudad` | `INTEGER` | Sí | FK, UK | `LOCALIDAD`(id_ciudad) |
| 3 | `nombre` | `VARCHAR2(100 CHAR)` | Sí | UK | — |
| 4 | `capacidad` | `INTEGER` | Sí | — | — |

**Relaciones**

- `LOCALIDAD` **dispone de** `RECINTO_DEPORTIVO` — `1:N`, vía `id_ciudad`; borrado `RESTRICT`.
- `RECINTO_DEPORTIVO` **alberga** `ENCUENTRO` — `1:N`.

**Reglas**

*Implementadas en el DDL:*

- `UNIQUE` `Unique_Keyv4` sobre (nombre, id_ciudad).
- `CHECK` `estadio_capacidad`: `capacidad > 0`.

*Descripción funcional:*

- La capacidad debe ser mayor que cero.
- El nombre del estadio no puede repetirse dentro de la misma ciudad.

### 3.5. FASE_TORNEO

**Fase del torneo.** Estructura deportiva de la competición. Con una sola entidad y una autorrelación se representan la fase de grupos, cada grupo y las instancias eliminatorias.

**Identificador:** `id_etapa`

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_etapa` | `INTEGER` | Sí | PK | — |
| 2 | `id_edicion` | `INTEGER` | Sí | FK | `TORNEO_MUNDIAL`(id_edicion) |
| 3 | `id_etapa_padre` | `INTEGER` | No | FK | `FASE_TORNEO`(id_etapa) |
| 4 | `nombre` | `VARCHAR2(80 CHAR)` | Sí | — | — |
| 5 | `tipo_etapa` | `VARCHAR2(40)` | Sí | — | — |
| 6 | `orden` | `INTEGER` | Sí | — | — |

**Relaciones**

- `TORNEO_MUNDIAL` **cuenta con** `FASE_TORNEO` — `1:N`, vía `id_edicion`; borrado `RESTRICT`.
- `FASE_TORNEO` **se conforma de** `FASE_TORNEO` — `1:N` (opcional), vía `id_etapa_padre`; borrado `SET NULL`.
- `FASE_TORNEO` **agrupa** `EQUIPO_NACIONAL` — `1:N`.
- `FASE_TORNEO` **contiene** `ENCUENTRO` — `1:N`.

**Reglas**

*Implementadas en el DDL:*

- `CHECK` `etapa_tipo`: `tipo_etapa IN ('FASE', 'GRUPO', 'INSTANCIA_ELIMINATORIA')`.

*Descripción funcional:*

- Una fase puede contener otras fases (por ejemplo, la fase de grupos contiene los grupos A, B, C…).
- Los valores de `tipo_etapa` son `FASE`, `GRUPO` e `INSTANCIA_ELIMINATORIA`.

### 3.6. ENTE_FUTBOLISTICO

**Ente futbolístico.** Organización institucional del fútbol. Una misma entidad, con autorrelación, representa confederaciones y federaciones nacionales.

**Identificador:** `id_organizacion`

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_organizacion` | `INTEGER` | Sí | PK | — |
| 2 | `nombre` | `VARCHAR2(100 CHAR)` | Sí | — | — |
| 3 | `tipo` | `VARCHAR2(30 CHAR)` | Sí | — | — |
| 4 | `pais` | `VARCHAR2(80 CHAR)` | Sí | — | — |
| 5 | `id_organizacion_padre` | `INTEGER` | No | FK | `ENTE_FUTBOLISTICO`(id_organizacion) |

**Relaciones**

- `ENTE_FUTBOLISTICO` **se forma de** `ENTE_FUTBOLISTICO` — `1:N` (opcional), vía `id_organizacion_padre`; borrado `SET NULL`.
- `ENTE_FUTBOLISTICO` **representa a** `EQUIPO_NACIONAL` — `1:N`.

**Reglas**

*Implementadas en el DDL:*

- `CHECK` `organizacion_tipo`: `tipo IN ('CONFEDERACION', 'FEDERACION_NACIONAL')`.

*Descripción funcional:*

- Una confederación no tiene organización padre; una federación nacional se asocia a una confederación.
- Los valores de `tipo` son `CONFEDERACION` y `FEDERACION_NACIONAL`.

### 3.7. EQUIPO_NACIONAL

**Equipo nacional.** Selección nacional que participa en una edición. Queda ubicada en un grupo (fase) y pertenece a una federación.

**Identificador:** `id_seleccion`

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_seleccion` | `INTEGER` | Sí | PK | — |
| 2 | `id_organizacion` | `INTEGER` | Sí | FK | `ENTE_FUTBOLISTICO`(id_organizacion) |
| 3 | `id_etapa_grupo` | `INTEGER` | Sí | FK | `FASE_TORNEO`(id_etapa) |
| 4 | `codigo_fifa` | `VARCHAR2(3 CHAR)` | Sí | — | — |

**Relaciones**

- `ENTE_FUTBOLISTICO` **representa a** `EQUIPO_NACIONAL` — `1:N`, vía `id_organizacion`; borrado `RESTRICT`.
- `FASE_TORNEO` **agrupa** `EQUIPO_NACIONAL` — `1:N`, vía `id_etapa_grupo`; borrado `RESTRICT`.
- `EQUIPO_NACIONAL` **cuenta con** `PLANTEL_EQUIPO` — `1:N`.
- `EQUIPO_NACIONAL` **disputa** `PARTICIPANTE_ENCUENTRO` — `1:N`.

**Reglas**

*Implementadas en el DDL:*

- Solo restricciones de llave (PK y FK).

*Descripción funcional:*

- La edición se obtiene a través del grupo (`id_etapa_grupo` → fase → torneo), por eso no se guarda como columna.
- La organización referenciada debe ser de tipo `FEDERACION_NACIONAL` (regla de negocio).

### 3.8. INTEGRANTE

**Integrante.** Persona natural relacionada con el torneo. La misma entidad sirve para jugadores, cuerpo técnico, árbitros y periodistas; el rol surge de las relaciones.

**Identificador:** `id_persona`

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_persona` | `INTEGER` | Sí | PK | — |
| 2 | `nombre_completo` | `VARCHAR2(120 CHAR)` | Sí | — | — |
| 3 | `nacionalidad` | `VARCHAR2(80 CHAR)` | No | — | — |
| 4 | `fecha_de_nacimiento` | `DATE` | No | — | — |

**Relaciones**

- `INTEGRANTE` **forma parte de** `PLANTEL_EQUIPO` — `1:N`.
- `INTEGRANTE` **es asignado en** `TERNA_ARBITRAL` — `1:N`.
- `INTEGRANTE` **protagoniza** `SUCESO_ENCUENTRO` — `1:N`.
- `INTEGRANTE` **se relaciona con** `SUCESO_ENCUENTRO` — `1:N`.
- `INTEGRANTE` **acumula** `RENDIMIENTO_JUGADOR` — `1:N`.
- `INTEGRANTE` **recibe** `CREDENCIAL_MEDIOS` — `1:N`.
- `INTEGRANTE` **realiza** `BITACORA_CAMBIOS` — `1:N`.

**Reglas**

*Implementadas en el DDL:*

- Solo restricciones de llave (PK y FK).

*Descripción funcional:*

- No se guardan datos personales sensibles reales.
- El rol no es un atributo fijo de la persona: se determina por las tablas en las que participa.

### 3.9. PLANTEL_EQUIPO

**Plantel del equipo.** Entidad asociativa entre integrantes y equipos nacionales. Registra tanto a los jugadores convocados como al cuerpo técnico.

**Identificador:** `id_vinculacion`

**Identificadores alternos (UK):** `Unique_Keyv2` (`id_seleccion`, `id_persona`)

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_vinculacion` | `INTEGER` | Sí | PK | — |
| 2 | `id_persona` | `INTEGER` | Sí | FK, UK | `INTEGRANTE`(id_persona) |
| 3 | `id_seleccion` | `INTEGER` | Sí | FK, UK | `EQUIPO_NACIONAL`(id_seleccion) |
| 4 | `capitan` | `CHAR(1 CHAR)` | No | — | — |
| 5 | `dorsal` | `SMALLINT` | No | — | — |
| 6 | `posicion` | `VARCHAR2(30)` | No | — | — |
| 7 | `rol` | `VARCHAR2(30 CHAR)` | Sí | — | — |
| 8 | `club` | `VARCHAR2(120 CHAR)` | No | — | — |

**Relaciones**

- `INTEGRANTE` **forma parte de** `PLANTEL_EQUIPO` — `1:N`, vía `id_persona`; borrado `RESTRICT`.
- `EQUIPO_NACIONAL` **cuenta con** `PLANTEL_EQUIPO` — `1:N`, vía `id_seleccion`; borrado `RESTRICT`.

**Reglas**

*Implementadas en el DDL:*

- `UNIQUE` `Unique_Keyv2` sobre (id_seleccion, id_persona).
- `CHECK` `vinculacion_rol`: `rol IN ('JUGADOR', 'DIRECTOR_TECNICO', 'ASISTENTE', 'PREPARADOR_FISICO')`.
- `CHECK` `vinculacion_dorsal`: `dorsal BETWEEN 1 AND 99`.

*Descripción funcional:*

- Un integrante no puede vincularse dos veces al mismo equipo.
- El dorsal, si se asigna, está entre 1 y 99.
- Los valores de `rol` son `JUGADOR`, `DIRECTOR_TECNICO`, `ASISTENTE` y `PREPARADOR_FISICO`.
- `dorsal`, `posicion` y `capitan` aplican principalmente a jugadores (regla de negocio).

### 3.10. ENCUENTRO

**Encuentro.** Cada partido disputado. Se ubica en una fase y en un recinto, y se enlaza con los partidos de los que proviene para reconstruir el cuadro de eliminación.

**Identificador:** `id_partido`

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_partido` | `INTEGER` | Sí | PK | — |
| 2 | `id_etapa` | `INTEGER` | Sí | FK | `FASE_TORNEO`(id_etapa) |
| 3 | `id_estadio` | `INTEGER` | Sí | FK | `RECINTO_DEPORTIVO`(id_estadio) |
| 4 | `id_partido_origen_1` | `INTEGER` | No | FK | `ENCUENTRO`(id_partido) |
| 5 | `id_partido_origen_2` | `INTEGER` | No | FK | `ENCUENTRO`(id_partido) |
| 6 | `fecha_hora` | `DATE` | Sí | — | — |
| 7 | `asistencia_registrada` | `INTEGER` | Sí | — | — |
| 8 | `estado` | `VARCHAR2(30 CHAR)` | Sí | — | — |
| 9 | `resultado_origen_1` | `VARCHAR2(20 CHAR)` | No | — | — |
| 10 | `resultado_origen_2` | `VARCHAR2(20 CHAR)` | No | — | — |

**Relaciones**

- `RECINTO_DEPORTIVO` **alberga** `ENCUENTRO` — `1:N`, vía `id_estadio`; borrado `RESTRICT`.
- `FASE_TORNEO` **contiene** `ENCUENTRO` — `1:N`, vía `id_etapa`; borrado `RESTRICT`.
- `ENCUENTRO` **precede (origen 1)** `ENCUENTRO` — `1:N` (opcional), vía `id_partido_origen_1`; borrado `SET NULL`.
- `ENCUENTRO` **precede (origen 2)** `ENCUENTRO` — `1:N` (opcional), vía `id_partido_origen_2`; borrado `SET NULL`.
- `ENCUENTRO` **se compone de** `PARTICIPANTE_ENCUENTRO` — `1:N`.
- `ENCUENTRO` **tiene asignados** `TERNA_ARBITRAL` — `1:N`.
- `ENCUENTRO` **genera** `SUCESO_ENCUENTRO` — `1:N`.
- `ENCUENTRO` **consolida** `RENDIMIENTO_JUGADOR` — `1:N`.
- `ENCUENTRO` **reporta** `NOVEDAD_ENCUENTRO` — `1:N`.
- `ENCUENTRO` **ofrece** `BOLETO` — `1:N`.

**Reglas**

*Implementadas en el DDL:*

- `CHECK` `partido_asistencia`: `asistencia_registrada >= 0`.

*Descripción funcional:*

- La asistencia registrada no puede ser negativa.
- Las referencias `id_partido_origen_1/2` permiten rastrear de qué partidos provienen los equipos de una llave.
- Un partido tiene exactamente dos participantes (regla de negocio).

### 3.11. PARTICIPANTE_ENCUENTRO

**Participante de encuentro.** Entidad asociativa que resuelve la relación muchos a muchos entre encuentros y equipos nacionales. Guarda la condición y el marcador de cada equipo.

**Identificador:** `id_participacion_partido`

**Identificadores alternos (UK):** `Unique_Key_1v2` (`id_seleccion`, `id_partido`); `Unique_Key_2v2` (`id_partido`, `condicion`)

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_participacion_partido` | `INTEGER` | Sí | PK | — |
| 2 | `id_partido` | `INTEGER` | Sí | FK, UK | `ENCUENTRO`(id_partido) |
| 3 | `id_seleccion` | `INTEGER` | Sí | FK, UK | `EQUIPO_NACIONAL`(id_seleccion) |
| 4 | `condicion` | `VARCHAR2(10 CHAR)` | Sí | UK | — |
| 5 | `goles` | `INTEGER` | Sí | — | — |
| 6 | `goles_penales` | `INTEGER` | Sí | — | — |
| 7 | `resultado` | `VARCHAR2(10)` | No | — | — |

**Relaciones**

- `ENCUENTRO` **se compone de** `PARTICIPANTE_ENCUENTRO` — `1:N`, vía `id_partido`; borrado `CASCADE`.
- `EQUIPO_NACIONAL` **disputa** `PARTICIPANTE_ENCUENTRO` — `1:N`, vía `id_seleccion`; borrado `RESTRICT`.

**Reglas**

*Implementadas en el DDL:*

- `UNIQUE` `Unique_Key_1v2` sobre (id_seleccion, id_partido).
- `UNIQUE` `Unique_Key_2v2` sobre (id_partido, condicion).
- `CHECK` `partido_condicion`: `condicion IN ('LOCAL', 'VISITANTE')`.
- `CHECK` `part_goles`: `goles >= 0 AND goles_penales >= 0`.
- `CHECK` `part_resultado`: `resultado IN ('GANO', 'PERDIO', 'EMPATO')`.

*Descripción funcional:*

- Un equipo no puede aparecer dos veces en el mismo partido.
- En un partido no puede haber dos equipos con la misma condición (`LOCAL` / `VISITANTE`).
- Los goles y los goles de penales no pueden ser negativos.
- Los valores de `resultado` son `GANO`, `PERDIO` y `EMPATO`.

### 3.12. TERNA_ARBITRAL

**Terna arbitral.** Entidad asociativa que asigna integrantes (árbitros) a los encuentros según su rol arbitral.

**Identificador:** `id_asignacion`

**Identificadores alternos (UK):** `Unique_Key_1` (`rol_arbitral`, `id_partido`); `Unique_Key_2` (`id_partido`, `id_persona`)

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_asignacion` | `INTEGER` | Sí | PK | — |
| 2 | `id_partido` | `INTEGER` | Sí | FK, UK | `ENCUENTRO`(id_partido) |
| 3 | `id_persona` | `INTEGER` | Sí | FK, UK | `INTEGRANTE`(id_persona) |
| 4 | `rol_arbitral` | `VARCHAR2(40 CHAR)` | Sí | UK | — |

**Relaciones**

- `ENCUENTRO` **tiene asignados** `TERNA_ARBITRAL` — `1:N`, vía `id_partido`; borrado `CASCADE`.
- `INTEGRANTE` **es asignado en** `TERNA_ARBITRAL` — `1:N`, vía `id_persona`; borrado `RESTRICT`.

**Reglas**

*Implementadas en el DDL:*

- `UNIQUE` `Unique_Key_1` sobre (rol_arbitral, id_partido).
- `UNIQUE` `Unique_Key_2` sobre (id_partido, id_persona).
- `CHECK` `asignacion_rol`: `rol_arbitral IN ('CENTRAL', 'ASISTENTE_1', 'ASISTENTE_2', 'CUARTO_ARBITRO', 'VAR', 'AVAR')`.

*Descripción funcional:*

- Una persona no puede repetirse dentro del cuerpo arbitral de un partido.
- Un mismo rol arbitral no puede asignarse dos veces en el mismo partido.
- Los valores de `rol_arbitral` son `CENTRAL`, `ASISTENTE_1`, `ASISTENTE_2`, `CUARTO_ARBITRO`, `VAR` y `AVAR`.

### 3.13. SUCESO_ENCUENTRO

**Suceso del encuentro.** Acontecimiento deportivo de un partido (gol, tarjeta, sustitución…). Una estructura general evita crear una tabla por cada tipo de evento.

**Identificador:** `id_evento`

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_evento` | `INTEGER` | Sí | PK | — |
| 2 | `id_partido` | `INTEGER` | Sí | FK | `ENCUENTRO`(id_partido) |
| 3 | `id_persona` | `INTEGER` | No | FK | `INTEGRANTE`(id_persona) |
| 4 | `id_persona_relacionada` | `INTEGER` | No | FK | `INTEGRANTE`(id_persona) |
| 5 | `tipo_evento` | `VARCHAR2(40 CHAR)` | Sí | — | — |
| 6 | `minuto` | `SMALLINT` | No | — | — |
| 7 | `valor_numerico` | `SMALLINT` | No | — | — |
| 8 | `descripcion` | `VARCHAR2(400 CHAR)` | No | — | — |

**Relaciones**

- `ENCUENTRO` **genera** `SUCESO_ENCUENTRO` — `1:N`, vía `id_partido`; borrado `CASCADE`.
- `INTEGRANTE` **protagoniza** `SUCESO_ENCUENTRO` — `1:N` (opcional), vía `id_persona`; borrado `RESTRICT`.
- `INTEGRANTE` **se relaciona con** `SUCESO_ENCUENTRO` — `1:N` (opcional), vía `id_persona_relacionada`; borrado `SET NULL`.

**Reglas**

*Implementadas en el DDL:*

- `CHECK` `evento_tipo`: `tipo_evento IN ('GOL', 'ASISTENCIA', 'TARJETA_AMARILLA', 'TARJETA_ROJA', 'SUSTITUCION', 'MINUTOS_JUGADOS')`.

*Descripción funcional:*

- Los valores de `tipo_evento` son `GOL`, `ASISTENCIA`, `TARJETA_AMARILLA`, `TARJETA_ROJA`, `SUSTITUCION` y `MINUTOS_JUGADOS`.
- En una sustitución, `id_persona` es quien sale e `id_persona_relacionada` quien entra (regla de negocio).
- Los campos obligatorios por tipo de evento se validan por aplicación.

### 3.14. RENDIMIENTO_JUGADOR

**Rendimiento del jugador.** Estadística individual de un jugador en un partido: goles, asistencias, tarjetas, tiros y minutos jugados.

**Identificador:** `id_estadistica`

**Identificadores alternos (UK):** `Unique_Keyv5` (`id_partido`, `id_persona`)

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_estadistica` | `INTEGER` | Sí | PK | — |
| 2 | `id_partido` | `INTEGER` | Sí | FK, UK | `ENCUENTRO`(id_partido) |
| 3 | `id_persona` | `INTEGER` | Sí | FK, UK | `INTEGRANTE`(id_persona) |
| 4 | `goles` | `INTEGER DEFAULT 0` | Sí | — | — |
| 5 | `asistencias` | `INTEGER DEFAULT 0` | Sí | — | — |
| 6 | `tarjetas_amarillas` | `INTEGER DEFAULT 0` | Sí | — | — |
| 7 | `tarjetas_rojas` | `INTEGER DEFAULT 0` | Sí | — | — |
| 8 | `tiros` | `INTEGER DEFAULT 0` | Sí | — | — |
| 9 | `minutos_jugados` | `INTEGER DEFAULT 0` | Sí | — | — |

**Relaciones**

- `ENCUENTRO` **consolida** `RENDIMIENTO_JUGADOR` — `1:N`, vía `id_partido`; borrado `CASCADE`.
- `INTEGRANTE` **acumula** `RENDIMIENTO_JUGADOR` — `1:N`, vía `id_persona`; borrado `RESTRICT`.

**Reglas**

*Implementadas en el DDL:*

- `UNIQUE` `Unique_Keyv5` sobre (id_partido, id_persona).
- `CHECK` `estadistica_goles`: `goles >= 0`.
- `CHECK` `estadistica_asistencias`: `asistencias >= 0`.
- `CHECK` `estadistica_amarillas`: `tarjetas_amarillas >= 0`.
- `CHECK` `estadistica_rojas`: `tarjetas_rojas >= 0`.
- `CHECK` `estadistica_tiros`: `tiros >= 0`.
- `CHECK` `estadistica_minutos`: `minutos_jugados BETWEEN 0 AND 120`.

*Descripción funcional:*

- Un jugador tiene una única fila de estadísticas por partido.
- Las métricas no pueden ser negativas y los minutos jugados van de 0 a 120.
- Las métricas se inicializan en 0.

### 3.15. NOVEDAD_ENCUENTRO

**Novedad del encuentro.** Incidencia operativa ocurrida durante un partido (climática, disciplinaria, técnica u otra).

**Identificador:** `id_incidencia`

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_incidencia` | `INTEGER` | Sí | PK | — |
| 2 | `id_partido` | `INTEGER` | Sí | FK | `ENCUENTRO`(id_partido) |
| 3 | `tipo` | `VARCHAR2(30 CHAR)` | Sí | — | — |
| 4 | `descripcion` | `VARCHAR2(500 CHAR)` | No | — | — |
| 5 | `minuto` | `SMALLINT` | No | — | — |

**Relaciones**

- `ENCUENTRO` **reporta** `NOVEDAD_ENCUENTRO` — `1:N`, vía `id_partido`; borrado `CASCADE`.

**Reglas**

*Implementadas en el DDL:*

- `CHECK` `incidencia_tipo`: `tipo IN ('CLIMATICA', 'DISCIPLINARIA', 'TECNICA', 'OTRA')`.
- `CHECK` `incidencia_minuto`: `minuto >= 0`.

*Descripción funcional:*

- Los valores de `tipo` son `CLIMATICA`, `DISCIPLINARIA`, `TECNICA` y `OTRA`.
- El minuto, si se informa, no puede ser negativo.

### 3.16. BOLETO

**Boleto.** Boletería asociada a un partido, por categoría y zona del estadio.

**Identificador:** `id_entrada`

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_entrada` | `INTEGER` | Sí | PK | — |
| 2 | `id_partido` | `INTEGER` | Sí | FK | `ENCUENTRO`(id_partido) |
| 3 | `categoria` | `VARCHAR2(30 CHAR)` | Sí | — | — |
| 4 | `zona` | `VARCHAR2(50 CHAR)` | Sí | — | — |
| 5 | `precio` | `NUMBER(10,2)` | Sí | — | — |
| 6 | `estado` | `VARCHAR2(20)` | Sí | — | — |

**Relaciones**

- `ENCUENTRO` **ofrece** `BOLETO` — `1:N`, vía `id_partido`; borrado `CASCADE`.

**Reglas**

*Implementadas en el DDL:*

- `CHECK` `entrada_precio`: `precio >= 0`.

*Descripción funcional:*

- El precio no puede ser negativo.
- No se almacena información personal del espectador.

### 3.17. CREDENCIAL_MEDIOS

**Credencial de medios.** Acreditación de un integrante (periodista) de un medio de comunicación para cubrir una edición.

**Identificador:** `id_acreditacion`

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_acreditacion` | `INTEGER` | Sí | PK | — |
| 2 | `id_persona` | `INTEGER` | Sí | FK | `INTEGRANTE`(id_persona) |
| 3 | `id_edicion` | `INTEGER` | Sí | FK | `TORNEO_MUNDIAL`(id_edicion) |
| 4 | `medio_comunicacio` | `VARCHAR2(120 CHAR)` | Sí | — | — |
| 5 | `fecha_emision` | `DATE` | Sí | — | — |
| 6 | `tipo_acreditacion` | `VARCHAR2(40 CHAR)` | Sí | — | — |
| 7 | `estado` | `VARCHAR2(20 CHAR)` | Sí | — | — |

**Relaciones**

- `TORNEO_MUNDIAL` **acredita a** `CREDENCIAL_MEDIOS` — `1:N`, vía `id_edicion`; borrado `RESTRICT`.
- `INTEGRANTE` **recibe** `CREDENCIAL_MEDIOS` — `1:N`, vía `id_persona`; borrado `RESTRICT`.

**Reglas**

*Implementadas en el DDL:*

- Solo restricciones de llave (PK y FK).

*Descripción funcional:*

- Cada credencial identifica el medio de comunicación.
- Una persona no debe tener credenciales duplicadas en la misma edición (regla de negocio; no hay `UNIQUE` en el DDL).

### 3.18. BITACORA_CAMBIOS

**Bitácora de cambios.** Trazabilidad de cambios sobre información crítica: quién, cuándo, en qué tabla, qué registro y qué valores antes y después.

**Identificador:** `id_auditoria`

**Atributos**

| N.º | Atributo | Tipo | Obligatorio | Clave | Referencia |
|---:|---|---|:---:|:---:|---|
| 1 | `id_auditoria` | `INTEGER` | Sí | PK | — |
| 2 | `id_persona` | `INTEGER` | No | FK | `INTEGRANTE`(id_persona) |
| 3 | `usuario_bd` | `VARCHAR2(100 CHAR)` | Sí | — | — |
| 4 | `tabla_afectada` | `VARCHAR2(50 CHAR)` | Sí | — | — |
| 5 | `id_registro_afectado` | `INTEGER` | Sí | — | — |
| 6 | `operacion` | `VARCHAR2(10 CHAR)` | Sí | — | — |
| 7 | `fecha_hora` | `TIMESTAMP` | Sí | — | — |
| 8 | `valor_anterior` | `CLOB` | No | — | — |
| 9 | `valor_nuevo` | `CLOB` | No | — | — |

**Relaciones**

- `INTEGRANTE` **realiza** `BITACORA_CAMBIOS` — `1:N` (opcional), vía `id_persona`; borrado `SET NULL`.

**Reglas**

*Implementadas en el DDL:*

- `CHECK` `auditoria_operacion`: `operacion IN ('INSERT', 'UPDATE', 'DELETE')`.

*Descripción funcional:*

- Los valores de `operacion` son `INSERT`, `UPDATE` y `DELETE`.
- La persona responsable es opcional: si se elimina, el registro de bitácora se conserva.

---

## 4. Resumen de relaciones y cardinalidades

| N.º | Entidad padre | Relación | Entidad hija | Cardinalidad | Participación del padre | Borrado |
|---:|---|---|---|:---:|:---:|:---:|
| 1 | `TORNEO_MUNDIAL` | tiene | `PAIS_ANFITRION` | 1:N | Obligatoria (1) | RESTRICT |
| 2 | `PAIS_ANFITRION` | posee | `LOCALIDAD` | 1:N | Obligatoria (1) | RESTRICT |
| 3 | `LOCALIDAD` | dispone de | `RECINTO_DEPORTIVO` | 1:N | Obligatoria (1) | RESTRICT |
| 4 | `TORNEO_MUNDIAL` | cuenta con | `FASE_TORNEO` | 1:N | Obligatoria (1) | RESTRICT |
| 5 | `FASE_TORNEO` | se conforma de | `FASE_TORNEO` | 1:N | Opcional (0..1) | SET NULL |
| 6 | `ENTE_FUTBOLISTICO` | se forma de | `ENTE_FUTBOLISTICO` | 1:N | Opcional (0..1) | SET NULL |
| 7 | `ENTE_FUTBOLISTICO` | representa a | `EQUIPO_NACIONAL` | 1:N | Obligatoria (1) | RESTRICT |
| 8 | `FASE_TORNEO` | agrupa | `EQUIPO_NACIONAL` | 1:N | Obligatoria (1) | RESTRICT |
| 9 | `INTEGRANTE` | forma parte de | `PLANTEL_EQUIPO` | 1:N | Obligatoria (1) | RESTRICT |
| 10 | `EQUIPO_NACIONAL` | cuenta con | `PLANTEL_EQUIPO` | 1:N | Obligatoria (1) | RESTRICT |
| 11 | `RECINTO_DEPORTIVO` | alberga | `ENCUENTRO` | 1:N | Obligatoria (1) | RESTRICT |
| 12 | `FASE_TORNEO` | contiene | `ENCUENTRO` | 1:N | Obligatoria (1) | RESTRICT |
| 13 | `ENCUENTRO` | precede (origen 1) | `ENCUENTRO` | 1:N | Opcional (0..1) | SET NULL |
| 14 | `ENCUENTRO` | precede (origen 2) | `ENCUENTRO` | 1:N | Opcional (0..1) | SET NULL |
| 15 | `ENCUENTRO` | se compone de | `PARTICIPANTE_ENCUENTRO` | 1:N | Obligatoria (1) | CASCADE |
| 16 | `EQUIPO_NACIONAL` | disputa | `PARTICIPANTE_ENCUENTRO` | 1:N | Obligatoria (1) | RESTRICT |
| 17 | `ENCUENTRO` | tiene asignados | `TERNA_ARBITRAL` | 1:N | Obligatoria (1) | CASCADE |
| 18 | `INTEGRANTE` | es asignado en | `TERNA_ARBITRAL` | 1:N | Obligatoria (1) | RESTRICT |
| 19 | `ENCUENTRO` | genera | `SUCESO_ENCUENTRO` | 1:N | Obligatoria (1) | CASCADE |
| 20 | `INTEGRANTE` | protagoniza | `SUCESO_ENCUENTRO` | 1:N | Opcional (0..1) | RESTRICT |
| 21 | `INTEGRANTE` | se relaciona con | `SUCESO_ENCUENTRO` | 1:N | Opcional (0..1) | SET NULL |
| 22 | `ENCUENTRO` | consolida | `RENDIMIENTO_JUGADOR` | 1:N | Obligatoria (1) | CASCADE |
| 23 | `INTEGRANTE` | acumula | `RENDIMIENTO_JUGADOR` | 1:N | Obligatoria (1) | RESTRICT |
| 24 | `ENCUENTRO` | reporta | `NOVEDAD_ENCUENTRO` | 1:N | Obligatoria (1) | CASCADE |
| 25 | `ENCUENTRO` | ofrece | `BOLETO` | 1:N | Obligatoria (1) | CASCADE |
| 26 | `TORNEO_MUNDIAL` | acredita a | `CREDENCIAL_MEDIOS` | 1:N | Obligatoria (1) | RESTRICT |
| 27 | `INTEGRANTE` | recibe | `CREDENCIAL_MEDIOS` | 1:N | Obligatoria (1) | RESTRICT |
| 28 | `INTEGRANTE` | realiza | `BITACORA_CAMBIOS` | 1:N | Opcional (0..1) | SET NULL |

Por política de borrado: 16 relaciones `RESTRICT`, 6 `CASCADE` y 6 `SET NULL`.

---

## 5. Relaciones muchos a muchos resueltas

| Relación | Por qué es N:M | Entidad asociativa | Atributos propios |
|---|---|---|---|
| Encuentro – Equipo nacional | Un partido enfrenta a dos equipos y un equipo juega varios partidos. | `PARTICIPANTE_ENCUENTRO` | condicion, goles, goles_penales, resultado |
| Integrante – Equipo nacional | Un equipo reúne a muchos integrantes y una persona puede estar en varios equipos a lo largo de las ediciones. | `PLANTEL_EQUIPO` | rol, dorsal, capitan, posicion, club |
| Integrante – Encuentro (arbitraje) | Un partido tiene varios árbitros y un árbitro dirige varios partidos. | `TERNA_ARBITRAL` | rol_arbitral |
| Integrante – Encuentro (rendimiento) | Un partido tiene estadísticas de muchos jugadores y un jugador acumula estadísticas en muchos partidos. | `RENDIMIENTO_JUGADOR` | goles, asistencias, tarjetas, tiros, minutos_jugados |

**Encuentro – Equipo nacional**

```text
ENCUENTRO 1:N PARTICIPANTE_ENCUENTRO N:1 EQUIPO_NACIONAL
```

**Integrante – Equipo nacional**

```text
INTEGRANTE 1:N PLANTEL_EQUIPO N:1 EQUIPO_NACIONAL
```

**Integrante – Encuentro (arbitraje)**

```text
INTEGRANTE 1:N TERNA_ARBITRAL N:1 ENCUENTRO
```

**Integrante – Encuentro (rendimiento)**

```text
INTEGRANTE 1:N RENDIMIENTO_JUGADOR N:1 ENCUENTRO
```

---

## 6. Organización jerárquica del modelo

### Organización geográfica

```text
TORNEO_MUNDIAL
      |  1:N
PAIS_ANFITRION
      |  1:N
  LOCALIDAD
      |  1:N
RECINTO_DEPORTIVO
      |  1:N
  ENCUENTRO
```

### Organización institucional del fútbol

```text
ENTE_FUTBOLISTICO (CONFEDERACION)
      |  1:N  (id_organizacion_padre)
ENTE_FUTBOLISTICO (FEDERACION_NACIONAL)
      |  1:N
EQUIPO_NACIONAL
```

### Organización deportiva

```text
TORNEO_MUNDIAL
      |  1:N
FASE_TORNEO ──(id_etapa_padre)──> FASE_TORNEO
      |
      +---- GRUPO ----------> EQUIPO_NACIONAL (id_etapa_grupo)
      |
      +---- INSTANCIA_ELIMINATORIA
      |  1:N
  ENCUENTRO ──(id_partido_origen_1/2)──> ENCUENTRO
```

### Desarrollo de un encuentro

```text
ENCUENTRO
├── PARTICIPANTE_ENCUENTRO ── EQUIPO_NACIONAL
├── TERNA_ARBITRAL ───────── INTEGRANTE
├── SUCESO_ENCUENTRO ─────── INTEGRANTE
├── RENDIMIENTO_JUGADOR ──── INTEGRANTE
├── NOVEDAD_ENCUENTRO
└── BOLETO
```

### Personas y equipos

```text
EQUIPO_NACIONAL 1──N PLANTEL_EQUIPO N──1 INTEGRANTE
INTEGRANTE 1──N CREDENCIAL_MEDIOS N──1 TORNEO_MUNDIAL
INTEGRANTE 1──N BITACORA_CAMBIOS (opcional)
```

---

## 7. Decisiones de diseño

### 7.1. Una sola entidad para fases, grupos e instancias (`FASE_TORNEO`)

La autorrelación `id_etapa_padre` y el atributo `tipo_etapa` representan toda la jerarquía de la competencia sin crear una tabla por nivel, y admiten otros formatos de torneo.

### 7.2. Una sola entidad para confederaciones y federaciones (`ENTE_FUTBOLISTICO`)

El atributo `tipo` las diferencia y `id_organizacion_padre` las enlaza. La confederación de un equipo se obtiene recorriendo la jerarquía, no se guarda.

### 7.3. Entidad general de personas (`INTEGRANTE`)

Jugadores, cuerpo técnico, árbitros y periodistas comparten los mismos datos básicos. El rol surge de la tabla donde participa la persona, lo que evita duplicar atributos.

### 7.4. Sucesos generales y rendimiento por separado

`SUCESO_ENCUENTRO` registra cada acontecimiento (minuto a minuto); `RENDIMIENTO_JUGADOR` guarda las cifras consolidadas por jugador y partido para consultas de estadísticas.

### 7.5. Novedades separadas de los sucesos

`NOVEDAD_ENCUENTRO` registra incidencias operativas (clima, disciplina, técnica) que no pertenecen a un jugador, con su propia descripción.

### 7.6. Bitácora vinculada a una persona

`BITACORA_CAMBIOS` referencia opcionalmente a `INTEGRANTE`, de modo que la auditoría queda conectada con el resto del modelo sin impedir conservar el historial si se elimina a la persona.

### 7.7. Identificadores subrogados

Todas las entidades usan un entero como identificador. Las combinaciones naturales (por ejemplo, equipo + partido) se protegen con `UNIQUE`.

---

## 8. Consideraciones de normalización

Los datos de una entidad se guardan una sola vez y se alcanzan por relaciones. Por ejemplo:

```text
RECINTO_DEPORTIVO → LOCALIDAD → PAIS_ANFITRION → TORNEO_MUNDIAL
EQUIPO_NACIONAL   → FASE_TORNEO (grupo) → TORNEO_MUNDIAL
EQUIPO_NACIONAL   → ENTE_FUTBOLISTICO (federación) → ENTE_FUTBOLISTICO (confederación)
ENCUENTRO         → FASE_TORNEO → TORNEO_MUNDIAL
```

Por eso `RECINTO_DEPORTIVO` no guarda la ciudad, el país ni la edición, `EQUIPO_NACIONAL` no guarda la edición ni la confederación, y `ENCUENTRO` no guarda la edición. La justificación formal de 1FN, 2FN y 3FN está en el documento de normalización.

---

## 9. Cobertura de los frentes funcionales

**Organización del torneo:** `TORNEO_MUNDIAL`, `PAIS_ANFITRION`, `LOCALIDAD`, `RECINTO_DEPORTIVO`

**Competencia deportiva:** `FASE_TORNEO`, `EQUIPO_NACIONAL`, `ENCUENTRO`, `PARTICIPANTE_ENCUENTRO`

**Selecciones, jugadores y cuerpo técnico:** `ENTE_FUTBOLISTICO`, `EQUIPO_NACIONAL`, `INTEGRANTE`, `PLANTEL_EQUIPO`

**Arbitraje:** `INTEGRANTE`, `TERNA_ARBITRAL`, `ENCUENTRO`

**Estadísticas de juego:** `SUCESO_ENCUENTRO`, `RENDIMIENTO_JUGADOR`, `INTEGRANTE`

**Logística, público, medios e incidencias:** `BOLETO`, `CREDENCIAL_MEDIOS`, `NOVEDAD_ENCUENTRO`

**Auditoría:** `BITACORA_CAMBIOS`

---

## 10. Conclusión

El modelo lógico está formado por 18 entidades y 28 relaciones y cubre la organización del torneo, la competencia, las selecciones y su plantel, el arbitraje, las estadísticas, la boletería, los medios, las incidencias y la auditoría. Las relaciones muchos a muchos se resuelven con entidades asociativas y la información derivable se obtiene por relaciones en vez de repetirse. Este modelo es la base del diagrama lógico en Data Modeler y coincide con el modelo físico y el diccionario de datos.
