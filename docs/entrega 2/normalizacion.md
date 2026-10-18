# Justificación de la Normalización del Modelo Físico

**Proyecto:** Sistema de Información para la Gestión Integral de la Copa Mundial de la FIFA
**Motor:** Oracle  · **Alcance:** las 18 tablas del modelo (`ddl_mundial.sql`)

---

## 1. Introducción

Este documento justifica que el modelo físico cumple la Primera (1FN), la Segunda (2FN) y la Tercera Forma Normal (3FN). El análisis cubre el modelo completo y se apoya en el DDL y en el Diccionario de Datos.

**Criterio de diseño que condiciona el análisis.** Todas las tablas usan una **llave primaria subrogada simple** (`INTEGER`). Las tablas asociativas (`PLANTEL_EQUIPO`, `PARTICIPANTE_ENCUENTRO`, `TERNA_ARBITRAL`, `RENDIMIENTO_JUGADOR`) tienen además su propia llave subrogada y garantizan la unicidad de la combinación natural con una restricción `UNIQUE`. Por eso se analizan las dependencias funcionales respecto de la llave primaria **y** respecto de la llave candidata natural.

| Tabla | Llave primaria | Llave candidata natural (UNIQUE) |
|---|---|---|
| TORNEO_MUNDIAL | id_edicion | anio |
| PAIS_ANFITRION | id_sede | (pais, id_edicion) |
| LOCALIDAD | id_ciudad | (id_sede, nombre) |
| RECINTO_DEPORTIVO | id_estadio | (nombre, id_ciudad) |
| FASE_TORNEO | id_etapa | — |
| ENTE_FUTBOLISTICO | id_organizacion | — |
| EQUIPO_NACIONAL | id_seleccion | — |
| INTEGRANTE | id_persona | — |
| PLANTEL_EQUIPO | id_vinculacion | (id_seleccion, id_persona) |
| ENCUENTRO | id_partido | — |
| PARTICIPANTE_ENCUENTRO | id_participacion_partido | (id_seleccion, id_partido) y (id_partido, condicion) |
| TERNA_ARBITRAL | id_asignacion | (rol_arbitral, id_partido) y (id_partido, id_persona) |
| SUCESO_ENCUENTRO | id_evento | — |
| RENDIMIENTO_JUGADOR | id_estadistica | (id_partido, id_persona) |
| NOVEDAD_ENCUENTRO | id_incidencia | — |
| BOLETO | id_entrada | — |
| CREDENCIAL_MEDIOS | id_acreditacion | — |
| BITACORA_CAMBIOS | id_auditoria | — |

---

## 2. Primera Forma Normal (1FN)

**Regla:** toda tabla tiene llave primaria, no hay grupos repetitivos y cada celda contiene un único valor atómico.

1. **Llave primaria en todas las tablas.** Las 18 tablas declaran su `PRIMARY KEY` (18 PK en el DDL), por lo que cada fila es identificable de forma única.
2. **Sin grupos repetitivos.** Ninguna tabla tiene columnas del tipo `jugador1, jugador2, …`. Lo que en el mundo real es una lista se modeló como filas de otra tabla:
   - Los jugadores y el cuerpo técnico de una selección → filas de `PLANTEL_EQUIPO`.
   - Los dos equipos de un partido → dos filas de `PARTICIPANTE_ENCUENTRO` (`LOCAL` y `VISITANTE`).
   - Los árbitros de un partido → filas de `TERNA_ARBITRAL`, una por rol.
   - Los goles, tarjetas y cambios → filas de `SUCESO_ENCUENTRO`.
3. **Valores atómicos.** Cada columna guarda un solo dato de un dominio simple (un nombre, una fecha, un entero, un código). Los dominios cerrados se refuerzan con `CHECK`, por ejemplo `rol` en `PLANTEL_EQUIPO` y `condicion` en `PARTICIPANTE_ENCUENTRO`, así no se almacenan listas dentro de un campo.
4. **Sin columnas multivaluadas en columnas de apoyo.** Los atributos de gran tamaño (`CLOB`) guardan un único texto descriptivo, no una colección de valores.

**Conclusión:** el modelo cumple 1FN.

---

## 3. Segunda Forma Normal (2FN)

**Regla:** cumple 1FN y ningún atributo no clave depende de solo una parte de una llave compuesta.

1. **Cumple 1FN** (sección 2).
2. **Llaves primarias simples.** Las 18 llaves primarias están formadas por una sola columna, así que **no pueden existir dependencias parciales** respecto de la llave primaria. Esto incluye a las tablas asociativas, que usan una llave subrogada propia.
3. **Revisión de las tablas asociativas contra su llave natural.** Aunque la llave primaria sea simple, se verificó que los atributos descriptivos dependan de la combinación **completa** de la llave natural y no de una sola de sus columnas:

