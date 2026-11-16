# Documentación BD — Entrega 3 

**Contenido:** 3 funciones, 2 procedimientos y 4 triggers.

## 1. Modelo y cambios de integridad

Se conservan las **18 tablas** del DDL.

**Convocatorias por edición:** cada registro de selección se asocia a un grupo y a una edición. `PLANTEL_EQUIPO` permite conservar el historial de una persona en diferentes ediciones. `trg_cupo_convocatoria` evita que una misma persona sea jugadora de dos selecciones en una misma edición y controla el cupo máximo de 26. En la aplicación existe una consulta del historial por jugador.

**Posiciones:** se calculan con una consulta `SELECT` directamente sobre los encuentros `FINALIZADO` de fase de grupos. No se guardan en una tabla adicional, evitando duplicar información. G = 3 puntos, E = 1 punto, P = 0 puntos. Se suman partidos jugados, victorias, empates, derrotas, goles a favor y en contra.

## 2. Funciones (`funciones.sql`)

| Función | Parámetros | Devuelve | Justificación |
|---|---|---|---|
| `fn_diferencia_gol` | `p_id_seleccion NUMBER` | Goles a favor menos goles en contra en encuentros finalizados | Consultar una métrica deportiva sin repetir la agregación |
| `fn_validar_cupo_convocatoria` | `p_id_seleccion NUMBER` | 1 si hay menos de 26 jugadores; 0 si la selección está llena | Conocer si se puede agregar un jugador; sirve al procedimiento de convocatoria |
| `fn_ranking_goleadores` | `p_id_edicion NUMBER`, `p_id_persona NUMBER` | Puesto del jugador; 0 cuando no aparece con goles | Consulta el ranking por edición sin usar `SYS_REFCURSOR` |

Para probar las funciones con los IDs del DML original:

```sql
SELECT fn_diferencia_gol(1) AS dg FROM dual;
SELECT fn_validar_cupo_convocatoria(1) AS cupo FROM dual;
SELECT fn_ranking_goleadores(1,1101) AS puesto FROM dual;
```

El ranking utiliza `SUM` para sumar goles y `DENSE_RANK` para asignar el mismo puesto cuando dos jugadores están empatados.

## 3. Procedimientos (`procedimientos.sql`)

### 3.1 `sp_registrar_resultado`

**Parámetros:** `p_id_partido NUMBER`, `p_goles_local NUMBER`, `p_goles_visitante NUMBER`, `p_penales_local NUMBER DEFAULT 0`, `p_penales_visitante NUMBER DEFAULT 0`.

**Operación:** verifica que el partido exista, que tenga dos filas de participantes y que goles/penales no sean nulos ni negativos. Rechaza cerrar de nuevo un partido `FINALIZADO`. Calcula `GANO`, `PERDIO` o `EMPATO` comparando goles y, si hay empate, penales. Actualiza las dos filas de `PARTICIPANTE_ENCUENTRO` y cambia `ENCUENTRO.estado` a `FINALIZADO`.

**Justificación:** conserva la versión sencilla probada en el esquema del estudiante; centraliza el registro del resultado en una única operación. Su bloque `WHEN OTHERS THEN ROLLBACK; RAISE;` revierte operaciones de la transacción si aparece una excepción. Java también controla la confirmación y reversión de su conexión.

**Integración con trigger:** al finalizar, `trg_auditoria_y_marcador` verifica que los goles oficiales coincidan con los registrados en `RENDIMIENTO_JUGADOR`. Si no coinciden, el procedimiento falla y el partido no se finaliza. Las estadísticas individuales deben registrarse antes de cerrar el partido.

### 3.2 `sp_convocar_jugador`

**Parámetros:** `p_id_seleccion NUMBER`, `p_id_persona NUMBER`, `p_dorsal NUMBER`, `p_posicion VARCHAR2 DEFAULT NULL`, `p_capitan CHAR DEFAULT 'N'`, `p_club VARCHAR2 DEFAULT NULL`.

