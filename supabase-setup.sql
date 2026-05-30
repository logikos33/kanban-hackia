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
