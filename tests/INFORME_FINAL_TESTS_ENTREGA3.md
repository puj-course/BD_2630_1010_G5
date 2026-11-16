# INFORME FINAL DE PRUEBAS SQL

**Sistema de Información para la Gestión Integral de la Copa Mundial de la FIFA**  
**Asignatura:** Bases de Datos  
**Modalidad:** Entrega 3 — proyecto individual  
**Motor:** Oracle Database 19c  
**Esquema evaluado:** `IS101005`  
**Fecha del informe:** 16 de noviembre de 2026

---

## 1. Resumen de resultados

El presente informe registra los resultados observados durante la ejecución de los casos de prueba SQL de la Entrega 3. Se evaluaron consultas a funciones, procedimientos almacenados, triggers, restricciones de integridad y limpieza de datos temporales, utilizando como evidencia la salida de SQL Developer recopilada en *Prompt resultados.pdf*.

La prueba de las tres funciones devolvió los valores esperados: diferencia de gol de Colombia igual a **2**, disponibilidad de cupo igual a **1** y posición del jugador `1101` en el ranking igual a **1**. También se confirmó una convocatoria válida mediante `sp_convocar_jugador`, con una fila registrada para la persona temporal `990009` y dorsal `98`.

No obstante, la ejecución **no permitió validar integralmente la programación en base de datos**. Se observaron errores `PLS-00905` para `SP_REGISTRAR_RESULTADO` y `ORA-04098` para `TRG_AUDITORIA_ENCUENTRO` y `TRG_AUDITORIA_ESTADISTICAS`. Estos errores indican objetos inválidos; no constituyen rechazos correctos por reglas de negocio. Varios casos posteriores quedaron sin validación concluyente porque no pudo crearse el partido temporal `990001`.

**Resultado general:** verificación **parcial**, con funcionalidades confirmadas y fallas de compilación o validez que impidieron completar la comprobación de otros componentes.

## 2. Alcance y condiciones de las pruebas

La ejecución incluyó doce bloques identificados como *Prompt 1* a *Prompt 12*, más el caso adicional *4A*. Los ejercicios se ejecutaron en el esquema `IS101005` utilizando identificadores de prueba `990001`, `990009` y `990011`. El diseño del script contemplaba un partido temporal, una convocatoria temporal y `ROLLBACK` para evitar conservar datos de prueba.

Los estados de este informe tienen el siguiente significado:

- **Comprobado:** la salida confirma expresamente el resultado esperado o una operación válida verificable mediante consulta.
- **No superado:** la operación requerida produjo un error técnico o un resultado contrario al objetivo.
- **No concluyente:** la salida no aporta el mensaje o las filas suficientes para afirmar que la regla se verificó; incluye pruebas afectadas por fallas previas.

La mención «Procedimiento PL/SQL terminado correctamente» indica que un bloque anónimo terminó sin excepción no controlada; por sí sola, **no demuestra** que una operación rechazada haya generado el código de error esperado, ni que se haya ejecutado el trigger previsto.

## 3. Pruebas de funciones

### 3.1. Cálculo de diferencia de gol

**Objeto evaluado:** `FN_DIFERENCIA_GOL`  
**Consulta ejecutada:**

```sql
SELECT fn_diferencia_gol(1) AS diferencia_colombia,
       fn_validar_cupo_convocatoria(1) AS hay_cupo_colombia,
       fn_ranking_goleadores(1, 1101) AS puesto_jugador_1101
FROM dual;
```

**Resultado registrado:**

```text
DIFERENCIA_COLOMBIA  HAY_CUPO_COLOMBIA  PUESTO_JUGADOR_1101
                  2                  1                    1
```

| Función | Resultado observado | Evaluación |
|---|---:|---|
| `fn_diferencia_gol(1)` | `2` | Comprobado |
| `fn_validar_cupo_convocatoria(1)` | `1` | Comprobado |
| `fn_ranking_goleadores(1,1101)` | `1` | Comprobado |

Los tres valores coincidieron con los previstos para los registros utilizados en el ensayo. Esta evidencia demuestra la ejecución correcta de **esas tres llamadas concretas**, sin establecer que todas las entradas posibles estén cubiertas.

## 4. Pruebas de procedimientos almacenados

### 4.1. Registro de resultados y errores controlados — Prompt 2

**Objeto evaluado:** `SP_REGISTRAR_RESULTADO`.

Se intentaron los casos de partido inexistente, goles negativos y partido previamente finalizado. En las tres ejecuciones apareció el mismo error:

```text
ORA-06550: línea 2, columna 3
PLS-00905: el objeto IS101005.SP_REGISTRAR_RESULTADO no es válido
PL/SQL: Statement ignored
```

