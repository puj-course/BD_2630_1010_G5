-- ===============================================================
--  CARGA DE DATOS DE PRUEBA  -  ENTREGA 2
--  Sistema de Informacion para la Gestion Integral de la Copa Mundial de la FIFA
-- ===============================================================

-- ==============================================================
-- 1. TORNEO_MUNDIAL
-- ==============================================================

INSERT INTO TORNEO_MUNDIAL (id_edicion, anio, nombre, lema, fecha_inicio, fecha_fin) VALUES (1, 2026, 'Copa Mundial 2026', 'Un solo mundo, un solo balon', DATE '2026-06-11', DATE '2026-07-19');
INSERT INTO TORNEO_MUNDIAL (id_edicion, anio, nombre, lema, fecha_inicio, fecha_fin) VALUES (2, 2022, 'Copa Mundial 2022', 'Now is All', DATE '2022-11-20', DATE '2022-12-18');

-- ==============================================================
-- 2. ENTE_FUTBOLISTICO
-- Primero las confederaciones (sin padre) y luego las federaciones nacionales.
-- ==============================================================

INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (1, 'CONMEBOL', 'CONFEDERACION', 'Sudamerica', NULL);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (2, 'UEFA', 'CONFEDERACION', 'Europa', NULL);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (3, 'CAF', 'CONFEDERACION', 'Africa', NULL);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (4, 'AFC', 'CONFEDERACION', 'Asia', NULL);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (5, 'CONCACAF', 'CONFEDERACION', 'Norteamerica', NULL);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (11, 'Federacion Colombiana de Futbol', 'FEDERACION_NACIONAL', 'Colombia', 1);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (12, 'Asociacion del Futbol Argentino', 'FEDERACION_NACIONAL', 'Argentina', 1);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (13, 'Confederacion Brasilena de Futbol', 'FEDERACION_NACIONAL', 'Brasil', 1);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (21, 'Real Federacion Espanola de Futbol', 'FEDERACION_NACIONAL', 'Espana', 2);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (22, 'Federacion Francesa de Futbol', 'FEDERACION_NACIONAL', 'Francia', 2);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (31, 'Federacion Real Marroqui de Futbol', 'FEDERACION_NACIONAL', 'Marruecos', 3);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (41, 'Asociacion de Futbol de Japon', 'FEDERACION_NACIONAL', 'Japon', 4);
INSERT INTO ENTE_FUTBOLISTICO (id_organizacion, nombre, tipo, pais, id_organizacion_padre) VALUES (51, 'Federacion Mexicana de Futbol', 'FEDERACION_NACIONAL', 'Mexico', 5);

-- ==============================================================
-- 3. INTEGRANTE
-- Jugadores y tecnicos (11xx-18xx), arbitros (20xx), periodistas (30xx) y un administrador (4001).
-- ==============================================================

INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1101, 'Santiago Ramirez', 'Colombiana', DATE '1996-08-14');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1102, 'Juan Camilo Ortiz', 'Colombiana', DATE '2000-01-30');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1103, 'Felipe Cardenas', 'Colombiana', DATE '1997-11-05');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1104, 'Hernan Beltran', 'Colombiana', DATE '1971-05-22');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1201, 'Alvaro Navarro', 'Espanola', DATE '1997-04-19');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1202, 'Marcos Iglesias', 'Espanola', DATE '2001-09-03');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1203, 'Raul Cordero', 'Espanola', DATE '1995-12-27');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1204, 'Joaquin Vidal', 'Espanola', DATE '1969-02-08');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1301, 'Kenji Watanabe', 'Japonesa', DATE '1999-06-17');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1302, 'Haruto Nakamura', 'Japonesa', DATE '2002-03-25');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1303, 'Ryo Kobayashi', 'Japonesa', DATE '1996-10-09');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1304, 'Takeshi Morita', 'Japonesa', DATE '1970-07-14');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1401, 'Youssef Benali', 'Marroqui', DATE '1998-08-21');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1402, 'Karim Haddad', 'Marroqui', DATE '2000-05-11');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1403, 'Omar Tazi', 'Marroqui', DATE '1994-01-29');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1404, 'Mehdi Alaoui', 'Marroqui', DATE '1973-09-30');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1501, 'Facundo Benitez', 'Argentina', DATE '1996-02-07');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1502, 'Lautaro Gimenez', 'Argentina', DATE '1999-10-16');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1503, 'Nicolas Acosta', 'Argentina', DATE '1997-07-02');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1504, 'Esteban Molina', 'Argentina', DATE '1968-11-13');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1601, 'Antoine Girard', 'Francesa', DATE '1998-12-04');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1602, 'Theo Lefevre', 'Francesa', DATE '2001-02-19');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1603, 'Baptiste Roux', 'Francesa', DATE '1995-06-26');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1604, 'Philippe Dumont', 'Francesa', DATE '1966-04-03');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1701, 'Rodrigo Almeida', 'Brasilena', DATE '1997-09-12');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1702, 'Gabriel Nascimento', 'Brasilena', DATE '2000-12-01');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1703, 'Thiago Barbosa', 'Brasilena', DATE '1996-03-18');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1704, 'Marcelo Teixeira', 'Brasilena', DATE '1972-08-25');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1801, 'Emiliano Castillo', 'Mexicana', DATE '1999-01-15');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1802, 'Diego Valenzuela', 'Mexicana', DATE '2002-07-08');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1803, 'Jorge Pacheco', 'Mexicana', DATE '1995-05-31');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (1804, 'Armando Salinas', 'Mexicana', DATE '1970-10-19');

INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (2001, 'Anders Nilsson', 'Sueca', DATE '1984-02-11');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (2002, 'Felix Okafor', 'Nigeriana', DATE '1985-07-23');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (2003, 'Stefano Marchetti', 'Italiana', DATE '1983-10-05');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (2004, 'Paul Whitaker', 'Inglesa', DATE '1986-04-17');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (2005, 'Mikael Jensen', 'Danesa', DATE '1985-12-09');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (2006, 'Luis Paredes', 'Peruana', DATE '1987-03-28');

INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (3001, 'Valentina Cruz', 'Chilena', DATE '1991-05-14');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (3002, 'Andrea Lozano', 'Mexicana', DATE '1989-09-02');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (3003, 'Tomas Ferreyra', 'Uruguaya', DATE '1990-01-26');
INSERT INTO INTEGRANTE (id_persona, nombre_completo, nacionalidad, fecha_de_nacimiento) VALUES (4001, 'Administrador del Sistema', NULL, NULL);

-- ==============================================================
-- 4. PAIS_ANFITRION
-- ==============================================================

INSERT INTO PAIS_ANFITRION (id_sede, id_edicion, pais) VALUES (1, 1, 'Estados Unidos');
INSERT INTO PAIS_ANFITRION (id_sede, id_edicion, pais) VALUES (2, 1, 'Mexico');
INSERT INTO PAIS_ANFITRION (id_sede, id_edicion, pais) VALUES (3, 1, 'Canada');
INSERT INTO PAIS_ANFITRION (id_sede, id_edicion, pais) VALUES (4, 2, 'Catar');

-- ==============================================================
-- 5. FASE_TORNEO
-- Las fases padre se insertan antes que sus grupos e instancias.
-- ==============================================================

INSERT INTO FASE_TORNEO (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden) VALUES (1, 1, NULL, 'Fase de Grupos', 'FASE', 1);
INSERT INTO FASE_TORNEO (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden) VALUES (2, 1, 1, 'Grupo A', 'GRUPO', 1);
INSERT INTO FASE_TORNEO (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden) VALUES (3, 1, 1, 'Grupo B', 'GRUPO', 2);
INSERT INTO FASE_TORNEO (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden) VALUES (4, 1, NULL, 'Fase Eliminatoria', 'FASE', 2);
INSERT INTO FASE_TORNEO (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden) VALUES (5, 1, 4, 'Semifinal', 'INSTANCIA_ELIMINATORIA', 1);
INSERT INTO FASE_TORNEO (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden) VALUES (6, 1, 4, 'Tercer puesto', 'INSTANCIA_ELIMINATORIA', 2);
INSERT INTO FASE_TORNEO (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden) VALUES (7, 1, 4, 'Final', 'INSTANCIA_ELIMINATORIA', 3);

-- ==============================================================
-- 6. CREDENCIAL_MEDIOS
-- La columna conserva el nombre del DDL: medio_comunicacio.
-- ==============================================================

INSERT INTO CREDENCIAL_MEDIOS (id_acreditacion, id_persona, id_edicion, medio_comunicacio, fecha_emision, tipo_acreditacion, estado) VALUES (1, 3001, 1, 'Diario Cronica Deportiva', DATE '2026-05-28', 'PRENSA_ESCRITA', 'ACTIVA');
INSERT INTO CREDENCIAL_MEDIOS (id_acreditacion, id_persona, id_edicion, medio_comunicacio, fecha_emision, tipo_acreditacion, estado) VALUES (2, 3002, 1, 'Canal Estadio TV', DATE '2026-05-30', 'TELEVISION', 'ACTIVA');
INSERT INTO CREDENCIAL_MEDIOS (id_acreditacion, id_persona, id_edicion, medio_comunicacio, fecha_emision, tipo_acreditacion, estado) VALUES (3, 3003, 1, 'Radio Meridiano', DATE '2026-06-02', 'RADIO', 'PENDIENTE');

