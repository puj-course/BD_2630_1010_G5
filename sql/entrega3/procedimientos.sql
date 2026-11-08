-- 1. Registrar el resultado de un partido

CREATE OR REPLACE PROCEDURE sp_registrar_resultado (
    p_id_partido        IN NUMBER,
    p_goles_local       IN NUMBER,
    p_goles_visitante   IN NUMBER,
    p_penales_local     IN NUMBER DEFAULT 0,
    p_penales_visitante IN NUMBER DEFAULT 0
) IS
    v_existe        NUMBER;
    v_estado        encuentro.estado%TYPE;
    v_participantes NUMBER;
    v_res_local     VARCHAR2(10);
    v_res_visitante VARCHAR2(10);
BEGIN
    -- 1. El partido debe existir
    SELECT COUNT(*) INTO v_existe
    FROM encuentro
    WHERE id_partido = p_id_partido;

    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'El partido no existe');
    END IF;

    -- 2. Debe tener un local y un visitante
    SELECT COUNT(*) INTO v_participantes
    FROM participante_encuentro
    WHERE id_partido = p_id_partido
      AND condicion IN ('LOCAL', 'VISITANTE');

    IF v_participantes <> 2 THEN
        RAISE_APPLICATION_ERROR(-20011, 'El partido debe tener un local y un visitante');
    END IF;

    -- 3. Los goles no pueden ser nulos ni negativos
    IF p_goles_local IS NULL OR p_goles_visitante IS NULL
       OR p_penales_local IS NULL OR p_penales_visitante IS NULL
       OR p_goles_local < 0 OR p_goles_visitante < 0
       OR p_penales_local < 0 OR p_penales_visitante < 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Los goles no pueden ser nulos ni negativos');
    END IF;

    -- 4. No se puede cerrar dos veces un partido
    SELECT estado INTO v_estado
    FROM encuentro
    WHERE id_partido = p_id_partido;

    IF v_estado = 'FINALIZADO' THEN
        RAISE_APPLICATION_ERROR(-20013, 'El partido ya está finalizado');
    END IF;

    -- Calcular el resultado de cada equipo
    IF p_goles_local > p_goles_visitante THEN
        v_res_local := 'GANO';
        v_res_visitante := 'PERDIO';
    ELSIF p_goles_local < p_goles_visitante THEN
        v_res_local := 'PERDIO';
        v_res_visitante := 'GANO';
    ELSIF p_penales_local > p_penales_visitante THEN
        v_res_local := 'GANO';
        v_res_visitante := 'PERDIO';
    ELSIF p_penales_local < p_penales_visitante THEN
        v_res_local := 'PERDIO';
        v_res_visitante := 'GANO';
    ELSE
        v_res_local := 'EMPATO';
        v_res_visitante := 'EMPATO';
    END IF;

    -- Guardar marcador y resultado de cada equipo
    UPDATE participante_encuentro
    SET goles = p_goles_local,
        goles_penales = p_penales_local,
        resultado = v_res_local
    WHERE id_partido = p_id_partido
      AND condicion = 'LOCAL';

    UPDATE participante_encuentro
    SET goles = p_goles_visitante,
        goles_penales = p_penales_visitante,
        resultado = v_res_visitante
    WHERE id_partido = p_id_partido
      AND condicion = 'VISITANTE';

    -- Finalizar el partido
    UPDATE encuentro
    SET estado = 'FINALIZADO'
    WHERE id_partido = p_id_partido;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END sp_registrar_resultado;
/

-- un partido nuevo (50) entre las selecciones 1 y 2, sin marcador
INSERT INTO encuentro (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2, fecha_hora, asistencia_registrada, estado)
VALUES (50, 5, 2, NULL, NULL, TO_DATE('2026-07-30 20:00', 'YYYY-MM-DD HH24:MI'), 0, 'PROGRAMADO');
INSERT INTO participante_encuentro (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales)
VALUES (50, 50, 1, 'LOCAL', 0, 0);
INSERT INTO participante_encuentro (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales)
VALUES (51, 50, 2, 'VISITANTE', 0, 0);

