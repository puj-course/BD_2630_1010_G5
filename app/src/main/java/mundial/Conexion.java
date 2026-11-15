package mundial;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class Conexion {

    private static final String ARCHIVO = "config.properties";

    public static Connection abrir() throws SQLException {
        Properties config = new Properties();
        try (FileInputStream entrada = new FileInputStream(ARCHIVO)) {
            config.load(entrada);
        } catch (IOException e) {
            throw new SQLException("No se encontro " + ARCHIVO + ". Copie config.example.properties y llenelo.");
        }
        Connection con = DriverManager.getConnection(
                config.getProperty("db.url"),
                config.getProperty("db.usuario"),
                config.getProperty("db.contrasena"));

        // Si el usuario no es el dueño de las tablas, se trabaja sobre el esquema del dueño.
        String esquema = config.getProperty("db.esquema", "").trim();
        if (!esquema.isEmpty()) {
            if (!esquema.matches("[A-Za-z0-9_$#]+")) {
                con.close();
                throw new SQLException("El valor de db.esquema no es valido.");
            }
            try (Statement st = con.createStatement()) {
                st.execute("ALTER SESSION SET CURRENT_SCHEMA = " + esquema);
            }
        }
        return con;
    }
}
