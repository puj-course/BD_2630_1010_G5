-- Entrega 1 - Las quince consultas

-- ==============================================================================
-- Consulta 1 <Top 5 selecciones con mas goles marcados>
-- ==============================================================================

SELECT *
FROM (
    SELECT s.pais,
           SUM(pp.goles_marcados) AS goles_totales
    FROM MORENOLUIS.FIFA_SELECCION s
    JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
        ON s.id_seleccion = pp.id_seleccion
    GROUP BY s.pais
    ORDER BY goles_totales DESC
)
WHERE ROWNUM <= 5;

-- ==============================================================================
-- Consulta 2 <Porcentaje de ocupacion estimado por estadio>
-- ==============================================================================

SELECT nombre AS estadio, ciudad, capacidad,
       COUNT(id_partido) partidos_jugados,
       ROUND(AVG(asistencia_registrada/capacidad*100),2) ocupacion_pct
FROM MORENOLUIS.FIFA_ESTADIO
JOIN MORENOLUIS.FIFA_PARTIDO USING (id_estadio)
GROUP BY nombre, ciudad, capacidad
ORDER BY ocupacion_pct DESC;

-- ==============================================================================
-- Consulta 3 <Selecciones con mayor diferencia de gol>
-- ==============================================================================

SELECT s.pais,
       SUM(pp.goles_marcados) AS goles_favor,
       SUM(
           (
               SELECT pp2.goles_marcados
               FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp2
               WHERE pp2.id_partido = pp.id_partido
                 AND pp2.id_seleccion <> pp.id_seleccion
           )
       ) AS goles_contra,
       SUM(pp.goles_marcados) -
       SUM(
           (
               SELECT pp2.goles_marcados
               FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp2
               WHERE pp2.id_partido = pp.id_partido
                 AND pp2.id_seleccion <> pp.id_seleccion
           )
       ) AS diferencia_gol
FROM MORENOLUIS.FIFA_SELECCION s
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
    ON s.id_seleccion = pp.id_seleccion
GROUP BY s.pais
ORDER BY diferencia_gol DESC;

-- ==============================================================================
-- Consulta 4 <Partidos jugados por fase>
-- ==============================================================================

SELECT fase, COUNT(id_partido) num_partidos
FROM MORENOLUIS.FIFA_PARTIDO
GROUP BY fase
ORDER BY num_partidos DESC;

-- ==============================================================================
-- Consulta 5 <Estadio(s) con mayor cantidad de partidos por edicion>
-- ==============================================================================

SELECT E.ID_EDICION, S.NOMBRE ESTADIO, COUNT(P.ID_PARTIDO) N_PARTIDOS
FROM MORENOLUIS.FIFA_EDICION_MUNDIAL E
JOIN MORENOLUIS.FIFA_ESTADIO S
    ON E.ID_EDICION = S.ID_EDICION
JOIN MORENOLUIS.FIFA_PARTIDO P
    ON P.ID_ESTADIO = S.ID_ESTADIO
GROUP BY E.ID_EDICION, S.ID_ESTADIO, S.NOMBRE
HAVING COUNT(P.ID_PARTIDO) = (SELECT MAX(COUNT(A.ID_PARTIDO))
                              FROM MORENOLUIS.FIFA_PARTIDO A
                              JOIN MORENOLUIS.FIFA_ESTADIO B
                                  ON A.ID_ESTADIO = B.ID_ESTADIO
                              WHERE E.ID_EDICION = B.ID_EDICION
                              GROUP BY A.ID_ESTADIO);

-- ==============================================================================
-- Consulta 6 <Partidos con patrones atipicos: marcador alto (>5) o sin goles>
-- ==============================================================================

SELECT P.id_partido, P.id_edicion, P.fase,
       SUM(PP.goles_marcados) goles_totales,
       CASE WHEN SUM(PP.goles_marcados) > 5 THEN 'MARCADOR ALTO'
            WHEN SUM(PP.goles_marcados) = 0 THEN 'SIN GOLES'
       END patron
FROM MORENOLUIS.FIFA_PARTIDO P
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PP
    ON P.id_partido = PP.id_partido
