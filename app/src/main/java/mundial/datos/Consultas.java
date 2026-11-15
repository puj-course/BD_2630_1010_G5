package mundial.datos;

/**
 * Consultas SQL de las pantallas de solo lectura. Las que tienen "? IS NULL OR ..."
 * reciben el valor del filtro (null = Todos).
 */
public class Consultas {

    // ---- Listas desplegables (valor, etiqueta) ----

    public static final String OPCIONES_EDICION = """
            SELECT id_edicion, anio || ' - ' || nombre
            FROM TORNEO_MUNDIAL
            ORDER BY anio
            """;

    public static final String OPCIONES_FASE = """
            SELECT f.id_etapa, f.nombre || ' (' || t.anio || ')'
            FROM FASE_TORNEO f
            JOIN TORNEO_MUNDIAL t ON t.id_edicion = f.id_edicion
            ORDER BY t.anio, f.orden
            """;

    public static final String OPCIONES_ESTADIO = """
            SELECT id_estadio, nombre
            FROM RECINTO_DEPORTIVO
            ORDER BY nombre
            """;

    public static final String OPCIONES_SELECCION = """
            SELECT s.id_seleccion, en.pais || ' (' || s.codigo_fifa || ')'
            FROM EQUIPO_NACIONAL s
            JOIN ENTE_FUTBOLISTICO en ON en.id_organizacion = s.id_organizacion
            ORDER BY en.pais
            """;

    public static final String OPCIONES_PERSONA = """
            SELECT id_persona, nombre_completo
            FROM INTEGRANTE
            ORDER BY nombre_completo
            """;

    public static final String OPCIONES_TIPO_INCIDENCIA = """
            SELECT DISTINCT tipo, tipo
            FROM NOVEDAD_ENCUENTRO
            ORDER BY 1
            """;

    // ---- Partidos ----

    public static final String PARTIDOS = """
            SELECT e.id_partido,
                   TO_CHAR(e.fecha_hora, 'YYYY-MM-DD HH24:MI') AS fecha,
                   f.nombre AS fase,
                   r.nombre AS estadio,
                   enl.pais AS equipo_local,
                   pl.goles AS goles_local,
                   pv.goles AS goles_visitante,
                   env.pais AS equipo_visitante,
                   pl.goles_penales AS pen_local,
                   pv.goles_penales AS pen_visitante,
                   e.estado
            FROM ENCUENTRO e
            JOIN FASE_TORNEO f ON f.id_etapa = e.id_etapa
            JOIN RECINTO_DEPORTIVO r ON r.id_estadio = e.id_estadio
            LEFT JOIN PARTICIPANTE_ENCUENTRO pl ON pl.id_partido = e.id_partido AND pl.condicion = 'LOCAL'
            LEFT JOIN EQUIPO_NACIONAL sl ON sl.id_seleccion = pl.id_seleccion
            LEFT JOIN ENTE_FUTBOLISTICO enl ON enl.id_organizacion = sl.id_organizacion
            LEFT JOIN PARTICIPANTE_ENCUENTRO pv ON pv.id_partido = e.id_partido AND pv.condicion = 'VISITANTE'
            LEFT JOIN EQUIPO_NACIONAL sv ON sv.id_seleccion = pv.id_seleccion
            LEFT JOIN ENTE_FUTBOLISTICO env ON env.id_organizacion = sv.id_organizacion
            WHERE (? IS NULL OR f.id_edicion = ?)
            ORDER BY e.fecha_hora
            """;

    public static final String RESULTADOS = """
            SELECT e.id_partido,
                   TO_CHAR(e.fecha_hora, 'YYYY-MM-DD HH24:MI') AS fecha,
                   f.nombre AS fase,
                   enl.pais AS equipo_local,
                   pl.goles AS goles_local,
                   pv.goles AS goles_visitante,
                   env.pais AS equipo_visitante,
                   pl.goles_penales AS pen_local,
                   pv.goles_penales AS pen_visitante
            FROM ENCUENTRO e
            JOIN FASE_TORNEO f ON f.id_etapa = e.id_etapa
            JOIN PARTICIPANTE_ENCUENTRO pl ON pl.id_partido = e.id_partido AND pl.condicion = 'LOCAL'
            JOIN EQUIPO_NACIONAL sl ON sl.id_seleccion = pl.id_seleccion
            JOIN ENTE_FUTBOLISTICO enl ON enl.id_organizacion = sl.id_organizacion
            JOIN PARTICIPANTE_ENCUENTRO pv ON pv.id_partido = e.id_partido AND pv.condicion = 'VISITANTE'
            JOIN EQUIPO_NACIONAL sv ON sv.id_seleccion = pv.id_seleccion
            JOIN ENTE_FUTBOLISTICO env ON env.id_organizacion = sv.id_organizacion
            WHERE e.estado = 'FINALIZADO'
              AND (? IS NULL OR f.id_edicion = ?)
            ORDER BY e.fecha_hora
            """;

