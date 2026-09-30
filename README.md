# BD_PROYECTO — Repositorio del Equipo
## Sistema de Información para la Gestión Integral de la Copa Mundial de la FIFA

Este repositorio se utiliza para desarrollar el proyecto de Bases de Datos desde la Semana 4 hasta la Semana 16 del curso, cubriendo la Entrega 1, la Entrega 2 y la Entrega 3, usando Git como herramienta de seguimiento del progreso.

Este README es el documento principal de lineamientos. Existen dos documentos complementarios:

- **README_CRONOGRAMA.md** — detalle semana a semana de entregables, nombres de archivo, contenido esperado y estructura de carpetas.
- **README_SERVIDOR_ENTREGA1.md** — guía de conexión al servidor de base de datos dispuesto por el curso para la Entrega 1 (modelo inicial).

Lee los tres documentos antes de empezar a trabajar.

---

## Información del equipo

- Integrante: Andrés Gómez
- Curso: Bases de Datos
- Entregas: 1 — Modelo relacional, SQL e integridad sobre el modelo inicial;
  2 — Consultas avanzadas, perfección del modelo y roles

---

## Alcance de la Entrega 1

La Entrega 1 se implementa sobre el modelo genérico inicial de cinco entidades:

1. `EDICION_MUNDIAL`
2. `ESTADIO`
3. `SELECCION`
4. `PARTIDO`
5. `PARTICIPACION_PARTIDO`

Se agregan únicamente ajustes menores necesarios para cumplir las consultas y reglas
solicitadas: asistencia registrada, estado del partido, resultado de cada participación y
claves compuestas de consistencia entre edición y sus entidades dependientes. Jugadores,
árbitros, grupos, estadísticas detalladas, boletería, prensa e incidencias se presentan como
evolución propuesta en la evaluación crítica (Sección 8.1.8), y se incorporan formalmente
en la Entrega 2.

---

## Alcance de la Entrega 2

A partir de la evaluación crítica y de la retroalimentación recibida en la sustentación, que no tuvimos de
la Entrega 1, se expande el modelo incorporando las entidades adicionales pertinentes
(jugadores, cuerpo técnico, árbitros, estadísticas, grupos, fases eliminatorias, boletería,
medios, incidencias, entre otras), normalizando hasta Tercera Forma Normal (3FN) y
definiendo roles con restricciones de acceso diferenciadas: Administrador del Torneo,
Analista Deportivo y Auditor/Consulta.

---

## Contexto académico

El proyecto se basa en el enunciado "Sistema de Información para la Gestión Integral de la Copa Mundial de la FIFA" (Ing. Luis Gabriel Moreno Sandoval, PhD. — Bases de Datos, PUJ). El trabajo se organiza según el siguiente cronograma académico del curso:

| Entrega | Semanas académicas | Semanas de trabajo | Cierre |
|---|---|---|---|
| Entrega 1 | Semana 4 a Semana 7 | 4 semanas | Semana 8 |
| Entrega 2 | Semana 9 a Semana 12 | 4 semanas | Semana 13 |
| Entrega 3 | Semana 14 a Semana 16 | 3 semanas | Semana 17 |

El detalle de qué se entrega cada semana específica está en README_CRONOGRAMA.md.

---

## Metodología de Trabajo

### 1. Trabajo por Ramas

Cada tarea/entregable debe realizarse en una rama diferente, creada a partir de `main`.

**Nombre sugerido:**
```
feature/<descripcion>
```

**Ejemplos:**
```
feature/consultas-joins-semana1
feature/modelo-logico
feature/triggers-auditoria
feature/documento-tecnico
```

#### Flujo recomendado:

**1. Crear la rama desde `main`**
```bash
git checkout main
git pull
git checkout -b feature/nombre-tarea
```

**2. Commits del progreso** (frecuentes, no solo uno al final de la semana)
```bash
git add .
git commit -m "Mensaje de commit descriptivo"
```

**3. Subir la rama al repositorio:**
```bash
git push origin feature/nombre-tarea
```

**4. Crear un Pull Request** para integrar los cambios en `main`, y fusionarlo antes del cierre de la semana correspondiente.

---

### 2. Registro del Progreso — CHANGELOG.md

Cada semana (de las 12 semanas de trabajo del proyecto) se debe actualizar el archivo `CHANGELOG.md` agregando una nueva entrada, sin borrar las anteriores. Formato sugerido por semana:

```markdown
## Semana X — Entrega Y — [rango de fechas]

Objetivos: metas de la semana según README_CRONOGRAMA.md

Tareas realizadas: lo que se completó (con referencia a los archivos/carpetas entregados)

Responsables: integrantes a cargo de cada tarea

Ramas utilizadas: nombres de las ramas creadas/fusionadas esta semana

Problemas: inconvenientes encontrados y cómo se resolvieron (o si siguen pendientes)
```

Este registro, junto con los commits y Pull Requests, es la evidencia principal de que todos los integrantes participaron de forma semanal.

---

## Ventana de tiempo válida para el aporte semanal

Cada semana de trabajo del proyecto se evalúa dentro de la ventana:

```
Lunes 12:00 a.m. (00:00) — Domingo 11:59 p.m. (23:59), hora Colombia (UTC-5)
```

