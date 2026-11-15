package mundial.datos;

/** Una columna de una tabla que el usuario puede ver y editar en pantalla. */
public record Campo(String columna, String etiqueta, Tipo tipo, boolean llave, String porDefecto) {

    public enum Tipo { TEXTO, NUMERO, FECHA, FECHA_HORA }

    public static Campo id(String columna, String etiqueta) {
        return new Campo(columna, etiqueta, Tipo.NUMERO, true, "");
    }

    public static Campo texto(String columna, String etiqueta) {
        return new Campo(columna, etiqueta, Tipo.TEXTO, false, "");
    }

    public static Campo numero(String columna, String etiqueta) {
        return new Campo(columna, etiqueta, Tipo.NUMERO, false, "");
    }

    public static Campo numero(String columna, String etiqueta, String porDefecto) {
        return new Campo(columna, etiqueta, Tipo.NUMERO, false, porDefecto);
    }

    public static Campo fecha(String columna, String etiqueta) {
        return new Campo(columna, etiqueta, Tipo.FECHA, false, "");
    }

    public static Campo fechaHora(String columna, String etiqueta) {
        return new Campo(columna, etiqueta, Tipo.FECHA_HORA, false, "");
    }

    /** Texto de ayuda para el formulario. */
    public String ayuda() {
        return switch (tipo) {
            case FECHA -> " (aaaa-mm-dd)";
            case FECHA_HORA -> " (aaaa-mm-dd hh:mm)";
            default -> "";
        };
    }
}
