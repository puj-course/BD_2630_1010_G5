-- ===============================================================
--  TABLAS
-- ===============================================================

CREATE TABLE TORNEO_MUNDIAL ( 
     id_edicion   INTEGER  NOT NULL , 
     anio         NUMBER  NOT NULL , 
     nombre       VARCHAR2 (100 CHAR)  NOT NULL , 
     lema         VARCHAR2 (200 CHAR) , 
     fecha_inicio DATE  NOT NULL , 
     fecha_fin    DATE  NOT NULL,
    
    CONSTRAINT edicion_fechas CHECK (fecha_fin > fecha_inicio)
    );

ALTER TABLE TORNEO_MUNDIAL 
    ADD CONSTRAINT TORNEO_MUNDIAL_PK PRIMARY KEY ( id_edicion ) ;

ALTER TABLE TORNEO_MUNDIAL 
    ADD CONSTRAINT anio UNIQUE ( anio ) ;

CREATE TABLE PAIS_ANFITRION ( 
     id_sede    INTEGER  NOT NULL , 
     id_edicion INTEGER  NOT NULL , 
     pais       VARCHAR2 (80 CHAR)  NOT NULL 
    );

ALTER TABLE PAIS_ANFITRION 
    ADD CONSTRAINT PAIS_ANFITRION_PK PRIMARY KEY ( id_sede ) ;

ALTER TABLE PAIS_ANFITRION 
    ADD CONSTRAINT Unique_Keyv1 UNIQUE ( pais , id_edicion ) ;

CREATE TABLE LOCALIDAD ( 
     id_ciudad INTEGER  NOT NULL , 
     id_sede   INTEGER  NOT NULL , 
     nombre    VARCHAR2 (80 CHAR)  NOT NULL 
    );

ALTER TABLE LOCALIDAD 
    ADD CONSTRAINT LOCALIDAD_PK PRIMARY KEY ( id_ciudad ) ;

ALTER TABLE LOCALIDAD 
    ADD CONSTRAINT Unique_Key UNIQUE ( id_sede , nombre ) ;

CREATE TABLE RECINTO_DEPORTIVO ( 
     id_estadio INTEGER  NOT NULL , 
     id_ciudad  INTEGER  NOT NULL , 
     nombre     VARCHAR2 (100 CHAR)  NOT NULL , 
     capacidad  INTEGER  NOT NULL,
    
    CONSTRAINT estadio_capacidad CHECK (capacidad > 0)
    );

ALTER TABLE RECINTO_DEPORTIVO 
    ADD CONSTRAINT RECINTO_DEPORTIVO_PK PRIMARY KEY ( id_estadio ) ;

ALTER TABLE RECINTO_DEPORTIVO 
    ADD CONSTRAINT Unique_Keyv4 UNIQUE ( nombre , id_ciudad ) ;

CREATE TABLE FASE_TORNEO ( 
     id_etapa       INTEGER  NOT NULL , 
     id_edicion     INTEGER  NOT NULL , 
     id_etapa_padre INTEGER , 
     nombre         VARCHAR2 (80 CHAR)  NOT NULL , 
     tipo_etapa     VARCHAR2 (40)  NOT NULL , 
     orden          INTEGER  NOT NULL,

     CONSTRAINT etapa_tipo CHECK (tipo_etapa IN ('FASE', 'GRUPO', 'INSTANCIA_ELIMINATORIA'))
    );

ALTER TABLE FASE_TORNEO 
    ADD CONSTRAINT FASE_TORNEO_PK PRIMARY KEY ( id_etapa ) ;

CREATE TABLE ENTE_FUTBOLISTICO ( 
     id_organizacion       INTEGER  NOT NULL , 
     nombre                VARCHAR2 (100 CHAR)  NOT NULL , 
     tipo                  VARCHAR2 (30 CHAR)  NOT NULL , 
     pais                  VARCHAR2 (80 CHAR)  NOT NULL , 
     id_organizacion_padre INTEGER,
    
    CONSTRAINT organizacion_tipo CHECK (tipo IN ('CONFEDERACION', 'FEDERACION_NACIONAL'))
    );

ALTER TABLE ENTE_FUTBOLISTICO 
    ADD CONSTRAINT ENTE_FUTBOLISTICO_PK PRIMARY KEY ( id_organizacion ) ;

