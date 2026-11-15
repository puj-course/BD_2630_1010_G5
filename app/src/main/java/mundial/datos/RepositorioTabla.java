package mundial.datos;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.List;
import java.util.Map;
import mundial.Conexion;

/**
 * CRUD generico de una tabla del modelo. Cada tabla se describe con sus campos
 * (ver Catalogos). El primer campo marcado como llave es la PK (numerica).
 */
public class RepositorioTabla {

    private final String tabla;
    private final List<Campo> campos;
    private final Campo llave;

    public RepositorioTabla(String tabla, Campo... campos) {
        this.tabla = tabla;
        this.campos = List.of(campos);
        this.llave = this.campos.stream().filter(Campo::llave).findFirst().orElseThrow();
    }

    public List<Campo> getCampos() {
        return campos;
    }

    public Tabla listar() throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT ");
        for (int i = 0; i < campos.size(); i++) {
            Campo c = campos.get(i);
            if (i > 0) {
                sql.append(", ");
            }
            switch (c.tipo()) {
                case FECHA -> sql.append("TO_CHAR(").append(c.columna()).append(", 'YYYY-MM-DD') AS ").append(c.columna());
                case FECHA_HORA -> sql.append("TO_CHAR(").append(c.columna()).append(", 'YYYY-MM-DD HH24:MI') AS ").append(c.columna());
                default -> sql.append(c.columna());
            }
        }
        sql.append(" FROM ").append(tabla).append(" ORDER BY ").append(llave.columna());
        return new RepositorioConsulta().consultar(sql.toString());
    }

    /** Inserta una fila. Si la llave viene vacia se usa MAX + 1 (el modelo no usa secuencias). */
    public void insertar(Map<String, String> valores) throws SQLException {
        StringBuilder cols = new StringBuilder();
        StringBuilder marcas = new StringBuilder();
        for (Campo c : campos) {
            if (cols.length() > 0) {
                cols.append(", ");
                marcas.append(", ");
            }
            cols.append(c.columna());
            marcas.append("?");
        }
        String sql = "INSERT INTO " + tabla + " (" + cols + ") VALUES (" + marcas + ")";
        try (Connection con = Conexion.abrir();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int pos = 1;
            for (Campo c : campos) {
                String texto = valores.get(c.columna());
                if (c.llave() && (texto == null || texto.isBlank())) {
                    texto = String.valueOf(siguienteId(con, tabla, c.columna()));
                }
                enlazar(ps, pos++, c, texto);
            }
            ps.executeUpdate();
        }
    }

    /** Actualiza todas las columnas (menos la llave) de la fila con esa llave. */
    public void actualizar(Map<String, String> valores) throws SQLException {
        StringBuilder sets = new StringBuilder();
        for (Campo c : campos) {
            if (!c.llave()) {
                if (sets.length() > 0) {
                    sets.append(", ");
                }
                sets.append(c.columna()).append(" = ?");
            }
        }
        String sql = "UPDATE " + tabla + " SET " + sets + " WHERE " + llave.columna() + " = ?";
        try (Connection con = Conexion.abrir();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int pos = 1;
            for (Campo c : campos) {
                if (!c.llave()) {
                    enlazar(ps, pos++, c, valores.get(c.columna()));
                }
            }
            enlazar(ps, pos, llave, valores.get(llave.columna()));
            ps.executeUpdate();
        }
    }

    public void eliminar(String id) throws SQLException {
        String sql = "DELETE FROM " + tabla + " WHERE " + llave.columna() + " = ?";
        try (Connection con = Conexion.abrir();
             PreparedStatement ps = con.prepareStatement(sql)) {
            enlazar(ps, 1, llave, id);
            ps.executeUpdate();
        }
    }

    /** Siguiente id disponible: MAX + 1. */
    public static int siguienteId(Connection con, String tabla, String columna) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("SELECT NVL(MAX(" + columna + "), 0) + 1 FROM " + tabla);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    private static void enlazar(PreparedStatement ps, int pos, Campo c, String texto) throws SQLException {
        String t = texto == null ? "" : texto.trim();
        if (t.isEmpty()) {
            int tipoSql = switch (c.tipo()) {
                case TEXTO -> Types.VARCHAR;
                case NUMERO -> Types.NUMERIC;
                case FECHA -> Types.DATE;
                case FECHA_HORA -> Types.TIMESTAMP;
            };
            ps.setNull(pos, tipoSql);
            return;
        }
        switch (c.tipo()) {
            case TEXTO -> ps.setString(pos, t);
            case NUMERO -> ps.setBigDecimal(pos, new BigDecimal(t));
            case FECHA -> ps.setDate(pos, Date.valueOf(t));
            case FECHA_HORA -> ps.setTimestamp(pos, Timestamp.valueOf(t.length() == 16 ? t + ":00" : t));
        }
    }
}
