-- ============================================================
-- Combinado Não Sai Caro — Kanban HackIA SC 2026
-- Migração consolidada v2 (rodar uma vez no Supabase SQL Editor).
-- Idempotente: pode rodar de novo sem quebrar nada.
-- ============================================================

-- ============================================================
-- 1) kanban_cards — descrição, responsáveis e suporte a "Won't"
-- ============================================================
ALTER TABLE kanban_cards ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE kanban_cards ADD COLUMN IF NOT EXISTS assignees   JSONB DEFAULT '[]'::jsonb;

ALTER TABLE kanban_cards DROP CONSTRAINT IF EXISTS kanban_cards_moscow_check;
ALTER TABLE kanban_cards ADD CONSTRAINT kanban_cards_moscow_check
  CHECK (moscow = ANY (ARRAY['must'::text,'should'::text,'could'::text,'wont'::text]));

CREATE INDEX IF NOT EXISTS kanban_cards_assignees_idx
  ON kanban_cards USING gin (assignees);

-- ============================================================
-- 2) hackathon_schedule — 3 FASES FIXAS, nunca apagadas.
--    status: pending → active → completed (terminal, sem reabrir)
--    Não há timer: transição apenas por clique manual na UI.
-- ============================================================
CREATE TABLE IF NOT EXISTS hackathon_schedule (
  id          TEXT PRIMARY KEY,
  name        TEXT,
  status      TEXT NOT NULL DEFAULT 'pending',
  position    INT NOT NULL DEFAULT 0,
  started_at  TIMESTAMPTZ,
  done_at     TIMESTAMPTZ,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE hackathon_schedule DROP CONSTRAINT IF EXISTS hackathon_schedule_status_check;
ALTER TABLE hackathon_schedule ADD CONSTRAINT hackathon_schedule_status_check
  CHECK (status = ANY (ARRAY['pending'::text,'active'::text,'completed'::text]));

INSERT INTO hackathon_schedule (id, name, position, status) VALUES
  ('ignicao',      'Ignição',      1, 'pending'),
  ('construcao',   'Construção',   2, 'pending'),
  ('apresentacao', 'Apresentação', 3, 'pending')
ON CONFLICT (id) DO NOTHING;

ALTER TABLE hackathon_schedule ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "schedule open all" ON hackathon_schedule;
CREATE POLICY "schedule open all" ON hackathon_schedule
  FOR ALL USING (true) WITH CHECK (true);

-- ============================================================
-- 3) kanban_team — responsáveis gerenciados pela UI
-- ============================================================
CREATE TABLE IF NOT EXISTS kanban_team (
  name        TEXT PRIMARY KEY,
  position    INT NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE kanban_team ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "team open all" ON kanban_team;
CREATE POLICY "team open all" ON kanban_team
  FOR ALL USING (true) WITH CHECK (true);

-- ============================================================
-- 4) kanban_lanes — swim lanes editáveis pela UI
-- ============================================================
CREATE TABLE IF NOT EXISTS kanban_lanes (
  id          TEXT PRIMARY KEY,
  name        TEXT NOT NULL,
  who         TEXT,
  color       TEXT,
  position    INT NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE kanban_lanes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "lanes open all" ON kanban_lanes;
CREATE POLICY "lanes open all" ON kanban_lanes
  FOR ALL USING (true) WITH CHECK (true);

-- ============================================================
-- 5) activity_notes — diário do time por card e por fase
--    Append-only na prática; delete só pelo autor em ≤ 5 min
--    (regra aplicada no client; aqui a policy é aberta para hackathon).
-- ============================================================
CREATE TABLE IF NOT EXISTS activity_notes (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  card_id     TEXT REFERENCES kanban_cards(id) ON DELETE CASCADE,
  sprint_id   TEXT REFERENCES hackathon_schedule(id),
  content     TEXT NOT NULL,
  author      TEXT NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE activity_notes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "notes open all" ON activity_notes;
CREATE POLICY "notes open all" ON activity_notes
  FOR ALL USING (true) WITH CHECK (true);

CREATE INDEX IF NOT EXISTS activity_notes_card_idx
  ON activity_notes(card_id, created_at DESC);
CREATE INDEX IF NOT EXISTS activity_notes_sprint_idx
  ON activity_notes(sprint_id, created_at DESC);

-- ============================================================
-- 6) Realtime publication para TODAS as tabelas relevantes
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables
                  WHERE pubname='supabase_realtime' AND tablename='kanban_cards')
    THEN EXECUTE 'ALTER PUBLICATION supabase_realtime ADD TABLE kanban_cards'; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables
                  WHERE pubname='supabase_realtime' AND tablename='hackathon_schedule')
    THEN EXECUTE 'ALTER PUBLICATION supabase_realtime ADD TABLE hackathon_schedule'; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables
                  WHERE pubname='supabase_realtime' AND tablename='kanban_team')
    THEN EXECUTE 'ALTER PUBLICATION supabase_realtime ADD TABLE kanban_team'; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables
                  WHERE pubname='supabase_realtime' AND tablename='kanban_lanes')
    THEN EXECUTE 'ALTER PUBLICATION supabase_realtime ADD TABLE kanban_lanes'; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables
                  WHERE pubname='supabase_realtime' AND tablename='activity_notes')
    THEN EXECUTE 'ALTER PUBLICATION supabase_realtime ADD TABLE activity_notes'; END IF;
END $$;

-- ============================================================
-- 7) Smoke tests (devem retornar resultados sem erro)
-- ============================================================
SELECT 'kanban_cards' AS tbl, COUNT(*) AS rows FROM kanban_cards
UNION ALL SELECT 'hackathon_schedule', COUNT(*) FROM hackathon_schedule
UNION ALL SELECT 'kanban_team',        COUNT(*) FROM kanban_team
UNION ALL SELECT 'kanban_lanes',       COUNT(*) FROM kanban_lanes
UNION ALL SELECT 'activity_notes',     COUNT(*) FROM activity_notes;