CREATE TABLE EQUIPO_NACIONAL ( 
     id_seleccion    INTEGER  NOT NULL , 
     id_organizacion INTEGER  NOT NULL , 
     id_etapa_grupo  INTEGER  NOT NULL , 
     codigo_fifa     VARCHAR2 (3 CHAR)  NOT NULL 
    );

ALTER TABLE EQUIPO_NACIONAL 
    ADD CONSTRAINT EQUIPO_NACIONAL_PK PRIMARY KEY ( id_seleccion ) ;

CREATE TABLE INTEGRANTE ( 
     id_persona          INTEGER  NOT NULL , 
     nombre_completo     VARCHAR2 (120 CHAR)  NOT NULL , 
     nacionalidad        VARCHAR2 (80 CHAR) , 
     fecha_de_nacimiento DATE 
    );

ALTER TABLE INTEGRANTE 
    ADD CONSTRAINT INTEGRANTE_PK PRIMARY KEY ( id_persona ) ;

CREATE TABLE PLANTEL_EQUIPO ( 
     id_vinculacion INTEGER  NOT NULL , 
     id_persona     INTEGER  NOT NULL , 
     id_seleccion   INTEGER  NOT NULL , 
     capitan        CHAR (1 CHAR) , 
     dorsal         SMALLINT , 
     posicion       VARCHAR2 (30) , 
     rol            VARCHAR2 (30 CHAR)  NOT NULL , 
     club           VARCHAR2 (120 CHAR),

     CONSTRAINT vinculacion_rol CHECK (rol IN ('JUGADOR', 'DIRECTOR_TECNICO', 'ASISTENTE', 'PREPARADOR_FISICO')),
     CONSTRAINT vinculacion_dorsal CHECK (dorsal BETWEEN 1 AND 99)
    );

ALTER TABLE PLANTEL_EQUIPO 
    ADD CONSTRAINT PLANTEL_EQUIPO_PK PRIMARY KEY ( id_vinculacion ) ;

ALTER TABLE PLANTEL_EQUIPO 
    ADD CONSTRAINT Unique_Keyv2 UNIQUE ( id_seleccion , id_persona ) ;

CREATE TABLE ENCUENTRO( 
     id_partido            INTEGER  NOT NULL , 
     id_etapa              INTEGER  NOT NULL , 
     id_estadio            INTEGER  NOT NULL , 
     id_partido_origen_1   INTEGER , 
     id_partido_origen_2   INTEGER , 
     fecha_hora            DATE  NOT NULL , 
     asistencia_registrada INTEGER  NOT NULL , 
     estado                VARCHAR2 (30 CHAR)  NOT NULL , 
     resultado_origen_1    VARCHAR2 (20 CHAR) , 
     resultado_origen_2    VARCHAR2 (20 CHAR),
    
    CONSTRAINT partido_asistencia CHECK (asistencia_registrada >= 0)
    );

ALTER TABLE ENCUENTRO 
    ADD CONSTRAINT ENCUENTRO_PK PRIMARY KEY ( id_partido ) ;

CREATE TABLE PARTICIPANTE_ENCUENTRO( 
     id_participacion_partido INTEGER  NOT NULL , 
     id_partido               INTEGER  NOT NULL , 
     id_seleccion             INTEGER  NOT NULL , 
     condicion                VARCHAR2 (10 CHAR)  NOT NULL , 
     goles                    INTEGER  NOT NULL , 
     goles_penales            INTEGER  NOT NULL , 
     resultado                VARCHAR2 (10),
    
    CONSTRAINT partido_condicion CHECK (condicion IN ('LOCAL', 'VISITANTE')),
    CONSTRAINT part_goles CHECK (goles >= 0 AND goles_penales >= 0),
    CONSTRAINT part_resultado CHECK (resultado IN ('GANO', 'PERDIO', 'EMPATO'))
    );

ALTER TABLE PARTICIPANTE_ENCUENTRO 
    ADD CONSTRAINT PARTICIPANTE_ENCUENTRO_PK PRIMARY KEY ( id_participacion_partido ) ;

ALTER TABLE PARTICIPANTE_ENCUENTRO 
    ADD CONSTRAINT Unique_Key_1v2 UNIQUE ( id_seleccion , id_partido ) ;

ALTER TABLE PARTICIPANTE_ENCUENTRO 
    ADD CONSTRAINT Unique_Key_2v2 UNIQUE ( id_partido , condicion ) ;