**Evaluación: no superado.** El procedimiento no llegó a ejecutar las validaciones de negocio esperadas (`ORA-20010`, `ORA-20012` y `ORA-20013`). La salida también muestra un bloque PL/SQL finalizado correctamente al final de este conjunto; sin el mensaje específico del caso de dorsal duplicado, dicho bloque no permite confirmar por sí solo que `SP_CONVOCAR_JUGADOR` haya rechazado ese dorsal por la regla esperada.

### 4.2. Registro válido de un marcador — Prompt 9

Se intentó registrar el resultado del partido temporal `990001` mediante `SP_REGISTRAR_RESULTADO`. La ejecución volvió a presentar `PLS-00905`. Además, el partido temporal y las estadísticas necesarias no pudieron prepararse correctamente debido a fallas previas de triggers. No se devolvieron filas del encuentro ni de sus participantes para verificar el marcador.

**Evaluación: no superado.** No existe evidencia de un marcador registrado mediante el procedimiento en esta ejecución.

### 4.3. Convocatoria válida — Prompt 11

**Objeto evaluado:** `SP_CONVOCAR_JUGADOR`.

Se insertó la persona temporal `990009` y se ejecutó la convocatoria para la selección `1` con dorsal `98`. La consulta de verificación produjo:

```text
ID_VINCULACION  ID_PERSONA  ID_SELECCION  DORSAL  ROL
          5025      990009             1      98  JUGADOR
```

**Evaluación: comprobado.** La fila confirma que la operación registró la vinculación temporal con la selección, el dorsal y el rol previstos.

## 5. Pruebas de triggers y restricciones de integridad

### 5.1. Operaciones inválidas sobre datos existentes — Prompt 3

El script ejecutó bloques de prueba para modificaciones de datos finalizados, participaciones duplicadas, condiciones repetidas y convocatorias incompatibles. La salida adjunta muestra cinco mensajes generales de finalización de PL/SQL y un `ROLLBACK`, **sin los mensajes individualizados `T05` a `T09`**.

**Evaluación: no concluyente.** No es posible atribuir los mensajes a rechazos de negocio específicos ni confirmar cuáles códigos de error se produjeron.

### 5.2. Creación del partido temporal — Prompt 4

La inserción del encuentro `990001`, en estado `PROGRAMADO`, falló por:

```text
ORA-04098: el disparador 'IS101005.TRG_AUDITORIA_ENCUENTRO'
no es válido y ha fallado al revalidar
```

Posteriormente, las inserciones de los dos participantes devolvieron:

```text
ORA-01403: No se ha encontrado ningún dato
ORA-06512: en "IS101005.TRG_PARTICIPACION_VALIDA", línea 15
ORA-04088: error durante la ejecución del disparador
```

**Evaluación: no superado.** La primera inserción no creó el encuentro; la ausencia de este registro explica que las inserciones dependientes no encontraran la información que necesitaban. `ORA-01403` en ese contexto no demuestra la validación de una participación de otra edición: aparece después de que falló la creación del partido base.

### 5.3. Selección de otra edición — Prompt 4A

Las inserciones temporales de una fase y una selección de otra edición devolvieron **una fila insertada** en cada operación. El bloque anónimo posterior terminó correctamente y se ejecutó `ROLLBACK` al punto de guardado.

**Evaluación: no concluyente.** No aparece en el registro el mensaje `T09B OK` ni el código `ORA-20221` previstos para confirmar el rechazo de una selección de otra edición. Además, el partido temporal original no se había creado.

### 5.4. Validaciones de estadísticas — Prompt 5

Se registraron dos bloques PL/SQL terminados correctamente, correspondientes a los ensayos de gol negativo y jugador ajeno al encuentro. No figuran los mensajes individualizados `T10` y `T11` ni los códigos de error esperados.

**Evaluación: no concluyente.** La salida no permite afirmar qué validación se activó.

### 5.5. Auditoría de encuentros — Prompt 6

La operación de actualización de asistencia del partido temporal produjo nuevamente `ORA-04098` para `TRG_AUDITORIA_ENCUENTRO`. La consulta posterior devolvió:

```text
AUDITORIAS_ACTUALIZACION_TEMPORAL
                                0
```

**Evaluación: no superado.** No se registró una auditoría de esa actualización. El resultado está condicionado por el trigger inválido y por la falta del partido temporal.

### 5.6. Asistencia negativa — Prompt 7

La salida contiene «Procedimiento PL/SQL terminado correctamente», pero no incluye el mensaje individualizado `T12 OK` ni una referencia al `ORA-02290` esperado para el `CHECK` de asistencia.

**Evaluación: no concluyente.** El bloqueo por la restricción no quedó demostrado expresamente en las evidencias adjuntas.

### 5.7. Consistencia de marcador — Prompt 8

