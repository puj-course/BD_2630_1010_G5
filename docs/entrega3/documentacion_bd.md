# Documentacion Bd

Proyecto: Sistema de Información para la Gestión Integral de la Copa Mundial de la FIFA · Oracle 19c · Schema `IS101005`

Este documento describe el propósito, los parámetros y el comportamiento esperado de las funciones, procedimientos y triggers que implementan la lógica de negocio del Mundial. Se limitó a lo esencial: cada pieza resuelve una regla concreta y usa solo las 18 tablas del modelo.

| Tipo | Cantidad | Qué resuelven |
|---|---|---|
| Funciones | 3 | Cálculos y validaciones que devuelven un valor |
| Procedimientos | 2 | Operaciones que modifican datos en varios pasos |
| Triggers | 3 | Reglas de negocio que se cumplen siempre, sin depender de quien inserte |

## Funciones
## Procedimientos
## Triggers

> Selección = `EQUIPO_NACIONAL` · participación = `PARTICIPANTE_ENCUENTRO` · partido = `ENCUENTRO` · convocatoria = `PLANTEL_EQUIPO`.
> `EQUIPO_NACIONAL` no tiene nombre: el país está en `ENTE_FUTBOLISTICO.pais`.
> Cuando una validación falla, la función, procedimiento o trigger detiene la operación y muestra un mensaje de error propio que explica el motivo.

---

# Funciones

## 1. `fn_diferencia_gol`

### Propósito
Calcular la diferencia de gol de una selección: goles a favor menos goles en contra, considerando todos sus partidos finalizados.

### Parámetros / entradas

| Parámetro | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `p_id_seleccion` | `NUMBER` | Sí | Identificador de la selección (`equipo_nacional.id_seleccion`). |

**Retorno:** `NUMBER`. Diferencia de gol (puede ser negativa).

### Comportamiento esperado

- Para cada partido de la selección busca la fila rival en `participante_encuentro` (mismo `id_partido`, distinta selección) y suma `goles propios - goles del rival`.
- Solo cuenta partidos con `encuentro.estado = 'FINALIZADO'`.
- No cuenta los goles de la tanda de penales (`goles_penales`).
- Si la selección existe pero no ha jugado, devuelve `0`.
- Si la selección no existe, muestra el mensaje 'La selección no existe'.

**Ejemplo:** `SELECT fn_diferencia_gol(1) FROM dual;`

---

## 2. `fn_validar_cupo_convocatoria`

### Propósito
Verificar si a una selección todavía se le puede agregar un jugador sin superar el cupo máximo de convocatoria.

### Parámetros / entradas

| Parámetro | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `p_id_seleccion` | `NUMBER` | Sí | Selección a validar. |
| `p_cupo_maximo` | `NUMBER` | No (default `26`) | Máximo de jugadores permitidos. |

**Retorno:** `NUMBER`. `1` si aún hay cupo, `0` si la convocatoria está completa. Se usa `NUMBER` y no `BOOLEAN` para poder llamarla también desde SQL.

### Comportamiento esperado

- Cuenta en `plantel_equipo` los registros de esa selección con `rol = 'JUGADOR'`. El cuerpo técnico no consume cupo.
- Devuelve `1` si `convocados < p_cupo_maximo` y `0` en caso contrario.
- Si la selección no existe, muestra 'La selección no existe'. Si el cupo máximo es nulo o menor que 1, muestra 'El cupo máximo debe ser mayor que cero'.
- La usan `sp_convocar_jugador` y el trigger `trg_cupo_convocatoria`.

**Ejemplo:** `SELECT fn_validar_cupo_convocatoria(1) FROM dual;`

---

## 3. `fn_verificar_dorsal_disponible`

### Propósito
Verificar si un número de camiseta está libre dentro de una selección.

### Parámetros / entradas