-- el local gana 3-1  [DEBE FUNCIONAR]
BEGIN
    sp_registrar_resultado(50, 3, 1);
END;
/

SELECT e.estado, pe.condicion, pe.goles, pe.goles_penales, pe.resultado
FROM encuentro e
JOIN participante_encuentro pe ON pe.id_partido = e.id_partido
WHERE e.id_partido = 50;

-- cerrar de nuevo el mismo partido  [DEBE FALLAR]
BEGIN
    sp_registrar_resultado(50, 2, 2);
END;
/

-- partido que no existe  [DEBE FALLAR]
BEGIN
    sp_registrar_resultado(9999, 1, 0);
END;
/

-- goles negativos  [DEBE FALLAR]
BEGIN
    sp_registrar_resultado(1, -1, 0);
END;
/

-- 2. Convocar un jugador a una seleccion

CREATE OR REPLACE PROCEDURE sp_convocar_jugador (
    p_id_seleccion IN NUMBER,
    p_id_persona   IN NUMBER,
    p_dorsal       IN NUMBER,
    p_posicion     IN VARCHAR2 DEFAULT NULL,
    p_capitan      IN CHAR     DEFAULT 'N',
    p_club         IN VARCHAR2 DEFAULT NULL
) IS
    v_sel     NUMBER;
    v_per     NUMBER;
    v_id_nuevo NUMBER;
BEGIN
    -- 1. La seleccion y la persona deben existir
    SELECT COUNT(*) INTO v_sel
    FROM equipo_nacional
    WHERE id_seleccion = p_id_seleccion;

    SELECT COUNT(*) INTO v_per
    FROM integrante
    WHERE id_persona = p_id_persona;

    IF v_sel = 0 OR v_per = 0 THEN
        RAISE_APPLICATION_ERROR(-20014, 'La selección o la persona no existe');
    END IF;

    -- 2. Debe haber cupo
    IF fn_validar_cupo_convocatoria(p_id_seleccion) = 0 THEN
        RAISE_APPLICATION_ERROR(-20015, 'La convocatoria ya está completa');
    END IF;

    -- 3. El dorsal debe estar libre
    IF fn_verificar_dorsal_disponible(p_id_seleccion, p_dorsal) = 0 THEN
        RAISE_APPLICATION_ERROR(-20016, 'El dorsal ya está asignado en esta selección');
    END IF;

    -- 4. Insertar (se toma el siguiente id)
    SELECT NVL(MAX(id_vinculacion), 0) + 1 INTO v_id_nuevo
    FROM plantel_equipo;

    INSERT INTO plantel_equipo (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club)
    VALUES (v_id_nuevo, p_id_persona, p_id_seleccion, p_capitan, p_dorsal, p_posicion, 'JUGADOR', p_club);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END sp_convocar_jugador;
/

-- convocar a la persona 2001 a la seleccion 1 con el dorsal 11  [DEBE FUNCIONAR]
BEGIN
    sp_convocar_jugador(1, 2001, 11, 'DELANTERO');
END;
/

SELECT id_vinculacion, id_persona, id_seleccion, dorsal, rol
FROM plantel_equipo
WHERE id_seleccion = 1;

-- Prueba de error: dorsal 11 ya ocupado en la seleccion 1  [DEBE FALLAR]
BEGIN
    sp_convocar_jugador(1, 2002, 11, 'DEFENSA');
END;
/

--seleccion que no existe  [DEBE FALLAR]
BEGIN
    sp_convocar_jugador(9999, 2002, 15);
END;
/

-- la misma persona dos veces en la misma seleccion  [DEBE FALLAR]
BEGIN
    sp_convocar_jugador(1, 2001, 12);
END;
/
