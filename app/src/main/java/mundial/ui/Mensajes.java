package mundial.ui;

import java.awt.Component;
import javax.swing.JOptionPane;

/** Ventanas de aviso. Los errores de Oracle se muestran tal cual (primera linea). */
public class Mensajes {

    public static void error(Component padre, Exception e) {
        String texto;
        if (e instanceof IllegalArgumentException) {
            texto = "Dato con formato invalido. Use numeros (123), fechas (aaaa-mm-dd) "
                    + "y fecha y hora (aaaa-mm-dd hh:mm).";
        } else {
            texto = e.getMessage() == null ? e.toString() : e.getMessage().split("\n")[0];
        }
        JOptionPane.showMessageDialog(padre, texto, "Error", JOptionPane.ERROR_MESSAGE);
    }

    public static void info(Component padre, String texto) {
        JOptionPane.showMessageDialog(padre, texto, "Informacion", JOptionPane.INFORMATION_MESSAGE);
    }

    public static boolean confirmar(Component padre, String texto) {
        return JOptionPane.showConfirmDialog(padre, texto, "Confirmar", JOptionPane.YES_NO_OPTION)
                == JOptionPane.YES_OPTION;
    }
}
