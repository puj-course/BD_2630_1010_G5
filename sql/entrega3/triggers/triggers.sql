-- 1. consistencia y auditoria marcador .
CREATE OR REPLACE TRIGGER trg_auditoria_y_marcador
BEFORE INSERT OR UPDATE OR DELETE ON ENCUENTRO
FOR EACH ROW
DECLARE
    v_participantes NUMBER;
    v_incorrectos NUMBER;
    v_id NUMBER;
    v_operacion VARCHAR2(10);
    v_antes VARCHAR2(500);
    v_despues VARCHAR2(500);
BEGIN
    IF (UPDATING OR DELETING) AND :OLD.estado='FINALIZADO' THEN
        RAISE_APPLICATION_ERROR(-20201,'Un partido finalizado no se puede modificar');
    END IF;

    IF UPDATING AND :NEW.estado='FINALIZADO' THEN
        SELECT COUNT(*) INTO v_participantes
        FROM PARTICIPANTE_ENCUENTRO
        WHERE id_partido=:NEW.id_partido;
        IF v_participantes<>2 THEN
            RAISE_APPLICATION_ERROR(-20202,'El partido requiere exactamente dos participantes');
        END IF;

        SELECT COUNT(*) INTO v_incorrectos
        FROM PARTICIPANTE_ENCUENTRO p
        WHERE p.id_partido=:NEW.id_partido
          AND p.goles<>(
             SELECT NVL(SUM(r.goles),0)
             FROM RENDIMIENTO_JUGADOR r
             JOIN PLANTEL_EQUIPO pl ON pl.id_persona=r.id_persona
                                     AND pl.id_seleccion=p.id_seleccion
                                     AND pl.rol='JUGADOR'
             WHERE r.id_partido=p.id_partido
          );
        IF v_incorrectos>0 THEN
            RAISE_APPLICATION_ERROR(-20203,'El marcador no coincide con goles de jugadores');
        END IF;
    END IF;

    IF INSERTING THEN
        v_id:=:NEW.id_partido;
        v_operacion:='INSERT';
    ELSIF UPDATING THEN
        v_id:=:NEW.id_partido;
        v_operacion:='UPDATE';
    ELSE
        v_id:=:OLD.id_partido;
        v_operacion:='DELETE';
    END IF;
    IF NOT INSERTING THEN
        v_antes:='estado='||:OLD.estado||';estadio='||:OLD.id_estadio;
    END IF;
    IF NOT DELETING THEN
        v_despues:='estado='||:NEW.estado||';estadio='||:NEW.id_estadio;
    END IF;
    INSERT INTO BITACORA_CAMBIOS
      (id_auditoria,id_persona,usuario_bd,tabla_afectada,id_registro_afectado,
       operacion,fecha_hora,valor_anterior,valor_nuevo)
    VALUES (seq_bitacora.NEXTVAL,NULL,USER,'ENCUENTRO',v_id,
            v_operacion,SYSTIMESTAMP,v_antes,v_despues);
END trg_auditoria_y_marcador;
/

-- 2. validacion de rangos y auditoria de estadisticas .
CREATE OR REPLACE TRIGGER trg_rangos_y_auditoria
BEFORE INSERT OR UPDATE OR DELETE ON RENDIMIENTO_JUGADOR
FOR EACH ROW
DECLARE
    v_total NUMBER;
    v_persona NUMBER;
    v_operacion VARCHAR2(10);
    v_antes VARCHAR2(500);
    v_despues VARCHAR2(500);
BEGIN
    IF UPDATING OR DELETING THEN
        SELECT COUNT(*) INTO v_total FROM ENCUENTRO
        WHERE id_partido=:OLD.id_partido AND estado='FINALIZADO';
        IF v_total>0 THEN
            RAISE_APPLICATION_ERROR(-20210,'No se cambian estadisticas de partidos finalizados');
        END IF;
    END IF;

    IF NOT DELETING THEN
        SELECT COUNT(*) INTO v_total FROM ENCUENTRO
        WHERE id_partido=:NEW.id_partido AND estado='FINALIZADO';
        IF v_total>0 THEN
            RAISE_APPLICATION_ERROR(-20210,'No se cambian estadisticas de partidos finalizados');
        END IF;
        IF :NEW.goles<0 OR :NEW.asistencias<0 OR :NEW.tarjetas_amarillas<0 OR
           :NEW.tarjetas_rojas<0 OR :NEW.tiros<0 OR
           :NEW.minutos_jugados<0 OR :NEW.minutos_jugados>120 THEN
            RAISE_APPLICATION_ERROR(-20211,'Las estadisticas no admiten valores negativos');
        END IF;
        SELECT COUNT(*) INTO v_total
        FROM PARTICIPANTE_ENCUENTRO p
        JOIN PLANTEL_EQUIPO pl ON pl.id_seleccion=p.id_seleccion
                                AND pl.id_persona=:NEW.id_persona
                                AND pl.rol='JUGADOR'
        WHERE p.id_partido=:NEW.id_partido;
        IF v_total=0 THEN
            RAISE_APPLICATION_ERROR(-20212,'Jugador ajeno a los equipos del partido');
        END IF;
    END IF;

    IF INSERTING THEN
        v_persona:=:NEW.id_estadistica; v_operacion:='INSERT';
    ELSIF UPDATING THEN
        v_persona:=:NEW.id_estadistica; v_operacion:='UPDATE';
    ELSE
        v_persona:=:OLD.id_estadistica; v_operacion:='DELETE';
    END IF;
    IF NOT INSERTING THEN
        v_antes:='partido='||:OLD.id_partido||';goles='||:OLD.goles||';asistencias='||:OLD.asistencias;
    END IF;
    IF NOT DELETING THEN
        v_despues:='partido='||:NEW.id_partido||';goles='||:NEW.goles||';asistencias='||:NEW.asistencias;
    END IF;
    INSERT INTO BITACORA_CAMBIOS
      (id_auditoria,id_persona,usuario_bd,tabla_afectada,id_registro_afectado,
       operacion,fecha_hora,valor_anterior,valor_nuevo)
    VALUES (seq_bitacora.NEXTVAL,NULL,USER,'RENDIMIENTO_JUGADOR',v_persona,
            v_operacion,SYSTIMESTAMP,v_antes,v_despues);
