package mundial.datos;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
import mundial.Conexion;

/** Operaciones sobre la convocatoria (PLANTEL_EQUIPO). */
public class RepositorioPlantel {

    /**
     * Llama al procedimiento sp_convocar_jugador, que valida el cupo y el dorsal
     * con las funciones fn_validar_cupo_convocatoria y fn_verificar_dorsal_disponible.
     */
    public void convocar(int idSeleccion, int idPersona, int dorsal, String posicion,
                         String capitan, String club) throws SQLException {
        try (Connection con = Conexion.abrir()) {
            con.setAutoCommit(false);
            try (CallableStatement cs = con.prepareCall("{call sp_convocar_jugador(?, ?, ?, ?, ?, ?)}")) {
                cs.setInt(1, idSeleccion);
                cs.setInt(2, idPersona);
                cs.setInt(3, dorsal);
                if (posicion == null || posicion.isBlank()) {
                    cs.setNull(4, Types.VARCHAR);
                } else {
                    cs.setString(4, posicion.trim());
                }
                cs.setString(5, capitan);
                if (club == null || club.isBlank()) {
                    cs.setNull(6, Types.VARCHAR);
                } else {
                    cs.setString(6, club.trim());
                }
                cs.execute();
                con.commit();
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
        }
    }

    public void quitar(int idVinculacion) throws SQLException {
        try (Connection con = Conexion.abrir();
             PreparedStatement ps = con.prepareStatement("DELETE FROM PLANTEL_EQUIPO WHERE id_vinculacion = ?")) {
            ps.setInt(1, idVinculacion);
            ps.executeUpdate();
        }
    }
}
