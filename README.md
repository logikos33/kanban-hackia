# Combinado Não Sai Caro — Kanban do MVP (HackIA SC 2026)

Quadro compartilhado do time para o MVP **"Combinado Não Sai Caro"** (gerador de contratos por IA para freelancers, devs e prestadores de serviço). Backlog espelhado do arquivo `Moskow Combinado nao sai caro.md`, sincronizado em tempo real via Supabase. Site estático (um `index.html`), sem build — perfeito para GitHub Pages.

**Produto em uma frase:** conversa curta → contrato sólido em linguagem clara, com cláusulas de proteção, explicação de cada cláusula e sinalização de red flags, pronto pra assinar.

## Publicar no GitHub Pages (passo a passo)

1. Crie um repositório novo e **público** no GitHub, ex.: `kanban-hackia`. Não marque "add README".
2. Nesta pasta (`kanban-pages/`), rode:

   ```bash
   cd kanban-pages
   git init
   git add .
   git commit -m "Quadro Kanban gestão à vista — tempo real (Supabase)"
   git branch -M main
   git remote add origin https://github.com/SEU_USUARIO/kanban-hackia.git
   git push -u origin main
   ```

3. No repositório do GitHub: **Settings → Pages**.
4. Em **Build and deployment → Source**, escolha **Deploy from a branch**.
5. Em **Branch**, selecione `main` + pasta `/ (root)` e clique **Save**.
6. Aguarde ~1 minuto. A URL pública aparece no topo da mesma tela:
   `https://SEU_USUARIO.github.io/kanban-hackia/`
7. Compartilhe com o time. Cada `git push` na `main` atualiza o site.

> O `.nojekyll` já está incluído para o Pages servir tudo sem processamento Jekyll.

## Como funciona o tempo real

- Os cards ficam na tabela `kanban_cards` do projeto Supabase `contai`.
- Quem abrir a URL lê e escreve na mesma tabela; arrastar, adicionar ou remover atualiza o banco e, via Supabase Realtime, o quadro de **todos** recarrega na hora.
- O indicador "● ao vivo" no topo mostra o status da conexão.

## Segurança

A chave embutida é a **publishable** do Supabase (uso normal no front). As políticas (RLS) hoje permitem **leitura e escrita a qualquer pessoa com a URL** — proporcional a um quadro interno de hackathon. Não coloque dados sensíveis. Para restringir depois: Supabase Auth + políticas mais estritas.

## Migração do banco (rodar uma vez no Supabase)

O modal de card guarda **descrição** e **responsáveis** em duas colunas novas. Antes da primeira edição, abra o **Supabase → SQL Editor** e rode `supabase-setup.sql`:

```sql
ALTER TABLE kanban_cards
  ADD COLUMN IF NOT EXISTS description TEXT,
  ADD COLUMN IF NOT EXISTS assignees   JSONB DEFAULT '[]'::jsonb;
```

Sem isso o quadro continua funcionando, mas o botão "Salvar" do modal vai avisar que faltam as colunas.

## Cronograma

Aba **⏱ Cronograma** mostra:
- relógio em tempo real e a data de hoje;
- contagem regressiva até o pitch (domingo 31/05 às 18:00);
- etapa **atual** destacada conforme a hora;
- checklist por dia (Sáb 30/05 e Dom 31/05) com **3 estados por clique**:
  - ⚪ pendente → ⏳ em andamento (grava `started_at`) → ✅ feito (grava `done_at`);
  - re-clique em ✅ pede confirmação e reabre a etapa.
- linha mono mostra "iniciada HH:MM · rodando há …" enquanto roda e "✅ HH:MM · DD/MM · durou …" depois;
- chip **previsto vs real** por etapa: 🟢 no prazo / 🟡 estourou até 30% / 🔴 atrasada;
- pills no topo: **acumulado hoje**, **% no prazo**, **feitas**, **em andamento**.

Estado dos timestamps é compartilhado em tempo real via Supabase (tabela `hackathon_schedule`). Para habilitar, rode o `supabase-setup.sql` no SQL Editor.

Os responsáveis disponíveis nos cards e no cronograma são: **Victor, Vitão, Monica, Gustavo, Nicolas**.

## Botões destrutivos do header

| Botão                       | O que faz                                                                                                | Confirma com    |
|-----------------------------|----------------------------------------------------------------------------------------------------------|-----------------|
| ↺ Voltar tudo ao backlog    | Move todos os cards para o Backlog. Nada é apagado.                                                      | OK do `confirm` |
| 🧹 Limpar tudo               | **APAGA** todos os cards (inclusive os "feitos" e os adicionados pelo time). Não toca no cronograma.    | Digite `LIMPAR` |
| 🔥 Re-seed MVP               | **APAGA** todos os cards **e** os timestamps do cronograma, depois planta o backlog do MoSCoW do zero.   | Digite `RESET MVP` |

Como atalho equivalente via SQL para o Re-seed, rode `seed-mvp-contratos.sql` no Supabase SQL Editor.

## Arquivos

- `index.html` — o quadro completo (UI + lógica + conexão Supabase).
- `Moskow Combinado nao sai caro.md` — backlog-fonte (MUST / SHOULD / COULD / WON'T).
- `supabase-setup.sql` — migrações: colunas `description`/`assignees` em `kanban_cards` e tabela `hackathon_schedule`.
- `seed-mvp-contratos.sql` — TRUNCATE + INSERT dos 23 cards do MVP.
- `.nojekyll` — desliga o processamento Jekyll do Pages.
- `.gitignore`.
