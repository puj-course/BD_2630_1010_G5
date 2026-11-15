package mundial.datos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import mundial.Conexion;

/** Ejecuta consultas de solo lectura y devuelve el resultado como texto. */
public class RepositorioConsulta {

    /** Ejecuta un SELECT. Cada parametro se envia como texto (null = vacio). */
    public Tabla consultar(String sql, String... params) throws SQLException {
        try (Connection con = Conexion.abrir();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                if (params[i] == null) {
                    ps.setNull(i + 1, Types.VARCHAR);
                } else {
                    ps.setString(i + 1, params[i]);
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData md = rs.getMetaData();
                int n = md.getColumnCount();
                String[] columnas = new String[n];
                for (int i = 0; i < n; i++) {
                    columnas[i] = md.getColumnLabel(i + 1).toLowerCase();
                }
                List<Object[]> filas = new ArrayList<>();
                while (rs.next()) {
                    Object[] fila = new Object[n];
                    for (int i = 0; i < n; i++) {
                        fila[i] = rs.getString(i + 1);
                    }
                    filas.add(fila);
                }
                return new Tabla(columnas, filas);
            }
        }
    }

    /** Consulta de dos columnas (valor, etiqueta) para llenar listas desplegables. */
    public List<String[]> opciones(String sql) throws SQLException {
        List<String[]> lista = new ArrayList<>();
        try (Connection con = Conexion.abrir();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new String[] {rs.getString(1), rs.getString(2)});
            }
        }
        return lista;
    }
}
