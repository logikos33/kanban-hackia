# Fase 1 - Spec do MVP CLI de Contratos

## Objetivo

Construir um backend CrewAI, inicialmente operado por CLI, que ajude prestadores de servico B2B no Brasil a:

1. criar contratos simples e minimamente seguros; e
2. analisar contratos enviados por clientes, apontando falhas, riscos e mudancas sugeridas.

O MVP deve resolver o problema central do ICP: transformar uma negociacao leiga em fatos contratuais estruturados, com perguntas objetivas, matriz de risco, minuta baseada em templates e explicacoes praticas do "juridiques".

O produto nao deve prometer substituir advogado. Em casos complexos ou de alto risco, deve bloquear a minuta final ou recomendar revisao humana.

## ICP Prioritario

- Desenvolvedores freelancer e pequenas software houses.
- Agencias de marketing, social media e gestores de trafego.
- Consultores B2B.
- Designers, copywriters, creators B2B e founders prestadores de servico.

O usuario tipico sabe vender e executar, mas nao sabe transformar preco, escopo, prazo, aceite e propriedade intelectual em contrato executavel.

## Escopo P0 do MVP

### Jornadas incluidas

- Criar contrato novo por entrevista conversacional.
- Analisar contrato recebido via upload.
- Explicar clausulas e riscos em linguagem simples.
- Gerar minuta em Markdown como formato canonico do MVP.
- Salvar trilha de auditoria local da conversa, decisoes, riscos e versoes.

### Tipos contratuais suportados

- Prestacao de servicos digitais.
- Desenvolvimento de software, site, app, automacao ou manutencao.
- Marketing digital/agencia.
- Consultoria.
- NDA simples.
- Proposta comercial com aceite e clausulas minimas.
- Termo aditivo simples.
- Distrato simples.

### Fora do MVP

- Societario, M&A, franquia, licitacao, contratos com poder publico.
- Trabalhista, representacao comercial complexa ou vinculo disfarçado.
- Operacao internacional.
- Consumidor final de alto risco.
- Financeiro, saude, seguros, educacao regulada ou setor regulado.
- Imobiliario e locacao.
- Casos com indicio de fraude, simulacao, ocultacao de fatos ou ilicitude.

## Principios de UX Conversacional

- Perguntar antes de redigir.
- Fazer uma pergunta por vez quando faltar dado essencial.
- Usar linguagem curta, direta e sem juridiquês.
- Explicar por que uma pergunta importa quando ela parece burocratica.
- Separar fatos informados, inferencias da IA e riscos.
- Mostrar risco antes da minuta final.
- Nunca gerar contrato final com partes, objeto, preco ou prazo ausentes.
- Marcar como `rascunho incompleto` quando houver pendencias.
- Sempre traduzir clausulas criticas para "o que isso significa na pratica".

## Jornada A - Criar Contrato

### Entrada inicial

O CLI deve aceitar:

```json
{
  "mode": "create",
  "user_profile": "dev_freelancer",
  "free_text": "Vou desenvolver um site institucional para uma clinica por R$ 8.000 em 3 parcelas."
}
```

Tambem deve funcionar em modo interativo:

```bash
contracts_cli create
```

### Fluxo esperado

1. Identificar objetivo pratico do usuario.
2. Classificar o tipo contratual provavel.
3. Coletar dados essenciais.
4. Fazer perguntas adaptativas por nicho.
5. Validar completude e coerencia.
6. Exibir matriz de risco.
7. Pedir decisao do usuario: corrigir, aceitar risco ou escalar.
8. Selecionar template e clausulas aplicaveis.
9. Gerar minuta ou rascunho incompleto.
10. Explicar clausulas criticas em linguagem simples.
11. Rodar checklist pre-assinatura.
12. Salvar artefatos em `output/contracts/<case_id>/`.

### Dados essenciais para contrato final

Contrato final so pode ser gerado quando houver:

- qualificacao das partes;
- papel de cada parte;
- objeto;
- escopo incluido e excluido;
- entregaveis;
- preco ou criterio de remuneracao;
- forma e prazo de pagamento;
- prazo de execucao ou vigencia;
- obrigacoes principais;
- criterios de aceite;
- regras de rescisao;
- foro ou metodo de solucao de disputa;
- assinatura e evidencias.

Se faltar algo, o sistema deve gerar apenas:

- diagnostico;
- lista de pendencias;
- perguntas seguintes;
- rascunho incompleto com campos entre colchetes.

### Perguntas adaptativas por nicho

#### Desenvolvimento de software

