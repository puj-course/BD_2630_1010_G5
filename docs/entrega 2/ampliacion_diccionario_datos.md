# Diccionario de Datos del Sistema

## 1. Información General
* **Nombre de la base de datos:** Sistema de Información para la Gestión Integral de la Copa Mundial de la FIFA
* **Grupo 1:**  Andres Gomez R
# Diccionario de Datos del Sistema

---

## 2. Catálogo de Tablas

### 2.1. Tabla: `TORNEO_MUNDIAL`
* **Descripción:** Representa cada edición de la Copa Mundial registrada en el sistema.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_edicion` | `INTEGER` | No | PK | - | Ninguna | Identificador de cada torneo. |
| `anio` | `NUMBER` | No | - | - | UNIQUE (anio) | Año en el que se disputó la edición. |
| `nombre` | `VARCHAR2(100 CHAR)` | No | - | - | Ninguna | Nombre de la edición. |
| `lema` | `VARCHAR2(200 CHAR)` | Si | - | - | Ninguna | Lema oficial de la edición. |
| `fecha_inicio` | `DATE` | No | - | - | Ninguna | Fecha de inicio del torneo. |
| `fecha_fin` | `DATE` | No | - | - | Ninguna | Fecha de fin del torneo. |

#### Restricciones de Tabla (Compuestas o Checks globales)
* **edicion_fechas:** `CHECK (fecha_fin > fecha_inicio)`

---

### 2.2. Tabla: `PAIS_ANFITRION`
* **Descripción:** Representa cada país anfitrión de una edición del Mundial.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_sede` | `INTEGER` | No | PK | - | Ninguna | Identificador de la sede. |
| `id_edicion` | `INTEGER` | No | FK | - | Ninguna | Identificador de la edición a la que pertenece. |
| `pais` | `VARCHAR2(80 CHAR)` | No | - | - | Ninguna | Nombre del país sede. |

#### Relaciones (Foreign Keys)
* `id_edicion` $\rightarrow$ Referencia a `TORNEO_MUNDIAL(id_edicion)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `tiene`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **Unique_Keyv1:** `UNIQUE (pais, id_edicion)`

---

### 2.3. Tabla: `LOCALIDAD`
* **Descripción:** Representa cada ciudad anfitriona perteneciente a un país sede.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_ciudad` | `INTEGER` | No | PK | - | Ninguna | Identificador de cada ciudad. |
| `id_sede` | `INTEGER` | No | FK | - | Ninguna | Identificador de la sede. |
| `nombre` | `VARCHAR2(80 CHAR)` | No | - | - | Ninguna | Nombre de la ciudad. |

#### Relaciones (Foreign Keys)
* `id_sede` $\rightarrow$ Referencia a `PAIS_ANFITRION(id_sede)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `posee`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **Unique_Key:** `UNIQUE (id_sede, nombre)`

---

### 2.4. Tabla: `RECINTO_DEPORTIVO`
* **Descripción:** Representa los estadios utilizados para la realización de partidos.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_estadio` | `INTEGER` | No | PK | - | Ninguna | Identificador del estadio. |
| `id_ciudad` | `INTEGER` | No | FK | - | Ninguna | Identificador de la ciudad donde se ubica. |
| `nombre` | `VARCHAR2(100 CHAR)` | No | - | - | Ninguna | Nombre del estadio. |
| `capacidad` | `INTEGER` | No | - | - | CHECK (capacidad > 0) | Capacidad del estadio. |

