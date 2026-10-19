-- ===============================================================
--  ENTREGA 2 - CONSULTAS AVANZADAS
--  Sistema de Informacion para la Gestion Integral de la Copa Mundial de la FIFA
-- ===============================================================


-- 1. Ranking de goleadores por edicion
-- Jugadores cuyos goles superan el promedio de goles de todos los jugadores registrados.

WITH goles_jugador AS (
    SELECT
        t.anio,
        i.id_persona,
        i.nombre_completo,
        SUM(r.goles) AS total_goles,
        COUNT(DISTINCT e.id_partido) AS partidos_jugados
    FROM RENDIMIENTO_JUGADOR r
    JOIN INTEGRANTE i
        ON i.id_persona = r.id_persona
    JOIN ENCUENTRO e
        ON e.id_partido = r.id_partido
    JOIN FASE_TORNEO f
        ON f.id_etapa = e.id_etapa
    JOIN TORNEO_MUNDIAL t
        ON t.id_edicion = f.id_edicion
    GROUP BY
        t.anio,
        i.id_persona,
        i.nombre_completo
)
SELECT
    anio,
    nombre_completo AS jugador,
    total_goles,
    partidos_jugados
FROM goles_jugador
WHERE total_goles > (
    SELECT AVG(total_goles)
    FROM goles_jugador
)
ORDER BY anio, total_goles DESC, jugador;


-- 2. Rendimiento de las selecciones por grupo
-- Compara goles a favor, goles en contra y diferencia de gol.

WITH goles_por_equipo AS (
    SELECT
        pe.id_partido,
        pe.id_seleccion,
        pe.goles AS goles_favor,
        rival.goles AS goles_contra
    FROM PARTICIPANTE_ENCUENTRO pe
    JOIN PARTICIPANTE_ENCUENTRO rival
        ON rival.id_partido = pe.id_partido
        AND rival.id_seleccion <> pe.id_seleccion
)
SELECT
    t.anio,
    g.nombre AS grupo,
    ef.pais AS seleccion,
    en.codigo_fifa,
    SUM(gpe.goles_favor) AS goles_favor,
    SUM(gpe.goles_contra) AS goles_contra,
    SUM(gpe.goles_favor) - SUM(gpe.goles_contra) AS diferencia_gol
FROM goles_por_equipo gpe
JOIN EQUIPO_NACIONAL en
    ON en.id_seleccion = gpe.id_seleccion
JOIN ENTE_FUTBOLISTICO ef
    ON ef.id_organizacion = en.id_organizacion
JOIN FASE_TORNEO g
    ON g.id_etapa = en.id_etapa_grupo
JOIN TORNEO_MUNDIAL t
    ON t.id_edicion = g.id_edicion
GROUP BY
    t.anio,
    g.nombre,
    ef.pais,
    en.codigo_fifa
ORDER BY
    t.anio,
    g.nombre,
    diferencia_gol DESC;


-- 3. Asistencia promedio y ocupacion por fase
-- Compara la asistencia registrada con la capacidad de los recintos.

SELECT
    t.anio,
    f.nombre AS fase,
    COUNT(e.id_partido) AS partidos_jugados,
    ROUND(AVG(e.asistencia_registrada), 2) AS asistencia_promedio,
    ROUND(
        AVG(100.0 * e.asistencia_registrada / NULLIF(rd.capacidad, 0)),
        2
    ) AS ocupacion_promedio_porcentaje
FROM ENCUENTRO e
JOIN FASE_TORNEO f
    ON f.id_etapa = e.id_etapa
JOIN TORNEO_MUNDIAL t
    ON t.id_edicion = f.id_edicion
JOIN RECINTO_DEPORTIVO rd
    ON rd.id_estadio = e.id_estadio
GROUP BY
    t.anio,
    f.nombre
HAVING COUNT(e.id_partido) > 0
ORDER BY
    t.anio,
    partidos_jugados DESC,
    f.nombre;


-- 4. Jugadores con mas tarjetas por edicion
-- Top 5 por edicion; DENSE_RANK permite empates en la misma posicion.