Los commits, ramas, Pull Requests y la actualización del `CHANGELOG.md` deben quedar registrados dentro de esa ventana para contar como aporte de esa semana específica.

---

## Evaluación del progreso semanal

El progreso del repositorio se revisa de forma semanal, considerando la actividad registrada en el historial de Git (commits, ramas, Pull Requests), la actualización del `CHANGELOG.md`, y la revisión del contenido técnico entregado.

Es indispensable seguir exactamente los nombres de archivo, extensiones y rutas indicadas en README_CRONOGRAMA.md.

No seguir los nombres de archivo, formatos o ubicaciones especificadas en README_CRONOGRAMA.md baja la nota, incluso si el contenido técnico es correcto, porque dificulta tanto la revisión manual como la automática.

---

## Participación individual

Es requisito indispensable que todos los integrantes registren actividad semanal verificable en el repositorio (commits con su propio correo, contribuciones en ramas, participación en Pull Requests o registro en el CHANGELOG). Los integrantes que no demuestren avances semanales verificables no serán tenidos en cuenta en la calificación de la entrega correspondiente.

---

## Estructura General de Carpetas del Proyecto

```text
BD_PROYECTO/
│
├── app/                          ---> Entrega 3 (aplicación funcional)
│
├── docs/                         ---> Documentos, modelos, diagramas, diccionario de datos
│   ├── entrega1/
│   ├── entrega2/
│   └── entrega3/
│
├── sql/
│   ├── entrega1/
│   │   ├── consultas/
│   │   ├── ddl/
│   │   ├── dml/
│   │   ├── vistas/
│   │   ├── roles/
│   │   └── algebra_relacional/
│   │
│   ├── entrega2/
│   │   ├── consultas/
│   │   ├── ddl/
│   │   ├── dml/
│   │   └── roles/
│   │
│   └── entrega3/
│       ├── funciones/
│       ├── procedimientos/
│       └── triggers/
│
├── tests/
│   ├── entrega1/
│   ├── entrega2/
│   └── entrega3/
│
├── .gitignore
├── CHANGELOG.md
├── README.md
├── README_CRONOGRAMA.md
└── README_SERVIDOR_ENTREGA1.md
```

El detalle exacto de qué archivo va dentro de cada subcarpeta, semana a semana, está en README_CRONOGRAMA.md. Esa estructura es la que se debe seguir de forma precisa.

---

## Cronograma de avances

| Semana | Hito | Actividad | Responsable | Evidencia |
|---|---|---|---|---|
| 1 | Alcance y supuestos | Revisar enunciado y rúbrica; redactar descripción del problema, alcance y supuestos de modelado | Andrés Gómez | `README.md`, `CHANGELOG.md` |
| 2 | Modelo ER y lógico | Diagramar el ERD y transformarlo a modelo lógico; construir el diccionario de datos | Andrés Gómez | `docs/documento_tecnico.md` |
| 3 | Integridad y reglas de negocio | Implementar DDL, PK/FK con `ON DELETE`/`ON UPDATE` justificado, `CHECK`/`UNIQUE`, índices y restricciones de negocio adicionales | Andrés Gómez | `sql/01_ddl.sql` |
| 4 | Datos y vistas | Cargar dataset sintético (mínimo 100 registros por tabla principal) y crear entre 4 y 5 vistas justificadas | Andrés Gómez | `sql/02_datos_prueba.sql`, `sql/03_vistas.sql` |
| 5 | DML y privilegios | Probar ciclo de vida de un partido, operaciones inválidas, `ON DELETE` y roles con `GRANT`/`REVOKE` | Andrés Gómez | `sql/04_dml_pruebas.sql`, `sql/05_privilegios.sql` |
| 6 | Álgebra, consultas y evaluación crítica | Traducir consultas a álgebra relacional, resolver las quince consultas SQL y redactar la evaluación crítica del modelo inicial | Andrés Gómez | `sql/06_consultas.sql`, `docs/algebra_relacional.md`, `docs/evaluacion_critica.md` |
| 7 | Revisión y sustentación (Entrega 1) | Ejecutar todo en el servidor, capturar evidencias, integrar ramas a `main` y sustentar de forma individual | Andrés Gómez | `sql/07_verificacion.sql`, capturas de resultados |
| 8 | Expansión del modelo (Entrega 2) | Incorporar nuevas entidades, avanzar al modelo físico normalizado (3FN) y construir consultas avanzadas | Andrés Gómez | `docs/entrega2/modelo_fisico.md`, `sql/entrega2/08_ddl_ampliado.sql`, `sql/entrega2/09_consultas_avanzadas.sql` |
| 9 | Roles y pruebas (Entrega 2) | Definir roles diferenciados (Administrador, Analista Deportivo, Auditor) y ejecutar casos de prueba válidos y fallidos | Andrés Gómez | `sql/entrega2/10_roles.sql`, `sql/entrega2/11_pruebas.sql` |

---

## Contacto

De presentar alguna inquietud con respecto al proyecto, uso de Git para este o los parámetros planteados, contactar a la monitora:

**Viviana Gómez**
Teams o Correo: [gomezlv@javeriana.edu.co](mailto:gomezlv@javeriana.edu.co)
