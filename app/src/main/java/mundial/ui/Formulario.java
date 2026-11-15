package mundial.ui;

import java.awt.Component;
import java.awt.GridLayout;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

/** Arma formularios sencillos de dos columnas: etiqueta y componente. */
public class Formulario {

    /** Recibe pares (texto de etiqueta, componente). */
    public static JPanel panel(Object... pares) {
        JPanel panel = new JPanel(new GridLayout(0, 2, 8, 6));
        for (int i = 0; i < pares.length; i += 2) {
            panel.add(new JLabel((String) pares[i]));
            panel.add((Component) pares[i + 1]);
        }
        return panel;
    }

    /** Muestra el formulario con Aceptar y Cancelar. Devuelve true si acepto. */
    public static boolean pedir(Component padre, String titulo, JPanel panel) {
        return JOptionPane.showConfirmDialog(padre, panel, titulo,
                JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE) == JOptionPane.OK_OPTION;
    }
}
