# Diccionario de Datos

**Proyecto:** Sistema de Información para la Gestión Integral de la Copa Mundial de la FIFA   
**Motor:** Oracle  
**Integrantes:** Andres Gomez
---

## 1. Resumen de tablas

| # | Tabla | Qué representa | Depende de |
| :-: | :--- | :--- | :--- |
| 1 | `TORNEO_MUNDIAL` | Cada edición de la Copa Mundial registrada en el sistema. | — |
| 2 | `PAIS_ANFITRION` | País anfitrión de una edición del Mundial. | `TORNEO_MUNDIAL` |
| 3 | `LOCALIDAD` | Ciudad anfitriona que pertenece a un país sede. | `PAIS_ANFITRION` |
| 4 | `RECINTO_DEPORTIVO` | Estadio utilizado para disputar partidos. | `LOCALIDAD` |
| 5 | `FASE_TORNEO` | Fases, grupos e instancias eliminatorias en que se divide la competencia. Una etapa puede contener otras (por ejemplo, la fase de grupos contiene el Grupo A, B, etc.). | `TORNEO_MUNDIAL` |
| 6 | `ENTE_FUTBOLISTICO` | Organizaciones del fútbol (confederaciones y federaciones nacionales) a las que pertenecen las selecciones. | — |
| 7 | `EQUIPO_NACIONAL` | Selección nacional, vinculada a su federación y al grupo en el que juega. | `ENTE_FUTBOLISTICO`, `FASE_TORNEO` |
| 8 | `INTEGRANTE` | Personas naturales relacionadas con el torneo: jugadores, técnicos, árbitros y periodistas. | — |
| 9 | `PLANTEL_EQUIPO` | Vinculación de una persona con una selección: convocatoria de jugadores y cuerpo técnico. | `INTEGRANTE`, `EQUIPO_NACIONAL` |
| 10 | `ENCUENTRO` | Partidos del torneo, incluidos los cruces de llave que dependen de partidos anteriores. | `FASE_TORNEO`, `RECINTO_DEPORTIVO` |
| 11 | `PARTICIPANTE_ENCUENTRO` | Participación de una selección en un partido; resuelve la relación muchos a muchos entre partidos y selecciones. | `ENCUENTRO`, `EQUIPO_NACIONAL` |
| 12 | `TERNA_ARBITRAL` | Asignación de árbitros a los partidos según su rol. | `ENCUENTRO`, `INTEGRANTE` |
| 13 | `SUCESO_ENCUENTRO` | Acontecimientos deportivos de un partido: goles, asistencias, tarjetas y sustituciones. | `ENCUENTRO`, `INTEGRANTE` |
| 14 | `RENDIMIENTO_JUGADOR` | Desempeño individual de cada jugador en cada partido. Todas las métricas comienzan en 0 si no se indica otro valor. | `ENCUENTRO`, `INTEGRANTE` |
| 15 | `NOVEDAD_ENCUENTRO` | Incidencias operativas ocurridas durante un partido. | `ENCUENTRO` |
| 16 | `BOLETO` | Boletería asociada a los partidos del torneo. | `ENCUENTRO` |
| 17 | `CREDENCIAL_MEDIOS` | Acreditación de miembros de medios de comunicación para cubrir el torneo. | `INTEGRANTE`, `TORNEO_MUNDIAL` |
| 18 | `BITACORA_CAMBIOS` | Trazabilidad de los cambios sobre información crítica: quién, cuándo y qué se modificó. | `INTEGRANTE` |

---

## 2. Detalle por tabla

### 2.1 `TORNEO_MUNDIAL`