CREATE TABLE TERNA_ARBITRAL ( 
     id_asignacion INTEGER  NOT NULL , 
     id_partido    INTEGER  NOT NULL , 
     id_persona    INTEGER  NOT NULL , 
     rol_arbitral  VARCHAR2 (40 CHAR)  NOT NULL,

     CONSTRAINT asignacion_rol CHECK (rol_arbitral IN ('CENTRAL', 'ASISTENTE_1', 'ASISTENTE_2', 'CUARTO_ARBITRO', 'VAR', 'AVAR'))
    );

ALTER TABLE TERNA_ARBITRAL 
    ADD CONSTRAINT TERNA_ARBITRAL_PK PRIMARY KEY ( id_asignacion ) ;

ALTER TABLE TERNA_ARBITRAL 
    ADD CONSTRAINT Unique_Key_1 UNIQUE (rol_arbitral , id_partido) ;

ALTER TABLE TERNA_ARBITRAL 
    ADD CONSTRAINT Unique_Key_2 UNIQUE (id_partido , id_persona) ;

CREATE TABLE SUCESO_ENCUENTRO ( 
     id_evento              INTEGER  NOT NULL , 
     id_partido             INTEGER  NOT NULL , 
     id_persona             INTEGER , 
     id_persona_relacionada INTEGER , 
     tipo_evento            VARCHAR2 (40 CHAR)  NOT NULL , 
     minuto                 SMALLINT , 
     valor_numerico         SMALLINT , 
     descripcion            VARCHAR2 (400 CHAR),

     CONSTRAINT evento_tipo CHECK (tipo_evento IN ('GOL', 'ASISTENCIA', 'TARJETA_AMARILLA', 'TARJETA_ROJA', 'SUSTITUCION', 'MINUTOS_JUGADOS'))
    );

ALTER TABLE SUCESO_ENCUENTRO 
    ADD CONSTRAINT SUCESO_ENCUENTRO_PK PRIMARY KEY ( id_evento ) ;

-- NUEVA: estadistica individual de cada jugador en cada partido
CREATE TABLE RENDIMIENTO_JUGADOR ( 
     id_estadistica     INTEGER  NOT NULL , 
     id_partido         INTEGER  NOT NULL , 
     id_persona         INTEGER  NOT NULL , 
     goles              INTEGER  DEFAULT 0 NOT NULL , 
     asistencias        INTEGER  DEFAULT 0 NOT NULL , 
     tarjetas_amarillas INTEGER  DEFAULT 0 NOT NULL , 
     tarjetas_rojas     INTEGER  DEFAULT 0 NOT NULL , 
     tiros              INTEGER  DEFAULT 0 NOT NULL , 
     minutos_jugados    INTEGER  DEFAULT 0 NOT NULL,

     CONSTRAINT estadistica_goles CHECK (goles >= 0),
     CONSTRAINT estadistica_asistencias CHECK (asistencias >= 0),
     CONSTRAINT estadistica_amarillas CHECK (tarjetas_amarillas >= 0),
     CONSTRAINT estadistica_rojas CHECK (tarjetas_rojas >= 0),
     CONSTRAINT estadistica_tiros CHECK (tiros >= 0),
     CONSTRAINT estadistica_minutos CHECK (minutos_jugados BETWEEN 0 AND 120)
    );

ALTER TABLE RENDIMIENTO_JUGADOR 
    ADD CONSTRAINT RENDIMIENTO_JUGADOR_PK PRIMARY KEY ( id_estadistica ) ;

ALTER TABLE RENDIMIENTO_JUGADOR 
    ADD CONSTRAINT Unique_Keyv5 UNIQUE ( id_partido , id_persona ) ;

-- NUEVA: incidencias operativas ocurridas durante un partido
CREATE TABLE NOVEDAD_ENCUENTRO ( 
     id_incidencia INTEGER  NOT NULL , 
     id_partido    INTEGER  NOT NULL , 
     tipo          VARCHAR2 (30 CHAR)  NOT NULL , 
     descripcion   VARCHAR2 (500 CHAR) , 
     minuto        SMALLINT,

     CONSTRAINT incidencia_tipo CHECK (tipo IN ('CLIMATICA', 'DISCIPLINARIA', 'TECNICA', 'OTRA')),
     CONSTRAINT incidencia_minuto CHECK (minuto >= 0)
    );

