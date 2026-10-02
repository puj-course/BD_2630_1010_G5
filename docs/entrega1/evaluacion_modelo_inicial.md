# Evaluación Crítica del Modelo Inicial

## 1. Introducción

Durante la Entrega 1 se trabajó sobre un modelo genérico reducido a cinco entidades:
`EDICION_MUNDIAL`, `ESTADIO`, `SELECCION`, `PARTIDO` y `PARTICIPACION_PARTIDO`.

El propósito de esta sección es revisar, uno por uno, los puntos donde el modelo inicial
se queda corto frente a las reglas de negocio planteadas en el enunciado, y dejar
planteada la dirección que debería tomar el modelo ampliado en la Entrega 2.

---

## 2. Limitaciones detectadas y cómo resolverlas

### 2.1. La confederación es solo texto libre

`SELECCION` guarda la confederación como un campo de texto, lo que abre la puerta a que
el mismo valor se escriba de formas distintas (por ejemplo, "Conmebol" vs. "CONMEBOL") y
no hay forma de restringir qué valores son válidos.

Conviene separar esta información en una entidad `CONFEDERACION` propia, enlazada por
clave foránea. Así se gana en normalización, se elimina la duplicidad y toda selección
queda obligatoriamente asociada a una confederación que ya existe en el sistema.

### 2.2. No hay federación nacional

El modelo conecta la selección directamente con la confederación, saltándose un nivel
que sí existe en la realidad: la federación nacional de fútbol de cada país.

La solución es intercalar una entidad `FEDERACION_NACIONAL` entre `SELECCION` y
`CONFEDERACION`, lo que refleja con más fidelidad cómo está organizado el fútbol a nivel
internacional en lugar de mezclar esa información dentro de la selección.

### 2.3. La fase del torneo también es texto libre

En `PARTIDO`, la fase (grupos, octavos, cuartos, etc.) es un atributo de texto, sin
ningún control sobre los valores posibles ni forma de relacionarla formalmente con una
edición específica.

Se propone crear una entidad `FASE`, relacionada tanto con `EDICION_MUNDIAL` como con
`PARTIDO`. Esto permite definir de antemano qué fases tiene cada edición, evita valores
inconsistentes y facilita análisis agregados por fase.

### 2.4. No existe una entidad de grupo

El modelo original no tiene forma de representar los grupos de la primera fase; en
algunos ajustes puntuales se terminó agregando `grupo` como atributo suelto de
`SELECCION`, lo cual es una solución parcial y poco escalable.

Lo correcto es crear una entidad `GRUPO` asociada a una edición y a las selecciones que
lo integran. Con esto se abre la puerta a construir tablas de posiciones, calcular
clasificaciones y modelar el avance entre fases de manera consistente.

### 2.5. No hay jugadores ni convocatorias

El modelo solo conoce selecciones como bloque, sin ningún registro de qué jugadores
fueron convocados en cada edición.

Se requieren las entidades `JUGADOR`, `CONVOCATORIA` y una tabla asociativa
`CONVOCATORIA_JUGADOR`. Esto permite mantener un historial de jugadores a través de
varias ediciones, asignar dorsales por convocatoria y saber exactamente quién participó
en cada Mundial.

### 2.6. Falta el cuerpo técnico

No hay manera de registrar entrenadores ni asistentes técnicos de cada selección.

Se propone una entidad `CUERPO_TECNICO` (o equivalente) ligada a la selección y a la
edición correspondiente, de modo que quede diferenciado el personal técnico del resto de
la información de la selección.

### 2.7. No hay información arbitral

El modelo no contempla qué árbitros dirigieron cada partido ni qué rol tuvo cada uno
(árbitro central, asistente, VAR).

Como la relación entre árbitros y partidos es muchos-a-muchos —un partido puede tener
varios árbitros y un árbitro puede dirigir varios partidos—, se necesitan dos entidades:
`ARBITRO` y una tabla asociativa `ASIGNACION_ARBITRAL`, esta última con el rol específico
de cada árbitro en cada partido.

### 2.8. No hay estadísticas por jugador