| Parámetro | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `p_id_seleccion` | `NUMBER` | Sí | Selección donde se quiere usar el dorsal. |
| `p_dorsal` | `NUMBER` | Sí | Número de camiseta a verificar. |
| `p_id_persona` | `NUMBER` | No | Persona que ya tiene la fila; se ignora al comparar, para poder actualizar su propio dorsal. |

**Retorno:** `NUMBER`. `1` si el dorsal está libre, `0` si otro integrante de la selección ya lo tiene.

### Comportamiento esperado

- Busca en `plantel_equipo` otra fila con la misma selección y el mismo dorsal, distinta de `p_id_persona`.
- Si no encuentra ninguna, devuelve `1`; si encuentra alguna, `0`.
- Si `p_dorsal` es nulo, devuelve `1` (el cuerpo técnico no usa dorsal).
- Si la selección no existe, muestra 'La selección no existe'. Si el dorsal está fuera de 1 a 99, muestra 'El dorsal debe estar entre 1 y 99'.
- La usan `sp_convocar_jugador` y el trigger `trg_dorsal_unico`.

**Ejemplo:** `SELECT fn_verificar_dorsal_disponible(1, 10) FROM dual;`

---

# Procedimientos

## 1. `sp_registrar_resultado`

### Propósito
Cerrar un partido: guardar el marcador de los dos equipos, calcular el resultado de cada uno y pasar el partido a `FINALIZADO`.

### Parámetros / entradas

| Parámetro | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `p_id_partido` | `NUMBER` | Sí | Partido a cerrar (`encuentro.id_partido`). |
| `p_goles_local` | `NUMBER` | Sí | Goles del equipo `LOCAL` en el juego. |
| `p_goles_visitante` | `NUMBER` | Sí | Goles del equipo `VISITANTE` en el juego. |
| `p_penales_local` | `NUMBER` | No (default `0`) | Goles del local en la tanda de penales. |
| `p_penales_visitante` | `NUMBER` | No (default `0`) | Goles del visitante en la tanda de penales. |

### Comportamiento esperado

- Actualiza `goles` y `goles_penales` en las dos filas de `participante_encuentro` del partido.
- Calcula `resultado` de cada equipo (`GANO`, `PERDIO`, `EMPATO`). Si hay empate en el juego y los penales son distintos, gana quien tenga más penales.
- Cambia `encuentro.estado` a `'FINALIZADO'`.
- Si el partido no existe, muestra 'El partido no existe'. Si no tiene exactamente un local y un visitante, muestra 'El partido debe tener un local y un visitante'. Si algún gol es nulo o negativo, muestra 'Los goles no pueden ser nulos ni negativos'. Si el partido ya estaba `FINALIZADO`, muestra 'El partido ya está finalizado' para no sobrescribir un resultado cerrado.
- Aplica `COMMIT` solo si todo salió bien; ante un error hace `ROLLBACK`.
- Mantiene coherente la columna `participante_encuentro.resultado`, una de las redundancias controladas de la normalización.

---

## 2. `sp_convocar_jugador`

### Propósito
Agregar un jugador a la convocatoria de una selección respetando el cupo y el dorsal único.

### Parámetros / entradas

| Parámetro | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `p_id_seleccion` | `NUMBER` | Sí | Selección que convoca. |
| `p_id_persona` | `NUMBER` | Sí | Persona a convocar (`integrante.id_persona`). |
| `p_dorsal` | `NUMBER` | Sí | Número de camiseta (1 a 99). |
| `p_posicion` | `VARCHAR2` | No | Posición en la cancha. |
| `p_capitan` | `CHAR` | No (default `'N'`) | `'S'` o `'N'`. |
| `p_club` | `VARCHAR2` | No | Club de origen. |

### Comportamiento esperado

- Verifica que la selección y la persona existan; si no, muestra 'La selección o la persona no existe'.
- Llama a `fn_validar_cupo_convocatoria`; si devuelve `0`, muestra 'La convocatoria ya está completa'.
- Llama a `fn_verificar_dorsal_disponible`; si devuelve `0`, muestra 'El dorsal ya está asignado en esta selección'.
- Calcula el nuevo `id_vinculacion` como `MAX(id_vinculacion) + 1` (el modelo no usa secuencias).
- Inserta en `plantel_equipo` con `rol = 'JUGADOR'`.
- Si la persona ya está en esa selección, lo rechaza la restricción `UNIQUE (id_seleccion, id_persona)`; el procedimiento no la repite.

