-- ============================================================
-- Migração: adicionar descrição e responsáveis aos cards
-- Rode no Supabase SQL Editor (projeto contai) uma vez.
-- ============================================================

ALTER TABLE kanban_cards
  ADD COLUMN IF NOT EXISTS description TEXT,
  ADD COLUMN IF NOT EXISTS assignees   JSONB DEFAULT '[]'::jsonb;

-- (Opcional) índice para consultar por responsável depois.
CREATE INDEX IF NOT EXISTS kanban_cards_assignees_idx
  ON kanban_cards USING gin (assignees);

-- ============================================================
-- Cronograma com timestamps reais (registro auditável)
-- 1 linha por etapa que alguém tocar. Suporta estados:
--   pendente   : sem linha (ou started_at NULL)
--   andamento  : started_at preenchido, done_at NULL
--   feito      : started_at e done_at preenchidos
-- ============================================================

CREATE TABLE IF NOT EXISTS hackathon_schedule (
  id          TEXT PRIMARY KEY,
  started_at  TIMESTAMPTZ,
  done_at     TIMESTAMPTZ,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE hackathon_schedule ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "schedule open all" ON hackathon_schedule;
CREATE POLICY "schedule open all" ON hackathon_schedule
  FOR ALL USING (true) WITH CHECK (true);

-- Habilita realtime
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname='supabase_realtime' AND tablename='hackathon_schedule'
  ) THEN
    EXECUTE 'ALTER PUBLICATION supabase_realtime ADD TABLE hackathon_schedule';
  END IF;
END $$;