#### Relaciones (Foreign Keys)
* `id_ciudad` $\rightarrow$ Referencia a `LOCALIDAD(id_ciudad)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `dispone`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **Unique_Keyv4:** `UNIQUE (nombre, id_ciudad)`
* **estadio_capacidad:** `CHECK (capacidad > 0)`

---

### 2.5. Tabla: `FASE_TORNEO`
* **Descripción:** Representa las fases, grupos e instancias eliminatorias en los que se divide la competencia de un torneo.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_etapa` | `INTEGER` | No | PK | - | Ninguna | Identificador de la etapa. |
| `id_edicion` | `INTEGER` | No | FK | - | Ninguna | Identificador de la edición a la que pertenece. |
| `id_etapa_padre` | `INTEGER` | Si | FK | - | Ninguna | Etapa mayor que contiene a otras etapas (ej: Fase de grupos contiene a Grupo A, B, etc.). |
| `nombre` | `VARCHAR2(80 CHAR)` | No | - | - | Ninguna | Nombre de la etapa. |
| `tipo_etapa` | `VARCHAR2(40)` | No | - | - | CHECK (tipo_etapa IN ('FASE', 'GRUPO', 'INSTANCIA_ELIMINATORIA')) | Tipo o categoría de la etapa. |
| `orden` | `INTEGER` | No | - | - | Ninguna | Orden secuencial de la etapa en el torneo. |

#### Relaciones (Foreign Keys)
* `id_edicion` $\rightarrow$ Referencia a `TORNEO_MUNDIAL(id_edicion)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `cuenta_con`)
* `id_etapa_padre` $\rightarrow$ Referencia a `FASE_TORNEO(id_etapa)` | Regla: `ON DELETE SET NULL`, `ON UPDATE RESTRICT`. (Constraint `se_conforma`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **etapa_tipo:** `CHECK (tipo_etapa IN ('FASE', 'GRUPO', 'INSTANCIA_ELIMINATORIA'))`

---

### 2.6. Tabla: `ENTE_FUTBOLISTICO`
* **Descripción:** Representa las organizaciones institucionales del fútbol (confederaciones y federaciones nacionales) relacionadas con las selecciones.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_organizacion` | `INTEGER` | No | PK | - | Ninguna | Identificador de la organización. |
| `nombre` | `VARCHAR2(100 CHAR)` | No | - | - | Ninguna | Nombre de la organización. |
| `tipo` | `VARCHAR2(30 CHAR)` | No | - | - | CHECK (tipo IN ('CONFEDERACION', 'FEDERACION_NACIONAL')) | Tipo de organización. |
| `pais` | `VARCHAR2(80 CHAR)` | No | - | - | Ninguna | Nombre del país al que pertenece. |
| `id_organizacion_padre` | `INTEGER` | Si | FK | - | Ninguna | Organización superior que la engloba (la confederación de una federación). |

#### Relaciones (Foreign Keys)
* `id_organizacion_padre` $\rightarrow$ Referencia a `ENTE_FUTBOLISTICO(id_organizacion)` | Regla: `ON DELETE SET NULL`, `ON UPDATE RESTRICT`. (Constraint `se_forma_de`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **organizacion_tipo:** `CHECK (tipo IN ('CONFEDERACION', 'FEDERACION_NACIONAL'))`

---

### 2.7. Tabla: `EQUIPO_NACIONAL`
* **Descripción:** Representa a una selección nacional, asociada a su federación y al grupo en el que juega.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_seleccion` | `INTEGER` | No | PK | - | Ninguna | Identificador de cada selección. |
| `id_organizacion` | `INTEGER` | No | FK | - | Ninguna | Identificador de la organización (federación) que representa. |
| `id_etapa_grupo` | `INTEGER` | No | FK | - | Ninguna | Identificador de la etapa o grupo al que pertenece. |
| `codigo_fifa` | `VARCHAR2(3 CHAR)` | No | - | - | Ninguna | Código de tres letras otorgado por la FIFA. |

#### Relaciones (Foreign Keys)
* `id_organizacion` $\rightarrow$ Referencia a `ENTE_FUTBOLISTICO(id_organizacion)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `representa`)
* `id_etapa_grupo` $\rightarrow$ Referencia a `FASE_TORNEO(id_etapa)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `agrupa`)

---

### 2.8. Tabla: `INTEGRANTE`
* **Descripción:** Representa actores naturales relacionados con el torneo (jugadores, técnicos, árbitros, periodistas).

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_persona` | `INTEGER` | No | PK | - | Ninguna | Identificador de la persona. |
| `nombre_completo` | `VARCHAR2(120 CHAR)` | No | - | - | Ninguna | Nombre completo de la persona. |
| `nacionalidad` | `VARCHAR2(80 CHAR)` | Si | - | - | Ninguna | Nacionalidad de la persona. |
| `fecha_de_nacimiento` | `DATE` | Si | - | - | Ninguna | Fecha de nacimiento de la persona. |

