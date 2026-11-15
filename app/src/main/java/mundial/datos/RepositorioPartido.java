package mundial.datos;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import mundial.Conexion;

/** Operaciones sobre partidos: programar uno nuevo y registrar su resultado. */
public class RepositorioPartido {

    /**
     * Crea el partido (estado PROGRAMADO) con sus dos equipos y marcador 0-0.
     * Todo en una transaccion. El trigger trg_cruce_agenda_estadio rechaza el
     * partido si el estadio ya esta ocupado a esa hora.
     */
    public void programar(int idFase, int idEstadio, String fechaHora, int idLocal, int idVisitante)
            throws SQLException {
        String t = fechaHora.trim();
        Timestamp fecha = Timestamp.valueOf(t.length() == 16 ? t + ":00" : t);

        try (Connection con = Conexion.abrir()) {
            con.setAutoCommit(false);
            try {
                int idPartido = RepositorioTabla.siguienteId(con, "ENCUENTRO", "id_partido");
                int idParticipacion = RepositorioTabla.siguienteId(con, "PARTICIPANTE_ENCUENTRO", "id_participacion_partido");

                try (PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO ENCUENTRO (id_partido, id_etapa, id_estadio, fecha_hora, asistencia_registrada, estado) "
                                + "VALUES (?, ?, ?, ?, 0, 'PROGRAMADO')")) {
                    ps.setInt(1, idPartido);
                    ps.setInt(2, idFase);
                    ps.setInt(3, idEstadio);
                    ps.setTimestamp(4, fecha);
                    ps.executeUpdate();
                }

                insertarParticipante(con, idParticipacion, idPartido, idLocal, "LOCAL");
                insertarParticipante(con, idParticipacion + 1, idPartido, idVisitante, "VISITANTE");
                con.commit();
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
        }
    }

    private void insertarParticipante(Connection con, int id, int idPartido, int idSeleccion, String condicion)
            throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(
                "INSERT INTO PARTICIPANTE_ENCUENTRO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales) "
                        + "VALUES (?, ?, ?, ?, 0, 0)")) {
            ps.setInt(1, id);
            ps.setInt(2, idPartido);
            ps.setInt(3, idSeleccion);
            ps.setString(4, condicion);
            ps.executeUpdate();
        }
    }

    /**
     * Llama al procedimiento sp_registrar_resultado. El procedimiento no hace COMMIT:
     * la aplicacion confirma la transaccion si todo salio bien.
     */
    public void registrarResultado(int idPartido, int golesLocal, int golesVisitante,
                                   int penalesLocal, int penalesVisitante) throws SQLException {
        try (Connection con = Conexion.abrir()) {
            con.setAutoCommit(false);
            try (CallableStatement cs = con.prepareCall("{call sp_registrar_resultado(?, ?, ?, ?, ?)}")) {
                cs.setInt(1, idPartido);
                cs.setInt(2, golesLocal);
                cs.setInt(3, golesVisitante);
                cs.setInt(4, penalesLocal);
                cs.setInt(5, penalesVisitante);
                cs.execute();
                con.commit();
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
        }
    }
}
