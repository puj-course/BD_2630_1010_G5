-- ===============================================================
--  CARGA DE DATOS DE PRUEBA  -  ENTREGA 2
--  Sistema de Informacion para la Gestion Integral de la Copa Mundial de la FIFA
-- ===============================================================

-- ==============================================================
-- 1. TORNEO_MUNDIAL
-- ==============================================================

INSERT INTO TORNEO_MUNDIAL (id_edicion, anio, nombre, lema, fecha_inicio, fecha_fin) 
  VALUES (1, 2026, 'Copa Mundial 2026', 'Un solo mundo, un solo balon', DATE '2026-06-11', DATE '2026-07-19');
INSERT INTO TORNEO_MUNDIAL (id_edicion, anio, nombre, lema, fecha_inicio, fecha_fin) 
  VALUES (2, 2022, 'Copa Mundial 2022', 'Now is All', DATE '2022-11-20', DATE '2022-12-18');

-- ==============================================================
-- 2. ENTE_FUTBOLISTICO
-- Primero las confederaciones (sin padre) y luego las federaciones nacionales.
-- ==============================================================

INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) 
  VALUES (1, 'CONMEBOL', 'CONFEDERACION', 'Sudamerica', NULL);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) 
  VALUES (2, 'UEFA', 'CONFEDERACION', 'Europa', NULL);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) 
  VALUES (11, 'Federacion Colombiana de Futbol', 'FEDERACION_NACIONAL', 'Colombia', 1);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) 
  VALUES (12, 'Asociacion del Futbol Argentino', 'FEDERACION_NACIONAL', 'Argentina', 1);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) 
  VALUES (21, 'Real Federacion Espanola de Futbol', 'FEDERACION_NACIONAL', 'Espana', 2);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) 
  VALUES (22, 'Federacion Francesa de Futbol', 'FEDERACION_NACIONAL', 'Francia', 2);

-- ==============================================================
-- 3. INTEGRANTE
-- ==============================================================

INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (1101, 'Santiago Ramirez', 'Colombiana', DATE '1996-08-14');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (1102, 'Juan Camilo Ortiz', 'Colombiana', DATE '2000-01-30');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (1103, 'Hernan Beltran', 'Colombiana', DATE '1971-05-22');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (1201, 'Alvaro Navarro', 'Espanola', DATE '1997-04-19');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (1202, 'Marcos Iglesias', 'Espanola', DATE '2001-09-03');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (1203, 'Joaquin Vidal', 'Espanola', DATE '1969-02-08');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (1301, 'Facundo Benitez', 'Argentina', DATE '1996-02-07');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (1302, 'Lautaro Gimenez', 'Argentina', DATE '1999-10-16');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (1303, 'Esteban Molina', 'Argentina', DATE '1968-11-13');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (1401, 'Antoine Girard', 'Francesa', DATE '1998-12-04');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (1402, 'Theo Lefevre', 'Francesa', DATE '2001-02-19');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (1403, 'Philippe Dumont', 'Francesa', DATE '1966-04-03');

INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (2001, 'Anders Nilsson', 'Sueca', DATE '1984-02-11');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (2002, 'Felix Okafor', 'Nigeriana', DATE '1985-07-23');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (2003, 'Stefano Marchetti', 'Italiana', DATE '1983-10-05');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (2004, 'Paul Whitaker', 'Inglesa', DATE '1986-04-17');

INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (3001, 'Valentina Cruz', 'Chilena', DATE '1991-05-14');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (3002, 'Andrea Lozano', 'Mexicana', DATE '1989-09-02');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) 
  VALUES (4001, 'Administrador del Sistema', NULL, NULL);

-- ==============================================================
-- 4. PAIS_ANFITRION
-- ==============================================================

INSERT INTO PAIS_ANFITRION (id_sede, id_edicion, pais) 
  VALUES (1, 1, 'Estados Unidos');
INSERT INTO PAIS_ANFITRION (id_sede, id_edicion, pais) 
  VALUES (2, 1, 'Mexico');
INSERT INTO PAIS_ANFITRION (id_sede, id_edicion, pais) 
  VALUES (3, 2, 'Catar');

-- ==============================================================
-- 5. FASE_TORNEO
-- Las fases padre se insertan antes que sus grupos e instancias.
-- ==============================================================

INSERT INTO FASE_TORNEO (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden) 
  VALUES (1, 1, NULL, 'Fase de Grupos', 'FASE', 1);
INSERT INTO FASE_TORNEO (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden) 
  VALUES (2, 1, 1, 'Grupo A', 'GRUPO', 1);
INSERT INTO FASE_TORNEO (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden) 
  VALUES (3, 1, 1, 'Grupo B', 'GRUPO', 2);
