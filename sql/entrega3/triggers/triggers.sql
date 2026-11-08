-- 1. CUPO DE CONVOCATORIA

CREATE OR REPLACE TRIGGER trg_cupo_convocatoria
BEFORE INSERT ON plantel_equipo
FOR EACH ROW
BEGIN
    IF :NEW.rol = 'JUGADOR'
       AND fn_validar_cupo_convocatoria(:NEW.id_seleccion) = 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'La convocatoria ya está completa');
    END IF;
END trg_cupo_convocatoria;
/

-- llenar la seleccion 4 (Francia) hasta 26 jugadores.

BEGIN
    FOR i IN 1 .. 24 LOOP
        INSERT INTO integrante (id_persona, nombre_completo)
        VALUES (5000 + i, 'Jugador de prueba ' || i);

        INSERT INTO plantel_equipo (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol)
        VALUES (5000 + i, 5000 + i, 4, 'N', 19 + i, 'DEFENSA', 'JUGADOR');
    END LOOP;
END;
/

SELECT COUNT(*) AS jugadores_francia
FROM plantel_equipo
WHERE id_seleccion = 4 AND rol = 'JUGADOR';

-- el jugador numero 27 no entra  [DEBE FALLAR]
BEGIN
    INSERT INTO integrante (id_persona, nombre_completo)
    VALUES (5100, 'Jugador de sobra');

    INSERT INTO plantel_equipo (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol)
    VALUES (5100, 5100, 4, 'N', 60, 'DEFENSA', 'JUGADOR');
END;
/


-- 2. DORSAL UNICO POR SELECCION

CREATE OR REPLACE TRIGGER trg_dorsal_unico
FOR INSERT OR UPDATE OF dorsal, id_seleccion ON plantel_equipo
COMPOUND TRIGGER

    TYPE t_fila IS RECORD (
        id_seleccion NUMBER,
        dorsal       NUMBER,
        id_persona   NUMBER
    );
    TYPE t_lista IS TABLE OF t_fila INDEX BY PLS_INTEGER;
    g_lista t_lista;

    AFTER EACH ROW IS
    BEGIN
        g_lista(g_lista.COUNT + 1).id_seleccion := :NEW.id_seleccion;
        g_lista(g_lista.COUNT).dorsal           := :NEW.dorsal;
        g_lista(g_lista.COUNT).id_persona       := :NEW.id_persona;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1 .. g_lista.COUNT LOOP
            IF fn_verificar_dorsal_disponible(g_lista(i).id_seleccion,
                                              g_lista(i).dorsal,
                                              g_lista(i).id_persona) = 0 THEN
                g_lista.DELETE;
                RAISE_APPLICATION_ERROR(-20021, 'El dorsal ya está asignado en esta selección');
            END IF;
        END LOOP;
        g_lista.DELETE;
    END AFTER STATEMENT;

END trg_dorsal_unico;
/

-- 3. cruce de agenda en estadio

CREATE OR REPLACE TRIGGER trg_cruce_agenda_estadio
FOR INSERT OR UPDATE OF id_estadio, fecha_hora ON encuentro
COMPOUND TRIGGER

    TYPE t_fila IS RECORD (
        id_partido NUMBER,
        id_estadio NUMBER,
        fecha_hora DATE
    );
    TYPE t_lista IS TABLE OF t_fila INDEX BY PLS_INTEGER;
    g_lista t_lista;

    AFTER EACH ROW IS
    BEGIN
        g_lista(g_lista.COUNT + 1).id_partido := :NEW.id_partido;
        g_lista(g_lista.COUNT).id_estadio     := :NEW.id_estadio;
        g_lista(g_lista.COUNT).fecha_hora     := :NEW.fecha_hora;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
        v_cruces NUMBER;
    BEGIN
        FOR i IN 1 .. g_lista.COUNT LOOP
            SELECT COUNT(*) INTO v_cruces
            FROM encuentro
            WHERE id_estadio = g_lista(i).id_estadio
              AND id_partido <> g_lista(i).id_partido
              AND ABS(fecha_hora - g_lista(i).fecha_hora) < 3 / 24;

            IF v_cruces > 0 THEN
                g_lista.DELETE;
                RAISE_APPLICATION_ERROR(-20022, 'El estadio ya tiene un partido en ese horario');
            END IF;
        END LOOP;
        g_lista.DELETE;
    END AFTER STATEMENT;

END trg_cruce_agenda_estadio;
/
