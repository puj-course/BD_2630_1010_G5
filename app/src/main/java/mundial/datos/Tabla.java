package mundial.datos;

import java.util.List;

/** Resultado de una consulta: nombres de columnas y filas (todo como texto). */
public record Tabla(String[] columnas, List<Object[]> filas) {
}