INSERT INTO FASE_TORNEO (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden) 
  VALUES (4, 1, NULL, 'Fase Eliminatoria', 'FASE', 2);
INSERT INTO FASE_TORNEO (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden) 
  VALUES (5, 1, 4, 'Semifinal', 'INSTANCIA_ELIMINATORIA', 1);
INSERT INTO FASE_TORNEO (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden) 
  VALUES (6, 1, 4, 'Final', 'INSTANCIA_ELIMINATORIA', 2);

-- ==============================================================
-- 6. CREDENCIAL_MEDIOS
-- ==============================================================

INSERT INTO CREDENCIAL_MEDIOS (id_acreditacion, id_persona, id_edicion, medio_comunicacio, fecha_emision, tipo_acreditacion, estado) 
  VALUES (1, 3001, 1, 'Diario Cronica Deportiva', DATE '2026-05-28', 'PRENSA_ESCRITA', 'ACTIVA');
INSERT INTO CREDENCIAL_MEDIOS (id_acreditacion, id_persona, id_edicion, medio_comunicacio, fecha_emision, tipo_acreditacion, estado) 
  VALUES (2, 3002, 1, 'Canal Estadio TV', DATE '2026-05-30', 'TELEVISION', 'PENDIENTE');

-- ==============================================================
-- 7. BITACORA_CAMBIOS
-- ==============================================================

INSERT INTO BITACORA_CAMBIOS (id_auditoria, id_persona, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora, valor_anterior, valor_nuevo)
  VALUES (1, 4001, 'USR_ADMIN', 'ENCUENTRO', 3, 'INSERT', TIMESTAMP '2026-05-20 09:15:00', NULL, 'Registro del partido de la final');
INSERT INTO BITACORA_CAMBIOS (id_auditoria, id_persona, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora, valor_anterior, valor_nuevo) 
  VALUES (2, 4001, 'USR_ADMIN', 'ENCUENTRO', 3, 'UPDATE', TIMESTAMP '2026-07-19 20:45:00', 'estado=PROGRAMADO', 'estado=FINALIZADO');
INSERT INTO BITACORA_CAMBIOS (id_auditoria, id_persona, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora, valor_anterior, valor_nuevo) 
  VALUES (3, NULL, 'USR_CARGA_DATOS', 'BOLETO', 6, 'UPDATE', TIMESTAMP '2026-07-10 12:30:00', 'estado=DISPONIBLE', 'estado=VENDIDO');

-- ==============================================================
-- 8. LOCALIDAD
-- ==============================================================

INSERT INTO LOCALIDAD (id_ciudad, id_sede, nombre) VALUES (1, 1, 'Nueva York');
INSERT INTO LOCALIDAD (id_ciudad, id_sede, nombre) VALUES (2, 1, 'Miami');
INSERT INTO LOCALIDAD (id_ciudad, id_sede, nombre) VALUES (3, 2, 'Ciudad de Mexico');
INSERT INTO LOCALIDAD (id_ciudad, id_sede, nombre) VALUES (4, 3, 'Lusail');

-- ==============================================================
-- 9. EQUIPO_NACIONAL
-- ==============================================================

INSERT INTO EQUIPO_NACIONAL (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa) 
  VALUES (1, 11, 2, 'COL');
INSERT INTO EQUIPO_NACIONAL (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa) 
  VALUES (2, 21, 2, 'ESP');
INSERT INTO EQUIPO_NACIONAL (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa) 
  VALUES (3, 12, 3, 'ARG');
INSERT INTO EQUIPO_NACIONAL (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa) 
  VALUES (4, 22, 3, 'FRA');

-- ==============================================================
-- 10. RECINTO_DEPORTIVO
-- ==============================================================

INSERT INTO RECINTO_DEPORTIVO (id_estadio, id_ciudad, nombre, capacidad) 
  VALUES (1, 1, 'Estadio Hudson Arena', 82000);
INSERT INTO RECINTO_DEPORTIVO (id_estadio, id_ciudad, nombre, capacidad) 
  VALUES (2, 2, 'Estadio Bahia Azul', 65000);
INSERT INTO RECINTO_DEPORTIVO (id_estadio, id_ciudad, nombre, capacidad) 
  VALUES (3, 3, 'Estadio Azteca Moderno', 87000);
INSERT INTO RECINTO_DEPORTIVO (id_estadio, id_ciudad, nombre, capacidad) 
  VALUES (4, 4, 'Estadio Lusail Central', 88000);

-- ==============================================================
-- 11. PLANTEL_EQUIPO
-- Cada equipo: 2 jugadores (el primero es capitan) y su director tecnico.
-- ==============================================================