> Cada edición de la Copa Mundial registrada en el sistema.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_edicion` | `INTEGER` | Sí | PK | — | Identificador de cada torneo. |
| `anio` | `NUMBER` | Sí | UK | UNIQUE | Año en el que se disputó la edición. |
| `nombre` | `VARCHAR2(100 CHAR)` | Sí | — | — | Nombre de la edición. |
| `lema` | `VARCHAR2(200 CHAR)` | No | — | — | Lema oficial de la edición. |
| `fecha_inicio` | `DATE` | Sí | — | — | Fecha de inicio del torneo. |
| `fecha_fin` | `DATE` | Sí | — | — | Fecha de fin del torneo. |

**Llaves foráneas**

Esta tabla no tiene llaves foráneas.

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `anio` | UNIQUE | `(anio)` |
| `edicion_fechas` | CHECK | `fecha_fin > fecha_inicio` |

---

### 2.2 `PAIS_ANFITRION`

> País anfitrión de una edición del Mundial.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_sede` | `INTEGER` | Sí | PK | — | Identificador de la sede. |
| `id_edicion` | `INTEGER` | Sí | FK | — | Edición a la que pertenece la sede. |
| `pais` | `VARCHAR2(80 CHAR)` | Sí | — | — | Nombre del país sede. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_edicion` | `TORNEO_MUNDIAL(id_edicion)` | RESTRICT | RESTRICT | `tiene` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `Unique_Keyv1` | UNIQUE | `(pais, id_edicion)` |

---

### 2.3 `LOCALIDAD`

> Ciudad anfitriona que pertenece a un país sede.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_ciudad` | `INTEGER` | Sí | PK | — | Identificador de la ciudad. |
| `id_sede` | `INTEGER` | Sí | FK | — | País sede al que pertenece. |
| `nombre` | `VARCHAR2(80 CHAR)` | Sí | — | — | Nombre de la ciudad. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_sede` | `PAIS_ANFITRION(id_sede)` | RESTRICT | RESTRICT | `posee` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `Unique_Key` | UNIQUE | `(id_sede, nombre)` |

---

### 2.4 `RECINTO_DEPORTIVO`

> Estadio utilizado para disputar partidos.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_estadio` | `INTEGER` | Sí | PK | — | Identificador del estadio. |
| `id_ciudad` | `INTEGER` | Sí | FK | — | Ciudad donde se ubica el estadio. |
| `nombre` | `VARCHAR2(100 CHAR)` | Sí | — | — | Nombre del estadio. |
| `capacidad` | `INTEGER` | Sí | — | capacidad > 0 | Cantidad máxima de espectadores. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_ciudad` | `LOCALIDAD(id_ciudad)` | RESTRICT | RESTRICT | `dispone` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `Unique_Keyv4` | UNIQUE | `(nombre, id_ciudad)` |
| `estadio_capacidad` | CHECK | `capacidad > 0` |

---

### 2.5 `FASE_TORNEO`

> Fases, grupos e instancias eliminatorias en que se divide la competencia. Una etapa puede contener otras (por ejemplo, la fase de grupos contiene el Grupo A, B, etc.).

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_etapa` | `INTEGER` | Sí | PK | — | Identificador de la etapa. |
| `id_edicion` | `INTEGER` | Sí | FK | — | Edición a la que pertenece. |
| `id_etapa_padre` | `INTEGER` | No | FK | — | Etapa mayor que contiene a esta. |
| `nombre` | `VARCHAR2(80 CHAR)` | Sí | — | — | Nombre de la etapa. |
| `tipo_etapa` | `VARCHAR2(40)` | Sí | — | FASE, GRUPO o INSTANCIA_ELIMINATORIA | Categoría de la etapa. |
| `orden` | `INTEGER` | Sí | — | — | Posición secuencial de la etapa en el torneo. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_edicion` | `TORNEO_MUNDIAL(id_edicion)` | RESTRICT | RESTRICT | `cuenta_con` |
| `id_etapa_padre` | `FASE_TORNEO(id_etapa)` | SET NULL | RESTRICT | `se_conforma` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `etapa_tipo` | CHECK | `tipo_etapa IN ('FASE', 'GRUPO', 'INSTANCIA_ELIMINATORIA')` |

---

### 2.6 `ENTE_FUTBOLISTICO`

> Organizaciones del fútbol (confederaciones y federaciones nacionales) a las que pertenecen las selecciones.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_organizacion` | `INTEGER` | Sí | PK | — | Identificador de la organización. |
| `nombre` | `VARCHAR2(100 CHAR)` | Sí | — | — | Nombre de la organización. |
| `tipo` | `VARCHAR2(30 CHAR)` | Sí | — | CONFEDERACION o FEDERACION_NACIONAL | Tipo de organización. |
| `pais` | `VARCHAR2(80 CHAR)` | Sí | — | — | País al que pertenece. |
| `id_organizacion_padre` | `INTEGER` | No | FK | — | Organización superior (la confederación de una federación). |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_organizacion_padre` | `ENTE_FUTBOLISTICO(id_organizacion)` | SET NULL | RESTRICT | `se_forma_de` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `organizacion_tipo` | CHECK | `tipo IN ('CONFEDERACION', 'FEDERACION_NACIONAL')` |

---

### 2.7 `EQUIPO_NACIONAL`

> Selección nacional, vinculada a su federación y al grupo en el que juega.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_seleccion` | `INTEGER` | Sí | PK | — | Identificador de la selección. |
| `id_organizacion` | `INTEGER` | Sí | FK | — | Federación a la que representa. |
| `id_etapa_grupo` | `INTEGER` | Sí | FK | — | Etapa o grupo al que pertenece. |
| `codigo_fifa` | `VARCHAR2(3 CHAR)` | Sí | — | — | Código de tres letras asignado por la FIFA. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_organizacion` | `ENTE_FUTBOLISTICO(id_organizacion)` | RESTRICT | RESTRICT | `representa` |
| `id_etapa_grupo` | `FASE_TORNEO(id_etapa)` | RESTRICT | RESTRICT | `agrupa` |

**Restricciones adicionales**

Sin restricciones adicionales.

---

### 2.8 `INTEGRANTE`

> Personas naturales relacionadas con el torneo: jugadores, técnicos, árbitros y periodistas.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_persona` | `INTEGER` | Sí | PK | — | Identificador de la persona. |
| `nombre_completo` | `VARCHAR2(120 CHAR)` | Sí | — | — | Nombre completo. |
| `nacionalidad` | `VARCHAR2(80 CHAR)` | No | — | — | Nacionalidad de la persona. |
| `fecha_de_nacimiento` | `DATE` | No | — | — | Fecha de nacimiento. |

