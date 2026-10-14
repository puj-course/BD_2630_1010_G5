-- Entrega 1 - DDL (modelo inicial, esquema MORENOLUIS)
-- Nota: Oracle no soporta ON UPDATE ni ON DELETE RESTRICT. Por eso:
--   * ON UPDATE: no se declara; las llaves primarias son subrogadas e inmutables
--     (equivale a RESTRICT).
--   * ON DELETE RESTRICT: se obtiene omitiendo la clausula (NO ACTION), que
--     rechaza el borrado si existen filas hijas.

------------------------------------------------------------------------
-- 1. EDICION_MUNDIAL
------------------------------------------------------------------------

CREATE TABLE FIFA_EDICION_MUNDIAL
    (id_edicion NUMBER(4),
    anio NUMBER(4) NOT NULL,
    pais_sede VARCHAR2(120) NOT NULL,
    lema VARCHAR2(200) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    PRIMARY KEY (id_edicion),

    CONSTRAINT anio_unico UNIQUE (anio),

    -- No hubo mundiales en 1942 ni 1946 (Segunda Guerra Mundial).
    CONSTRAINT min_anio_edicion
        CHECK (anio >= 1930 AND anio != 1942 AND anio != 1946),

    CONSTRAINT fecha_edicion CHECK (fecha_fin > fecha_inicio)
    );

------------------------------------------------------------------------
-- 2. ESTADIO: pertenece a una edicion.
------------------------------------------------------------------------

CREATE TABLE FIFA_ESTADIO
    (id_estadio NUMBER(10),
    id_edicion NUMBER(4) NOT NULL,
    nombre VARCHAR2(120) NOT NULL,
    ciudad VARCHAR2(80) NOT NULL,
    capacidad NUMBER(6) NOT NULL,
    PRIMARY KEY (id_estadio),

    CONSTRAINT edicion_nombre UNIQUE (id_edicion, nombre),

    CONSTRAINT capacidad_valida CHECK (capacidad BETWEEN 10000 AND 120000),

    -- JUSTIFICACION:
    -- ON DELETE: CASCADE, si se borra una edicion sus estadios pierden su contexto
    -- (son sedes de esa edicion) y no tiene sentido conservarlos.
    -- ON UPDATE: RESTRICT, id_edicion es PK subrogada y debe ser inmutable.
    CONSTRAINT fk_estadio_edicion FOREIGN KEY (id_edicion)
        REFERENCES FIFA_EDICION_MUNDIAL
        ON DELETE CASCADE
    );

------------------------------------------------------------------------
-- 3. SELECCION: participante de una edicion.
------------------------------------------------------------------------

CREATE TABLE FIFA_SELECCION
    (id_seleccion NUMBER(10),
    id_edicion NUMBER(4) NOT NULL,
    pais VARCHAR2(100) NOT NULL,
    confederacion VARCHAR2(20) NOT NULL,
    PRIMARY KEY (id_seleccion),

    CONSTRAINT edicion_pais UNIQUE (id_edicion, pais),

    CONSTRAINT confederacion_valida CHECK (
        confederacion IN ('AFC','CAF','CONCACAF','CONMEBOL','OFC','UEFA','OTRA')),

    -- JUSTIFICACION:
    -- ON DELETE: CASCADE, una seleccion existe solo como participante de una
    -- edicion; si la edicion se borra pierde su contexto.
    -- ON UPDATE: RESTRICT, id_edicion es PK subrogada y debe ser inmutable.
    CONSTRAINT fk_seleccion_edicion FOREIGN KEY (id_edicion)
        REFERENCES FIFA_EDICION_MUNDIAL
        ON DELETE CASCADE
    );

------------------------------------------------------------------------
-- 4. PARTIDO
------------------------------------------------------------------------

