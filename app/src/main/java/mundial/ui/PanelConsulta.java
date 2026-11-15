package mundial.ui;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
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
 * Pantalla de solo lectura: muestra el resultado de una consulta, con un filtro
 * opcional (lista desplegable). Los paneles de partidos y plantel la extienden
 * para agregar sus propios botones.
 */
public class PanelConsulta extends JPanel {

    /** Elemento de una lista desplegable: valor (id) y texto que se ve. */
    public record Opcion(String valor, String etiqueta) {
        @Override
        public String toString() {
            return etiqueta;
        }
    }

    protected final RepositorioConsulta repositorio = new RepositorioConsulta();
    protected final JPanel botones = new JPanel(new FlowLayout(FlowLayout.LEFT));
    protected final JTable tabla;
    protected JComboBox<Opcion> filtro;

    private final DefaultTableModel modelo = new DefaultTableModel() {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private final String sql;

    public PanelConsulta(String titulo, String sql) {
        this(titulo, sql, null, null);
    }

    public PanelConsulta(String titulo, String sql, String etiquetaFiltro, String sqlOpciones) {
        super(new BorderLayout(0, 10));
        this.sql = sql;
        this.tabla = new JTable(modelo);
        setBorder(BorderFactory.createEmptyBorder(15, 15, 15, 15));

        JPanel norte = new JPanel(new FlowLayout(FlowLayout.LEFT));
        norte.add(new JLabel(titulo));
        if (etiquetaFiltro != null) {
            norte.add(new JLabel("      " + etiquetaFiltro + ":"));
            filtro = new JComboBox<>();
            filtro.addItem(new Opcion(null, "Todos"));
            try {
                for (String[] o : repositorio.opciones(sqlOpciones)) {
                    filtro.addItem(new Opcion(o[0], o[1]));
                }
            } catch (SQLException ex) {
                Mensajes.error(this, ex);
            }
            filtro.addActionListener(e -> cargar());
            norte.add(filtro);
        }
        add(norte, BorderLayout.NORTH);
        add(new JScrollPane(tabla), BorderLayout.CENTER);

        JButton recargar = new JButton("Recargar");
        recargar.addActionListener(e -> cargar());
        botones.add(recargar);
        add(botones, BorderLayout.SOUTH);

        cargar();
    }

    protected void cargar() {
        try {
            String[] params = new String[(int) sql.chars().filter(c -> c == '?').count()];
            Arrays.fill(params, valorFiltro());
            Tabla datos = repositorio.consultar(sql, params);
            modelo.setDataVector(datos.filas().toArray(new Object[0][]), datos.columnas());
        } catch (SQLException ex) {
            Mensajes.error(this, ex);
        }
    }

    /** Valor (id) elegido en el filtro; null si es "Todos" o no hay filtro. */
    protected String valorFiltro() {
        return filtro == null ? null : ((Opcion) filtro.getSelectedItem()).valor();
    }

    /** Valor de la primera columna de la fila seleccionada; null si no hay seleccion. */
    protected String idSeleccionado() {
        int fila = tabla.getSelectedRow();
        if (fila < 0) {
            Mensajes.info(this, "Seleccione una fila de la tabla.");
            return null;
        }
        return String.valueOf(modelo.getValueAt(tabla.convertRowIndexToModel(fila), 0));
    }

    /** Lista desplegable sin la opcion "Todos", para usar en formularios. */
    protected static JComboBox<Opcion> combo(List<String[]> opciones) {
        JComboBox<Opcion> combo = new JComboBox<>();
        for (String[] o : opciones) {
            combo.addItem(new Opcion(o[0], o[1]));
        }
        return combo;
    }

    protected static String valor(JComboBox<Opcion> combo) {
        return ((Opcion) combo.getSelectedItem()).valor();
    }
}
