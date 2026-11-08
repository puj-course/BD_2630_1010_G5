-- 1. Diferencia de gol de una seleccion

CREATE OR REPLACE FUNCTION fn_diferencia_gol (
    p_id_seleccion IN NUMBER
) RETURN NUMBER IS
    v_existe NUMBER;
    v_dif    NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM equipo_nacional
    WHERE id_seleccion = p_id_seleccion;

    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'La selección no existe');
    END IF;

    SELECT NVL(SUM(pe.goles - rival.goles), 0)
    INTO v_dif
    FROM participante_encuentro pe
    JOIN participante_encuentro rival ON rival.id_partido = pe.id_partido
                                     AND rival.id_seleccion <> pe.id_seleccion
    JOIN encuentro e ON e.id_partido = pe.id_partido
    WHERE pe.id_seleccion = p_id_seleccion
      AND e.estado = 'FINALIZADO';

    RETURN v_dif;
END fn_diferencia_gol;
/

-- 2. Validar cupo de convocatoria

CREATE OR REPLACE FUNCTION fn_validar_cupo_convocatoria (
    p_id_seleccion IN NUMBER,
    p_cupo_maximo  IN NUMBER DEFAULT 26
) RETURN NUMBER IS
    v_existe     NUMBER;
    v_convocados NUMBER;
BEGIN
    IF p_cupo_maximo IS NULL OR p_cupo_maximo < 1 THEN
        RAISE_APPLICATION_ERROR(-20003, 'El cupo máximo debe ser mayor que cero');
    END IF;

    SELECT COUNT(*) INTO v_existe
    FROM equipo_nacional
    WHERE id_seleccion = p_id_seleccion;

    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'La selección no existe');
    END IF;

    SELECT COUNT(*) INTO v_convocados
    FROM plantel_equipo
    WHERE id_seleccion = p_id_seleccion
      AND rol = 'JUGADOR';

    IF v_convocados < p_cupo_maximo THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END fn_validar_cupo_convocatoria;
/

-- 3. Verificar que un dorsal este libre en una seleccion

CREATE OR REPLACE FUNCTION fn_verificar_dorsal_disponible (
    p_id_seleccion IN NUMBER,
    p_dorsal       IN NUMBER,
    p_id_persona   IN NUMBER DEFAULT NULL
) RETURN NUMBER IS
    v_existe  NUMBER;
    v_ocupado NUMBER;
BEGIN
    -- el cuerpo tecnico no usa dorsal
    IF p_dorsal IS NULL THEN
        RETURN 1;
    END IF;

    IF p_dorsal < 1 OR p_dorsal > 99 THEN
        RAISE_APPLICATION_ERROR(-20005, 'El dorsal debe estar entre 1 y 99');
    END IF;

    SELECT COUNT(*) INTO v_existe
    FROM equipo_nacional
    WHERE id_seleccion = p_id_seleccion;

    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'La selección no existe');
    END IF;

    --sSe ignora la fila de la misma persona, para poder actualizar su propio dorsal
    SELECT COUNT(*) INTO v_ocupado
    FROM plantel_equipo
    WHERE id_seleccion = p_id_seleccion
      AND dorsal = p_dorsal
      AND (p_id_persona IS NULL OR id_persona <> p_id_persona);

    IF v_ocupado = 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END fn_verificar_dorsal_disponible;
/