| Tabla | Llave natural | Atributos descriptivos | Dependen de... |
|---|---|---|---|
| PLANTEL_EQUIPO | (id_seleccion, id_persona) | rol, dorsal, posicion, capitan, club | La persona **en esa selección**: el dorsal y el rol cambian según la selección, no son propios de la persona. |
| PARTICIPANTE_ENCUENTRO | (id_partido, id_seleccion) | condicion, goles, goles_penales, resultado | El equipo **en ese partido**: los goles no son del partido ni del equipo por separado. |
| TERNA_ARBITRAL | (id_partido, id_persona) | rol_arbitral | La persona **en ese partido**: un árbitro puede ser central en un partido y VAR en otro. |
| RENDIMIENTO_JUGADOR | (id_partido, id_persona) | goles, asistencias, tarjetas, tiros, minutos_jugados | El jugador **en ese partido**: las métricas se miden por la pareja completa. |

   Ningún atributo de esta tabla depende solo de `id_persona`, `id_seleccion` o `id_partido`. Los datos propios de la persona (nombre, nacionalidad, etc.) están en `INTEGRANTE`; los del equipo, en `EQUIPO_NACIONAL`; los del partido, en `ENCUENTRO`.

**Conclusión:** el modelo cumple 2FN.

---

## 4. Tercera Forma Normal (3FN)

**Regla:** cumple 2FN y ningún atributo no clave depende de otro atributo no clave (no hay dependencias transitivas).

1. **Cumple 1FN y 2FN** (secciones 2 y 3).
2. **Cada atributo describe solo a su entidad.** Los datos de una entidad relacionada se guardan una sola vez, en su propia tabla, y se acceden por llave foránea (28 FK en el modelo). Ejemplos:
   - `ENCUENTRO` guarda `id_estadio` y `id_etapa`, pero **no** repite el nombre del recinto, la ciudad ni el torneo.
   - `RECINTO_DEPORTIVO` guarda solo `id_ciudad`. La sede y el torneo se obtienen por la cadena:
     `RECINTO_DEPORTIVO → LOCALIDAD → PAIS_ANFITRION → TORNEO_MUNDIAL`
   - `EQUIPO_NACIONAL` no guarda el torneo: se obtiene por `id_etapa_grupo → FASE_TORNEO → TORNEO_MUNDIAL`. Tampoco guarda el nombre de la federación, que vive en `ENTE_FUTBOLISTICO`.
   - `BOLETO` referencia el partido (`id_partido`) y no copia fecha, estadio ni equipos.
   - `PLANTEL_EQUIPO` referencia a `INTEGRANTE`; el nombre y los datos personales no se repiten por cada selección o torneo.
3. **Sin dependencias transitivas por llaves naturales.** Los atributos de las tablas con llave natural (`anio` en `TORNEO_MUNDIAL`, `pais` en `PAIS_ANFITRION`, `codigo_fifa` en `EQUIPO_NACIONAL`) dependen directamente de la llave primaria y no determinan a otros atributos no clave de la misma tabla.
4. **Dominios cerrados por `CHECK`, no por columnas derivadas.** Los valores permitidos (`rol_arbitral`, `condicion`, `tipo` de novedad) se validan con 22 restricciones `CHECK` en vez de duplicar descripciones en cada fila.

### Redundancias controladas (se documentan por transparencia)

Estos campos son valores que podrían calcularse a partir de otros datos; se conservan por consulta y por trazabilidad y se mantienen coherentes desde la aplicación:

| Atributo | Podría derivarse de | Por qué se conserva |
|---|---|---|
| `PARTICIPANTE_ENCUENTRO.resultado` (GANO/PERDIO/EMPATO) | Comparar `goles` (y `goles_penales`) de las dos filas del partido | Evita autouniones en consultas de posiciones. |
| `RENDIMIENTO_JUGADOR.goles` | Contar los goles del jugador en `SUCESO_ENCUENTRO` | Es una estadística agregada por partido para reportes rápidos. |
| `ENCUENTRO.resultado_origen_1/2` | Resultado de los partidos de origen (`id_partido_origen_1/2`) | Describe la regla del cuadro (ganador/perdedor) que alimenta el partido, y no es un dato del partido anterior. |

Estas columnas no generan dependencias transitivas dentro de su propia tabla, porque dependen de la llave de su fila. Son duplicidad de información entre tablas, y la integridad entre ellas se controla con las reglas de negocio y las pruebas de carga.

**Conclusión:** el modelo cumple 3FN. Las únicas desviaciones son las tres redundancias controladas de la tabla anterior, aceptadas de forma explícita.

---

## 5. Resumen

| Forma normal | ¿Cumple? | Evidencia principal |
|---|---|---|
| 1FN | Sí | 18 PK; sin grupos repetitivos; datos atómicos; dominios con CHECK |
| 2FN | Sí | PK simples; atributos de tablas asociativas dependen de la combinación natural completa |
| 3FN | Sí | Datos de entidades relacionadas solo por FK; sin dependencias transitivas; 3 redundancias controladas documentadas |