    public static final String POSICIONES = """
            SELECT t.anio,
                   en.pais AS seleccion,
                   s.codigo_fifa AS codigo,
                   COUNT(*) AS pj,
                   SUM(CASE WHEN p.resultado = 'GANO' THEN 1 ELSE 0 END) AS ganados,
                   SUM(CASE WHEN p.resultado = 'EMPATO' THEN 1 ELSE 0 END) AS empatados,
                   SUM(CASE WHEN p.resultado = 'PERDIO' THEN 1 ELSE 0 END) AS perdidos,
                   SUM(p.goles) AS gf,
                   SUM(rv.goles) AS gc,
                   SUM(p.goles - rv.goles) AS dg,
                   SUM(CASE WHEN p.resultado = 'GANO' THEN 3 WHEN p.resultado = 'EMPATO' THEN 1 ELSE 0 END) AS puntos
            FROM PARTICIPANTE_ENCUENTRO p
            JOIN PARTICIPANTE_ENCUENTRO rv ON rv.id_partido = p.id_partido AND rv.id_seleccion <> p.id_seleccion
            JOIN ENCUENTRO e ON e.id_partido = p.id_partido AND e.estado = 'FINALIZADO'
            JOIN FASE_TORNEO f ON f.id_etapa = e.id_etapa
            JOIN TORNEO_MUNDIAL t ON t.id_edicion = f.id_edicion
            JOIN EQUIPO_NACIONAL s ON s.id_seleccion = p.id_seleccion
            JOIN ENTE_FUTBOLISTICO en ON en.id_organizacion = s.id_organizacion
            WHERE (? IS NULL OR t.id_edicion = ?)
            GROUP BY t.anio, en.pais, s.codigo_fifa
            ORDER BY t.anio, puntos DESC, dg DESC, gf DESC
            """;

    public static final String INCIDENCIAS = """
            SELECT n.id_incidencia,
                   n.tipo,
                   n.minuto,
                   n.descripcion,
                   e.id_partido,
                   TO_CHAR(e.fecha_hora, 'YYYY-MM-DD HH24:MI') AS fecha,
                   enl.pais || ' vs ' || env.pais AS partido
            FROM NOVEDAD_ENCUENTRO n
            JOIN ENCUENTRO e ON e.id_partido = n.id_partido
            LEFT JOIN PARTICIPANTE_ENCUENTRO pl ON pl.id_partido = e.id_partido AND pl.condicion = 'LOCAL'
            LEFT JOIN EQUIPO_NACIONAL sl ON sl.id_seleccion = pl.id_seleccion
            LEFT JOIN ENTE_FUTBOLISTICO enl ON enl.id_organizacion = sl.id_organizacion
            LEFT JOIN PARTICIPANTE_ENCUENTRO pv ON pv.id_partido = e.id_partido AND pv.condicion = 'VISITANTE'
            LEFT JOIN EQUIPO_NACIONAL sv ON sv.id_seleccion = pv.id_seleccion
            LEFT JOIN ENTE_FUTBOLISTICO env ON env.id_organizacion = sv.id_organizacion
            WHERE (? IS NULL OR n.tipo = ?)
            ORDER BY e.fecha_hora, n.minuto
            """;

    // ---- Selecciones: usa las funciones fn_diferencia_gol y fn_validar_cupo_convocatoria ----

    public static final String RENDIMIENTO_SELECCIONES = """
            SELECT s.id_seleccion,
                   en.pais,
                   s.codigo_fifa AS codigo,
                   f.nombre AS grupo,
                   t.anio,
                   fn_diferencia_gol(s.id_seleccion) AS dif_gol,
                   CASE WHEN fn_validar_cupo_convocatoria(s.id_seleccion) = 1 THEN 'SI' ELSE 'NO' END AS cupo_disponible
            FROM EQUIPO_NACIONAL s
            JOIN ENTE_FUTBOLISTICO en ON en.id_organizacion = s.id_organizacion
            JOIN FASE_TORNEO f ON f.id_etapa = s.id_etapa_grupo
            JOIN TORNEO_MUNDIAL t ON t.id_edicion = f.id_edicion
            WHERE (? IS NULL OR t.id_edicion = ?)
            ORDER BY t.anio, f.nombre, en.pais
            """;

    // ---- Plantel (convocatoria) ----

    public static final String PLANTEL = """
            SELECT pl.id_vinculacion,
                   en.pais AS seleccion,
                   s.codigo_fifa AS codigo,
                   i.nombre_completo AS persona,
                   pl.rol,
                   pl.dorsal,
                   pl.posicion,
                   pl.capitan,
                   pl.club
            FROM PLANTEL_EQUIPO pl
            JOIN INTEGRANTE i ON i.id_persona = pl.id_persona
            JOIN EQUIPO_NACIONAL s ON s.id_seleccion = pl.id_seleccion
            JOIN ENTE_FUTBOLISTICO en ON en.id_organizacion = s.id_organizacion
            WHERE (? IS NULL OR s.id_seleccion = ?)
            ORDER BY en.pais, pl.rol, pl.dorsal
            """;

    // ---- Auditoria ----

    public static final String BITACORA = """
            SELECT id_auditoria,
                   TO_CHAR(fecha_hora, 'YYYY-MM-DD HH24:MI:SS') AS fecha,
                   usuario_bd,
                   tabla_afectada,
                   id_registro_afectado,
                   operacion
            FROM BITACORA_CAMBIOS
            ORDER BY id_auditoria DESC
            """;
}
