-- ═══════════════════════════════════════════════════════════════════
--  SETUP COMPLETO — DIGRAPH CHALLENGE
--  Fundamentos de Computación · Dra. Marianela Soledad Reinhardt
--
--  INSTRUCCIONES:
--  1. Abrí tu proyecto en supabase.com
--  2. Ir a SQL Editor → New Query
--  3. Pegá TODO este archivo → Run
-- ═══════════════════════════════════════════════════════════════════


-- ──────────────────────────────────────────────────────────────────
-- 1. TABLA PRINCIPAL
-- ──────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS digraph_challenge (
  id               BIGSERIAL    PRIMARY KEY,
  nombre           TEXT         NOT NULL,
  tiempo_segundos  INTEGER      NOT NULL CHECK (tiempo_segundos >= 0),
  errores          INTEGER      NOT NULL DEFAULT 0 CHECK (errores >= 0),
  puntaje          INTEGER      NOT NULL DEFAULT 0 CHECK (puntaje >= 0),
  completado       BOOLEAN      NOT NULL DEFAULT false,
  created_at       TIMESTAMPTZ  NOT NULL DEFAULT now()
);

COMMENT ON TABLE digraph_challenge IS
  'Resultados del desafío de armado del dígrafo — Fundamentos de Computación';

COMMENT ON COLUMN digraph_challenge.puntaje IS
  'Puntaje ponderado: suma de (peso_arista × multiplicador_tiempo) − (errores × 75)';


-- ──────────────────────────────────────────────────────────────────
-- 2. ÍNDICES
-- ──────────────────────────────────────────────────────────────────

-- Ranking principal: mayor puntaje, menor tiempo, menos errores
CREATE INDEX IF NOT EXISTS idx_challenge_ranking
  ON digraph_challenge (completado, puntaje DESC, tiempo_segundos ASC, errores ASC);

-- Búsqueda por nombre (para el leaderboard "vos" highlight)
CREATE INDEX IF NOT EXISTS idx_challenge_nombre
  ON digraph_challenge (nombre);


-- ──────────────────────────────────────────────────────────────────
-- 3. ROW LEVEL SECURITY (RLS)
--    anon key puede insertar y leer completados — nada más
-- ──────────────────────────────────────────────────────────────────
ALTER TABLE digraph_challenge ENABLE ROW LEVEL SECURITY;

-- Cualquier anon puede insertar su resultado
CREATE POLICY "anon_insert"
  ON digraph_challenge FOR INSERT
  WITH CHECK (true);

-- Solo se pueden leer filas completadas (no intentos parciales)
CREATE POLICY "anon_select_completed"
  ON digraph_challenge FOR SELECT
  USING (completado = true);

-- Solo el owner del proyecto puede actualizar/borrar
CREATE POLICY "owner_all"
  ON digraph_challenge FOR ALL
  USING (auth.role() = 'authenticated');


-- ──────────────────────────────────────────────────────────────────
-- 4. VERIFICACIÓN — corré esto para confirmar
-- ──────────────────────────────────────────────────────────────────
SELECT
  column_name,
  data_type,
  column_default,
  is_nullable
FROM information_schema.columns
WHERE table_name = 'digraph_challenge'
ORDER BY ordinal_position;


-- ═══════════════════════════════════════════════════════════════════
--  QUERIES ÚTILES PARA LA CLASE
-- ═══════════════════════════════════════════════════════════════════

-- Ver ranking completo:
/*
SELECT
  ROW_NUMBER() OVER (ORDER BY puntaje DESC, tiempo_segundos ASC) AS posicion,
  nombre,
  puntaje,
  tiempo_segundos,
  errores,
  created_at
FROM digraph_challenge
WHERE completado = true
ORDER BY puntaje DESC, tiempo_segundos ASC;
*/

-- Estadísticas rápidas:
/*
SELECT
  COUNT(*)                                              AS total_jugadores,
  COUNT(*) FILTER (WHERE errores = 0)                  AS perfectos,
  MAX(puntaje)                                          AS mejor_puntaje,
  MIN(tiempo_segundos)                                  AS mejor_tiempo_seg,
  ROUND(AVG(puntaje))                                   AS puntaje_promedio,
  ROUND(AVG(tiempo_segundos))                           AS tiempo_promedio_seg,
  ROUND(AVG(errores), 1)                                AS errores_promedio
FROM digraph_challenge
WHERE completado = true;
*/

-- Limpiar para empezar de cero entre clases:
/*
DELETE FROM digraph_challenge;
-- o para resetear el contador de IDs también:
TRUNCATE TABLE digraph_challenge RESTART IDENTITY;
*/
