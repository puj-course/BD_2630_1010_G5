# Mundial App - Entrega 3

Aplicacion (Java Swing + JDBC) para el Sistema de Informacion de la Copa Mundial de la FIFA.
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