- O projeto e site, app, sistema, automacao, integracao ou manutencao?
- O codigo-fonte sera entregue?
- Havera cessao, licenca ou apenas permissao de uso?
- Quem fornece hospedagem, dominio, infraestrutura e APIs?
- Quem paga ferramentas de terceiros?
- Havera suporte ou manutencao apos entrega?
- Quantas rodadas de ajuste estao incluidas?
- Como sera o aceite tecnico?
- O cliente tera acesso ao repositorio?
- Ha credenciais, ambientes, dados pessoais ou integracoes criticas?

#### Marketing digital

- O servico e recorrente ou projeto fechado?
- Inclui gestao de trafego?
- Quem paga verba de midia?
- Ha metas ou promessa de resultado?
- Quem aprova criativos, copies e campanhas?
- Quantas pecas, reunioes e revisoes estao incluidas?
- Ha uso de imagem, depoimentos, marcas ou cases?
- O cliente precisa fornecer acessos e briefing?
- Qual aviso previo para rescisao?

#### Consultoria

- A consultoria inclui execucao ou apenas recomendacao?
- Quantas reunioes estao incluidas?
- Ha entregavel escrito?
- Quem implementa as recomendacoes?
- Existe meta de resultado?
- Como sera medido o aceite?
- Ha confidencialidade, exclusividade ou acesso a dados sensiveis?

### Saidas da jornada de criacao

#### Diagnostico

```markdown
**Diagnostico**
- Tipo provavel:
- Confianca:
- Papel do usuario:
- Objetivo pratico:
- Dados essenciais presentes:
- Dados pendentes:
- Fora de escopo ou pontos de atencao:

**Proximas perguntas**
1.
2.
3.
```

#### Matriz de risco

```markdown
| Nivel | Risco | Por que importa | Clausula | Recomendacao | Acao |
|---|---|---|---|---|---|
```

#### Minuta

A minuta deve ser precedida por uma declaracao:

- `minuta pronta para revisao`; ou
- `rascunho incompleto`.

Depois disso, deve conter premissas, pendencias e clausulas numeradas.

## Jornada B - Analisar Contrato Recebido

### Entrada inicial

```json
{
  "mode": "analyze",
  "contract_file": "input/cliente_contrato.pdf",
  "user_role": "prestador",
  "user_goal": "Quero saber se posso assinar ou o que pedir para mudar."
}
```

### Fluxo esperado

1. Ler o arquivo enviado.
2. Extrair partes, objeto, valor, prazo, aceite, pagamento, rescisao, PI, confidencialidade, LGPD, foro e penalidades.
3. Identificar o tipo contratual.
4. Gerar resumo simples do contrato.
5. Apontar pontos favoraveis ao prestador.
6. Apontar riscos contra o prestador.
7. Listar clausulas ausentes ou fracas.
8. Traduzir clausulas sensiveis para linguagem pratica.
9. Sugerir contrapropostas de clausulas ou comentarios de negociacao.
10. Classificar risco geral: baixo, medio ou alto.
11. Indicar se deve chamar advogado.
12. Salvar relatorio em Markdown.

### Leitura de documentos

O MVP deve usar ferramentas nativas do CrewAI para leitura sempre que possivel:

- `FileReadTool` para texto, Markdown e arquivos simples.
- `PDFSearchTool` para PDFs.
- `DOCXSearchTool` para DOCX.

Nao implementar OCR, parser proprio complexo, consulta externa ou pipeline custom no P0. Se a leitura nativa falhar, responder de forma conversacional: "Nao consegui ler esse arquivo. Envie em PDF, DOCX, texto, ou cole o conteudo."

### Saida da analise

```markdown
# Revisao do contrato recebido

## Resumo simples

## Pontos favoraveis ao prestador

## Riscos contra o prestador

## Clausulas ausentes ou fracas

## Juridiques traduzido

| Trecho/tema | O que significa na pratica | Risco | Sugestao |
|---|---|---|---|

## Sugestoes de contraproposta

## Pontos que exigem advogado

## Perguntas pendentes
```

## Tradutor de Juridiques

Toda explicacao de clausula critica deve seguir este formato:

```markdown
**Clausula**

**Em linguagem simples**

**Risco que cobre**

**Alternativa pro-prestador**

**Alternativa equilibrada**

**Quando chamar advogado**
```

Exemplos de termos que sempre devem ser traduzidos:

- cessao de direitos;
- licenca de uso;
- responsabilidade solidaria;
- multa compensatoria;
- multa moratoria;
- lucros cessantes;
- aceite tacito;
- confidencialidade;
- tratamento de dados pessoais;
- foro;
- rescisao imotivada;
- vencimento antecipado;
- limitacao de responsabilidade;
- nao vinculacao trabalhista.