**Llaves foráneas**

Esta tabla no tiene llaves foráneas.

**Restricciones adicionales**

Sin restricciones adicionales.

---

### 2.9 `PLANTEL_EQUIPO`

> Vinculación de una persona con una selección: convocatoria de jugadores y cuerpo técnico.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_vinculacion` | `INTEGER` | Sí | PK | — | Identificador de la vinculación. |
| `id_persona` | `INTEGER` | Sí | FK | — | Persona vinculada. |
| `id_seleccion` | `INTEGER` | Sí | FK | — | Selección a la que se vincula. |
| `capitan` | `CHAR(1 CHAR)` | No | — | — | Indica si la persona es el capitán. |
| `dorsal` | `SMALLINT` | No | — | dorsal entre 1 y 99 | Número de camiseta. |
| `posicion` | `VARCHAR2(30)` | No | — | — | Posición de juego. |
| `rol` | `VARCHAR2(30 CHAR)` | Sí | — | JUGADOR, DIRECTOR_TECNICO, ASISTENTE o PREPARADOR_FISICO | Rol que desempeña en la selección. |
| `club` | `VARCHAR2(120 CHAR)` | No | — | — | Club de procedencia. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_persona` | `INTEGRANTE(id_persona)` | RESTRICT | RESTRICT | `crea` |
| `id_seleccion` | `EQUIPO_NACIONAL(id_seleccion)` | RESTRICT | RESTRICT | `vincula` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `Unique_Keyv2` | UNIQUE | `(id_seleccion, id_persona)` |
| `vinculacion_rol` | CHECK | `rol IN ('JUGADOR', 'DIRECTOR_TECNICO', 'ASISTENTE', 'PREPARADOR_FISICO')` |
| `vinculacion_dorsal` | CHECK | `dorsal BETWEEN 1 AND 99` |