-- ==============================================================
-- 7. BITACORA_CAMBIOS
-- id_persona es opcional: puede ser NULL cuando el cambio lo hace un proceso automatico.
-- ==============================================================

INSERT INTO BITACORA_CAMBIOS (id_auditoria, id_persona, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora, valor_anterior, valor_nuevo) VALUES (1, 4001, 'USR_ADMIN', 'ENCUENTRO', 8, 'INSERT', TIMESTAMP '2026-05-20 09:15:00', NULL, 'Registro del partido de la final');
INSERT INTO BITACORA_CAMBIOS (id_auditoria, id_persona, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora, valor_anterior, valor_nuevo) VALUES (2, 4001, 'USR_ADMIN', 'ENCUENTRO', 8, 'UPDATE', TIMESTAMP '2026-07-19 20:45:00', 'estado=PROGRAMADO', 'estado=FINALIZADO');
INSERT INTO BITACORA_CAMBIOS (id_auditoria, id_persona, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora, valor_anterior, valor_nuevo) VALUES (3, NULL, 'USR_CARGA_DATOS', 'BOLETO', 24, 'UPDATE', TIMESTAMP '2026-07-10 12:30:00', 'estado=DISPONIBLE', 'estado=VENDIDO');
INSERT INTO BITACORA_CAMBIOS (id_auditoria, id_persona, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora, valor_anterior, valor_nuevo) VALUES (4, 4001, 'USR_ADMIN', 'PLANTEL_EQUIPO', 1, 'UPDATE', TIMESTAMP '2026-06-01 10:00:00', 'capitan=N', 'capitan=S');
INSERT INTO BITACORA_CAMBIOS (id_auditoria, id_persona, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora, valor_anterior, valor_nuevo) VALUES (5, 4001, 'USR_ADMIN', 'BOLETO', 99, 'DELETE', TIMESTAMP '2026-06-05 16:20:00', 'categoria=CATEGORIA_3;precio=70.00', NULL);

-- ==============================================================
-- 8. LOCALIDAD
-- ==============================================================

INSERT INTO LOCALIDAD (id_ciudad, id_sede, nombre) VALUES (1, 1, 'Nueva York');
INSERT INTO LOCALIDAD (id_ciudad, id_sede, nombre) VALUES (2, 1, 'Miami');
INSERT INTO LOCALIDAD (id_ciudad, id_sede, nombre) VALUES (3, 2, 'Ciudad de Mexico');
INSERT INTO LOCALIDAD (id_ciudad, id_sede, nombre) VALUES (4, 2, 'Guadalajara');
INSERT INTO LOCALIDAD (id_ciudad, id_sede, nombre) VALUES (5, 3, 'Toronto');
INSERT INTO LOCALIDAD (id_ciudad, id_sede, nombre) VALUES (6, 3, 'Vancouver');
INSERT INTO LOCALIDAD (id_ciudad, id_sede, nombre) VALUES (7, 4, 'Lusail');

-- ==============================================================
-- 9. EQUIPO_NACIONAL
-- La edicion se obtiene por id_etapa_grupo -> FASE_TORNEO. Grupo A = etapa 2, Grupo B = etapa 3.
-- ==============================================================

INSERT INTO EQUIPO_NACIONAL (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa) VALUES (1, 11, 2, 'COL');
INSERT INTO EQUIPO_NACIONAL (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa) VALUES (2, 21, 2, 'ESP');
INSERT INTO EQUIPO_NACIONAL (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa) VALUES (3, 41, 2, 'JPN');
INSERT INTO EQUIPO_NACIONAL (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa) VALUES (4, 31, 2, 'MAR');
INSERT INTO EQUIPO_NACIONAL (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa) VALUES (5, 12, 3, 'ARG');
INSERT INTO EQUIPO_NACIONAL (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa) VALUES (6, 22, 3, 'FRA');
INSERT INTO EQUIPO_NACIONAL (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa) VALUES (7, 13, 3, 'BRA');
INSERT INTO EQUIPO_NACIONAL (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa) VALUES (8, 51, 3, 'MEX');

-- ==============================================================
-- 10. RECINTO_DEPORTIVO
-- ==============================================================