## Templates e Base de Conhecimento

### Estrutura sugerida

```text
src/my_flow/knowledge/contracts/
├── templates/
│   ├── prestacao_servicos_digitais.md
│   ├── desenvolvimento_software.md
│   ├── marketing_digital.md
│   ├── consultoria.md
│   ├── nda_simples.md
│   ├── proposta_com_aceite.md
│   ├── aditivo_simples.md
│   └── distrato_simples.md
├── clauses/
│   ├── aceite.yaml
│   ├── pagamento.yaml
│   ├── propriedade_intelectual.yaml
│   ├── lgpd.yaml
│   ├── confidencialidade.yaml
│   ├── rescisao.yaml
│   └── assinatura_eletronica.yaml
└── rules/
    ├── completeness_rules.yaml
    ├── coherence_rules.yaml
    ├── risk_rules.yaml
    └── escalation_rules.yaml
```

### Regras para templates

- Templates devem ter versao, tipo contratual, segmento, premissas e campos obrigatorios.
- Clausulas devem ter variantes: pro-prestador, equilibrada e conservadora.
- Toda clausula critica deve ter explicacao simples associada.
- A origem da clausula deve ser rastreavel no relatorio final.
- O sistema nao deve inventar artigo, jurisprudencia ou base legal especifica sem fonte validada.

## Motor de Risco

### Baixo

Caso simples, baixo valor, partes identificadas, escopo claro, sem dados sensiveis, sem cessao complexa de PI e sem contraparte dominante.

Acao: permitir minuta e assinatura com recomendacoes padrao.

### Medio

Valor relevante, muitas entregas, dependencia do cliente, dados pessoais comuns, cessao parcial de PI, contrato recorrente, subcontratacao, ferramentas de terceiros ou aceite complexo.

Acao: gerar minuta com alertas, explicar alternativas e recomendar revisao opcional.

### Alto

Valor alto, dados sensiveis, exclusividade ampla, multa agressiva, vinculo trabalhista potencial, sociedade/parceria disfarçada, contraparte grande com contrato proprio, operacao internacional, consumidor final, regulado, fraude, ilicito ou inconsistencia documental.

Acao: bloquear contrato final ou exigir aceite explicito de risco e recomendar advogado humano.

## Guardrails Obrigatorios do MVP

O MVP deve ter guardrails em tres camadas. A ordem importa: regras deterministicas primeiro, guardrails das tasks CrewAI depois, revisao humana por ultimo.

### Fronteira deterministica vs IA

O Flow deterministico e a autoridade final sobre avanco, bloqueio e escrita de artefatos. A IA pode interpretar, extrair, sugerir, explicar e redigir dentro de limites, mas nao decide sozinha que um contrato esta pronto.

Fica com o Flow deterministico:

- validar `mode`, payload, arquivo e estado do caso;
- controlar `status`, `missing_fields`, `risk_level`, `user_decisions` e outputs;
- aplicar regras de completude, coerencia, risco, placeholders e fora do MVP;
- escolher a rota `create` ou `analyze` e impedir atalhos;
- validar que templates e clausulas existem na biblioteca versionada;
- bloquear contrato final quando houver pendencia essencial;
- marcar `rascunho incompleto`;
- acionar HITL antes de risco medio/alto, aceite de risco ou minuta final;
- escrever arquivos, audit log e relatorios finais.

Fica com a IA e agents:

- entender texto livre do usuario e classificar tipo contratual provavel;
- transformar respostas leigas em fatos estruturados;
- sugerir proximas perguntas conversacionais;
- extrair partes, clausulas, prazos, valores e riscos de contratos recebidos;
- apontar red flags com evidencia textual;
- recomendar template e clausulas, sem inventar itens fora da biblioteca;
- preencher minuta a partir de fatos confirmados e blocos curados;
- explicar juridiquês em linguagem simples.

Quando houver conflito entre sugestao da IA e regra deterministica, a regra deterministica vence.

### Core operacional incorporado

Adotar apenas o nucleo operacional simples:

- modos principais: `create` e `analyze`;
- contrato final bloqueado sem partes, papel das partes, objeto, escopo, entregaveis, valor, pagamento, prazo, aceite, rescisao e foro;
- `rascunho incompleto` permitido quando dados secundarios ou contraparte estiverem pendentes;
- contrato final bloqueado quando houver `[A DEFINIR]`, `[CAMPO PENDENTE]`, `{{variavel}}` ou pendencia essencial;
- matriz de risco obrigatoria antes da minuta;
- explicacao simples obrigatoria para clausulas criticas;
- analise de upload deve apontar red flags rastreaveis ao texto ou recomendar advogado;
- alto risco e fora do MVP devem recomendar advogado.