---

### 2.10 `ENCUENTRO`

> Partidos del torneo, incluidos los cruces de llave que dependen de partidos anteriores.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_partido` | `INTEGER` | Sí | PK | — | Identificador del partido. |
| `id_etapa` | `INTEGER` | Sí | FK | — | Etapa en la que se juega. |
| `id_estadio` | `INTEGER` | Sí | FK | — | Estadio donde se disputa. |
| `id_partido_origen_1` | `INTEGER` | No | FK | — | Primer partido previo del que proviene un clasificado. |
| `id_partido_origen_2` | `INTEGER` | No | FK | — | Segundo partido previo del que proviene un clasificado. |
| `fecha_hora` | `DATE` | Sí | — | — | Fecha y hora del partido. |
| `asistencia_registrada` | `INTEGER` | Sí | — | asistencia_registrada >= 0 | Público presente en el partido. |
| `estado` | `VARCHAR2(30 CHAR)` | Sí | — | — | Estado del partido. |
| `resultado_origen_1` | `VARCHAR2(20 CHAR)` | No | — | — | Resultado del primer partido de origen que da paso al cruce. |
| `resultado_origen_2` | `VARCHAR2(20 CHAR)` | No | — | — | Resultado del segundo partido de origen que da paso al cruce. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_etapa` | `FASE_TORNEO(id_etapa)` | RESTRICT | RESTRICT | `contiene` |
| `id_estadio` | `RECINTO_DEPORTIVO(id_estadio)` | RESTRICT | RESTRICT | `alberga` |
| `id_partido_origen_1` | `ENCUENTRO(id_partido)` | SET NULL | RESTRICT | `P2precede` |
| `id_partido_origen_2` | `ENCUENTRO(id_partido)` | SET NULL | RESTRICT | `precede` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `partido_asistencia` | CHECK | `asistencia_registrada >= 0` |

---

### 2.11 `PARTICIPANTE_ENCUENTRO`

> Participación de una selección en un partido; resuelve la relación muchos a muchos entre partidos y selecciones.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_participacion_partido` | `INTEGER` | Sí | PK | — | Identificador de la participación. |
| `id_partido` | `INTEGER` | Sí | FK | — | Partido en el que participa. |
| `id_seleccion` | `INTEGER` | Sí | FK | — | Selección que participa. |
| `condicion` | `VARCHAR2(10 CHAR)` | Sí | — | LOCAL o VISITANTE | Condición de la selección en el partido. |
| `goles` | `INTEGER` | Sí | — | goles >= 0 | Goles marcados en el partido. |
| `goles_penales` | `INTEGER` | Sí | — | goles_penales >= 0 | Goles marcados en la tanda de penales. |
| `resultado` | `VARCHAR2(10)` | No | — | GANO, PERDIO o EMPATO | Resultado de la selección. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_partido` | `ENCUENTRO(id_partido)` | CASCADE | RESTRICT | `rellena` |
| `id_seleccion` | `EQUIPO_NACIONAL(id_seleccion)` | RESTRICT | RESTRICT | `registra` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `Unique_Key_1v2` | UNIQUE | `(id_seleccion, id_partido)` |
| `Unique_Key_2v2` | UNIQUE | `(id_partido, condicion)` |
| `partido_condicion` | CHECK | `condicion IN ('LOCAL', 'VISITANTE')` |
| `part_goles` | CHECK | `goles >= 0 AND goles_penales >= 0` |
| `part_resultado` | CHECK | `resultado IN ('GANO', 'PERDIO', 'EMPATO')` |

---