---

### 2.9. Tabla: `PLANTEL_EQUIPO`
* **Descripción:** Entidad asociativa que relaciona personas con selecciones (convocatorias de jugadores y cuerpos técnicos).

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_vinculacion` | `INTEGER` | No | PK | - | Ninguna | Identificador de la vinculación. |
| `id_persona` | `INTEGER` | No | FK | - | Ninguna | Identificador de la persona. |
| `id_seleccion` | `INTEGER` | No | FK | - | Ninguna | Identificador de la selección. |
| `capitan` | `CHAR(1 CHAR)` | Si | - | - | Ninguna | Indicador de si es el capitán. |
| `dorsal` | `SMALLINT` | Si | - | - | CHECK (dorsal BETWEEN 1 AND 99) | Número de camiseta asignado. |
| `posicion` | `VARCHAR2(30)` | Si | - | - | Ninguna | Posición de juego. |
| `rol` | `VARCHAR2(30 CHAR)` | No | - | - | CHECK (rol IN ('JUGADOR', 'DIRECTOR_TECNICO', 'ASISTENTE', 'PREPARADOR_FISICO')) | Rol desempeñado en la selección. |
| `club` | `VARCHAR2(120 CHAR)` | Si | - | - | Ninguna | Club de procedencia. |

#### Relaciones (Foreign Keys)
* `id_persona` $\rightarrow$ Referencia a `INTEGRANTE(id_persona)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `crea`)
* `id_seleccion` $\rightarrow$ Referencia a `EQUIPO_NACIONAL(id_seleccion)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `vincula`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **Unique_Keyv2:** `UNIQUE (id_seleccion, id_persona)`
* **vinculacion_rol:** `CHECK (rol IN ('JUGADOR', 'DIRECTOR_TECNICO', 'ASISTENTE', 'PREPARADOR_FISICO'))`
* **vinculacion_dorsal:** `CHECK (dorsal BETWEEN 1 AND 99)`

---

### 2.10. Tabla: `ENCUENTRO`
* **Descripción:** Contiene la información de los partidos del torneo, incluyendo los cruces de llave que dependen de partidos anteriores.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_partido` | `INTEGER` | No | PK | - | Ninguna | Identificador del partido. |
| `id_etapa` | `INTEGER` | No | FK | - | Ninguna | Identificador de la etapa en la que se juega. |
| `id_estadio` | `INTEGER` | No | FK | - | Ninguna | Identificador del estadio sede. |
| `id_partido_origen_1` | `INTEGER` | Si | FK | - | Ninguna | Primer partido previo del que proviene un clasificado (llaves eliminatorias). |
| `id_partido_origen_2` | `INTEGER` | Si | FK | - | Ninguna | Segundo partido previo del que proviene un clasificado. |
| `fecha_hora` | `DATE` | No | - | - | Ninguna | Fecha y hora del partido. |
| `asistencia_registrada` | `INTEGER` | No | - | - | CHECK (asistencia_registrada >= 0) | Asistencia de aficionados en el partido. |
| `estado` | `VARCHAR2(30 CHAR)` | No | - | - | Ninguna | Estado del partido. |
| `resultado_origen_1` | `VARCHAR2(20 CHAR)` | Si | - | - | Ninguna | Resultado del primer partido de origen (ganador o perdedor). |
| `resultado_origen_2` | `VARCHAR2(20 CHAR)` | Si | - | - | Ninguna | Resultado del segundo partido de origen. |