INSERT INTO RECINTO_DEPORTIVO (id_estadio, id_ciudad, nombre, capacidad) VALUES (1, 1, 'Estadio Hudson Arena', 82000);
INSERT INTO RECINTO_DEPORTIVO (id_estadio, id_ciudad, nombre, capacidad) VALUES (2, 2, 'Estadio Bahia Azul', 65000);
INSERT INTO RECINTO_DEPORTIVO (id_estadio, id_ciudad, nombre, capacidad) VALUES (3, 3, 'Estadio Azteca Moderno', 87000);
INSERT INTO RECINTO_DEPORTIVO (id_estadio, id_ciudad, nombre, capacidad) VALUES (4, 4, 'Estadio Perla Tapatia', 48000);
INSERT INTO RECINTO_DEPORTIVO (id_estadio, id_ciudad, nombre, capacidad) VALUES (5, 5, 'Estadio Lago Ontario', 45000);
INSERT INTO RECINTO_DEPORTIVO (id_estadio, id_ciudad, nombre, capacidad) VALUES (6, 6, 'Estadio Pacifico', 54000);
INSERT INTO RECINTO_DEPORTIVO (id_estadio, id_ciudad, nombre, capacidad) VALUES (7, 7, 'Estadio Lusail Central', 88000);

-- ==============================================================
-- 11. PLANTEL_EQUIPO
-- Cada equipo: 3 jugadores (el primero es capitan) y su director tecnico.
-- ==============================================================

-- COL
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (1, 1101, 1, 'S', 9, 'DELANTERO', 'JUGADOR', 'Club Andino');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (2, 1102, 1, 'N', 10, 'MEDIOCAMPISTA', 'JUGADOR', 'Deportivo Capital');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (3, 1103, 1, 'N', 4, 'DEFENSA', 'JUGADOR', 'Atletico del Valle');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (4, 1104, 1, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);
-- ESP
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (5, 1201, 2, 'S', 9, 'DELANTERO', 'JUGADOR', 'Madrid Deportivo');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (6, 1202, 2, 'N', 8, 'MEDIOCAMPISTA', 'JUGADOR', 'Club Mediterraneo');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (7, 1203, 2, 'N', 3, 'DEFENSA', 'JUGADOR', 'Sevilla Union');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (8, 1204, 2, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);
-- JPN
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (9, 1301, 3, 'S', 11, 'DELANTERO', 'JUGADOR', 'Tokyo Stars');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (10, 1302, 3, 'N', 10, 'MEDIOCAMPISTA', 'JUGADOR', 'Osaka Blue');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (11, 1303, 3, 'N', 5, 'DEFENSA', 'JUGADOR', 'Nagoya FC');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (12, 1304, 3, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);
-- MAR
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (13, 1401, 4, 'S', 7, 'DELANTERO', 'JUGADOR', 'Casablanca Atletico');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (14, 1402, 4, 'N', 14, 'MEDIOCAMPISTA', 'JUGADOR', 'Rabat United');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (15, 1403, 4, 'N', 2, 'DEFENSA', 'JUGADOR', 'Fez Sport');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (16, 1404, 4, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);
-- ARG
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (17, 1501, 5, 'S', 10, 'DELANTERO', 'JUGADOR', 'Atletico del Plata');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (18, 1502, 5, 'N', 11, 'MEDIOCAMPISTA', 'JUGADOR', 'Buenos Aires FC');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (19, 1503, 5, 'N', 3, 'DEFENSA', 'JUGADOR', 'Rosario Central Norte');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (20, 1504, 5, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);
-- FRA
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (21, 1601, 6, 'S', 9, 'DELANTERO', 'JUGADOR', 'Paris Athletic');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (22, 1602, 6, 'N', 7, 'MEDIOCAMPISTA', 'JUGADOR', 'Lyon Sport');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (23, 1603, 6, 'N', 5, 'DEFENSA', 'JUGADOR', 'Marseille Olympic');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (24, 1604, 6, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);
-- BRA
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (25, 1701, 7, 'S', 9, 'DELANTERO', 'JUGADOR', 'Sao Paulo Atletico');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (26, 1702, 7, 'N', 10, 'MEDIOCAMPISTA', 'JUGADOR', 'Rio Carioca');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (27, 1703, 7, 'N', 4, 'DEFENSA', 'JUGADOR', 'Bahia Mar');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (28, 1704, 7, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);
-- MEX
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (29, 1801, 8, 'S', 9, 'DELANTERO', 'JUGADOR', 'Guadalajara Rojo');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (30, 1802, 8, 'N', 16, 'MEDIOCAMPISTA', 'JUGADOR', 'Monterrey Norte');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (31, 1803, 8, 'N', 6, 'DEFENSA', 'JUGADOR', 'Puebla Fuerte');
INSERT INTO PLANTEL_EQUIPO (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club) VALUES (32, 1804, 8, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);

