# MoSCoW — MVP "Combinado Não Sai Caro"

Gerador de contratos por IA para freelancers, devs e prestadores de serviço. Documento de priorização do MVP (sprint de hackathon), estruturado para virar cards no kanban do time.

**Produto em uma frase:** conversa curta → contrato sólido em linguagem clara, com cláusulas de proteção, explicação de cada cláusula e sinalização de red flags, pronto pra assinar.

**Como usar este arquivo:** cada item abaixo é um card. `Must Have` = backlog imediato do MVP. `Should/Could` = só entram se sobrar tempo. `Won't (agora)` = roadmap, não puxar para o MVP.

---

## 🔴 Must Have — sem isto não há MVP

Estes formam o fluxo central ponta a ponta e a credibilidade jurídica que evita a eliminatória do edital.

- **Setup do projeto e ambiente** — repositório, stack (front simples + backend), chaves de API (Claude/GPT) e escopo congelado.
- **Biblioteca de cláusulas curadas** — pagamento, multa por atraso, escopo, revisões, propriedade intelectual, rescisão e foro. Base do guardrail anti-alucinação.
- **RAG sobre fontes legais** — indexação de Código Civil e Lei de Direito Autoral para validar/ancorar as cláusulas (o LLM monta/preenche, não inventa lei).
- **Intake conversacional** — coleta tipo de serviço, valor, prazo, entregáveis e nº de revisões em uma conversa curta (formulário guiado + LLM interpretando).
- **Geração do contrato** — LLM monta o contrato a partir do intake + cláusulas curadas, em português claro.
- **Explicação de cada cláusula** — texto de "por que essa cláusula te protege" ao lado de cada item, em linguagem leiga.
- **Sinalização de red flags** — destacar pontos de risco no contrato (escopo aberto, ausência de multa, etc.).
- **Export pronto pra assinar** — saída em PDF/DOC do contrato final.
- **Guardrails anti-alucinação** — validação por código + cláusulas curadas para o LLM não errar a lei; teste de stress com 2–3 contratos reais.
- **Front mínimo do fluxo** — tela única ponta a ponta (intake → contrato → explicação → download) suficiente para demo ao vivo.

## 🟠 Should Have — importante, entra se houver tempo

Reforça confiança e qualidade, mas o MVP demonstra valor sem eles.

- **Validação jurídica via API/MCP** — camada extra de checagem contra fontes legais além do RAG básico.
- **Tradução de "juridiquês" refinada** — desmistificar a linguagem jurídica para o leigo, com dicas contextuais.
- **Dicas contextuais durante o intake** — sugestões enquanto o usuário responde (ex.: "recomendamos sinal antecipado").
- **Documentação dos testes de stress** — registrar os 2–3 contratos de prova para defesa no pitch.

## 🟡 Could Have — desejável, baixa prioridade

Bons diferenciais virais/pegajosos, mas opcionais no MVP.

- **Calculadoras de estimativa** — valor de serviço, prazo, nº de revisões; servem de isca de topo de funil e alimentam o contrato.
- **Gerador grátis de cláusula única** — isca freemium → upsell para o contrato completo.
- **Marca d'água da ferramenta** — rodapé discreto no contrato gerado como gancho viral.

## ⚪ Won't Have (agora) — roadmap, fora do MVP

Explicitamente fora do escopo desta sprint para proteger o foco.

- **Assinatura/aceite digital integrado** (link de assinatura).
- **Sinal via Pix embutido** no contrato.
- **Aditivo de escopo em 1 clique** para scope creep.
- **Cobrança/lembrete automático** de parcelas e multa.
- **Expansão B2C** (aluguel, serviços domésticos, venda entre pessoas).
- **Definição do modelo de cobrança** (freemium x sob demanda x assinatura) — **decisão pendente**, não bloqueia o MVP técnico.

---

## Critério de "pronto" do MVP

O MVP está pronto quando: um usuário entra, responde a conversa curta, recebe um contrato em linguagem clara com cláusulas de proteção e explicações, vê as red flags sinalizadas, baixa o arquivo pronto pra assinar — e os guardrails seguram pelo menos 2–3 contratos de stress sem alucinar lei.

## Pontos em aberto

- **Modelo de cobrança** a decidir (freemium, sob demanda ou assinatura).
- **Horizonte da sprint** a confirmar (1 dia x fim de semana inteiro) — afeta quais itens `Could` sobem para `Must`.