### 2.12 `TERNA_ARBITRAL`

> Asignación de árbitros a los partidos según su rol.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_asignacion` | `INTEGER` | Sí | PK | — | Identificador de la asignación. |
| `id_partido` | `INTEGER` | Sí | FK | — | Partido al que se asigna. |
| `id_persona` | `INTEGER` | Sí | FK | — | Persona que actúa como árbitro. |
| `rol_arbitral` | `VARCHAR2(40 CHAR)` | Sí | — | CENTRAL, ASISTENTE_1, ASISTENTE_2, CUARTO_ARBITRO, VAR o AVAR | Rol arbitral en el partido. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_partido` | `ENCUENTRO(id_partido)` | CASCADE | RESTRICT | `tienev2` |
| `id_persona` | `INTEGRANTE(id_persona)` | RESTRICT | RESTRICT | `es` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `Unique_Key_1` | UNIQUE | `(rol_arbitral, id_partido)` |
| `Unique_Key_2` | UNIQUE | `(id_partido, id_persona)` |
| `asignacion_rol` | CHECK | `rol_arbitral IN ('CENTRAL', 'ASISTENTE_1', 'ASISTENTE_2', 'CUARTO_ARBITRO', 'VAR', 'AVAR')` |

---

### 2.13 `SUCESO_ENCUENTRO`

> Acontecimientos deportivos de un partido: goles, asistencias, tarjetas y sustituciones.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_evento` | `INTEGER` | Sí | PK | — | Identificador del evento. |
| `id_partido` | `INTEGER` | Sí | FK | — | Partido en el que ocurre. |
| `id_persona` | `INTEGER` | No | FK | — | Persona protagonista del evento. |
| `id_persona_relacionada` | `INTEGER` | No | FK | — | Segunda persona involucrada (por ejemplo, en una sustitución). |
| `tipo_evento` | `VARCHAR2(40 CHAR)` | Sí | — | GOL, ASISTENCIA, TARJETA_AMARILLA, TARJETA_ROJA, SUSTITUCION o MINUTOS_JUGADOS | Tipo de evento. |
| `minuto` | `SMALLINT` | No | — | — | Minuto del partido en que ocurre. |
| `valor_numerico` | `SMALLINT` | No | — | — | Valor numérico auxiliar (por ejemplo, minutos jugados). |
| `descripcion` | `VARCHAR2(400 CHAR)` | No | — | — | Detalle del suceso. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_partido` | `ENCUENTRO(id_partido)` | CASCADE | RESTRICT | `genera` |
| `id_persona` | `INTEGRANTE(id_persona)` | RESTRICT | RESTRICT | `relaciona` |
| `id_persona_relacionada` | `INTEGRANTE(id_persona)` | SET NULL | RESTRICT | `involucra` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `evento_tipo` | CHECK | `tipo_evento IN ('GOL', 'ASISTENCIA', 'TARJETA_AMARILLA', 'TARJETA_ROJA', 'SUSTITUCION', 'MINUTOS_JUGADOS')` |

---

### 2.14 `RENDIMIENTO_JUGADOR`

