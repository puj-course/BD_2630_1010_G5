-- 1. diferencia de goles es igual a goles a favor - goles en contra
CREATE OR REPLACE FUNCTION fn_diferencia_gol(p_id_seleccion IN NUMBER)
RETURN NUMBER IS
    v_existe NUMBER;
    v_diferencia NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM EQUIPO_NACIONAL WHERE id_seleccion=p_id_seleccion;
    IF v_existe=0 THEN
        RAISE_APPLICATION_ERROR(-20001,'La seleccion no existe');
    END IF;

    SELECT NVL(SUM(p.goles-rival.goles),0) INTO v_diferencia
    FROM PARTICIPANTE_ENCUENTRO p
    JOIN PARTICIPANTE_ENCUENTRO rival ON rival.id_partido=p.id_partido
                                      AND rival.id_seleccion<>p.id_seleccion
    JOIN ENCUENTRO e ON e.id_partido=p.id_partido
    WHERE p.id_seleccion=p_id_seleccion AND e.estado='FINALIZADO';
    RETURN v_diferencia;
END fn_diferencia_gol;
/

-- 2. devuelve 1 si hay cupo para otro jugador, 0 si se lleno el plantel
CREATE OR REPLACE FUNCTION fn_validar_cupo_convocatoria(p_id_seleccion IN NUMBER)
RETURN NUMBER IS
    v_existe NUMBER;
    v_jugadores NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM EQUIPO_NACIONAL WHERE id_seleccion=p_id_seleccion;
    IF v_existe=0 THEN
        RAISE_APPLICATION_ERROR(-20002,'La seleccion no existe');
    END IF;

    SELECT COUNT(*) INTO v_jugadores FROM PLANTEL_EQUIPO
    WHERE id_seleccion=p_id_seleccion AND rol='JUGADOR';
    IF v_jugadores<26 THEN RETURN 1; END IF;
    RETURN 0;
END fn_validar_cupo_convocatoria;
/

-- 3. posicion de una persona en goleadores de una edicion y se valida de forma que 1 significa primer lugar. Si no tiene goles/estadisticas, devuelve 0
CREATE OR REPLACE FUNCTION fn_ranking_goleadores(
    p_id_edicion IN NUMBER, p_id_persona IN NUMBER)
RETURN NUMBER IS
    v_posicion NUMBER;
BEGIN
    SELECT NVL(MAX(posicion),0) INTO v_posicion
    FROM (
        SELECT id_persona, DENSE_RANK() OVER (ORDER BY total_goles DESC) posicion
        FROM (
            SELECT r.id_persona,SUM(r.goles) total_goles
            FROM RENDIMIENTO_JUGADOR r
            JOIN ENCUENTRO e ON e.id_partido=r.id_partido
            JOIN FASE_TORNEO f ON f.id_etapa=e.id_etapa
            WHERE f.id_edicion=p_id_edicion AND e.estado='FINALIZADO'
            GROUP BY r.id_persona
            HAVING SUM(r.goles)>0
        )
    ) WHERE id_persona=p_id_persona;
    RETURN v_posicion;
END fn_ranking_goleadores;
/
