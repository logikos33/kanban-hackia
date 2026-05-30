# Quadro Kanban — Gestão à vista (HackIA SC 2026)

Quadro compartilhado do time, sincronizado em tempo real via Supabase. Site estático (um `index.html`), sem build — perfeito para GitHub Pages.

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
- checklist por dia (Sáb 30/05 e Dom 31/05). As marcações ficam em `localStorage` do navegador.

Os responsáveis disponíveis nos cards e no cronograma são: **Victor, Vitão, Monica, Gustavo, Nicolas**.

## Arquivos

- `index.html` — o quadro completo (UI + lógica + conexão Supabase).
- `supabase-setup.sql` — migração das colunas `description` e `assignees`.
- `.nojekyll` — desliga o processamento Jekyll do Pages.
- `.gitignore`.