> Desempeño individual de cada jugador en cada partido. Todas las métricas comienzan en 0 si no se indica otro valor.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_estadistica` | `INTEGER` | Sí | PK | — | Identificador del registro. |
| `id_partido` | `INTEGER` | Sí | FK | — | Partido evaluado. |
| `id_persona` | `INTEGER` | Sí | FK | — | Jugador evaluado. |
| `goles` | `INTEGER` | Sí | — | DEFAULT 0; goles >= 0 | Goles marcados. |
| `asistencias` | `INTEGER` | Sí | — | DEFAULT 0; asistencias >= 0 | Asistencias realizadas. |
| `tarjetas_amarillas` | `INTEGER` | Sí | — | DEFAULT 0; tarjetas_amarillas >= 0 | Tarjetas amarillas recibidas. |
| `tarjetas_rojas` | `INTEGER` | Sí | — | DEFAULT 0; tarjetas_rojas >= 0 | Tarjetas rojas recibidas. |
| `tiros` | `INTEGER` | Sí | — | DEFAULT 0; tiros >= 0 | Tiros realizados. |
| `minutos_jugados` | `INTEGER` | Sí | — | DEFAULT 0; entre 0 y 120 | Minutos disputados. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_partido` | `ENCUENTRO(id_partido)` | CASCADE | RESTRICT | `fk_estadistica_partido` |
| `id_persona` | `INTEGRANTE(id_persona)` | RESTRICT | RESTRICT | `fk_estadistica_persona` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `Unique_Keyv5` | UNIQUE | `(id_partido, id_persona)` |
| `estadistica_goles` | CHECK | `goles >= 0` |
| `estadistica_asistencias` | CHECK | `asistencias >= 0` |
| `estadistica_amarillas` | CHECK | `tarjetas_amarillas >= 0` |
| `estadistica_rojas` | CHECK | `tarjetas_rojas >= 0` |
| `estadistica_tiros` | CHECK | `tiros >= 0` |
| `estadistica_minutos` | CHECK | `minutos_jugados BETWEEN 0 AND 120` |

---

### 2.15 `NOVEDAD_ENCUENTRO`

> Incidencias operativas ocurridas durante un partido.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_incidencia` | `INTEGER` | Sí | PK | — | Identificador de la incidencia. |
| `id_partido` | `INTEGER` | Sí | FK | — | Partido en el que ocurrió. |
| `tipo` | `VARCHAR2(30 CHAR)` | Sí | — | CLIMATICA, DISCIPLINARIA, TECNICA u OTRA | Clase de incidencia. |
| `descripcion` | `VARCHAR2(500 CHAR)` | No | — | — | Detalle de lo ocurrido. |
| `minuto` | `SMALLINT` | No | — | minuto >= 0 | Minuto del partido en que ocurrió. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_partido` | `ENCUENTRO(id_partido)` | CASCADE | RESTRICT | `fk_incidencia_partido` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `incidencia_tipo` | CHECK | `tipo IN ('CLIMATICA', 'DISCIPLINARIA', 'TECNICA', 'OTRA')` |
| `incidencia_minuto` | CHECK | `minuto >= 0` |

---

### 2.16 `BOLETO`

> Boletería asociada a los partidos del torneo.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_entrada` | `INTEGER` | Sí | PK | — | Identificador de la entrada. |
| `id_partido` | `INTEGER` | Sí | FK | — | Partido al que da acceso. |
| `categoria` | `VARCHAR2(30 CHAR)` | Sí | — | — | Categoría de la localidad. |
| `zona` | `VARCHAR2(50 CHAR)` | Sí | — | — | Zona del estadio. |
| `precio` | `NUMBER(10,2)` | Sí | — | precio >= 0 | Valor de la entrada. |
| `estado` | `VARCHAR2(20)` | Sí | — | — | Disponibilidad de la entrada. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_partido` | `ENCUENTRO(id_partido)` | CASCADE | RESTRICT | `tienev1` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `entrada_precio` | CHECK | `precio >= 0` |

---

### 2.17 `CREDENCIAL_MEDIOS`

> Acreditación de miembros de medios de comunicación para cubrir el torneo.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_acreditacion` | `INTEGER` | Sí | PK | — | Identificador de la acreditación. |
| `id_persona` | `INTEGER` | Sí | FK | — | Persona acreditada. |
| `id_edicion` | `INTEGER` | Sí | FK | — | Edición para la que se acredita. |
| `medio_comunicacio` | `VARCHAR2(120 CHAR)` | Sí | — | — | Medio de comunicación al que pertenece. |
| `fecha_emision` | `DATE` | Sí | — | — | Fecha en que se emitió la acreditación. |
| `tipo_acreditacion` | `VARCHAR2(40 CHAR)` | Sí | — | — | Tipo de acreditación otorgada. |
| `estado` | `VARCHAR2(20 CHAR)` | Sí | — | — | Estado actual de la acreditación. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_persona` | `INTEGRANTE(id_persona)` | RESTRICT | RESTRICT | `recibe` |
| `id_edicion` | `TORNEO_MUNDIAL(id_edicion)` | RESTRICT | RESTRICT | `acredita` |