Hoy en día solo se registran los goles a nivel de selección, a través de
`PARTICIPACION_PARTIDO`, sin saber quién los anotó ni ninguna otra métrica individual.

Se propone una entidad `ESTADISTICA_JUGADOR_PARTIDO` para registrar goles, asistencias,
tarjetas y minutos jugados por jugador en cada partido. Esto habilita consultas típicas
como tablas de goleadores, asistidores o reportes disciplinarios.

### 2.9. No hay sustituciones

No existe ninguna estructura para los cambios de jugadores durante un partido.

Una entidad `SUSTITUCION`, con el jugador que entra, el que sale y el minuto del cambio,
resolvería esta limitación y aportaría más detalle sobre el desarrollo de cada encuentro.

### 2.10. Sedes y geografía demasiado simplificadas

`pais_sede` y `ciudad` son hoy simples atributos de texto, lo que no alcanza para
representar ediciones organizadas por varios países y numerosas ciudades.

Conviene introducir entidades `SEDE` y `CIUDAD`, relacionadas con `EDICION_MUNDIAL` y
`ESTADIO`, para poder organizar correctamente la geografía del torneo y permitir
consultas agregadas por país o por ciudad.

### 2.11. No se registran incidencias

No hay forma de dejar constancia de eventos extraordinarios durante un partido: clima
adverso, suspensiones, incidentes de orden público, etc.

Se propone una entidad `INCIDENCIA` que permita registrar y luego analizar este tipo de
eventos, asociándolos a un partido, un estadio o una fase del torneo.

### 2.12. No hay auditoría

El modelo actual no deja rastro de quién modificó información sensible ni cuándo.

Una entidad `AUDITORIA_EVENTO` permitiría registrar las operaciones realizadas sobre
información crítica y mejorar la trazabilidad de los cambios dentro del sistema.

---

## 3. Entidades que se incorporarán en el modelo ampliado

De los puntos anteriores se desprende la siguiente lista de entidades nuevas a
incorporar en la Entrega 2:

- `CONFEDERACION`
- `FEDERACION_NACIONAL`
- `FASE`
- `GRUPO`
- `JUGADOR`
- `CONVOCATORIA`
- `CONVOCATORIA_JUGADOR`
- `CUERPO_TECNICO`
- `ARBITRO`
- `ASIGNACION_ARBITRAL`
- `ESTADISTICA_JUGADOR_PARTIDO`
- `SUSTITUCION`
- `SEDE`
- `CIUDAD`
- `INCIDENCIA`
- `AUDITORIA_EVENTO`

Esta lista es una propuesta conceptual de partida; es de esperar que se ajuste una vez se
trabaje el modelo lógico ampliado con mayor nivel de detalle.

---

## 4. Boceto conceptual del modelo ampliado

La idea es conservar intactas las entidades centrales del modelo inicial y sumarles las
estructuras nuevas descritas arriba, de forma que el modelo resultante cubra con más
fidelidad la organización, la competencia deportiva, los jugadores, el arbitraje, las
estadísticas y la operación del torneo.

El boceto conceptual correspondiente se encuentra en:

`docs/entrega1/boceto_modelo_ampliado.png`

Este diagrama muestra únicamente las entidades principales y sus relaciones; no incluye
todavía atributos, tipos de dato ni restricciones, ya que ese nivel de detalle
corresponde a la Entrega 2.

---

## 5. Conclusión

El modelo inicial cumplió su propósito: fue una base suficiente para trabajar SQL,
integridad referencial, vistas, DML y privilegios durante la Entrega 1. Pero al
contrastarlo con lo que realmente implica gestionar una Copa Mundial, quedan varios
vacíos evidentes —organización del torneo, grupos y fases, jugadores y convocatorias,
arbitraje, estadísticas por jugador e incidencias, entre otros.

Las mejoras planteadas apuntan en una misma dirección: reducir los atributos de texto
libre, subir el nivel de normalización, representar relaciones del dominio que hoy no
existen, y dejar el modelo listo para consultas y procesos más exigentes en la Entrega 2.