Rejeitar para o P0:

- validacao de CPF/CNPJ;
- Receita Federal, ViaCEP, IBGE ou qualquer consulta externa;
- OCR de imagem;
- score de equilibrio 0-10;
- tracking de scroll, tempo de leitura ou bloqueio por leitura;
- assinatura digital integrada, hash, IP, user-agent, lembretes ou pos-contrato;
- criacao de contrato como tomador.

### 1. Guardrails deterministicas

Essas validacoes nao devem depender do LLM:

- bloquear contrato final sem partes, papel das partes, objeto, escopo, entregaveis, preco, pagamento, prazo, aceite, rescisao ou foro;
- bloquear objetivo ilicito, fraude, simulacao ou ocultacao de fato relevante;
- bloquear contrato fora do MVP sem revisao humana;
- impedir minuta final quando houver contradicao critica nao resolvida;
- impedir recomendacao de assinatura quando risco alto nao foi aceito ou escalado;
- validar soma de parcelas, datas, vigencia, aceite, rescisao, LGPD, PI e foro;
- exigir matriz de risco antes da minuta final;
- exigir ausencia de placeholders em contrato final;
- exigir trilha de auditoria com fatos, inferencias, riscos e decisoes do usuario.

### 2. Guardrails das tasks CrewAI

Cada task critica deve usar `guardrail` ou `guardrails` do CrewAI:

- `classify_case_task`: deve retornar tipo contratual, confianca, justificativa e perguntas pendentes.
- `intake_task`: deve retornar dados presentes, dados ausentes e proxima pergunta objetiva.
- `document_analysis_task`: deve retornar resumo simples, riscos contra o prestador, clausulas ausentes e sugestoes.
- `risk_review_task`: deve retornar matriz baixo/medio/alto e acao esperada para cada risco.
- `template_selection_task`: deve recomendar apenas templates e clausulas existentes na biblioteca versionada.
- `draft_contract_task`: nao pode declarar minuta pronta se `missing_fields` nao estiver vazio.
- `plain_language_task`: deve traduzir clausulas criticas para efeito pratico, risco coberto e quando chamar advogado.

### 3. Human-in-the-loop

O usuario deve aprovar ou corrigir pontos sensiveis antes da etapa seguinte quando houver:

- risco medio ou alto;
- dados essenciais ainda pendentes;
- aceite explicito de risco;
- clausula agressiva ou potencialmente abusiva;
- mudanca pedida pelo usuario que aumente risco;
- analise de contrato recebido com recomendacao de negociacao ou advogado.

## Simplificacoes Recomendadas Para o MVP

- Comecar com Markdown como formato canonico do contrato.
- Deixar exportacao DOCX/PDF para depois que a estrutura juridica estiver validada.
- Usar regras deterministicas para completude e coerencia antes de chamar agente redator.
- Usar `guardrails` nativos do CrewAI nas tasks criticas, sem substituir as regras deterministicas.
- Usar templates versionados em arquivo local antes de RAG sofisticado.
- Priorizar 3 nichos no primeiro corte: dev, marketing e consultoria.
- Tratar assinatura como orientacao/checklist no MVP CLI, deixando integracao para fase posterior.
- Manter armazenamento local por `case_id` antes de banco relacional.
- Usar ferramentas nativas CrewAI para leitura de documentos; nao criar parser custom no P0.

## Criterios de Aceite da Fase 1

- Dev freelancer gera contrato com escopo, pagamento, aceite, PI e inadimplencia.
- Agencia gera contrato recorrente sem promessa indevida de resultado e com limites de escopo.
- Consultor gera contrato que separa recomendacao, execucao, entregaveis e responsabilidade do cliente.
- Sistema bloqueia ou marca como incompleto contrato sem partes, objeto, valor ou prazo.
- Matriz de risco aparece antes da minuta final.
- Analise de contrato recebido retorna resumo, riscos, falhas, sugestoes e juridiques traduzido.
- Pelo menos 10 clausulas criticas sao explicadas em linguagem simples.
- Alto risco recomenda advogado.
- Toda execucao salva trilha auditavel local.
- Nao ha citacoes legais inventadas.
- Tasks criticas possuem `guardrail` ou `guardrails` com retries limitados.
- Specs nao exigem Receita, ViaCEP, IBGE, OCR ou validacao de CPF/CNPJ no MVP.