**Restricciones adicionales**

Sin restricciones adicionales.

---

### 2.18 `BITACORA_CAMBIOS`

> Trazabilidad de los cambios sobre información crítica: quién, cuándo y qué se modificó.

**Atributos**

| Atributo | Tipo | Obligatorio | Llave | Reglas | Descripción |
| :--- | :--- | :-: | :-: | :--- | :--- |
| `id_auditoria` | `INTEGER` | Sí | PK | — | Identificador del registro de auditoría. |
| `id_persona` | `INTEGER` | No | FK | — | Persona responsable del cambio. |
| `usuario_bd` | `VARCHAR2(100 CHAR)` | Sí | — | — | Usuario de base de datos que ejecutó la acción. |
| `tabla_afectada` | `VARCHAR2(50 CHAR)` | Sí | — | — | Tabla modificada. |
| `id_registro_afectado` | `INTEGER` | Sí | — | — | Registro modificado. |
| `operacion` | `VARCHAR2(10 CHAR)` | Sí | — | INSERT, UPDATE o DELETE | Tipo de operación. |
| `fecha_hora` | `TIMESTAMP` | Sí | — | — | Momento en que ocurrió el cambio. |
| `valor_anterior` | `CLOB` | No | — | — | Contenido antes de la modificación. |
| `valor_nuevo` | `CLOB` | No | — | — | Contenido después de la modificación. |

**Llaves foráneas**

| Columna | Referencia | Al borrar | Al actualizar | Constraint |
| :--- | :--- | :-: | :-: | :--- |
| `id_persona` | `INTEGRANTE(id_persona)` | SET NULL | RESTRICT | `fk_auditoria_persona` |

**Restricciones adicionales**

| Nombre | Tipo | Definición |
| :--- | :-: | :--- |
| `auditoria_operacion` | CHECK | `operacion IN ('INSERT', 'UPDATE', 'DELETE')` |

---

## 3. Índices

| Índice | Tabla | Columnas | Para qué sirve |
| :--- | :--- | :--- | :--- |
| `idx_encuentro_fecha` | `ENCUENTRO` | `fecha_hora` | Búsquedas por fecha y orden cronológico. |
| `idx_suceso_encuentro` | `SUCESO_ENCUENTRO` | `id_partido` | Goles, tarjetas y tiempos de un partido. |
| `idx_boleto_encuentro_estado` | `BOLETO` | `id_partido, estado` | Entradas disponibles o vendidas por partido. |
| `idx_rendimiento_integrante` | `RENDIMIENTO_JUGADOR` | `id_persona` | Estadísticas acumuladas de un jugador. |
| `idx_novedad_encuentro` | `NOVEDAD_ENCUENTRO` | `id_partido` | Incidencias de un partido. |

---

## 4. Comportamiento al borrar

| Regla | Qué ocurre | Relaciones |
| :--- | :--- | :--- |
| `CASCADE` | Se eliminan también los registros hijos. | De `ENCUENTRO` hacia `PARTICIPANTE_ENCUENTRO`, `TERNA_ARBITRAL`, `SUCESO_ENCUENTRO`, `RENDIMIENTO_JUGADOR`, `NOVEDAD_ENCUENTRO` y `BOLETO`. |
| `SET NULL` | El hijo se conserva y la referencia queda vacía. | Etapa padre, organización padre, partidos de origen, persona relacionada de un suceso y persona de la bitácora. |
| `RESTRICT` | No se permite borrar el padre si tiene hijos. | Todas las demás relaciones, para conservar el historial del torneo. |
