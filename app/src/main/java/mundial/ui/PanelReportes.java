package mundial.ui;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;
import mundial.datos.RepositorioConsulta;
import mundial.datos.Tabla;

/**
 * Panel de reportes: ejecuta las 10 consultas avanzadas de la Entrega 2. Las consultas
 * se leen del archivo reportes.sql (el mismo consultas_avanzadas_mundial.sql).
 */
public class PanelReportes extends JPanel {

    private record Reporte(String titulo, String sql) {
        @Override
        public String toString() {
            return titulo;
        }
    }

    private final RepositorioConsulta repositorio = new RepositorioConsulta();
    private final DefaultTableModel modelo = new DefaultTableModel() {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private final JComboBox<Reporte> reportes = new JComboBox<>();

    public PanelReportes() {
        super(new BorderLayout(0, 10));
        setBorder(BorderFactory.createEmptyBorder(15, 15, 15, 15));

        JPanel norte = new JPanel(new FlowLayout(FlowLayout.LEFT));
        norte.add(new JLabel("Reporte:"));
        for (Reporte r : leerReportes()) {
            reportes.addItem(r);
        }
        norte.add(reportes);
        JButton ejecutar = new JButton("Ejecutar");
        ejecutar.addActionListener(e -> ejecutar());
        norte.add(ejecutar);

        add(norte, BorderLayout.NORTH);
        add(new JScrollPane(new JTable(modelo)), BorderLayout.CENTER);
    }

    private void ejecutar() {
        Reporte r = (Reporte) reportes.getSelectedItem();
        if (r == null) {
            return;
        }
        try {
            Tabla datos = repositorio.consultar(r.sql());
            modelo.setDataVector(datos.filas().toArray(new Object[0][]), datos.columnas());
        } catch (SQLException ex) {
            Mensajes.error(this, ex);
        }
    }

    /** Separa el archivo por los encabezados "-- N. Titulo" y quita los comentarios y el ";" final. */
    private List<Reporte> leerReportes() {
        List<Reporte> lista = new ArrayList<>();
        try (InputStream in = getClass().getResourceAsStream("/reportes.sql")) {
            if (in == null) {
                return lista;
            }
            String texto = new String(in.readAllBytes(), StandardCharsets.UTF_8);
            Pattern encabezado = Pattern.compile("^-- (\\d+)\\. (.+)$", Pattern.MULTILINE);
            Matcher m = encabezado.matcher(texto);
            List<int[]> posiciones = new ArrayList<>();
            List<String> titulos = new ArrayList<>();
            while (m.find()) {
                posiciones.add(new int[] {m.start(), m.end()});
                titulos.add(m.group(1) + ". " + m.group(2).trim());
            }
            for (int i = 0; i < posiciones.size(); i++) {
                int fin = i + 1 < posiciones.size() ? posiciones.get(i + 1)[0] : texto.length();
                StringBuilder sql = new StringBuilder();
                for (String linea : texto.substring(posiciones.get(i)[1], fin).split("\n")) {
                    if (!linea.trim().startsWith("--")) {
                        sql.append(linea).append("\n");
                    }
                }
                String limpio = sql.toString().trim();
                if (limpio.endsWith(";")) {
                    limpio = limpio.substring(0, limpio.length() - 1);
                }
                lista.add(new Reporte(titulos.get(i), limpio));
            }
        } catch (IOException e) {
            Mensajes.error(this, e);
        }
        return lista;
    }
}