-- COL
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) 
  VALUES (1, 1101, 1, 'S', 9, 'DELANTERO', 'JUGADOR', 'Club Andino');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) 
  VALUES (2, 1102, 1, 'N', 10, 'MEDIOCAMPISTA', 'JUGADOR', 'Deportivo Capital');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) 
  VALUES (3, 1103, 1, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);
-- ESP
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) 
  VALUES (4, 1201, 2, 'S', 9, 'DELANTERO', 'JUGADOR', 'Madrid Deportivo');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) 
  VALUES (5, 1202, 2, 'N', 8, 'MEDIOCAMPISTA', 'JUGADOR', 'Club Mediterraneo');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) 
  VALUES (6, 1203, 2, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);
-- ARG
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) 
  VALUES (7, 1301, 3, 'S', 10, 'DELANTERO', 'JUGADOR', 'Atletico del Plata');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) 
  VALUES (8, 1302, 3, 'N', 11, 'MEDIOCAMPISTA', 'JUGADOR', 'Buenos Aires FC');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) 
  VALUES (9, 1303, 3, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);
-- FRA
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) 
  VALUES (10, 1401, 4, 'S', 9, 'DELANTERO', 'JUGADOR', 'Paris Athletic');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) 
  VALUES (11, 1402, 4, 'N', 7, 'MEDIOCAMPISTA', 'JUGADOR', 'Lyon Sport');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) 
  VALUES (12, 1403, 4, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);

-- ==============================================================
-- 12. ENCUENTRO
-- Partidos 1 y 2: semifinales. Partido 3: final (ganadores de 1 y 2).
-- ==============================================================

-- Semifinal 1: Colombia - Francia
INSERT INTO ENCUENTRO (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2) 
  VALUES (1, 5, 2, NULL, NULL, TO_DATE('2026-07-07 20:00', 'YYYY-MM-DD HH24:MI'), 63200, 'FINALIZADO', NULL, NULL);
-- Semifinal 2: Espana - Argentina
INSERT INTO ENCUENTRO (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2) 
  VALUES (2, 5, 3, NULL, NULL, TO_DATE('2026-07-08 20:00', 'YYYY-MM-DD HH24:MI'), 86400, 'FINALIZADO', NULL, NULL);
-- Final: Colombia - Espana
INSERT INTO ENCUENTRO (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2) 
  VALUES (3, 6, 1, 1, 2, TO_DATE('2026-07-19 18:00', 'YYYY-MM-DD HH24:MI'), 81900, 'FINALIZADO', 'GANADOR', 'GANADOR');

-- ==============================================================
-- 13. PARTICIPANTE_ENCUENTRO
-- Dos filas por partido (LOCAL y VISITANTE). goles_penales solo cuenta la tanda de penales.
-- ==============================================================

INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) 
  VALUES (1, 1, 1, 'LOCAL', 2, 0, 'GANO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) 
  VALUES (2, 1, 4, 'VISITANTE', 1, 0, 'PERDIO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) 
  VALUES (3, 2, 2, 'LOCAL', 1, 4, 'GANO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) 
  VALUES (4, 2, 3, 'VISITANTE', 1, 3, 'PERDIO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) 
  VALUES (5, 3, 1, 'LOCAL', 2, 0, 'GANO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) 
  VALUES (6, 3, 2, 'VISITANTE', 1, 0, 'PERDIO');

-- ==============================================================
-- 14. TERNA_ARBITRAL
-- Cada partido tiene tres arbitros con roles distintos, sin repetir persona.
-- ==============================================================

INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) 
  VALUES (1, 1, 2002, 'CENTRAL');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) 
  VALUES (2, 1, 2003, 'ASISTENTE_1');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) 
  VALUES (3, 1, 2004, 'VAR');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) 
  VALUES (4, 2, 2003, 'CENTRAL');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) 
  VALUES (5, 2, 2004, 'ASISTENTE_1');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) 
  VALUES (6, 2, 2001, 'VAR');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) 
  VALUES (7, 3, 2004, 'CENTRAL');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) 
  VALUES (8, 3, 2001, 'ASISTENTE_1');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) 
  VALUES (9, 3, 2002, 'VAR');

-- ==============================================================
-- 15. SUCESO_ENCUENTRO
-- Los GOL de cada equipo coinciden con el marcador.
-- ==============================================================

INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (1, 1, 1101, NULL, 'GOL', 19, NULL, 'Gol de Santiago Ramirez');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (2, 1, 1401, NULL, 'GOL', 40, NULL, 'Gol de Antoine Girard');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (3, 1, 1402, NULL, 'TARJETA_AMARILLA', 58, NULL, 'Falta en mediocampo');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (4, 1, 1102, NULL, 'GOL', 64, NULL, 'Gol de Juan Camilo Ortiz');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (5, 1, 1101, NULL, 'ASISTENCIA', 64, NULL, 'Pase de gol de Santiago Ramirez');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (6, 2, 1201, NULL, 'GOL', 33, NULL, 'Gol de Alvaro Navarro');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (7, 2, 1301, NULL, 'TARJETA_AMARILLA', 75, NULL, 'Falta tactica');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (8, 2, 1301, NULL, 'GOL', 88, NULL, 'Gol del empate de Facundo Benitez');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (9, 2, 1201, NULL, 'MINUTOS_JUGADOS', NULL, 120, 'Disputo tiempo reglamentario y prorroga');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (10, 3, 1101, NULL, 'GOL', 27, NULL, 'Gol de Santiago Ramirez');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (11, 3, 1102, NULL, 'ASISTENCIA', 27, NULL, 'Pase de gol de Juan Camilo Ortiz');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (12, 3, 1202, NULL, 'GOL', 58, NULL, 'Gol del empate de Marcos Iglesias');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (13, 3, 1202, NULL, 'TARJETA_AMARILLA', 63, NULL, 'Falta en mediocampo');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (14, 3, 1102, NULL, 'GOL', 72, NULL, 'Gol definitivo de Juan Camilo Ortiz');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) 
  VALUES (15, 3, 1101, NULL, 'MINUTOS_JUGADOS', NULL, 90, 'Disputo todo el partido');

-- ==============================================================
-- 16. RENDIMIENTO_JUGADOR
-- Una fila por jugador y partido (2 jugadores por equipo). Goles, asistencias y tarjetas se derivan de SUCESO_ENCUENTRO.
-- ==============================================================

-- Partido 1
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) 
  VALUES (1, 1, 1101, 1, 1, 0, 0, 2, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) 
  VALUES (2, 1, 1102, 1, 0, 0, 0, 4, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) 
  VALUES (3, 1, 1401, 1, 0, 0, 0, 2, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) 
  VALUES (4, 1, 1402, 0, 0, 1, 0, 1, 90);
-- Partido 2
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) 
  VALUES (5, 2, 1201, 1, 0, 0, 0, 5, 120);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) 
  VALUES (6, 2, 1202, 0, 0, 0, 0, 3, 120);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) 
  VALUES (7, 2, 1301, 1, 0, 1, 0, 5, 120);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) 
  VALUES (8, 2, 1302, 0, 0, 0, 0, 1, 120);
-- Partido 3
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) 
  VALUES (9, 3, 1101, 1, 0, 0, 0, 2, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) 
  VALUES (10, 3, 1102, 1, 1, 0, 0, 2, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) 
  VALUES (11, 3, 1201, 0, 0, 0, 0, 0, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) 
  VALUES (12, 3, 1202, 1, 0, 1, 0, 4, 90);

-- ==============================================================
-- 17. NOVEDAD_ENCUENTRO
-- ==============================================================

INSERT INTO NOVEDAD_ENCUENTRO (id_incidencia, id_partido, tipo, descripcion, minuto) 
  VALUES (1, 1, 'CLIMATICA', 'Lluvia intensa retrasa el inicio del partido 15 minutos', 0);
INSERT INTO NOVEDAD_ENCUENTRO (id_incidencia, id_partido, tipo, descripcion, minuto) 
  VALUES (2, 2, 'OTRA', 'El partido se define por penales: Espana 4 - Argentina 3', 120);
INSERT INTO NOVEDAD_ENCUENTRO (id_incidencia, id_partido, tipo, descripcion, minuto) 
  VALUES (3, 3, 'TECNICA', 'Falla momentanea del sistema VAR durante una revision', 47);

-- ==============================================================
-- 18. BOLETO
-- Dos categorias por partido. El precio sube en la final.
-- ==============================================================

INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) 
  VALUES (1, 1, 'CATEGORIA_1', 'CENTRAL', 396.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) 
  VALUES (2, 1, 'CATEGORIA_2', 'LATERAL', 264.00, 'DISPONIBLE');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) 
  VALUES (3, 2, 'CATEGORIA_1', 'CENTRAL', 396.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) 
  VALUES (4, 2, 'CATEGORIA_2', 'LATERAL', 264.00, 'DISPONIBLE');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) 
  VALUES (5, 3, 'CATEGORIA_1', 'CENTRAL', 1170.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) 
  VALUES (6, 3, 'CATEGORIA_2', 'LATERAL', 780.00, 'VENDIDO');

COMMIT;