ALTER TABLE NOVEDAD_ENCUENTRO 
    ADD CONSTRAINT NOVEDAD_ENCUENTRO_PK PRIMARY KEY ( id_incidencia ) ;

CREATE TABLE BOLETO ( 
     id_entrada INTEGER  NOT NULL , 
     id_partido INTEGER  NOT NULL , 
     categoria  VARCHAR2 (30 CHAR)  NOT NULL , 
     zona       VARCHAR2 (50 CHAR)  NOT NULL , 
     precio     NUMBER (10,2)  NOT NULL , 
     estado     VARCHAR2 (20)  NOT NULL,

     CONSTRAINT entrada_precio CHECK (precio >= 0)
    );

ALTER TABLE BOLETO 
    ADD CONSTRAINT BOLETO_PK PRIMARY KEY ( id_entrada ) ;

CREATE TABLE CREDENCIAL_MEDIOS ( 
     id_acreditacion   INTEGER  NOT NULL , 
     id_persona        INTEGER  NOT NULL , 
     id_edicion        INTEGER  NOT NULL , 
     medio_comunicacio VARCHAR2 (120 CHAR)  NOT NULL , 
     fecha_emision     DATE  NOT NULL , 
     tipo_acreditacion VARCHAR2 (40 CHAR)  NOT NULL , 
     estado            VARCHAR2 (20 CHAR)  NOT NULL    
    );

ALTER TABLE CREDENCIAL_MEDIOS 
    ADD CONSTRAINT CREDENCIAL_MEDIOS_PK PRIMARY KEY ( id_acreditacion ) ;

-- BITACORA_CAMBIOS ahora se relaciona con INTEGRANTE (quien realizo el cambio)
CREATE TABLE BITACORA_CAMBIOS ( 
     id_auditoria         INTEGER  NOT NULL , 
     id_persona           INTEGER , 
     usuario_bd           VARCHAR2 (100 CHAR)  NOT NULL , 
     tabla_afectada       VARCHAR2 (50 CHAR)  NOT NULL , 
     id_registro_afectado INTEGER  NOT NULL , 
     operacion            VARCHAR2 (10 CHAR)  NOT NULL , 
     fecha_hora           TIMESTAMP  NOT NULL , 
     valor_anterior       CLOB , 
     valor_nuevo          CLOB,
    
    CONSTRAINT auditoria_operacion CHECK (operacion IN ('INSERT', 'UPDATE', 'DELETE'))
    );

ALTER TABLE BITACORA_CAMBIOS 
    ADD CONSTRAINT BITACORA_CAMBIOS_PK PRIMARY KEY ( id_auditoria ) ;

-- ===============================================================
--  LLAVES FORANEAS
--  (ON UPDATE RESTRICT en todas: los id son subrogados y no cambian)
-- ===============================================================

ALTER TABLE PAIS_ANFITRION 
    ADD CONSTRAINT tiene FOREIGN KEY 
    (id_edicion) 
    REFERENCES TORNEO_MUNDIAL 
    (id_edicion) 
    /* ON DELETE RESTRICT: no se elimina una edicion que tenga sedes asignadas. */
;

ALTER TABLE LOCALIDAD 
    ADD CONSTRAINT posee FOREIGN KEY 
    (id_sede) 
    REFERENCES PAIS_ANFITRION 
    (id_sede) 
    /* ON DELETE RESTRICT: no se elimina una sede que tenga ciudades registradas. */
;

ALTER TABLE RECINTO_DEPORTIVO 
    ADD CONSTRAINT dispone FOREIGN KEY 
    (id_ciudad) 
    REFERENCES LOCALIDAD 
    (id_ciudad) 
    /* ON DELETE RESTRICT: no se elimina una ciudad que tenga estadios. */
;

ALTER TABLE FASE_TORNEO 
    ADD CONSTRAINT cuenta_con FOREIGN KEY 
    (id_edicion) 
    REFERENCES TORNEO_MUNDIAL 
    (id_edicion)
    /* ON DELETE RESTRICT: no se eliminan ediciones que ya tienen etapas. */
;

ALTER TABLE FASE_TORNEO 
    ADD CONSTRAINT se_conforma FOREIGN KEY 
    (id_etapa_padre) 
    REFERENCES FASE_TORNEO 
    (id_etapa) 
    ON DELETE SET NULL
    /* ON DELETE SET NULL: si se elimina una etapa, las subetapas quedan sin padre. */