---

# Triggers

## 1. `trg_cupo_convocatoria`

| Atributo | Valor |
|---|---|
| Tabla | `plantel_equipo` |
| Momento | `BEFORE INSERT` (por fila) |
| Regla de negocio | Cupo de convocatoria |

### Comportamiento esperado

- Solo actúa si la fila nueva tiene `rol = 'JUGADOR'`.
- Llama a `fn_validar_cupo_convocatoria`. Si devuelve `0`, rechaza el INSERT y muestra 'La convocatoria ya está completa'.
- Garantiza la regla aunque alguien inserte directamente en la tabla sin usar `sp_convocar_jugador`.

---

## 2. `trg_dorsal_unico`

| Atributo | Valor |
|---|---|
| Tabla | `plantel_equipo` |
| Momento | `BEFORE INSERT OR UPDATE OF dorsal, id_seleccion` |
| Regla de negocio | Dorsal único por selección |

### Comportamiento esperado

- Llama a `fn_verificar_dorsal_disponible` con la selección, el dorsal y la persona de la fila.
- Si devuelve `0`, rechaza la operación y muestra 'El dorsal ya está asignado en esta selección'.
- El DDL solo garantiza `UNIQUE (id_seleccion, id_persona)`; la unicidad del dorsal no está en una restricción, por eso se hace con trigger.
- Como la validación consulta la misma tabla que se está modificando, se implementa como *compound trigger*. Así se evita el problema de la tabla mutante: Oracle no deja leer una tabla mientras un trigger de fila la está cambiando.

---

## 3. `trg_cruce_agenda_estadio`

| Atributo | Valor |
|---|---|
| Tabla | `encuentro` |
| Momento | `BEFORE INSERT OR UPDATE OF id_estadio, fecha_hora` |
| Regla de negocio | Cruce de agenda en estadio |

### Comportamiento esperado

- Revisa si ya existe otro partido en el mismo `id_estadio` con `fecha_hora` a menos de 3 horas del partido nuevo.
- Si existe, rechaza la operación y muestra 'El estadio ya tiene un partido en ese horario'.
- Ignora el propio partido cuando es un UPDATE.
- Se implementa como *compound trigger* por la misma razón que el anterior.
- La ventana de 3 horas es un supuesto de diseño y queda documentada para poder ajustarla.

---

| Tipo | Nombre | Regla / uso | Qué se evita |
|---|---|---|---|
| Función | `fn_diferencia_gol` | Diferencia de gol de una selección | Consultar una selección inexistente |
| Función | `fn_validar_cupo_convocatoria` | Cupo de 26 jugadores | Superar el cupo; cupo inválido |
| Función | `fn_verificar_dorsal_disponible` | Dorsal libre en la selección | Dorsal repetido o fuera de rango |
| Procedimiento | `sp_registrar_resultado` | Cerrar partido y calcular resultados | Marcadores inválidos; cerrar dos veces un partido |
| Procedimiento | `sp_convocar_jugador` | Convocar con cupo y dorsal válidos | Convocatoria llena; dorsal repetido |
| Trigger | `trg_cupo_convocatoria` | Cupo de convocatoria | Insertar jugadores de más |
| Trigger | `trg_dorsal_unico` | Dorsal único por selección | Dos jugadores con el mismo número |
| Trigger | `trg_cruce_agenda_estadio` | Sin cruce de horario en estadio | Dos partidos a la vez en un estadio |

---

Las validaciones de rangos (goles ≥ 0, dorsal de 1 a 99) y de duplicados (selección repetida en un partido) no necesitan trigger, porque ya las cubren `CHECK` y `UNIQUE` en el DDL.