GROUP BY P.id_partido, P.id_edicion, P.fase
HAVING SUM(PP.goles_marcados) = 0 OR SUM(PP.goles_marcados) > 5
ORDER BY goles_totales DESC;

-- ==============================================================================
-- Consulta 7 <Selecciones invictas>
-- ==============================================================================

SELECT s.pais
FROM MORENOLUIS.FIFA_SELECCION S
WHERE NOT EXISTS
 (SELECT 1
  FROM MORENOLUIS.FIFA_PARTIDO P
  JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PP ON P.id_partido = PP.id_partido
  WHERE PP.id_seleccion = S.id_seleccion
  AND (
      (PP.condicion = 'local'
      AND PP.goles_marcados <
      (SELECT MAX(PPV.goles_marcados)
       FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PPV
       WHERE PPV.id_partido = P.id_partido AND PPV.condicion = 'visitante'))
      OR
      (PP.condicion = 'visitante'
      AND PP.goles_marcados <
          (SELECT MAX(PPL.goles_marcados)
           FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PPL
           WHERE PPL.id_partido = P.id_partido AND PPL.condicion = 'local'))
     )
  );

-- ==============================================================================
-- Consulta 8 <Estadios sobre el promedio de ocupacion>
-- ==============================================================================

SELECT nombre AS estadio, ciudad,
       ROUND(AVG(asistencia_registrada/capacidad*100),2) ocupacion_pct
FROM MORENOLUIS.FIFA_ESTADIO E
JOIN MORENOLUIS.FIFA_PARTIDO P ON E.id_estadio = P.id_estadio
GROUP BY E.nombre, E.ciudad
HAVING ROUND(AVG(asistencia_registrada/capacidad*100),2) > (
    SELECT ROUND(AVG(asistencia_registrada/capacidad*100),2)
    FROM MORENOLUIS.FIFA_ESTADIO E1
    JOIN MORENOLUIS.FIFA_PARTIDO P1 ON E1.id_estadio = P1.id_estadio)
ORDER BY ocupacion_pct DESC;

-- ==============================================================================
-- Consulta 9 <Partido con mayor marcador combinado por estadio>
-- ==============================================================================

SELECT E.NOMBRE, A.ID_PARTIDO, A.FASE, SUM(P.GOLES_MARCADOS) GOLES_TOTALES
FROM MORENOLUIS.FIFA_PARTIDO A
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO P
    ON A.ID_PARTIDO = P.ID_PARTIDO
JOIN MORENOLUIS.FIFA_ESTADIO E
    ON A.ID_ESTADIO = E.ID_ESTADIO
GROUP BY A.ID_PARTIDO, E.NOMBRE, A.ID_ESTADIO, A.FASE
HAVING SUM(P.GOLES_MARCADOS) = (SELECT MAX(SUM(Y.GOLES_MARCADOS))
                                FROM MORENOLUIS.FIFA_PARTIDO Z
                                JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO Y
                                    ON Z.ID_PARTIDO = Y.ID_PARTIDO
                                WHERE Z.ID_ESTADIO = A.ID_ESTADIO
                                GROUP BY Z.ID_PARTIDO)
ORDER BY NOMBRE;

-- ==============================================================================
-- Consulta 10 <Selecciones con condicion exclusiva>
-- ==============================================================================

SELECT S.pais,
       SUM(CASE WHEN PP.condicion = 'local' THEN 1 ELSE 0 END) partidos_local,
       SUM(CASE WHEN PP.condicion = 'visitante' THEN 1 ELSE 0 END) partidos_visitante,
       COUNT(PP.id_participacion) total_partidos
FROM MORENOLUIS.FIFA_SELECCION S
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PP
    ON S.id_seleccion = PP.id_seleccion
GROUP BY S.pais
HAVING SUM(CASE WHEN PP.condicion = 'local' THEN 1 ELSE 0 END) = 0
    OR SUM(CASE WHEN PP.condicion = 'visitante' THEN 1 ELSE 0 END) = 0
ORDER BY S.pais;

-- ==============================================================================
-- Consulta 11 <Selecciones sobre el promedio de diferencia de gol>
-- ==============================================================================