WITH disciplina AS (
    SELECT
        t.id_edicion,
        t.anio,
        i.id_persona,
        i.nombre_completo AS jugador,
        SUM(r.tarjetas_amarillas) AS tarjetas_amarillas,
        SUM(r.tarjetas_rojas) AS tarjetas_rojas,
        SUM(r.tarjetas_amarillas + r.tarjetas_rojas) AS total_tarjetas
    FROM RENDIMIENTO_JUGADOR r
    JOIN INTEGRANTE i
        ON i.id_persona = r.id_persona
    JOIN ENCUENTRO e
        ON e.id_partido = r.id_partido
    JOIN FASE_TORNEO f
        ON f.id_etapa = e.id_etapa
    JOIN TORNEO_MUNDIAL t
        ON t.id_edicion = f.id_edicion
    GROUP BY
        t.id_edicion,
        t.anio,
        i.id_persona,
        i.nombre_completo
),
ranking AS (
    SELECT
        disciplina.*,
        DENSE_RANK() OVER (
            PARTITION BY id_edicion
            ORDER BY total_tarjetas DESC
        ) AS posicion
    FROM disciplina
    WHERE total_tarjetas > 0
)
SELECT
    anio,
    posicion,
    jugador,
    tarjetas_amarillas,
    tarjetas_rojas,
    total_tarjetas
FROM ranking
WHERE posicion <= 5
ORDER BY anio, posicion, jugador;


-- 5. Carga de trabajo de los arbitros por edicion
-- Arbitros con al menos 2 partidos, separando los que fueron central o VAR.

SELECT
    t.anio,
    i.id_persona,
    i.nombre_completo AS arbitro,
    COUNT(DISTINCT e.id_partido) AS partidos_asignados,
    SUM(CASE WHEN ta.rol_arbitral = 'CENTRAL' THEN 1 ELSE 0 END) AS asignaciones_central,
    SUM(CASE WHEN ta.rol_arbitral = 'VAR' THEN 1 ELSE 0 END) AS asignaciones_var
FROM TERNA_ARBITRAL ta
JOIN INTEGRANTE i
    ON i.id_persona = ta.id_persona
JOIN ENCUENTRO e
    ON e.id_partido = ta.id_partido
JOIN FASE_TORNEO f
    ON f.id_etapa = e.id_etapa
JOIN TORNEO_MUNDIAL t
    ON t.id_edicion = f.id_edicion
GROUP BY
    t.anio,
    i.id_persona,
    i.nombre_completo
HAVING COUNT(DISTINCT e.id_partido) >= 2
ORDER BY
    t.anio,
    partidos_asignados DESC,
    arbitro;


-- 6. Cantidad de convocados y capitanes por seleccion

SELECT
    t.anio,
    ef.pais AS seleccion,
    en.codigo_fifa,
    COUNT(pl.id_vinculacion) AS jugadores_convocados,
    SUM(CASE WHEN pl.capitan = 'S' THEN 1 ELSE 0 END) AS cantidad_capitanes
FROM EQUIPO_NACIONAL en
JOIN ENTE_FUTBOLISTICO ef
    ON ef.id_organizacion = en.id_organizacion
JOIN FASE_TORNEO g
    ON g.id_etapa = en.id_etapa_grupo
JOIN TORNEO_MUNDIAL t
    ON t.id_edicion = g.id_edicion
LEFT JOIN PLANTEL_EQUIPO pl
    ON pl.id_seleccion = en.id_seleccion
    AND pl.rol = 'JUGADOR'
GROUP BY
    t.anio,
    en.id_seleccion,
    ef.pais,
    en.codigo_fifa
HAVING COUNT(pl.id_vinculacion) > 0
ORDER BY
    t.anio,
    jugadores_convocados DESC,
    ef.pais;


-- 7. Analisis de novedades por tipo y edicion
-- Con pocos datos de prueba no se filtra por un minimo de novedades.

SELECT
    t.anio,
    n.tipo,
    COUNT(n.id_incidencia) AS cantidad_novedades,
    ROUND(AVG(n.minuto), 2) AS minuto_promedio,
    MIN(n.minuto) AS primer_minuto,
    MAX(n.minuto) AS ultimo_minuto
FROM NOVEDAD_ENCUENTRO n
JOIN ENCUENTRO e
    ON e.id_partido = n.id_partido
JOIN FASE_TORNEO f
    ON f.id_etapa = e.id_etapa
JOIN TORNEO_MUNDIAL t
    ON t.id_edicion = f.id_edicion
GROUP BY
    t.anio,
    n.tipo
HAVING COUNT(n.id_incidencia) >= 1
ORDER BY
    t.anio,
    cantidad_novedades DESC,
    n.tipo;


-- 8. Partidos con muchos goles o grandes diferencias
-- Umbrales ajustados a los datos de prueba: 3 goles o mas, o diferencia de 2 o mas.

