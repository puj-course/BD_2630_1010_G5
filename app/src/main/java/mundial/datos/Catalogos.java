package mundial.datos;

/** Descripcion de las tablas que se administran con el CRUD generico. */
public class Catalogos {

    public static RepositorioTabla ediciones() {
        return new RepositorioTabla("TORNEO_MUNDIAL",
                Campo.id("id_edicion", "Id"),
                Campo.numero("anio", "Anio"),
                Campo.texto("nombre", "Nombre"),
                Campo.texto("lema", "Lema"),
                Campo.fecha("fecha_inicio", "Inicio"),
                Campo.fecha("fecha_fin", "Fin"));
    }

    public static RepositorioTabla sedes() {
        return new RepositorioTabla("PAIS_ANFITRION",
                Campo.id("id_sede", "Id"),
                Campo.numero("id_edicion", "Id edicion"),
                Campo.texto("pais", "Pais"));
    }

    public static RepositorioTabla ciudades() {
        return new RepositorioTabla("LOCALIDAD",
                Campo.id("id_ciudad", "Id"),
                Campo.numero("id_sede", "Id sede"),
                Campo.texto("nombre", "Nombre"));
    }

    public static RepositorioTabla estadios() {
        return new RepositorioTabla("RECINTO_DEPORTIVO",
                Campo.id("id_estadio", "Id"),
                Campo.numero("id_ciudad", "Id ciudad"),
                Campo.texto("nombre", "Nombre"),
                Campo.numero("capacidad", "Capacidad"));
    }

    public static RepositorioTabla fases() {
        return new RepositorioTabla("FASE_TORNEO",
                Campo.id("id_etapa", "Id"),
                Campo.numero("id_edicion", "Id edicion"),
                Campo.numero("id_etapa_padre", "Id fase padre"),
                Campo.texto("nombre", "Nombre"),
                Campo.texto("tipo_etapa", "Tipo (FASE, GRUPO, INSTANCIA_ELIMINATORIA)"),
                Campo.numero("orden", "Orden"));
    }

    public static RepositorioTabla federaciones() {
        return new RepositorioTabla("ENTE_FUTBOLISTICO",
                Campo.id("id_organizacion", "Id"),
                Campo.texto("nombre", "Nombre"),
                Campo.texto("tipo", "Tipo (CONFEDERACION, FEDERACION_NACIONAL)"),
                Campo.texto("pais", "Pais"),
                Campo.numero("id_organizacion_padre", "Id organizacion padre"));
    }

    public static RepositorioTabla selecciones() {
        return new RepositorioTabla("EQUIPO_NACIONAL",
                Campo.id("id_seleccion", "Id"),
                Campo.numero("id_organizacion", "Id federacion"),
                Campo.numero("id_etapa_grupo", "Id grupo"),
                Campo.texto("codigo_fifa", "Codigo FIFA"));
    }

    public static RepositorioTabla integrantes() {
        return new RepositorioTabla("INTEGRANTE",
                Campo.id("id_persona", "Id"),
                Campo.texto("nombre_completo", "Nombre completo"),
                Campo.texto("nacionalidad", "Nacionalidad"),
                Campo.fecha("fecha_de_nacimiento", "Fecha de nacimiento"));
    }

    public static RepositorioTabla arbitros() {
        return new RepositorioTabla("TERNA_ARBITRAL",
                Campo.id("id_asignacion", "Id"),
                Campo.numero("id_partido", "Id partido"),
                Campo.numero("id_persona", "Id arbitro (persona)"),
                Campo.texto("rol_arbitral", "Rol (CENTRAL, ASISTENTE_1, ASISTENTE_2, CUARTO_ARBITRO, VAR, AVAR)"));
    }

    public static RepositorioTabla sucesos() {
        return new RepositorioTabla("SUCESO_ENCUENTRO",
                Campo.id("id_evento", "Id"),
                Campo.numero("id_partido", "Id partido"),
                Campo.numero("id_persona", "Id persona"),
                Campo.numero("id_persona_relacionada", "Id persona relacionada"),
                Campo.texto("tipo_evento", "Tipo (GOL, ASISTENCIA, TARJETA_AMARILLA, TARJETA_ROJA, SUSTITUCION, MINUTOS_JUGADOS)"),
                Campo.numero("minuto", "Minuto"),
                Campo.numero("valor_numerico", "Valor numerico"),
                Campo.texto("descripcion", "Descripcion"));
    }

    public static RepositorioTabla estadisticas() {
        return new RepositorioTabla("RENDIMIENTO_JUGADOR",
                Campo.id("id_estadistica", "Id"),
                Campo.numero("id_partido", "Id partido"),
                Campo.numero("id_persona", "Id jugador (persona)"),
                Campo.numero("goles", "Goles", "0"),
                Campo.numero("asistencias", "Asistencias", "0"),
                Campo.numero("tarjetas_amarillas", "Tarjetas amarillas", "0"),
                Campo.numero("tarjetas_rojas", "Tarjetas rojas", "0"),
                Campo.numero("tiros", "Tiros", "0"),
                Campo.numero("minutos_jugados", "Minutos jugados (0 a 120)", "0"));
    }

    public static RepositorioTabla incidencias() {
        return new RepositorioTabla("NOVEDAD_ENCUENTRO",
                Campo.id("id_incidencia", "Id"),
                Campo.numero("id_partido", "Id partido"),
                Campo.texto("tipo", "Tipo (CLIMATICA, DISCIPLINARIA, TECNICA, OTRA)"),
                Campo.texto("descripcion", "Descripcion"),
                Campo.numero("minuto", "Minuto"));
    }

    public static RepositorioTabla boletos() {
        return new RepositorioTabla("BOLETO",
                Campo.id("id_entrada", "Id"),
                Campo.numero("id_partido", "Id partido"),
                Campo.texto("categoria", "Categoria"),
                Campo.texto("zona", "Zona"),
                Campo.numero("precio", "Precio"),
                Campo.texto("estado", "Estado (DISPONIBLE, VENDIDO)"));
    }

    public static RepositorioTabla credenciales() {
        return new RepositorioTabla("CREDENCIAL_MEDIOS",
                Campo.id("id_acreditacion", "Id"),
                Campo.numero("id_persona", "Id persona"),
                Campo.numero("id_edicion", "Id edicion"),
                Campo.texto("medio_comunicacio", "Medio de comunicacion"),
                Campo.fecha("fecha_emision", "Fecha de emision"),
                Campo.texto("tipo_acreditacion", "Tipo de acreditacion"),
                Campo.texto("estado", "Estado"));
    }
}