CREATE TABLE FIFA_PARTIDO
    (id_partido NUMBER(10),
    id_edicion NUMBER(4) NOT NULL,
    id_estadio NUMBER(10) NOT NULL,
    fecha_hora DATE NOT NULL,
    fase VARCHAR2(30) NOT NULL,
    asistencia_registrada NUMBER(6) DEFAULT 0 NOT NULL,
    PRIMARY KEY (id_partido),

    -- Un estadio no puede tener dos partidos en la misma fecha y hora.
    CONSTRAINT unico_partido UNIQUE (id_estadio, fecha_hora),

    CONSTRAINT asistencia_positiva CHECK (asistencia_registrada >= 0),

    CONSTRAINT fase_valida CHECK (
        fase IN ('Fase de Grupos','Dieciseisavos','Octavos','Cuartos',
                 'Semifinal','Tercer Puesto','Final')),

    -- JUSTIFICACION:
    -- ON DELETE: CASCADE, un partido no tiene sentido sin su edicion.
    -- ON UPDATE: RESTRICT, id_edicion es PK subrogada y debe ser inmutable.
    CONSTRAINT fk_partido_edicion FOREIGN KEY (id_edicion)
        REFERENCES FIFA_EDICION_MUNDIAL
        ON DELETE CASCADE,

    -- JUSTIFICACION:
    -- ON DELETE: RESTRICT (NO ACTION), no se puede borrar un estadio que ya tiene
    -- partidos registrados, para conservar el historial del torneo.
    -- ON UPDATE: RESTRICT, id_estadio es PK subrogada y debe ser inmutable.
    CONSTRAINT fk_partido_estadio FOREIGN KEY (id_estadio)
        REFERENCES FIFA_ESTADIO
    );

------------------------------------------------------------------------
-- 5. PARTICIPACION_PARTIDO: N:M entre PARTIDO y SELECCION.
------------------------------------------------------------------------

CREATE TABLE FIFA_PARTICIPACION_PARTIDO
    (id_participacion NUMBER(12),
    id_partido NUMBER(10) NOT NULL,
    id_seleccion NUMBER(10) NOT NULL,
    condicion VARCHAR2(10) NOT NULL,
    goles_marcados NUMBER(3) DEFAULT 0 NOT NULL,
    resultado VARCHAR2(7) NOT NULL,
    PRIMARY KEY (id_participacion),

    -- Una seleccion no puede participar dos veces en el mismo partido.
    CONSTRAINT partido_seleccion UNIQUE (id_partido, id_seleccion),

    -- Un partido no puede tener dos participaciones con la misma condicion.
    CONSTRAINT partido_condicion UNIQUE (id_partido, condicion),

    CONSTRAINT goles_positivos CHECK (goles_marcados BETWEEN 0 AND 99),

    CONSTRAINT condicion_valida CHECK (condicion IN ('local','visitante')),

    CONSTRAINT resultado_valido CHECK (resultado IN ('GANO','PERDIO','EMPATO')),

    -- JUSTIFICACION:
    -- ON DELETE: CASCADE, no tiene sentido guardar la participacion si se borra
    -- el partido.
    -- ON UPDATE: RESTRICT, id_partido es PK subrogada y debe ser inmutable.
    CONSTRAINT fk_participacion_partido FOREIGN KEY (id_partido)
        REFERENCES FIFA_PARTIDO
        ON DELETE CASCADE,

    -- JUSTIFICACION:
    -- ON DELETE: RESTRICT (NO ACTION), no se puede borrar una seleccion que ya
    -- ha jugado uno o mas partidos.
    -- ON UPDATE: RESTRICT, id_seleccion es PK subrogada y debe ser inmutable.
    CONSTRAINT fk_participacion_seleccion FOREIGN KEY (id_seleccion)
        REFERENCES FIFA_SELECCION
    );

-- ========================================================================
-- INDICES
-- ========================================================================
-- id_edicion en ESTADIO y SELECCION ya queda cubierto por los indices de
-- edicion_nombre y edicion_pais; id_estadio en PARTIDO por unico_partido.

CREATE INDEX indice_partido_edicion_fase
ON FIFA_PARTIDO (id_edicion, fase);

-- JUSTIFICACION:
-- Permite cargar los partidos de una edicion agrupados por fase (consultas 4 y 12)
-- y hace eficiente el borrado en cascada de los partidos si se borra el torneo.

CREATE INDEX indice_partic_seleccion
ON FIFA_PARTICIPACION_PARTIDO (id_seleccion);

-- JUSTIFICACION:
-- Facilita la consulta del historial y desempeño de una seleccion (partidos,
-- goles, victorias) sin recorrer las participaciones de los demas paises.
