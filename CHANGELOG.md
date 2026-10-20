# CHANGELOG

Registro del progreso semanal del proyecto, las tareas realizadas, los responsables y las ramas utilizadas. Cada entrada debe acompañarse de commits, ramas o pull requests visibles en GitHub.

---

## Equipo del Proyecto
| Nombre        | GitHub / Perfil |
|--------------|-----------------|
| Andrés Gómez | github.com/andrs-gmzz |

---
## Registro del proyecto

## Semana 1 (30 de septiembre) — Planificación e inicio

### Objetivos de la semana
- Subir documentos de la Entrega 1
- Ajustar observaciones
- Definir consultas a implementar
- Comprender la rúbrica y delimitar la Entrega 1 al modelo inicial.

### Tareas realizadas

| Tarea | Responsable(s) | Rama | Archivo(s) / Descripción |
|------|----------------|------|-----------|
| Revisión del enunciado y criterios de evaluación | Andrés Gómez | main | 	Lectura de la rúbrica para delimitar el alcance de la Entrega 1 |
| Definición de herramientas | Andrés Gómez | 	main | Motor Oracle Database y cliente SQL Developer |
| Publicación inicial | Andrés Gómez | main | README.md y CHANGELOG.md |


### Cambios principales
- Publicación inicial de README.md y CHANGELOG.md.


### Problemas encontrados
- Falta ejecutar la entrega en el servidor y completar los datos de conexión entregados por el curso.

---
## Semana 2 (30 de septiembre) — Modelo y documentación

### Objetivos de la semana

- Documentar el modelo inicial y su evolución futura.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|------|------|------|------|
|Cierre del ERD y supuestos |Andrés Gómez |feature/modelo-documental |Modelo entidad-relación y supuestos de diseño |
|Transformación al modelo lógico y diccionario de datos |Andrés Gómez |feature/modelo-documental |Documentado en docs/documento_tecnico.md |
|Evaluación crítica y matriz de trazabilidad |Andrés Gómez |feature/modelo-documental |Documentado en docs/documento_tecnico.md |

### Cambios principales
- Documentación técnica del modelo inicial publicada en docs/.

### Problemas encontrados
- Aún falta ejecutar y validar los scripts en el servidor Oracle del curso.

---

## Semana 3 (30 de septiembre ) — DDL, integridad y restricciones de negocio

### Objetivos de la semana

-Ejecutar el DDL en el esquema del curso y validar restricciones de integridad y de negocio.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|------|------|------|------|
| Script DDL| Andrés Gómez | feature/ddl-restricciones |Creación de tablas (sql/01_ddl.sql) |
| Pruebas de restricciones | Andrés Gómez | feature/ddl-restricciones |PK, FK, CHECK, UNIQUE e índices (8.1.2) |


### Cambios principales
-Esquema físico creado en Oracle mediante sql/01_ddl.sql.

### Problemas encontrados
-errores de ejecución y su solución.

---

## Semana 4 (30 de septiembre ) — Datos y vistas

### Objetivos de la semana

-Cargar el dataset sintético y verificar las vistas.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|------|------|------|------|
|Carga de dataset sintético |Andrés Gómez |feature/datos-vistas |Mínimo 100 registros por tabla principal, con coherencia edición–estadio–selección–partido–participación (8.1.3). sql/02_datos_prueba.sql |
|Diseño e implementación de vistas |Andrés Gómez |feature/datos-vistas |4 a 5 vistas justificadas (8.1.4): tabla de posiciones parcial, goleadores acumulados, ocupación por estadio y partidos con marcador y sede. sql/03_vistas.sql |
|Verificación |Andrés Gómez |feature/datos-vistas |Conteo de registros, coherencia referencial y documentación de resultados |

### Cambios principales
-Datos de prueba y vistas publicados en sql/.

### Problemas encontrados
-inconsistencias o ajustes realizados.

---

## Semana 5 (30 de septiembre) — DML y privilegios

### Objetivos de la semana

-Probar el ciclo de vida de un partido, operaciones inválidas y roles.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|------|------|------|------|
|Script DML |Andrés Gómez |feature/consultas-pruebas |Creación de partido, registro de participaciones y actualización del marcador final (8.1.5). sql/04_dml_pruebas.sql |
|Operaciones inválidas |Andrés Gómez |feature/consultas-pruebas |Al menos 3 intentos que violen reglas de negocio o integridad, documentando el error obtenido (8.1.5) |
|Verificación de ON DELETE |Andrés Gómez |feature/consultas-pruebas |En al menos 2 relaciones distintas |
|Usuarios/roles y privilegios |Andrés Gómez |feature/consultas-pruebas |Un rol de solo consulta y uno operativo, con GRANT/REVOKE documentados y probados (8.1.6). sql/05_privilegios.sql |

### Cambios principales
-vistas publicados en sql/.

### Problemas encontrados
-limitaciones del servidor o permisos DBA.

---

## Semana 6 (30 de septiembre) — Álgebra relacional, consultas SQL y evaluación crítica

### Objetivos de la semana

-Resolver las consultas SQL solicitadas, su equivalente en álgebra relacional y evaluar críticamente el modelo inicial.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|------|------|------|------|
|Álgebra relacional |Andrés Gómez |feature/consultas-pruebas |Traducción (σ, π, ⋈, ρ, entre otros) de al menos 4 consultas de la Sección 8.1.9 (8.1.7). sql/algebra_relacional.md |
|Consultas SQL |Andrés Gómez |feature/consultas-pruebas |15 consultas: JOIN, subconsultas correlacionadas y no correlacionadas, GROUP BY/HAVING, agregaciones y reutilización de al menos una vista (8.1.9). sql/06_consultas.sql |
|Evaluación crítica del modelo inicial |Andrés Gómez |feature/consultas-pruebas |Problemas identificados, ajustes propuestos con justificación y bosquejo del ERD ampliado con nuevas entidades anticipadas (8.1.8). docs/evaluacion_critica.md |