END trg_rangos_y_auditoria;
/

-- 3. anti-duplicidad Y edicion de las participaciones agrega la comprobacion de que ambos equipos sean de la misma edicion.
CREATE OR REPLACE TRIGGER trg_participacion_valida
BEFORE INSERT OR UPDATE OR DELETE ON PARTICIPANTE_ENCUENTRO
FOR EACH ROW
DECLARE
    v_edicion_partido NUMBER;
    v_edicion_seleccion NUMBER;
    v_estado VARCHAR2(30);
BEGIN
    IF UPDATING OR DELETING THEN
        SELECT estado INTO v_estado FROM ENCUENTRO
        WHERE id_partido=:OLD.id_partido;
        IF v_estado='FINALIZADO' THEN
            RAISE_APPLICATION_ERROR(-20220,'No se modifican participantes de un finalizado');
        END IF;
    END IF;

    IF NOT DELETING THEN
        SELECT f.id_edicion INTO v_edicion_partido
        FROM ENCUENTRO e JOIN FASE_TORNEO f ON f.id_etapa=e.id_etapa
        WHERE e.id_partido=:NEW.id_partido;
        SELECT f.id_edicion INTO v_edicion_seleccion
        FROM EQUIPO_NACIONAL s JOIN FASE_TORNEO f ON f.id_etapa=s.id_etapa_grupo
        WHERE s.id_seleccion=:NEW.id_seleccion;
        IF v_edicion_partido<>v_edicion_seleccion THEN
            RAISE_APPLICATION_ERROR(-20221,'La seleccion es de otra edicion');
        END IF;
    END IF;
END trg_participacion_valida;
/

-- 4. convocatorias, controla cupo 26 y evita que un jugador representa dos selecciones en la misma edicion. 
CREATE OR REPLACE TRIGGER trg_cupo_convocatoria
FOR INSERT OR UPDATE OR DELETE ON PLANTEL_EQUIPO
COMPOUND TRIGGER
    TYPE lista_numeros IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_selecciones lista_numeros;
    v_personas lista_numeros;

    BEFORE EACH ROW IS
        v_historico NUMBER;
    BEGIN
        IF DELETING OR UPDATING THEN
            -- No borrar ni trasladar una vinculacion con estadisticas historicas.
            IF DELETING OR :NEW.id_persona<>:OLD.id_persona OR
               :NEW.id_seleccion<>:OLD.id_seleccion OR :NEW.rol<>:OLD.rol THEN
                SELECT COUNT(*) INTO v_historico
                FROM RENDIMIENTO_JUGADOR r
                JOIN PARTICIPANTE_ENCUENTRO p ON p.id_partido=r.id_partido
                WHERE r.id_persona=:OLD.id_persona
                  AND p.id_seleccion=:OLD.id_seleccion;
                IF v_historico>0 THEN
                    RAISE_APPLICATION_ERROR(-20232,'No se altera un historial con estadisticas');
                END IF;
            END IF;
        END IF;
    END BEFORE EACH ROW;

    AFTER EACH ROW IS
    BEGIN
        IF INSERTING OR UPDATING THEN
            v_selecciones(v_selecciones.COUNT+1):=:NEW.id_seleccion;
            v_personas(v_personas.COUNT+1):=:NEW.id_persona;
        END IF;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
        v_total NUMBER;
        v_edicion NUMBER;
        v_equipos NUMBER;
    BEGIN
        FOR i IN 1 .. v_selecciones.COUNT LOOP
            SELECT COUNT(*) INTO v_total
            FROM PLANTEL_EQUIPO
            WHERE id_seleccion=v_selecciones(i) AND rol='JUGADOR';
            IF v_total>26 THEN
                RAISE_APPLICATION_ERROR(-20230,'El cupo maximo es de 26 jugadores');
            END IF;

            SELECT f.id_edicion INTO v_edicion
            FROM EQUIPO_NACIONAL s JOIN FASE_TORNEO f ON f.id_etapa=s.id_etapa_grupo
            WHERE s.id_seleccion=v_selecciones(i);

            SELECT COUNT(DISTINCT pl.id_seleccion) INTO v_equipos
            FROM PLANTEL_EQUIPO pl
            JOIN EQUIPO_NACIONAL s ON s.id_seleccion=pl.id_seleccion
            JOIN FASE_TORNEO f ON f.id_etapa=s.id_etapa_grupo
            WHERE pl.id_persona=v_personas(i) AND pl.rol='JUGADOR'
              AND f.id_edicion=v_edicion;
            IF v_equipos>1 THEN
                RAISE_APPLICATION_ERROR(-20231,'Jugador en dos selecciones de la misma edicion');
            END IF;
        END LOOP;
    END AFTER STATEMENT;
END trg_cupo_convocatoria;
/
