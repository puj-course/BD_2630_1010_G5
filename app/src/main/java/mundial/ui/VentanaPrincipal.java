package mundial.ui;

import java.awt.BorderLayout;
import java.awt.Font;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.SwingConstants;
import mundial.datos.Catalogos;
import mundial.datos.Consultas;

public class VentanaPrincipal extends JFrame {

    public VentanaPrincipal(String usuario) {
        super("Copa Mundial FIFA - " + usuario);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(1100, 680);
        setLocationRelativeTo(null);

        JMenuBar barra = new JMenuBar();

        JMenu catalogos = new JMenu("Catalogos");
        agregar(catalogos, "Ediciones del Mundial", () -> new PanelCrud("Ediciones del Mundial", Catalogos.ediciones()));
        agregar(catalogos, "Sedes", () -> new PanelCrud("Sedes (paises anfitriones)", Catalogos.sedes()));
        agregar(catalogos, "Ciudades", () -> new PanelCrud("Ciudades", Catalogos.ciudades()));
        agregar(catalogos, "Estadios", () -> new PanelCrud("Estadios", Catalogos.estadios()));
        catalogos.addSeparator();
        agregar(catalogos, "Fases y grupos", () -> new PanelCrud("Fases y grupos", Catalogos.fases()));
        agregar(catalogos, "Federaciones y confederaciones", () -> new PanelCrud("Federaciones y confederaciones", Catalogos.federaciones()));
        agregar(catalogos, "Selecciones", () -> new PanelCrud("Selecciones", Catalogos.selecciones()));
        catalogos.addSeparator();
        agregar(catalogos, "Integrantes (personas)", () -> new PanelCrud("Integrantes", Catalogos.integrantes()));
        agregar(catalogos, "Jugadores y cuerpo tecnico", PanelPlantel::new);

        JMenu partidos = new JMenu("Partidos");
        agregar(partidos, "Registro de partidos", PanelPartidos::new);
        agregar(partidos, "Arbitros del partido", () -> new PanelCrud("Terna arbitral", Catalogos.arbitros()));
        agregar(partidos, "Sucesos del partido", () -> new PanelCrud("Sucesos del partido", Catalogos.sucesos()));
        agregar(partidos, "Estadisticas", () -> new PanelCrud("Estadisticas por jugador", Catalogos.estadisticas()));
        agregar(partidos, "Incidencias", () -> new PanelCrud("Incidencias del partido", Catalogos.incidencias()));

        JMenu logistica = new JMenu("Logistica");
        agregar(logistica, "Boletos", () -> new PanelCrud("Boletos", Catalogos.boletos()));
        agregar(logistica, "Credenciales de prensa", () -> new PanelCrud("Credenciales de medios", Catalogos.credenciales()));

        JMenu consultas = new JMenu("Consultas");
        agregar(consultas, "Tabla de posiciones", () -> new PanelConsulta("Tabla de posiciones", Consultas.POSICIONES, "Edicion", Consultas.OPCIONES_EDICION));
        agregar(consultas, "Resultados", () -> new PanelConsulta("Resultados de partidos finalizados", Consultas.RESULTADOS, "Edicion", Consultas.OPCIONES_EDICION));
        agregar(consultas, "Incidencias", () -> new PanelConsulta("Consulta de incidencias", Consultas.INCIDENCIAS, "Tipo", Consultas.OPCIONES_TIPO_INCIDENCIA));
        agregar(consultas, "Rendimiento de selecciones", () -> new PanelConsulta("Rendimiento de selecciones", Consultas.RENDIMIENTO_SELECCIONES, "Edicion", Consultas.OPCIONES_EDICION));
        agregar(consultas, "Bitacora de cambios", () -> new PanelConsulta("Bitacora de cambios", Consultas.BITACORA));

        JMenu reportes = new JMenu("Reportes");
        agregar(reportes, "Panel de reportes", PanelReportes::new);

        barra.add(catalogos);
        barra.add(partidos);
        barra.add(logistica);
        barra.add(consultas);
        barra.add(reportes);
        setJMenuBar(barra);

        mostrar(inicio(usuario));
    }

    private void agregar(JMenu menu, String titulo, Pantalla pantalla) {
        JMenuItem item = new JMenuItem(titulo);
        item.addActionListener(e -> mostrar(pantalla.crear()));
        menu.add(item);
    }

    private void mostrar(JPanel panel) {
        getContentPane().removeAll();
        getContentPane().add(panel, BorderLayout.CENTER);
        revalidate();
        repaint();
    }

    private JPanel inicio(String usuario) {
        JPanel panel = new JPanel(new BorderLayout());
        JLabel texto = new JLabel("Conectado a Oracle como " + usuario + ". Elija un modulo en el menu.",
                SwingConstants.CENTER);
        texto.setFont(texto.getFont().deriveFont(Font.PLAIN, 16f));
        panel.add(texto, BorderLayout.CENTER);
        return panel;
    }

    @FunctionalInterface
    private interface Pantalla {
        JPanel crear();
    }
}
