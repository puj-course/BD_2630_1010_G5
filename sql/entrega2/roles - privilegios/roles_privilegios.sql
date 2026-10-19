-- ===============================================================
--  ROLES Y PRIVILEGIOS  -  ENTREGA 2
--  Sistema de Informacion para la Gestion Integral de la Copa Mundial de la FIFA
-- ===============================================================

-- ===============================================================
--  1. CREACION DE ROLES
-- ===============================================================

CREATE ROLE rol_gestor_torneo;
CREATE ROLE rol_analista_deportivo;
CREATE ROLE rol_auditor_torneo;

-- ===============================================================
--  2. PRIVILEGIOS DE ROL_GESTOR_TORNEO (Gestor del torneo)
-- ===============================================================

GRANT SELECT, INSERT, UPDATE ON TORNEO_MUNDIAL TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON PAIS_ANFITRION TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON LOCALIDAD TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON RECINTO_DEPORTIVO TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON FASE_TORNEO TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON ENTE_FUTBOLISTICO TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON EQUIPO_NACIONAL TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON INTEGRANTE TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON PLANTEL_EQUIPO TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON ENCUENTRO TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON PARTICIPANTE_ENCUENTRO TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON TERNA_ARBITRAL TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON SUCESO_ENCUENTRO TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON RENDIMIENTO_JUGADOR TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON NOVEDAD_ENCUENTRO TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON BOLETO TO rol_gestor_torneo;
GRANT SELECT, INSERT, UPDATE ON CREDENCIAL_MEDIOS TO rol_gestor_torneo;

GRANT SELECT ON BITACORA_CAMBIOS TO rol_gestor_torneo;

-- ===============================================================
--  2. PRIVILEGIOS DE ROL_ANALISTA_DEPORTIVO (Analista deportivo)
-- ===============================================================

GRANT SELECT ON TORNEO_MUNDIAL TO rol_analista_deportivo;
GRANT SELECT ON PAIS_ANFITRION TO rol_analista_deportivo;
GRANT SELECT ON LOCALIDAD TO rol_analista_deportivo;
GRANT SELECT ON RECINTO_DEPORTIVO TO rol_analista_deportivo;
GRANT SELECT ON FASE_TORNEO TO rol_analista_deportivo;
GRANT SELECT ON ENTE_FUTBOLISTICO TO rol_analista_deportivo;
GRANT SELECT ON EQUIPO_NACIONAL TO rol_analista_deportivo;
GRANT SELECT ON PLANTEL_EQUIPO TO rol_analista_deportivo;
GRANT SELECT ON ENCUENTRO TO rol_analista_deportivo;
GRANT SELECT ON PARTICIPANTE_ENCUENTRO TO rol_analista_deportivo;
GRANT SELECT ON TERNA_ARBITRAL TO rol_analista_deportivo;
GRANT SELECT ON BOLETO TO rol_analista_deportivo;

GRANT SELECT, INSERT, UPDATE ON SUCESO_ENCUENTRO TO rol_analista_deportivo;
GRANT SELECT, INSERT, UPDATE ON RENDIMIENTO_JUGADOR TO rol_analista_deportivo;
GRANT SELECT, INSERT, UPDATE ON NOVEDAD_ENCUENTRO TO rol_analista_deportivo;

-- ===============================================================
--  3. PRIVILEGIOS DE ROL_AUDITOR_TORNEO (Auditor)
-- ===============================================================

GRANT SELECT ON TORNEO_MUNDIAL TO rol_auditor_torneo;
GRANT SELECT ON PAIS_ANFITRION TO rol_auditor_torneo;
GRANT SELECT ON LOCALIDAD TO rol_auditor_torneo;
GRANT SELECT ON RECINTO_DEPORTIVO TO rol_auditor_torneo;
GRANT SELECT ON FASE_TORNEO TO rol_auditor_torneo;
GRANT SELECT ON ENTE_FUTBOLISTICO TO rol_auditor_torneo;
GRANT SELECT ON EQUIPO_NACIONAL TO rol_auditor_torneo;
GRANT SELECT ON PLANTEL_EQUIPO TO rol_auditor_torneo;
GRANT SELECT ON ENCUENTRO TO rol_auditor_torneo;
GRANT SELECT ON PARTICIPANTE_ENCUENTRO TO rol_auditor_torneo;
GRANT SELECT ON TERNA_ARBITRAL TO rol_auditor_torneo;
GRANT SELECT ON SUCESO_ENCUENTRO TO rol_auditor_torneo;
GRANT SELECT ON RENDIMIENTO_JUGADOR TO rol_auditor_torneo;
GRANT SELECT ON NOVEDAD_ENCUENTRO TO rol_auditor_torneo;
GRANT SELECT ON BOLETO TO rol_auditor_torneo;
GRANT SELECT ON BITACORA_CAMBIOS TO rol_auditor_torneo;