;

ALTER TABLE ENTE_FUTBOLISTICO 
    ADD CONSTRAINT se_forma_de FOREIGN KEY 
    (id_organizacion_padre) 
    REFERENCES ENTE_FUTBOLISTICO 
    (id_organizacion) 
    ON DELETE SET NULL
    /* ON DELETE SET NULL: si se disuelve una organizacion, las suborganizaciones quedan independientes. */
;

ALTER TABLE EQUIPO_NACIONAL 
    ADD CONSTRAINT representa FOREIGN KEY 
    (id_organizacion) 
    REFERENCES ENTE_FUTBOLISTICO 
    (id_organizacion) 
    /* ON DELETE RESTRICT: no se eliminan organizaciones que tengan selecciones. */
;

ALTER TABLE EQUIPO_NACIONAL 
    ADD CONSTRAINT agrupa FOREIGN KEY 
    (id_etapa_grupo) 
    REFERENCES FASE_TORNEO 
    (id_etapa) 
    /* ON DELETE RESTRICT: no se eliminan etapas que tengan selecciones asociadas. */
;

ALTER TABLE PLANTEL_EQUIPO 
    ADD CONSTRAINT crea FOREIGN KEY 
    (id_persona) 
    REFERENCES INTEGRANTE 
    (id_persona) 
    /* ON DELETE RESTRICT: no se elimina una persona vinculada a una seleccion. */
;

ALTER TABLE PLANTEL_EQUIPO 
    ADD CONSTRAINT vincula FOREIGN KEY 
    (id_seleccion) 
    REFERENCES EQUIPO_NACIONAL 
    (id_seleccion) 
    /* ON DELETE RESTRICT: no se elimina una seleccion que tenga personas vinculadas. */
;

ALTER TABLE ENCUENTRO 
    ADD CONSTRAINT alberga FOREIGN KEY 
    (id_estadio) 
    REFERENCES RECINTO_DEPORTIVO 
    (id_estadio) 
    /* ON DELETE RESTRICT: un estadio con partidos no debe borrarse por historial. */
;

ALTER TABLE ENCUENTRO 
    ADD CONSTRAINT contiene FOREIGN KEY 
    (id_etapa) 
    REFERENCES FASE_TORNEO 
    (id_etapa) 
    /* ON DELETE RESTRICT: no se elimina una etapa que ya tenga partidos. */
;

ALTER TABLE ENCUENTRO 
    ADD CONSTRAINT P2precede FOREIGN KEY 
    (id_partido_origen_1) 
    REFERENCES ENCUENTRO 
    (id_partido) 
    ON DELETE SET NULL
    /* ON DELETE SET NULL: si el partido previo se descarta, el siguiente queda sin origen 1. */
;

ALTER TABLE ENCUENTRO 
    ADD CONSTRAINT precede FOREIGN KEY 
    (id_partido_origen_2) 
    REFERENCES ENCUENTRO 
    (id_partido) 
    ON DELETE SET NULL
    /* ON DELETE SET NULL: si el partido previo se descarta, el siguiente queda sin origen 2. */
;

ALTER TABLE PARTICIPANTE_ENCUENTRO 
    ADD CONSTRAINT rellena FOREIGN KEY 
    (id_partido) 
    REFERENCES ENCUENTRO 
    (id_partido) 
    ON DELETE CASCADE 
    /* ON DELETE CASCADE: al eliminar un partido se eliminan sus participaciones. */
;

ALTER TABLE PARTICIPANTE_ENCUENTRO 
    ADD CONSTRAINT registra FOREIGN KEY 
    (id_seleccion) 
    REFERENCES EQUIPO_NACIONAL 
    (id_seleccion) 
    /* ON DELETE RESTRICT: no se elimina una seleccion con participaciones registradas. */
;

ALTER TABLE TERNA_ARBITRAL 
    ADD CONSTRAINT tienev2 FOREIGN KEY 
    (id_partido) 
    REFERENCES ENCUENTRO 
    (id_partido) 
    ON DELETE CASCADE
    /* ON DELETE CASCADE: al eliminar un partido se eliminan sus asignaciones arbitrales. */
;

ALTER TABLE TERNA_ARBITRAL 
    ADD CONSTRAINT es FOREIGN KEY 
    (id_persona) 
    REFERENCES INTEGRANTE 
    (id_persona) 
    /* ON DELETE RESTRICT: no se elimina una persona con asignaciones arbitrales. */