**Operación:** verifica que existan la selección y la persona; llama a `fn_validar_cupo_convocatoria` para comprobar el máximo de 26 jugadores; comprueba que el dorsal sea entero entre 1 y 99 y que no esté utilizado en esa selección. Genera un ID mediante `seq_plantel.NEXTVAL` e inserta un `JUGADOR` en `PLANTEL_EQUIPO`. El índice único y el trigger vuelven a proteger la integridad ante inserciones concurrentes o por fuera de la aplicación.

**Justificación:** recupera el procedimiento antiguo de convocatoria. Solo se sustituyó la función retirada `fn_verificar_dorsal_disponible` por un `SELECT COUNT(*)` sobre la tabla y se sustituyó el cálculo `MAX(id)+1` por una secuencia para no duplicar IDs. No incluye `MERGE` ni cursores avanzados.

**Uso en la app:** `RepositorioPlantel` llama a este procedimiento para rol `JUGADOR`. Los integrantes del cuerpo técnico se insertan directamente sin dorsal, porque no forman parte del cupo de 26.

## 4. Triggers (`triggers.sql`)

| Trigger | Tabla | Qué valida o registra |
|---|---|---|
| `trg_auditoria_y_marcador` | `ENCUENTRO` | Audita operaciones y, al finalizar mediante `UPDATE`, verifica que los goles oficiales coincidan con la suma de goles individuales. También bloquea modificaciones de finalizados |
| `trg_rangos_y_auditoria` | `RENDIMIENTO_JUGADOR` | Rechaza valores negativos y estadísticas de partidos finalizados; comprueba que el jugador corresponda a un participante y audita los cambios |
| `trg_participacion_valida` | `PARTICIPANTE_ENCUENTRO` | Comprueba que la selección pertenezca a la misma edición del partido y bloquea cambios en participantes finalizados. Las restricciones `UNIQUE` del DDL evitan duplicaciones de selección o condición |
| `trg_cupo_convocatoria` | `PLANTEL_EQUIPO` | Controla máximo 26, impide pertenecer a dos selecciones en la misma edición y protege historiales con estadísticas |

`trg_cupo_convocatoria` es el único **trigger compuesto**. Registra los IDs afectados por cada fila y consulta el plantel después de completar la sentencia; así evita consultar la misma tabla durante un trigger por fila (error de tabla mutante de Oracle).

La auditoría se registra en `BITACORA_CAMBIOS`, una tabla que ya existía en el DDL . Sus filas pertenecen a la misma transacción: si se deshace una operación, también se deshace su registro de auditoría.

## 5. Aplicación Java y reportes

- `RepositorioPartido`: programa partidos en una fecha/estadio coherentes y llama a `sp_registrar_resultado` para guardar el marcador. **No tiene carga masiva**.
- `RepositorioPlantel`: usa `sp_convocar_jugador` para jugadores y `INSERT` normal para cuerpo técnico.
- `Consultas.POSICIONES` y `ReportesConsultas.POSICIONES_SQL`: calculan en vivo la tabla de posiciones mediante un `SELECT` y agregaciones sobre `ENCUENTRO` y `PARTICIPANTE_ENCUENTRO`. Por eso **no requieren `POSICION_GRUPO` ni procedimiento de actualización**.
- `PanelReportes`: filtros por edición, selección, grupo y fase para goleadores, posiciones, incidencias y rendimiento.
- Las consultas usan `PreparedStatement` y parámetros `?`. La aplicación confirma operaciones cuando terminan correctamente.

La entrega individual **no automatiza carga masiva, avance de clasificados ni un procedimiento de posiciones**. La rúbrica escrita menciona varios como ejemplos esperados, de modo que el docente decidirá cómo valorar ese alcance reducido según sus comentarios. Los reportes sí cubren posiciones en tiempo de consulta y las reglas de integridad centrales siguen en la base.
