package mundial.ui;

import java.sql.SQLException;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JTextField;
import mundial.datos.Consultas;
import mundial.datos.RepositorioPartido;

/** Registro de partidos: lista, programar un partido nuevo y registrar su resultado. */
public class PanelPartidos extends PanelConsulta {

    private final RepositorioPartido partidos = new RepositorioPartido();

    public PanelPartidos() {
        super("Registro de partidos", Consultas.PARTIDOS, "Edicion", Consultas.OPCIONES_EDICION);

        JButton programar = new JButton("Programar partido");
        programar.addActionListener(e -> programar());
        JButton resultado = new JButton("Registrar resultado");
        resultado.addActionListener(e -> registrarResultado());
        botones.add(programar);
        botones.add(resultado);
    }

    private void programar() {
        try {
            JComboBox<Opcion> fase = combo(repositorio.opciones(Consultas.OPCIONES_FASE));
            JComboBox<Opcion> estadio = combo(repositorio.opciones(Consultas.OPCIONES_ESTADIO));
            JTextField fecha = new JTextField("2026-07-20 20:00");
            JComboBox<Opcion> local = combo(repositorio.opciones(Consultas.OPCIONES_SELECCION));
            JComboBox<Opcion> visitante = combo(repositorio.opciones(Consultas.OPCIONES_SELECCION));

            if (!Formulario.pedir(this, "Programar partido", Formulario.panel(
                    "Fase", fase,
                    "Estadio", estadio,
                    "Fecha y hora (aaaa-mm-dd hh:mm)", fecha,
                    "Equipo local", local,
                    "Equipo visitante", visitante))) {
                return;
            }
            if (valor(local).equals(valor(visitante))) {
                Mensajes.info(this, "El local y el visitante deben ser equipos distintos.");
                return;
            }
            partidos.programar(Integer.parseInt(valor(fase)), Integer.parseInt(valor(estadio)), fecha.getText(),
                    Integer.parseInt(valor(local)), Integer.parseInt(valor(visitante)));
            cargar();
            Mensajes.info(this, "Partido programado.");
        } catch (SQLException | IllegalArgumentException ex) {
            Mensajes.error(this, ex);
        }
    }

    private void registrarResultado() {
        String id = idSeleccionado();
        if (id == null) {
            return;
        }
        JTextField golesLocal = new JTextField("0");
        JTextField golesVisitante = new JTextField("0");
        JTextField penalesLocal = new JTextField("0");
        JTextField penalesVisitante = new JTextField("0");

        if (!Formulario.pedir(this, "Registrar resultado del partido " + id, Formulario.panel(
                "Goles del local", golesLocal,
                "Goles del visitante", golesVisitante,
                "Penales del local", penalesLocal,
                "Penales del visitante", penalesVisitante))) {
            return;
        }
        try {
            partidos.registrarResultado(Integer.parseInt(id),
                    Integer.parseInt(golesLocal.getText().trim()),
                    Integer.parseInt(golesVisitante.getText().trim()),
                    Integer.parseInt(penalesLocal.getText().trim()),
                    Integer.parseInt(penalesVisitante.getText().trim()));
            cargar();
            Mensajes.info(this, "Resultado registrado. El partido quedo FINALIZADO.");
        } catch (SQLException | IllegalArgumentException ex) {
            Mensajes.error(this, ex);
        }
    }
}