WITH marcador AS (
    SELECT
        e.id_partido,
        t.anio,
        f.nombre AS fase,
        MAX(CASE WHEN pe.condicion = 'LOCAL' THEN ef.pais END) AS seleccion_local,
        MAX(CASE WHEN pe.condicion = 'LOCAL' THEN pe.goles END) AS goles_local,
        MAX(CASE WHEN pe.condicion = 'VISITANTE' THEN ef.pais END) AS seleccion_visitante,
        MAX(CASE WHEN pe.condicion = 'VISITANTE' THEN pe.goles END) AS goles_visitante
    FROM ENCUENTRO e
    JOIN FASE_TORNEO f
        ON f.id_etapa = e.id_etapa
    JOIN TORNEO_MUNDIAL t
        ON t.id_edicion = f.id_edicion
    JOIN PARTICIPANTE_ENCUENTRO pe
        ON pe.id_partido = e.id_partido
    JOIN EQUIPO_NACIONAL en
        ON en.id_seleccion = pe.id_seleccion
    JOIN ENTE_FUTBOLISTICO ef
        ON ef.id_organizacion = en.id_organizacion
    GROUP BY
        e.id_partido,
        t.anio,
        f.nombre
)
SELECT
    anio,
    id_partido,
    fase,
    seleccion_local,
    goles_local,
    seleccion_visitante,
    goles_visitante,
    goles_local + goles_visitante AS goles_totales,
    ABS(goles_local - goles_visitante) AS diferencia_goles
FROM marcador
WHERE goles_local IS NOT NULL
  AND goles_visitante IS NOT NULL
  AND (
      goles_local + goles_visitante >= 3
      OR ABS(goles_local - goles_visitante) >= 2
  )
ORDER BY
    anio,
    goles_totales DESC,
    diferencia_goles DESC;


-- 9. Selecciones con mejor rendimiento por edicion
-- Equipos cuya diferencia de gol supera el promedio de su edicion.

WITH rendimiento AS (
    SELECT
        t.id_edicion,
        t.anio,
        g.nombre AS grupo,
        en.id_seleccion,
        ef.pais AS seleccion,
        SUM(pe.goles) AS goles_favor,
        SUM(rival.goles) AS goles_contra,
        SUM(pe.goles) - SUM(rival.goles) AS diferencia_gol
    FROM PARTICIPANTE_ENCUENTRO pe
    JOIN PARTICIPANTE_ENCUENTRO rival
        ON rival.id_partido = pe.id_partido
        AND rival.id_seleccion <> pe.id_seleccion
    JOIN EQUIPO_NACIONAL en
        ON en.id_seleccion = pe.id_seleccion
    JOIN ENTE_FUTBOLISTICO ef
        ON ef.id_organizacion = en.id_organizacion
    JOIN FASE_TORNEO g
        ON g.id_etapa = en.id_etapa_grupo
    JOIN TORNEO_MUNDIAL t
        ON t.id_edicion = g.id_edicion
    GROUP BY
        t.id_edicion,
        t.anio,
        g.nombre,
        en.id_seleccion,
        ef.pais
)
SELECT
    anio,
    grupo,
    seleccion,
    goles_favor,
    goles_contra,
    diferencia_gol
FROM rendimiento r
WHERE diferencia_gol > (
    SELECT AVG(r2.diferencia_gol)
    FROM rendimiento r2
    WHERE r2.id_edicion = r.id_edicion
)
ORDER BY
    anio,
    grupo,
    diferencia_gol DESC;


-- 10. Recintos con ocupacion superior al promedio por edicion

WITH ocupacion AS (
    SELECT
        t.id_edicion,
        t.anio,
        f.nombre AS fase,
        rd.id_estadio,
        rd.nombre AS estadio,
        rd.capacidad,
        COUNT(e.id_partido) AS partidos_jugados,
        ROUND(AVG(e.asistencia_registrada), 2) AS asistencia_promedio,
        ROUND(
            AVG(100.0 * e.asistencia_registrada / NULLIF(rd.capacidad, 0)),
            2
        ) AS ocupacion_promedio
    FROM ENCUENTRO e
    JOIN FASE_TORNEO f
        ON f.id_etapa = e.id_etapa
    JOIN TORNEO_MUNDIAL t
        ON t.id_edicion = f.id_edicion
    JOIN RECINTO_DEPORTIVO rd
        ON rd.id_estadio = e.id_estadio
    WHERE e.asistencia_registrada IS NOT NULL
    GROUP BY
        t.id_edicion,
        t.anio,
        f.nombre,
        rd.id_estadio,
        rd.nombre,
        rd.capacidad
)
SELECT
    anio,
    fase,
    estadio,
    capacidad,
    partidos_jugados,
    asistencia_promedio,
    ocupacion_promedio
FROM ocupacion o
WHERE ocupacion_promedio > (
    SELECT AVG(o2.ocupacion_promedio)
    FROM ocupacion o2
    WHERE o2.id_edicion = o.id_edicion
)
ORDER BY
    anio,
    fase,
    ocupacion_promedio DESC;
