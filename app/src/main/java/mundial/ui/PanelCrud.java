package mundial.ui;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;
import mundial.datos.Campo;
import mundial.datos.RepositorioTabla;
import mundial.datos.Tabla;

/** Pantalla generica: lista una tabla y permite crear, modificar y eliminar filas. */
public class PanelCrud extends JPanel {

    private final RepositorioTabla repositorio;
    private final DefaultTableModel modelo = new DefaultTableModel() {
        @Override
        public boolean isCellEditable(int fila, int columna) {
            return false;
        }
    };
    private final JTable tabla = new JTable(modelo);

    public PanelCrud(String titulo, RepositorioTabla repositorio) {
        super(new BorderLayout(0, 10));
        this.repositorio = repositorio;
        setBorder(BorderFactory.createEmptyBorder(15, 15, 15, 15));

        add(new JLabel(titulo), BorderLayout.NORTH);
        add(new JScrollPane(tabla), BorderLayout.CENTER);

        JButton nuevo = new JButton("Nuevo");
        nuevo.addActionListener(e -> nuevo());
        JButton modificar = new JButton("Modificar");
        modificar.addActionListener(e -> modificar());
        JButton eliminar = new JButton("Eliminar");
        eliminar.addActionListener(e -> eliminar());
        JButton recargar = new JButton("Recargar");
        recargar.addActionListener(e -> cargar());

        JPanel botones = new JPanel(new FlowLayout(FlowLayout.LEFT));
        botones.add(nuevo);
        botones.add(modificar);
        botones.add(eliminar);
        botones.add(recargar);
        add(botones, BorderLayout.SOUTH);

        cargar();
    }

    private void cargar() {
        try {
            Tabla datos = repositorio.listar();
            modelo.setDataVector(datos.filas().toArray(new Object[0][]), datos.columnas());
        } catch (SQLException ex) {
            Mensajes.error(this, ex);
        }
    }

    private void nuevo() {
        Map<String, String> valores = formulario("Nuevo registro", null);
        if (valores == null) {
            return;
        }
        try {
            repositorio.insertar(valores);
            cargar();
        } catch (SQLException | IllegalArgumentException ex) {
            Mensajes.error(this, ex);
        }
    }

    private void modificar() {
        int fila = tabla.getSelectedRow();
        if (fila < 0) {
            Mensajes.info(this, "Seleccione una fila de la tabla.");
            return;
        }
        Map<String, String> actuales = new HashMap<>();
        for (int i = 0; i < repositorio.getCampos().size(); i++) {
            Object v = modelo.getValueAt(tabla.convertRowIndexToModel(fila), i);
            actuales.put(repositorio.getCampos().get(i).columna(), v == null ? "" : v.toString());
        }
        Map<String, String> valores = formulario("Modificar registro", actuales);
        if (valores == null) {
            return;
        }
        try {
            repositorio.actualizar(valores);
            cargar();
        } catch (SQLException | IllegalArgumentException ex) {
            Mensajes.error(this, ex);
        }
    }

    private void eliminar() {
        int fila = tabla.getSelectedRow();
        if (fila < 0) {
            Mensajes.info(this, "Seleccione una fila de la tabla.");
            return;
        }
        String id = String.valueOf(modelo.getValueAt(tabla.convertRowIndexToModel(fila), 0));
        if (!Mensajes.confirmar(this, "Eliminar el registro con id " + id + "?")) {
            return;
        }
        try {
            repositorio.eliminar(id);
            cargar();
        } catch (SQLException ex) {
            Mensajes.error(this, ex);
        }
    }

    /** Muestra el formulario. Si 'actuales' es null es un registro nuevo. Devuelve null si cancela. */
    private Map<String, String> formulario(String titulo, Map<String, String> actuales) {
        Map<String, JTextField> cajas = new LinkedHashMap<>();
        Object[] pares = new Object[repositorio.getCampos().size() * 2];
        int i = 0;
        for (Campo c : repositorio.getCampos()) {
            JTextField caja = new JTextField(actuales == null ? c.porDefecto() : actuales.get(c.columna()), 22);
            if (c.llave()) {
                caja.setEditable(false);
                if (actuales == null) {
                    caja.setText("(automatico)");
                }
            }
            cajas.put(c.columna(), caja);
            pares[i++] = c.etiqueta() + c.ayuda();
            pares[i++] = caja;
        }
        if (!Formulario.pedir(this, titulo, Formulario.panel(pares))) {
            return null;
        }
        Map<String, String> valores = new HashMap<>();
        for (Campo c : repositorio.getCampos()) {
            String texto = cajas.get(c.columna()).getText();
            valores.put(c.columna(), c.llave() && actuales == null ? "" : texto);
        }
        return valores;
    }
}