### Cambios principales
-Consultas, álgebra relacional y evaluación crítica publicadas.

### Problemas encontrados
-limitaciones del servidor o permisos DBA.

---

## Semana 7 (No hubo) — Revisión, sustentación y cierre de Entrega 1

### Objetivos de la semana

-Ejecutar el flujo completo en el motor, preparar evidencias y sustentar de forma individual.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|------|------|------|------|
|Verificación de conteos, resultados esperados (Figura 2) y trazabilidad |Andrés Gómez |feature/revision-entrega-1 |Commits, ramas y pull requests en GitHub |
|Revisión final del README.md e integración a main |Andrés Gómez |feature/revision-entrega-1 → main |Capturas de resultados y README.md actualizado |
|Material para la sustentación individual |Andrés Gómez |feature/revision-entrega-1  |Preparación de apoyo |


### Cambios principales
-Semana sin sustentación: no se realizó la sustentación de la Entrega 1.

### Problemas encontrados
-No hubo que calificar (Culpa de nosotros).

---

## Semana 8 (30 de septiembre - 4 Octubre) — Expansión del modelo y consultas avanzadas (Entrega 2)

### Objetivos de la semana

-Incorporar la retroalimentación de la sustentación de la Entrega 1 (no se recibió, por no haberse realizado).
-Expandir el modelo con nuevas entidades: jugadores, cuerpo técnico, árbitros, estadísticas, grupos, fases eliminatorias, boletería, medios e incidencias, entre otras (8.2).

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|------|------|------|------|
|Actualizar el modelo lógico y avanzar al físico |Andrés Gómez |feature/consultas-avanzadas |Modelo de 18 tablas en Oracle 19c (ddl_mundial_v3.sql), con 28 FK, 22 CHECK y 10 UNIQUE. Documentos modelo_logico_ampliado.md, modelo_fisico_ampliado.md y diccionario_datos_v3.md |
|Consultas de análisis deportivo y operativo |Andrés Gómez |feature/consultas-avanzadas |10 consultas con JOIN múltiples, subconsultas, CTE y agregaciones por nivel: Jugador → Partido → Selección → Grupo/Fase → Edición (8.2.1). consultas_avanzadas_mundial.sql |


### Cambios principales
-Modelo ampliado de 18 tablas y 10 consultas avanzadas publicadas.

### Problemas encontrados
-No hubo retroalimentación de la Entrega 1, por lo que no hay ajustes derivados de ella.
-EQUIPO_NACIONAL no tiene columna de nombre: se resolvió usando ENTE_FUTBOLISTICO (país) y codigo_fifa en las consultas.

---

## Semana 9 (5 Octubre - 11 Octubre) — Roles diferenciados y pruebas (Entrega 2)

### Objetivos de la semana

-Definir roles con restricciones de acceso diferenciadas y validar el modelo ampliado con casos de prueba.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|------|------|------|------|
|Roles con privilegios diferenciados |Andrés Gómez |feature/roles-privilegios-2 |Administrador del Torneo (rol_gestor_torneo), Analista Deportivo (rol_analista_deportivo) y Auditor/Consulta (rol_auditor_torneo), sin DELETE ni DDL (8.2.3). roles_privilegios_mundial.sql y definicion_roles_privilegios.md |
|Casos de prueba exitosos y fallidos |Andrés Gómez |feature/roles-privilegios-2 |17 casos exitosos (E01–E17) y 43 fallidos (F01–F43) con resultado esperado vs. obtenido (8.2.4). pruebas_mundial.sql y casos_de_prueba.md |
|Pruebas de privilegios por rol |Andrés Gómez |feature/roles-privilegios-2 |23 pruebas (8 gestor, 8 analista, 7 auditor) con GRANT, SET ROLE y REVOKE. pruebas_privilegios.sql y pruebas_privilegios.md |


### Cambios principales
-Roles, casos de prueba y pruebas de privilegios publicados.

### Problemas encontrados
-El error al leer una tabla sin ningún privilegio puede ser ORA-00942 o ORA-01031 según el servidor.
-No le pude otorgar a nadie los privilegios, ya que estoy solo

---

## Semana 10 (12 Octubre - 18 Octubre) — Justificación de 1FN, 2FN y 3FN (Entrega 2)

### Objetivos de la semana

-Justificar que el modelo cumple 1FN, 2FN y 3FN.
-Cargar un conjunto de datos de prueba reducido (unas 120 filas) coherente con el modelo.
-Preparar la documentación para la sustentación.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|------|------|------|------|
|Justificación de normalización |Andrés Gómez |feature/normalizacion |1FN, 2FN y 3FN de las 18 tablas, con 3 redundancias controladas documentadas. normalizacion_modelo.md |
|Carga de datos de prueba |Andrés Gómez |feature/normalizacion |119 INSERT coherentes entre torneo, sedes, equipos, partidos, árbitros, boletos y bitácora. dml_mundial_v3.sql |
|Consultas adicionales |Andrés Gómez |feature/normalizacion |8 consultas adaptadas de la entrega anterior. consultas_entrega2_mundial.sql |
|Guía de sustentación |Andrés Gómez |feature/normalizacion |Documento que explica el proyecto sin tecnicismos. guia_sustentacion.md |


### Cambios principales
-Normalización, datos de prueba y guía de sustentación publicados.

### Problemas encontrados
-La consulta 4 del segundo archivo devuelve 0 filas porque solo la edición 2026 tiene partidos cargados.
