package mundial.ui;

import java.sql.SQLException;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JTextField;
import mundial.datos.Consultas;
import mundial.datos.RepositorioPlantel;

/** Jugadores y cuerpo tecnico: lista la convocatoria y permite convocar o quitar a una persona. */
public class PanelPlantel extends PanelConsulta {

    private final RepositorioPlantel plantel = new RepositorioPlantel();

    public PanelPlantel() {
        super("Jugadores y cuerpo tecnico", Consultas.PLANTEL, "Seleccion", Consultas.OPCIONES_SELECCION);

        JButton convocar = new JButton("Convocar jugador");
        convocar.addActionListener(e -> convocar());
        JButton quitar = new JButton("Quitar del plantel");
        quitar.addActionListener(e -> quitar());
        botones.add(convocar);
        botones.add(quitar);
    }

    private void convocar() {
        try {
            JComboBox<Opcion> seleccion = combo(repositorio.opciones(Consultas.OPCIONES_SELECCION));
            JComboBox<Opcion> persona = combo(repositorio.opciones(Consultas.OPCIONES_PERSONA));
            JTextField dorsal = new JTextField();
            JTextField posicion = new JTextField();
            JComboBox<String> capitan = new JComboBox<>(new String[] {"N", "S"});
            JTextField club = new JTextField();

            // Si hay una seleccion elegida en el filtro, queda preseleccionada.
            String actual = valorFiltro();
            for (int i = 0; actual != null && i < seleccion.getItemCount(); i++) {
                if (seleccion.getItemAt(i).valor().equals(actual)) {
                    seleccion.setSelectedIndex(i);
                }
            }

            if (!Formulario.pedir(this, "Convocar jugador", Formulario.panel(
                    "Seleccion", seleccion,
                    "Persona", persona,
                    "Dorsal (1 a 99)", dorsal,
                    "Posicion", posicion,
                    "Capitan", capitan,
                    "Club", club))) {
                return;
            }
            plantel.convocar(Integer.parseInt(valor(seleccion)), Integer.parseInt(valor(persona)),
                    Integer.parseInt(dorsal.getText().trim()), posicion.getText(),
                    (String) capitan.getSelectedItem(), club.getText());
            cargar();
            Mensajes.info(this, "Jugador convocado.");
        } catch (SQLException | IllegalArgumentException ex) {
            Mensajes.error(this, ex);
        }
    }

    private void quitar() {
        String id = idSeleccionado();
        if (id == null || !Mensajes.confirmar(this, "Quitar del plantel el registro " + id + "?")) {
            return;
        }
        try {
            plantel.quitar(Integer.parseInt(id));
            cargar();
        } catch (SQLException ex) {
            Mensajes.error(this, ex);
        }
    }
}