WITH diferencia_por_seleccion AS (
    SELECT S.id_seleccion,
           S.pais,
           SUM(
             CASE WHEN PP.condicion = 'local'
                  THEN PP.goles_marcados
                  ELSE 0 END
           )
           + SUM(
             CASE WHEN PP.condicion = 'visitante'
                  THEN PP.goles_marcados
                  ELSE 0 END
           )
           - SUM(
             CASE WHEN PP.condicion = 'local'
                  THEN (
                    SELECT MAX(PPV.goles_marcados)
                    FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PPV
                    WHERE PPV.id_partido = PP.id_partido
                      AND PPV.condicion = 'visitante'
                  )
                  ELSE (
                    SELECT MAX(PPL.goles_marcados)
                    FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PPL
                    WHERE PPL.id_partido = PP.id_partido
                      AND PPL.condicion = 'local'
                  )
             END
           ) AS diferencia_gol
    FROM MORENOLUIS.FIFA_SELECCION S
    JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PP
         ON S.id_seleccion = PP.id_seleccion
    GROUP BY S.id_seleccion, S.pais
),
promedio_global AS (
    SELECT AVG(diferencia_gol) AS promedio
    FROM diferencia_por_seleccion
)
SELECT d.pais, d.diferencia_gol
FROM diferencia_por_seleccion d, promedio_global pg
WHERE d.diferencia_gol > pg.promedio
ORDER BY d.diferencia_gol DESC;

-- ==============================================================================
-- Consulta 12 <Goles fase de grupos vs fase eliminatoria>
-- ==============================================================================

SELECT S.PAIS,
    SUM(CASE WHEN P.FASE = 'Fase de Grupos' THEN PP.GOLES_MARCADOS ELSE 0 END) GOLES_FASE_GRUPOS,
    SUM(CASE WHEN P.FASE IN ('Semifinal', 'Tercer Puesto', 'Final') THEN PP.GOLES_MARCADOS ELSE 0 END) GOLES_ELIMINATORIA
FROM MORENOLUIS.FIFA_SELECCION S
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PP
    ON S.ID_SELECCION = PP.ID_SELECCION
JOIN MORENOLUIS.FIFA_PARTIDO P
    ON PP.ID_PARTIDO = P.ID_PARTIDO
GROUP BY S.PAIS
ORDER BY S.PAIS;

-- ==============================================================================
-- Consulta 13 <Estadios con mas de una fase distinta>
-- ==============================================================================

SELECT E.NOMBRE, COUNT(DISTINCT P.FASE) N_FASES_DISTINTAS,
    CASE WHEN SUM(CASE WHEN P.FASE = 'Fase de Grupos' THEN 1 ELSE 0 END) > 0 THEN 'Fase de Grupos' ELSE '' END ||
    CASE WHEN SUM(CASE WHEN P.FASE = 'Semifinal' THEN 1 ELSE 0 END) > 0 THEN ', Semifinal' ELSE '' END ||
    CASE WHEN SUM(CASE WHEN P.FASE = 'Tercer Puesto' THEN 1 ELSE 0 END) > 0 THEN ', Tercer Puesto' ELSE '' END ||
    CASE WHEN SUM(CASE WHEN P.FASE = 'Final' THEN 1 ELSE 0 END) > 0 THEN ', Final' ELSE '' END FASES
FROM MORENOLUIS.FIFA_ESTADIO E
JOIN MORENOLUIS.FIFA_PARTIDO P
    ON E.ID_ESTADIO = P.ID_ESTADIO
GROUP BY E.NOMBRE, E.ID_ESTADIO
HAVING COUNT(DISTINCT P.FASE) > 1;

-- ==============================================================================
-- Consulta 14 <Verificacion de participaciones duplicadas>
-- ==============================================================================

SELECT id_partido,
       id_seleccion,
       COUNT(*) AS cantidad_participaciones
FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO
GROUP BY id_partido, id_seleccion
HAVING COUNT(*) > 1;

-- ==============================================================================
-- Consulta 15 <Fase con mayor cantidad de partidos, usando una vista>
-- ==============================================================================

SELECT fase,
       cantidad_partidos
FROM v_partidos_por_fase
WHERE cantidad_partidos = (
    SELECT MAX(cantidad_partidos)
    FROM v_partidos_por_fase
);