#### Relaciones (Foreign Keys)
* `id_etapa` $\rightarrow$ Referencia a `FASE_TORNEO(id_etapa)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `contiene`)
* `id_estadio` $\rightarrow$ Referencia a `RECINTO_DEPORTIVO(id_estadio)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `alberga`)
* `id_partido_origen_1` $\rightarrow$ Referencia a `ENCUENTRO(id_partido)` | Regla: `ON DELETE SET NULL`, `ON UPDATE RESTRICT`. (Constraint `P2precede`)
* `id_partido_origen_2` $\rightarrow$ Referencia a `ENCUENTRO(id_partido)` | Regla: `ON DELETE SET NULL`, `ON UPDATE RESTRICT`. (Constraint `precede`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **partido_asistencia:** `CHECK (asistencia_registrada >= 0)`

---

### 2.11. Tabla: `PARTICIPANTE_ENCUENTRO`
* **Descripción:** Tabla asociativa que registra la participación de una selección en un partido específico.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_participacion_partido` | `INTEGER` | No | PK | - | Ninguna | Identificador de la participación. |
| `id_partido` | `INTEGER` | No | FK | - | Ninguna | Identificador del partido. |
| `id_seleccion` | `INTEGER` | No | FK | - | Ninguna | Identificador de la selección. |
| `condicion` | `VARCHAR2(10 CHAR)` | No | - | - | CHECK (condicion IN ('LOCAL', 'VISITANTE')) | Condición de participación en el encuentro. |
| `goles` | `INTEGER` | No | - | - | CHECK (goles >= 0) | Goles marcados por la selección en el partido. |
| `goles_penales` | `INTEGER` | No | - | - | CHECK (goles_penales >= 0) | Goles marcados en la tanda de penales. |
| `resultado` | `VARCHAR2(10)` | Si | - | - | CHECK (resultado IN ('GANO', 'PERDIO', 'EMPATO')) | Resultado de la selección en el partido. |

#### Relaciones (Foreign Keys)
* `id_partido` $\rightarrow$ Referencia a `ENCUENTRO(id_partido)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`. (Constraint `rellena`)
* `id_seleccion` $\rightarrow$ Referencia a `EQUIPO_NACIONAL(id_seleccion)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `registra`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **Unique_Key_1v2:** `UNIQUE (id_seleccion, id_partido)`
* **Unique_Key_2v2:** `UNIQUE (id_partido, condicion)`
* **partido_condicion:** `CHECK (condicion IN ('LOCAL', 'VISITANTE'))`
* **part_goles:** `CHECK (goles >= 0 AND goles_penales >= 0)`
* **part_resultado:** `CHECK (resultado IN ('GANO', 'PERDIO', 'EMPATO'))`

---

### 2.12. Tabla: `TERNA_ARBITRAL`
* **Descripción:** Entidad asociativa que representa la asignación de árbitros a los partidos.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_asignacion` | `INTEGER` | No | PK | - | Ninguna | Identificador de la asignación. |
| `id_partido` | `INTEGER` | No | FK | - | Ninguna | Identificador del partido. |
| `id_persona` | `INTEGER` | No | FK | - | Ninguna | Identificador de la persona (árbitro). |
| `rol_arbitral` | `VARCHAR2(40 CHAR)` | No | - | - | CHECK (rol_arbitral IN ('CENTRAL', 'ASISTENTE_1', 'ASISTENTE_2', 'CUARTO_ARBITRO', 'VAR', 'AVAR')) | Rol arbitral asignado en el partido. |

#### Relaciones (Foreign Keys)
* `id_partido` $\rightarrow$ Referencia a `ENCUENTRO(id_partido)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`. (Constraint `tienev2`)
* `id_persona` $\rightarrow$ Referencia a `INTEGRANTE(id_persona)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `es`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **Unique_Key_1:** `UNIQUE (rol_arbitral, id_partido)`
* **Unique_Key_2:** `UNIQUE (id_partido, id_persona)`

---

### 2.13. Tabla: `SUCESO_ENCUENTRO`
* **Descripción:** Registra acontecimientos deportivos asociados a un partido (goles, asistencias, tarjetas, sustituciones).

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_evento` | `INTEGER` | No | PK | - | Ninguna | Identificador del evento. |
| `id_partido` | `INTEGER` | No | FK | - | Ninguna | Identificador del partido. |
| `id_persona` | `INTEGER` | Si | FK | - | Ninguna | Identificador de la persona protagonista. |
| `id_persona_relacionada` | `INTEGER` | Si | FK | - | Ninguna | Segunda persona relacionada (ej. sustitución). |
| `tipo_evento` | `VARCHAR2(40 CHAR)` | No | - | - | CHECK (tipo_evento IN ('GOL', 'ASISTENCIA', 'TARJETA_AMARILLA', 'TARJETA_ROJA', 'SUSTITUCION', 'MINUTOS_JUGADOS')) | Tipo de evento registrado. |
| `minuto` | `SMALLINT` | Si | - | - | Ninguna | Minuto del partido en que ocurre. |
| `valor_numerico` | `SMALLINT` | Si | - | - | Ninguna | Valor numérico auxiliar (ej. minutos jugados). |
| `descripcion` | `VARCHAR2(400 CHAR)` | Si | - | - | Ninguna | Descripción detallada del suceso. |

#### Relaciones (Foreign Keys)
* `id_partido` $\rightarrow$ Referencia a `ENCUENTRO(id_partido)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`. (Constraint `genera`)
* `id_persona` $\rightarrow$ Referencia a `INTEGRANTE(id_persona)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `relaciona`)
* `id_persona_relacionada` $\rightarrow$ Referencia a `INTEGRANTE(id_persona)` | Regla: `ON DELETE SET NULL`, `ON UPDATE RESTRICT`. (Constraint `involucra`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **evento_tipo:** `CHECK (tipo_evento IN ('GOL', 'ASISTENCIA', 'TARJETA_AMARILLA', 'TARJETA_ROJA', 'SUSTITUCION', 'MINUTOS_JUGADOS'))`

---

### 2.14. Tabla: `RENDIMIENTO_JUGADOR`
* **Descripción:** Registra el desempeño individual de cada jugador en cada partido (goles, asistencias, tarjetas, tiros y minutos jugados).

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_estadistica` | `INTEGER` | No | PK | - | Ninguna | Identificador del registro de estadística. |
| `id_partido` | `INTEGER` | No | FK | - | Ninguna | Identificador del partido. |
| `id_persona` | `INTEGER` | No | FK | - | Ninguna | Identificador de la persona (jugador). |
| `goles` | `INTEGER` | No | - | 0 | CHECK (goles >= 0) | Goles marcados por el jugador en el partido. |
| `asistencias` | `INTEGER` | No | - | 0 | CHECK (asistencias >= 0) | Asistencias realizadas por el jugador. |
| `tarjetas_amarillas` | `INTEGER` | No | - | 0 | CHECK (tarjetas_amarillas >= 0) | Tarjetas amarillas recibidas. |
| `tarjetas_rojas` | `INTEGER` | No | - | 0 | CHECK (tarjetas_rojas >= 0) | Tarjetas rojas recibidas. |
| `tiros` | `INTEGER` | No | - | 0 | CHECK (tiros >= 0) | Tiros realizados. |
| `minutos_jugados` | `INTEGER` | No | - | 0 | CHECK (minutos_jugados BETWEEN 0 AND 120) | Minutos jugados en el partido. |

#### Relaciones (Foreign Keys)
* `id_partido` $\rightarrow$ Referencia a `ENCUENTRO(id_partido)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`. (Constraint `fk_estadistica_partido`)
* `id_persona` $\rightarrow$ Referencia a `INTEGRANTE(id_persona)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `fk_estadistica_persona`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **Unique_Keyv5:** `UNIQUE (id_partido, id_persona)`
* **estadistica_goles / estadistica_asistencias / estadistica_amarillas / estadistica_rojas / estadistica_tiros:** `CHECK (campo >= 0)`
* **estadistica_minutos:** `CHECK (minutos_jugados BETWEEN 0 AND 120)`

---

### 2.15. Tabla: `NOVEDAD_ENCUENTRO`
* **Descripción:** Registra las incidencias operativas ocurridas durante un partido (climáticas, disciplinarias, técnicas u otras).

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_incidencia` | `INTEGER` | No | PK | - | Ninguna | Identificador de la incidencia. |
| `id_partido` | `INTEGER` | No | FK | - | Ninguna | Identificador del partido. |
| `tipo` | `VARCHAR2(30 CHAR)` | No | - | - | CHECK (tipo IN ('CLIMATICA', 'DISCIPLINARIA', 'TECNICA', 'OTRA')) | Tipo de incidencia. |
| `descripcion` | `VARCHAR2(500 CHAR)` | Si | - | - | Ninguna | Descripción detallada de la incidencia. |
| `minuto` | `SMALLINT` | Si | - | - | CHECK (minuto >= 0) | Minuto del partido en que ocurrió. |

#### Relaciones (Foreign Keys)
* `id_partido` $\rightarrow$ Referencia a `ENCUENTRO(id_partido)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`. (Constraint `fk_incidencia_partido`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **incidencia_tipo:** `CHECK (tipo IN ('CLIMATICA', 'DISCIPLINARIA', 'TECNICA', 'OTRA'))`
* **incidencia_minuto:** `CHECK (minuto >= 0)`

---

### 2.16. Tabla: `BOLETO`
* **Descripción:** Representa la boletería asociada a los partidos del torneo.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_entrada` | `INTEGER` | No | PK | - | Ninguna | Identificador de la entrada. |
| `id_partido` | `INTEGER` | No | FK | - | Ninguna | Identificador del partido. |
| `categoria` | `VARCHAR2(30 CHAR)` | No | - | - | Ninguna | Categoría de la localidad. |
| `zona` | `VARCHAR2(50 CHAR)` | No | - | - | Ninguna | Zona del estadio. |
| `precio` | `NUMBER(10,2)` | No | - | - | CHECK (precio >= 0) | Precio de la entrada. |
| `estado` | `VARCHAR2(20)` | No | - | - | Ninguna | Estado de disponibilidad de la entrada. |

#### Relaciones (Foreign Keys)
* `id_partido` $\rightarrow$ Referencia a `ENCUENTRO(id_partido)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`. (Constraint `tienev1`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **entrada_precio:** `CHECK (precio >= 0)`

---

### 2.17. Tabla: `CREDENCIAL_MEDIOS`
* **Descripción:** Representa la acreditación de miembros de medios de comunicación para cubrir el torneo.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_acreditacion` | `INTEGER` | No | PK | - | Ninguna | Identificador de la acreditación. |
| `id_persona` | `INTEGER` | No | FK | - | Ninguna | Identificador de la persona acreditada. |
| `id_edicion` | `INTEGER` | No | FK | - | Ninguna | Identificador de la edición mundial. |
| `medio_comunicacio` | `VARCHAR2(120 CHAR)` | No | - | - | Ninguna | Nombre del medio de comunicación. |
| `fecha_emision` | `DATE` | No | - | - | Ninguna | Fecha de emisión de la acreditación. |
| `tipo_acreditacion` | `VARCHAR2(40 CHAR)` | No | - | - | Ninguna | Tipo de acreditación otorgada. |
| `estado` | `VARCHAR2(20 CHAR)` | No | - | - | Ninguna | Estado actual de la acreditación. |

#### Relaciones (Foreign Keys)
* `id_persona` $\rightarrow$ Referencia a `INTEGRANTE(id_persona)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `recibe`)
* `id_edicion` $\rightarrow$ Referencia a `TORNEO_MUNDIAL(id_edicion)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`. (Constraint `acredita`)

---

### 2.18. Tabla: `BITACORA_CAMBIOS`
* **Descripción:** Almacena la trazabilidad de los cambios realizados sobre información crítica del sistema, indicando quién, cuándo y qué se modificó.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_auditoria` | `INTEGER` | No | PK | - | Ninguna | Identificador del registro de auditoría. |
| `id_persona` | `INTEGER` | Si | FK | - | Ninguna | Persona responsable del cambio. |
| `usuario_bd` | `VARCHAR2(100 CHAR)` | No | - | - | Ninguna | Usuario de base de datos que ejecutó la acción. |
| `tabla_afectada` | `VARCHAR2(50 CHAR)` | No | - | - | Ninguna | Nombre de la tabla modificada. |
| `id_registro_afectado` | `INTEGER` | No | - | - | Ninguna | Identificador del registro afectado. |
| `operacion` | `VARCHAR2(10 CHAR)` | No | - | - | CHECK (operacion IN ('INSERT', 'UPDATE', 'DELETE')) | Tipo de operación realizada. |
| `fecha_hora` | `TIMESTAMP` | No | - | - | Ninguna | Fecha y hora en que ocurrió el evento. |
| `valor_anterior` | `CLOB` | Si | - | - | Ninguna | Contenido previo a la modificación. |
| `valor_nuevo` | `CLOB` | Si | - | - | Ninguna | Contenido posterior a la modificación. |

#### Relaciones (Foreign Keys)
* `id_persona` $\rightarrow$ Referencia a `INTEGRANTE(id_persona)` | Regla: `ON DELETE SET NULL`, `ON UPDATE RESTRICT`. (Constraint `fk_auditoria_persona`)

#### Restricciones de Tabla (Compuestas o Checks globales)
* **auditoria_operacion:** `CHECK (operacion IN ('INSERT', 'UPDATE', 'DELETE'))`

---

## 3. Índices

| Índice | Tabla | Columnas | Justificación |
| :--- | :--- | :--- | :--- |
| `idx_encuentro_fecha` | `ENCUENTRO` | `fecha_hora` | Búsquedas frecuentes por fecha u orden cronológico. |
| `idx_suceso_encuentro` | `SUCESO_ENCUENTRO` | `id_partido` | Consulta de goles, tarjetas y tiempos de un partido. |
| `idx_boleto_encuentro_estado` | `BOLETO` | `id_partido, estado` | Disponibilidad de entradas (disponibles o vendidas) por partido. |
| `idx_rendimiento_integrante` | `RENDIMIENTO_JUGADOR` | `id_persona` | Estadísticas acumuladas de un jugador (goleadores, asistidores). |
| `idx_novedad_encuentro` | `NOVEDAD_ENCUENTRO` | `id_partido` | Consulta de las incidencias de un partido. |

---

## 4. Resumen de Reglas de Borrado

| Regla | Relaciones |
| :--- | :--- |
| `ON DELETE CASCADE` | `ENCUENTRO` → `PARTICIPANTE_ENCUENTRO`, `TERNA_ARBITRAL`, `SUCESO_ENCUENTRO`, `RENDIMIENTO_JUGADOR`, `NOVEDAD_ENCUENTRO`, `BOLETO` |
| `ON DELETE SET NULL` | `FASE_TORNEO` (etapa padre), `ENTE_FUTBOLISTICO` (organización padre), `ENCUENTRO` (partidos de origen), `SUCESO_ENCUENTRO` (persona relacionada), `BITACORA_CAMBIOS` (persona) |
| `ON DELETE RESTRICT` | Todas las demás relaciones: se conserva el historial del torneo. |