El intento de modificar goles oficiales del partido temporal afectó **cero filas**. Después se ejecutó un bloque PL/SQL y se realizó `ROLLBACK` al punto de guardado.

**Evaluación: no concluyente.** Al no actualizarse ningún registro, no quedó probado el rechazo de una discrepancia entre el marcador oficial y los goles individuales.

### 5.8. Auditoría y estadísticas individuales — Prompt 9

Las dos inserciones de estadísticas individuales devolvieron:

```text
ORA-04098: el disparador 'IS101005.TRG_AUDITORIA_ESTADISTICAS'
no es válido y ha fallado al revalidar
```

La consulta de auditoría indicó:

```text
AUDITORIAS_ESTADISTICAS_TEMPORALES
                                 0
```

**Evaluación: no superado.** No se insertaron las estadísticas temporales ni se generaron registros de auditoría para ellas.

## 6. Integridad de los datos de prueba y limpieza

La ejecución confirmó que los registros temporales controlados no permanecieron almacenados después de los `ROLLBACK`.

| Bloque | Comprobación | Resultado observado | Evaluación |
|---|---|---:|---|
| Prompt 10 | Partidos temporales restantes (`id_partido=990001`) | `0` | Comprobado |
| Prompt 12 | Personas temporales restantes (`id_persona=990009`) | `0` | Comprobado |
| Prompt 12 | Convocatorias temporales restantes (`id_persona=990009`) | `0` | Comprobado |

En el caso del partido `990001`, el cero también se explica porque la creación del encuentro había fallado. La comprobación sí confirma que no quedó un partido con ese identificador al finalizar. La limpieza del jugador y de su convocatoria se verificó tras una inserción efectiva en el Prompt 11.

## 7. Síntesis del cumplimiento observado

| Componente o comportamiento | Evidencia principal | Estado |
|---|---|---|
| Función de diferencia de gol | Valor `2` | Comprobado |
| Función de cupo de convocatoria | Valor `1` | Comprobado |
| Función de ranking | Valor `1` | Comprobado |
| Procedimiento de convocatoria válida | Fila `5025 / 990009 / 1 / 98 / JUGADOR` | Comprobado |
| Procedimiento de registro de resultados | `PLS-00905` | No superado |
| Trigger de auditoría de encuentro | `ORA-04098`, auditorías `0` | No superado |
| Trigger de auditoría de estadísticas | `ORA-04098`, auditorías `0` | No superado |
| Participación en partido temporal | `ORA-01403` tras falla al insertar encuentro | No superado en el montaje temporal |
| Rangos, duplicidad y convocatoria por edición | Bloques sin salida individualizada | No concluyente |
| Consistencia del marcador | `0` filas actualizadas | No concluyente |
| Reversión de convocatoria temporal | Dos conteos finales `0` | Comprobado |

Los nombres `TRG_AUDITORIA_ENCUENTRO` y `TRG_AUDITORIA_ESTADISTICAS` aparecen en los errores de Oracle. Las evidencias no incluyen un inventario completo de los objetos instalados que permita determinar si pertenecen a una versión anterior del esquema o si coexisten con los triggers de la versión individual más reciente. Por ello, el informe describe **la ejecución real observada**, sin dar por confirmada una configuración que no está documentada en las salidas.

## 8. Conclusiones

Las pruebas proporcionan **evidencia positiva** para las tres funciones calculadas con los datos disponibles y para el procedimiento de convocatoria de un jugador. En este último caso, la fila registrada coincide con la selección, el dorsal y el rol previstos. Asimismo, la reversión final de los datos temporales de convocatoria quedó confirmada.

Por otro lado, el procedimiento `SP_REGISTRAR_RESULTADO` y los triggers de auditoría señalados por Oracle presentaron errores de validez que impidieron ejecutar correctamente parte de los escenarios. Estos errores condicionaron las pruebas posteriores, en particular la creación de un partido temporal, el registro de estadísticas y la verificación de consistencia entre goles individuales y marcador oficial.

En consecuencia, **la ejecución documentada no constituye una aprobación completa de la lógica de programación de la Entrega 3**. Su resultado es **parcial**: determinados cálculos y la convocatoria válida quedaron demostrados, mientras que el registro de resultados y las auditorías no superaron los ensayos, y otras validaciones permanecieron sin evidencia suficiente para emitir un juicio concluyente.

---

**Fuente de evidencia:** archivo `Prompt resultados.pdf`, páginas 1 a 7, que contiene las salidas de SQL Developer identificadas como Prompt 1 a Prompt 12.  
**Carácter del informe:** registro final de los resultados efectivamente aportados; no incluye resultados simulados ni pruebas atribuidas como exitosas sin evidencia explícita.