-- ==============================================================
-- 12. ENCUENTRO
-- Partidos 1-4: fase de grupos. 5-6: semifinales. 7: tercer puesto (perdedores de 5 y 6). 8: final (ganadores de 5 y 6).
-- ==============================================================

-- Grupo A: Colombia - Japon
INSERT INTO ENCUENTRO (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2) VALUES (1, 2, 5, NULL, NULL, TO_DATE('2026-06-12 18:00', 'YYYY-MM-DD HH24:MI'), 43800, 'FINALIZADO', NULL, NULL);
-- Grupo A: Espana - Marruecos
INSERT INTO ENCUENTRO (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2) VALUES (2, 2, 3, NULL, NULL, TO_DATE('2026-06-12 21:00', 'YYYY-MM-DD HH24:MI'), 85600, 'FINALIZADO', NULL, NULL);
-- Grupo B: Argentina - Mexico
INSERT INTO ENCUENTRO (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2) VALUES (3, 3, 2, NULL, NULL, TO_DATE('2026-06-13 18:00', 'YYYY-MM-DD HH24:MI'), 63200, 'FINALIZADO', NULL, NULL);
-- Grupo B: Francia - Brasil
INSERT INTO ENCUENTRO (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2) VALUES (4, 3, 6, NULL, NULL, TO_DATE('2026-06-13 21:00', 'YYYY-MM-DD HH24:MI'), 52900, 'FINALIZADO', NULL, NULL);
-- Semifinal 1: Colombia - Francia
INSERT INTO ENCUENTRO (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2) VALUES (5, 5, 1, NULL, NULL, TO_DATE('2026-07-07 20:00', 'YYYY-MM-DD HH24:MI'), 81500, 'FINALIZADO', NULL, NULL);
-- Semifinal 2: Espana - Argentina
INSERT INTO ENCUENTRO (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2) VALUES (6, 5, 3, NULL, NULL, TO_DATE('2026-07-08 20:00', 'YYYY-MM-DD HH24:MI'), 86400, 'FINALIZADO', NULL, NULL);
-- Tercer puesto: Francia - Argentina
INSERT INTO ENCUENTRO (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2) VALUES (7, 6, 2, 5, 6, TO_DATE('2026-07-18 17:00', 'YYYY-MM-DD HH24:MI'), 64100, 'FINALIZADO', 'PERDEDOR', 'PERDEDOR');
-- Final: Colombia - Espana
INSERT INTO ENCUENTRO (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2) VALUES (8, 7, 1, 5, 6, TO_DATE('2026-07-19 18:00', 'YYYY-MM-DD HH24:MI'), 81900, 'FINALIZADO', 'GANADOR', 'GANADOR');

-- ==============================================================
-- 13. PARTICIPANTE_ENCUENTRO
-- Dos filas por partido (LOCAL y VISITANTE). goles_penales solo cuenta la tanda de penales.
-- ==============================================================

INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (1, 1, 1, 'LOCAL', 2, 0, 'GANO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (2, 1, 3, 'VISITANTE', 1, 0, 'PERDIO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (3, 2, 2, 'LOCAL', 1, 0, 'GANO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (4, 2, 4, 'VISITANTE', 0, 0, 'PERDIO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (5, 3, 5, 'LOCAL', 2, 0, 'GANO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (6, 3, 8, 'VISITANTE', 0, 0, 'PERDIO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (7, 4, 6, 'LOCAL', 1, 0, 'EMPATO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (8, 4, 7, 'VISITANTE', 1, 0, 'EMPATO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (9, 5, 1, 'LOCAL', 2, 0, 'GANO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (10, 5, 6, 'VISITANTE', 1, 0, 'PERDIO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (11, 6, 2, 'LOCAL', 1, 4, 'GANO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (12, 6, 5, 'VISITANTE', 1, 3, 'PERDIO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (13, 7, 6, 'LOCAL', 3, 0, 'GANO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (14, 7, 5, 'VISITANTE', 2, 0, 'PERDIO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (15, 8, 1, 'LOCAL', 2, 0, 'GANO');
INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado) VALUES (16, 8, 2, 'VISITANTE', 1, 0, 'PERDIO');

-- ==============================================================
-- 14. TERNA_ARBITRAL
-- Cada partido tiene cuatro arbitros con roles distintos, sin repetir persona.
-- ==============================================================

INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (1, 1, 2002, 'CENTRAL');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (2, 1, 2003, 'ASISTENTE_1');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (3, 1, 2004, 'ASISTENTE_2');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (4, 1, 2005, 'VAR');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (5, 2, 2003, 'CENTRAL');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (6, 2, 2004, 'ASISTENTE_1');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (7, 2, 2005, 'ASISTENTE_2');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (8, 2, 2006, 'VAR');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (9, 3, 2004, 'CENTRAL');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (10, 3, 2005, 'ASISTENTE_1');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (11, 3, 2006, 'ASISTENTE_2');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (12, 3, 2001, 'VAR');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (13, 4, 2005, 'CENTRAL');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (14, 4, 2006, 'ASISTENTE_1');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (15, 4, 2001, 'ASISTENTE_2');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (16, 4, 2002, 'VAR');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (17, 5, 2006, 'CENTRAL');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (18, 5, 2001, 'ASISTENTE_1');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (19, 5, 2002, 'ASISTENTE_2');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (20, 5, 2003, 'VAR');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (21, 6, 2001, 'CENTRAL');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (22, 6, 2002, 'ASISTENTE_1');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (23, 6, 2003, 'ASISTENTE_2');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (24, 6, 2004, 'VAR');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (25, 7, 2002, 'CENTRAL');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (26, 7, 2003, 'ASISTENTE_1');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (27, 7, 2004, 'ASISTENTE_2');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (28, 7, 2005, 'VAR');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (29, 8, 2003, 'CENTRAL');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (30, 8, 2004, 'ASISTENTE_1');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (31, 8, 2005, 'ASISTENTE_2');
INSERT INTO TERNA_ARBITRAL (id_asignacion, id_partido, id_persona, rol_arbitral) VALUES (32, 8, 2006, 'VAR');

-- ==============================================================
-- 15. SUCESO_ENCUENTRO
-- Los GOL de cada equipo coinciden con el marcador. En SUSTITUCION: id_persona sale e id_persona_relacionada entra.
-- ==============================================================

INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (1, 1, 1101, NULL, 'GOL', 23, NULL, 'Gol de Santiago Ramirez');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (2, 1, 1102, NULL, 'ASISTENCIA', 23, NULL, 'Pase de gol de Juan Camilo Ortiz');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (3, 1, 1102, NULL, 'GOL', 61, NULL, 'Gol de Juan Camilo Ortiz');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (4, 1, 1301, NULL, 'GOL', 78, NULL, 'Gol de Kenji Watanabe');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (5, 1, 1303, NULL, 'TARJETA_AMARILLA', 52, NULL, 'Amonestacion por falta tactica');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (6, 2, 1201, NULL, 'GOL', 55, NULL, 'Gol de Alvaro Navarro');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (7, 2, 1401, NULL, 'TARJETA_AMARILLA', 40, NULL, 'Protesta ante el arbitro');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (8, 3, 1501, NULL, 'GOL', 12, NULL, 'Gol de Facundo Benitez');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (9, 3, 1502, NULL, 'ASISTENCIA', 12, NULL, 'Pase de gol de Lautaro Gimenez');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (10, 3, 1502, NULL, 'GOL', 70, NULL, 'Gol de Lautaro Gimenez');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (11, 3, 1803, NULL, 'TARJETA_AMARILLA', 65, NULL, 'Falta por detras');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (12, 4, 1601, NULL, 'GOL', 34, NULL, 'Gol de Antoine Girard');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (13, 4, 1701, NULL, 'TARJETA_AMARILLA', 66, NULL, 'Juego brusco');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (14, 4, 1701, NULL, 'GOL', 80, NULL, 'Gol del empate de Rodrigo Almeida');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (15, 4, 1603, NULL, 'TARJETA_AMARILLA', 88, NULL, 'Perdida deliberada de tiempo');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (16, 5, 1101, NULL, 'GOL', 19, NULL, 'Gol de Santiago Ramirez');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (17, 5, 1601, NULL, 'GOL', 40, NULL, 'Gol de Antoine Girard');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (18, 5, 1602, NULL, 'TARJETA_AMARILLA', 58, NULL, 'Falta en mediocampo');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (19, 5, 1102, NULL, 'GOL', 64, NULL, 'Gol de Juan Camilo Ortiz');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (20, 5, 1103, NULL, 'ASISTENCIA', 64, NULL, 'Pase de gol de Felipe Cardenas');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (21, 6, 1201, NULL, 'GOL', 33, NULL, 'Gol de Alvaro Navarro');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (22, 6, 1501, NULL, 'TARJETA_AMARILLA', 75, NULL, 'Falta tactica');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (23, 6, 1501, NULL, 'GOL', 88, NULL, 'Gol del empate de Facundo Benitez');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (24, 6, 1201, NULL, 'MINUTOS_JUGADOS', NULL, 120, 'Disputo tiempo reglamentario y prorroga');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (25, 7, 1601, NULL, 'GOL', 9, NULL, 'Gol de Antoine Girard');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (26, 7, 1603, NULL, 'ASISTENCIA', 9, NULL, 'Pase de gol de Baptiste Roux');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (27, 7, 1501, NULL, 'GOL', 30, NULL, 'Gol de Facundo Benitez');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (28, 7, 1602, NULL, 'GOL', 51, NULL, 'Gol de Theo Lefevre');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (29, 7, 1601, NULL, 'GOL', 77, NULL, 'Segundo gol de Antoine Girard');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (30, 7, 1503, NULL, 'GOL', 85, NULL, 'Gol de Nicolas Acosta');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (31, 7, 1503, NULL, 'TARJETA_ROJA', 88, NULL, 'Expulsion por falta grave');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (32, 8, 1101, NULL, 'GOL', 27, NULL, 'Gol de Santiago Ramirez');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (33, 8, 1103, NULL, 'ASISTENCIA', 27, NULL, 'Pase de gol de Felipe Cardenas');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (34, 8, 1202, NULL, 'GOL', 58, NULL, 'Gol del empate de Marcos Iglesias');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (35, 8, 1202, NULL, 'TARJETA_AMARILLA', 63, NULL, 'Falta en mediocampo');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (36, 8, 1202, 1203, 'SUSTITUCION', 70, NULL, 'Cambio realizado por Espana');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (37, 8, 1102, NULL, 'GOL', 72, NULL, 'Gol definitivo de Juan Camilo Ortiz');
INSERT INTO SUCESO_ENCUENTRO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion) VALUES (38, 8, 1101, NULL, 'MINUTOS_JUGADOS', NULL, 90, 'Disputo todo el partido');

-- ==============================================================
-- 16. RENDIMIENTO_JUGADOR
-- Una fila por jugador y partido (3 jugadores por equipo). Goles, asistencias y tarjetas se derivan de SUCESO_ENCUENTRO.
-- ==============================================================

-- Partido 1
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (1, 1, 1101, 1, 0, 0, 0, 2, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (2, 1, 1102, 1, 1, 0, 0, 4, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (3, 1, 1103, 0, 0, 0, 0, 0, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (4, 1, 1301, 1, 0, 0, 0, 3, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (5, 1, 1302, 0, 0, 0, 0, 3, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (6, 1, 1303, 0, 0, 1, 0, 1, 90);
-- Partido 2
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (7, 2, 1201, 1, 0, 0, 0, 5, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (8, 2, 1202, 0, 0, 0, 0, 1, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (9, 2, 1203, 0, 0, 0, 0, 0, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (10, 2, 1401, 0, 0, 1, 0, 0, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (11, 2, 1402, 0, 0, 0, 0, 0, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (12, 2, 1403, 0, 0, 0, 0, 1, 90);
-- Partido 3
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (13, 3, 1501, 1, 0, 0, 0, 2, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (14, 3, 1502, 1, 1, 0, 0, 5, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (15, 3, 1503, 0, 0, 0, 0, 0, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (16, 3, 1801, 0, 0, 0, 0, 3, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (17, 3, 1802, 0, 0, 0, 0, 2, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (18, 3, 1803, 0, 0, 1, 0, 0, 90);
-- Partido 4
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (19, 4, 1601, 1, 0, 0, 0, 5, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (20, 4, 1602, 0, 0, 0, 0, 2, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (21, 4, 1603, 0, 0, 1, 0, 1, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (22, 4, 1701, 1, 0, 1, 0, 4, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (23, 4, 1702, 0, 0, 0, 0, 3, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (24, 4, 1703, 0, 0, 0, 0, 0, 90);
-- Partido 5
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (25, 5, 1101, 1, 0, 0, 0, 4, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (26, 5, 1102, 1, 0, 0, 0, 2, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (27, 5, 1103, 0, 1, 0, 0, 1, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (28, 5, 1601, 1, 0, 0, 0, 4, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (29, 5, 1602, 0, 0, 1, 0, 3, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (30, 5, 1603, 0, 0, 0, 0, 0, 90);
-- Partido 6
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (31, 6, 1201, 1, 0, 0, 0, 4, 120);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (32, 6, 1202, 0, 0, 0, 0, 0, 120);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (33, 6, 1203, 0, 0, 0, 0, 1, 120);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (34, 6, 1501, 1, 0, 1, 0, 4, 120);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (35, 6, 1502, 0, 0, 0, 0, 3, 120);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (36, 6, 1503, 0, 0, 0, 0, 1, 120);
-- Partido 7
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (37, 7, 1601, 2, 0, 0, 0, 4, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (38, 7, 1602, 1, 0, 0, 0, 5, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (39, 7, 1603, 0, 1, 0, 0, 1, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (40, 7, 1501, 1, 0, 0, 0, 2, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (41, 7, 1502, 0, 0, 0, 0, 3, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (42, 7, 1503, 1, 0, 0, 1, 3, 90);
-- Partido 8
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (43, 8, 1101, 1, 0, 0, 0, 5, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (44, 8, 1102, 1, 0, 0, 0, 4, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (45, 8, 1103, 0, 1, 0, 0, 1, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (46, 8, 1201, 0, 0, 0, 0, 3, 90);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (47, 8, 1202, 1, 0, 1, 0, 2, 70);
INSERT INTO RENDIMIENTO_JUGADOR (id_estadistica, id_partido, id_persona, goles, asistencias, tarjetas_amarillas, tarjetas_rojas, tiros, minutos_jugados) VALUES (48, 8, 1203, 0, 0, 0, 0, 0, 20);

-- ==============================================================
-- 17. NOVEDAD_ENCUENTRO
-- ==============================================================

INSERT INTO NOVEDAD_ENCUENTRO (id_incidencia, id_partido, tipo, descripcion, minuto) VALUES (1, 4, 'CLIMATICA', 'Lluvia intensa retrasa el inicio del partido 15 minutos', 0);
INSERT INTO NOVEDAD_ENCUENTRO (id_incidencia, id_partido, tipo, descripcion, minuto) VALUES (2, 2, 'TECNICA', 'Falla momentanea del sistema VAR durante una revision', 47);
INSERT INTO NOVEDAD_ENCUENTRO (id_incidencia, id_partido, tipo, descripcion, minuto) VALUES (3, 6, 'OTRA', 'El partido se define por penales: Espana 4 - Argentina 3', 120);
INSERT INTO NOVEDAD_ENCUENTRO (id_incidencia, id_partido, tipo, descripcion, minuto) VALUES (4, 7, 'DISCIPLINARIA', 'Expulsion de Nicolas Acosta (Argentina) por falta grave', 88);
INSERT INTO NOVEDAD_ENCUENTRO (id_incidencia, id_partido, tipo, descripcion, minuto) VALUES (5, 8, 'OTRA', 'Suspension breve del juego por ingreso de un espectador al campo', 35);

-- ==============================================================
-- 18. BOLETO
-- Tres categorias por partido. El precio sube en semifinales, tercer puesto y final.
-- ==============================================================

INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (1, 1, 'CATEGORIA_1', 'CENTRAL', 162.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (2, 1, 'CATEGORIA_2', 'LATERAL', 108.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (3, 1, 'CATEGORIA_3', 'TRIBUNA_ALTA', 90.00, 'DISPONIBLE');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (4, 2, 'CATEGORIA_1', 'CENTRAL', 162.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (5, 2, 'CATEGORIA_2', 'LATERAL', 108.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (6, 2, 'CATEGORIA_3', 'TRIBUNA_ALTA', 90.00, 'DISPONIBLE');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (7, 3, 'CATEGORIA_1', 'CENTRAL', 162.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (8, 3, 'CATEGORIA_2', 'LATERAL', 108.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (9, 3, 'CATEGORIA_3', 'TRIBUNA_ALTA', 90.00, 'DISPONIBLE');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (10, 4, 'CATEGORIA_1', 'CENTRAL', 162.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (11, 4, 'CATEGORIA_2', 'LATERAL', 108.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (12, 4, 'CATEGORIA_3', 'TRIBUNA_ALTA', 90.00, 'DISPONIBLE');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (13, 5, 'CATEGORIA_1', 'CENTRAL', 396.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (14, 5, 'CATEGORIA_2', 'LATERAL', 264.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (15, 5, 'CATEGORIA_3', 'TRIBUNA_ALTA', 220.00, 'DISPONIBLE');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (16, 6, 'CATEGORIA_1', 'CENTRAL', 396.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (17, 6, 'CATEGORIA_2', 'LATERAL', 264.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (18, 6, 'CATEGORIA_3', 'TRIBUNA_ALTA', 220.00, 'DISPONIBLE');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (19, 7, 'CATEGORIA_1', 'CENTRAL', 270.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (20, 7, 'CATEGORIA_2', 'LATERAL', 180.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (21, 7, 'CATEGORIA_3', 'TRIBUNA_ALTA', 150.00, 'DISPONIBLE');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (22, 8, 'CATEGORIA_1', 'CENTRAL', 1170.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (23, 8, 'CATEGORIA_2', 'LATERAL', 780.00, 'VENDIDO');
INSERT INTO BOLETO (id_entrada, id_partido, categoria, zona, precio, estado) VALUES (24, 8, 'CATEGORIA_3', 'TRIBUNA_ALTA', 650.00, 'VENDIDO');

COMMIT;