;

ALTER TABLE SUCESO_ENCUENTRO 
    ADD CONSTRAINT genera FOREIGN KEY 
    (id_partido) 
    REFERENCES ENCUENTRO 
    (id_partido)
    ON DELETE CASCADE
    /* ON DELETE CASCADE: al eliminar un partido se eliminan sus eventos. */
;

ALTER TABLE SUCESO_ENCUENTRO 
    ADD CONSTRAINT relaciona FOREIGN KEY 
    (id_persona) 
    REFERENCES INTEGRANTE 
    (id_persona) 
    /* ON DELETE RESTRICT: no se elimina una persona que protagoniza eventos. */
;

ALTER TABLE SUCESO_ENCUENTRO 
    ADD CONSTRAINT involucra FOREIGN KEY 
    (id_persona_relacionada) 
    REFERENCES INTEGRANTE 
    (id_persona)
    ON DELETE SET NULL
    /* ON DELETE SET NULL: el evento se conserva sin la persona relacionada. */
;

ALTER TABLE RENDIMIENTO_JUGADOR 
    ADD CONSTRAINT fk_estadistica_partido FOREIGN KEY 
    (id_partido) 
    REFERENCES ENCUENTRO 
    (id_partido)
    ON DELETE CASCADE
    /* ON DELETE CASCADE: al eliminar un partido se eliminan sus estadisticas. */
;

ALTER TABLE RENDIMIENTO_JUGADOR 
    ADD CONSTRAINT fk_estadistica_persona FOREIGN KEY 
    (id_persona) 
    REFERENCES INTEGRANTE 
    (id_persona)
    /* ON DELETE RESTRICT: no se elimina una persona con estadisticas registradas. */
;

ALTER TABLE NOVEDAD_ENCUENTRO 
    ADD CONSTRAINT fk_incidencia_partido FOREIGN KEY 
    (id_partido) 
    REFERENCES ENCUENTRO 
    (id_partido)
    ON DELETE CASCADE
    /* ON DELETE CASCADE: al eliminar un partido se eliminan sus incidencias. */
;

ALTER TABLE BOLETO 
    ADD CONSTRAINT tienev1 FOREIGN KEY 
    (id_partido) 
    REFERENCES ENCUENTRO 
    (id_partido) 
    ON DELETE CASCADE
    /* ON DELETE CASCADE: al eliminar un partido se eliminan sus entradas. */
;

ALTER TABLE CREDENCIAL_MEDIOS 
    ADD CONSTRAINT acredita FOREIGN KEY 
    (id_edicion) 
    REFERENCES TORNEO_MUNDIAL 
    (id_edicion) 
    /* ON DELETE RESTRICT: no se elimina una edicion con acreditaciones. */
;

ALTER TABLE CREDENCIAL_MEDIOS 
    ADD CONSTRAINT recibe FOREIGN KEY 
    (id_persona) 
    REFERENCES INTEGRANTE 
    (id_persona) 
    /* ON DELETE RESTRICT: se conserva el historial de acreditaciones de la persona. */
;

ALTER TABLE BITACORA_CAMBIOS 
    ADD CONSTRAINT fk_auditoria_persona FOREIGN KEY 
    (id_persona) 
    REFERENCES INTEGRANTE 
    (id_persona)
    ON DELETE SET NULL
    /* ON DELETE SET NULL: la bitacora se conserva aunque se elimine la persona. */
;

-- ===============================================================
--  INDICES
-- ===============================================================

CREATE INDEX idx_encuentro_fecha ON ENCUENTRO (fecha_hora);
/* Busquedas frecuentes por fecha u orden cronologico. */

CREATE INDEX idx_suceso_encuentro ON SUCESO_ENCUENTRO (id_partido);
/* Goles, tarjetas y tiempos de un partido. */

CREATE INDEX idx_boleto_encuentro_estado ON BOLETO (id_partido, estado);
/* Disponibilidad de entradas (disponibles o vendidas) por partido. */

CREATE INDEX idx_rendimiento_integrante ON RENDIMIENTO_JUGADOR (id_persona);
/* Estadisticas acumuladas de un jugador (goleadores, asistidores). */

CREATE INDEX idx_novedad_encuentro ON NOVEDAD_ENCUENTRO (id_partido);
/* Incidencias de un partido. */
