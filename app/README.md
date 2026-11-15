# Mundial App - Entrega 3

Aplicacion de escritorio (Java Swing + JDBC) para el Sistema de Informacion de la Copa Mundial de la FIFA.
Se conecta a la base de datos Oracle de las entregas anteriores (18 tablas).

## Como ejecutarla

1. Copiar `config.example.properties` como `config.properties` y llenar usuario y contrasena.
   `config.properties` esta en `.gitignore` y no se sube al repositorio.
2. En la base de datos deben estar creados, en este orden: DDL, DML, `funciones_mundial.sql`,
   `procedimientos_mundial.sql` y `triggers_mundial.sql`.
3. Ejecutar: `mvn compile exec:java` (Java 21 y Maven).

## Estructura

| Paquete / archivo | Que hace |
|---|---|
| `Main` | Prueba la conexion y abre la ventana principal. |
| `Conexion` | Abre la conexion con los datos de `config.properties`. |
| `ui/VentanaPrincipal` | Menu con todos los modulos. |
| `ui/PanelCrud` | Pantalla generica: lista una tabla y permite crear, modificar y eliminar. |
| `ui/PanelConsulta` | Pantalla de solo lectura con filtro (lista desplegable). |
| `ui/PanelPartidos` | Programar partidos y registrar resultados. |
| `ui/PanelPlantel` | Convocar jugadores y ver la convocatoria. |
| `ui/PanelReportes` | Ejecuta las 10 consultas avanzadas (`reportes.sql`). |
| `datos/Catalogos` | Describe las 14 tablas que se administran con el CRUD. |
| `datos/RepositorioTabla` | Instrucciones INSERT, UPDATE, DELETE y SELECT de cualquier tabla descrita. |
| `datos/Consultas` | Consultas SQL de las pantallas de lectura. |
| `datos/RepositorioPartido` / `RepositorioPlantel` | Llaman a los procedimientos almacenados. |

## Menu y tablas

| Menu | Opcion | Tabla o consulta |
|---|---|---|
| Catalogos | Ediciones, Sedes, Ciudades, Estadios | TORNEO_MUNDIAL, PAIS_ANFITRION, LOCALIDAD, RECINTO_DEPORTIVO |
| Catalogos | Fases y grupos, Federaciones, Selecciones | FASE_TORNEO, ENTE_FUTBOLISTICO, EQUIPO_NACIONAL |
| Catalogos | Integrantes | INTEGRANTE |
| Catalogos | Jugadores y cuerpo tecnico | PLANTEL_EQUIPO (procedimiento `sp_convocar_jugador`) |
| Partidos | Registro de partidos | ENCUENTRO + PARTICIPANTE_ENCUENTRO (procedimiento `sp_registrar_resultado`) |
| Partidos | Arbitros, Sucesos, Estadisticas, Incidencias | TERNA_ARBITRAL, SUCESO_ENCUENTRO, RENDIMIENTO_JUGADOR, NOVEDAD_ENCUENTRO |
| Logistica | Boletos, Credenciales | BOLETO, CREDENCIAL_MEDIOS |
| Consultas | Posiciones, Resultados, Incidencias | Consultas con JOIN y agregaciones |
| Consultas | Rendimiento de selecciones | Usa `fn_diferencia_gol` y `fn_validar_cupo_convocatoria` |
| Consultas | Bitacora de cambios | BITACORA_CAMBIOS |
| Reportes | Panel de reportes | Las 10 consultas avanzadas |

## Como se conecta con lo que ya hicimos

- **Funciones:** la consulta "Rendimiento de selecciones" las usa dentro del SELECT.
- **Procedimientos:** "Convocar jugador" llama a `sp_convocar_jugador` y "Registrar resultado" a `sp_registrar_resultado`.
  Los procedimientos no hacen COMMIT: la aplicacion confirma (`commit`) si todo salio bien y deshace (`rollback`) si falla.
- **Triggers:** se prueban desde la aplicacion. Programar un partido en un estadio ocupado muestra el mensaje de
  `trg_cruce_agenda_estadio`; convocar con un dorsal repetido, el de `trg_dorsal_unico`; llenar una convocatoria, el de `trg_cupo_convocatoria`.
- **Restricciones:** un dorsal de 100, minutos de 130 o una fecha de fin anterior a la de inicio muestran el mensaje de Oracle del `CHECK` correspondiente.
- **Roles:** cada usuario trabaja con sus propios privilegios. Conectarse con un usuario que solo tenga `rol_auditor_torneo`
  y crear un registro muestra el error de privilegios insuficientes; con `rol_analista_deportivo`, solo se puede modificar
  sucesos, estadisticas e incidencias.

## Como probar rapido

1. Consultas > Tabla de posiciones: debe mostrar COL con 6 puntos.
2. Partidos > Registro de partidos > Programar partido: mismo estadio y 1 hora despues del partido 1 -> rechazado por el trigger.
3. Catalogos > Jugadores y cuerpo tecnico > Convocar jugador con dorsal 9 en la seleccion 1 -> rechazado (dorsal ocupado).
4. Catalogos > Ediciones > Eliminar la edicion 1 -> rechazado (tiene datos relacionados).
5. Reportes > elegir una consulta > Ejecutar.

## Notas de diseno

- Las pantallas de tablas usan un CRUD generico (`PanelCrud` + `RepositorioTabla`) descrito en `Catalogos`, en vez de una clase y un repositorio por entidad. Asi las 14 tablas comparten el mismo codigo.
- Los ids se calculan como `MAX + 1`, porque el modelo no usa secuencias.
- Las fechas se escriben como `aaaa-mm-dd` y las fechas con hora como `aaaa-mm-dd hh:mm`.
- Los errores de Oracle se muestran tal cual (por ejemplo `ORA-20015: La convocatoria ya esta completa`).
