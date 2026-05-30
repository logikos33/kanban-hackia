-- ============================================================
-- Re-seed do MVP "Combinado Não Sai Caro"
-- Apaga TODOS os cards atuais e planta o backlog do MoSCoW
-- (espelha o arquivo "Moskow Combinado nao sai caro.md").
-- Também zera os timestamps do cronograma.
--
-- Atalho equivalente ao botão "🔥 Re-seed MVP" no header da UI.
-- ============================================================

TRUNCATE TABLE kanban_cards;
TRUNCATE TABLE hackathon_schedule;

INSERT INTO kanban_cards (id, lane, moscow, title, status, is_custom, position, description, assignees) VALUES
-- MUST (10)
('m01','gestao',  'must','Setup do projeto e ambiente — repo, stack, chaves de API, escopo congelado','backlog',false, 1,'Repositório, stack (front simples + backend), chaves Claude/GPT e escopo congelado.','[]'),
('m02','juridico','must','Biblioteca de cláusulas curadas',                                            'backlog',false, 2,'Pagamento, multa por atraso, escopo, revisões, propriedade intelectual, rescisão e foro. Base do guardrail anti-alucinação.','[]'),
('m03','juridico','must','RAG sobre fontes legais (Código Civil + Lei de Direito Autoral)',            'backlog',false, 3,'Indexar Código Civil e Lei de Direito Autoral para validar/ancorar cláusulas — o LLM monta/preenche, não inventa lei.','[]'),
('m04','back',    'must','Intake conversacional (tipo, valor, prazo, entregáveis, revisões)',          'backlog',false, 4,'Conversa curta + formulário guiado com LLM interpretando para coletar dados do serviço.','[]'),
('m05','back',    'must','Geração do contrato pelo LLM (intake + cláusulas)',                          'backlog',false, 5,'LLM monta o contrato em português claro a partir do intake e da biblioteca curada.','[]'),
('m06','back',    'must','Explicação leiga de cada cláusula',                                          'backlog',false, 6,'Para cada cláusula, um texto curto de "por que isto te protege" em linguagem do dia a dia.','[]'),
('m07','back',    'must','Sinalização de red flags no contrato',                                       'backlog',false, 7,'Destacar pontos de risco no contrato (escopo aberto, ausência de multa, foro desfavorável etc.).','[]'),
('m08','back',    'must','Guardrails anti-alucinação + teste de stress (2–3 contratos reais)',         'backlog',false, 8,'Validação por código + cláusulas curadas para o LLM não errar lei. Stress-test com 2–3 contratos reais.','[]'),
('m09','front',   'must','Front mínimo do fluxo (intake → contrato → explicação → download)',          'backlog',false, 9,'Tela única ponta a ponta, suficiente para a demo ao vivo do pitch.','[]'),
('m10','front',   'must','Export pronto pra assinar (PDF/DOC)',                                        'backlog',false,10,'Saída final do contrato em PDF/DOC, pronta para o usuário enviar e assinar.','[]'),
-- SHOULD (4)
('s01','juridico','should','Validação jurídica via API/MCP (camada extra)','backlog',false,11,'Checagem adicional contra fontes legais além do RAG básico.','[]'),
('s02','back',    'should','Tradução de juridiquês refinada',                'backlog',false,12,'Desmistifica linguagem jurídica para o leigo com dicas contextuais.','[]'),
('s03','front',   'should','Dicas contextuais durante o intake',             'backlog',false,13,'Sugestões enquanto o usuário responde (ex.: "recomendamos sinal antecipado").','[]'),
('s04','gestao',  'should','Documentar testes de stress para defender no pitch','backlog',false,14,'Registrar os 2–3 contratos de prova: o que foi pedido, o que saiu, onde o guardrail segurou.','[]'),
-- COULD (3)
('c01','front','could','Calculadoras de estimativa (valor / prazo / nº de revisões)','backlog',false,15,'Isca de topo de funil e alimenta o contrato com números base.','[]'),
('c02','front','could','Gerador grátis de cláusula única (freemium → upsell)',        'backlog',false,16,'Isca freemium que puxa o usuário para o contrato completo.','[]'),
('c03','front','could','Marca d''água da ferramenta no contrato',                     'backlog',false,17,'Rodapé discreto no contrato gerado como gancho viral.','[]'),
-- WON'T (6) — roadmap pós-MVP
('w01','front', 'wont','Assinatura / aceite digital integrado (link de assinatura)',      'backlog',false,18,'Fora do MVP — entra depois.','[]'),
('w02','back',  'wont','Sinal via Pix embutido no contrato',                              'backlog',false,19,'Fora do MVP — depende de integração de pagamento.','[]'),
('w03','front', 'wont','Aditivo de escopo em 1 clique (scope creep)',                     'backlog',false,20,'Fora do MVP — feature de gestão pós-fechamento.','[]'),
('w04','back',  'wont','Cobrança / lembrete automático de parcelas e multa',              'backlog',false,21,'Fora do MVP — pertence a um módulo financeiro futuro.','[]'),
('w05','gestao','wont','Expansão B2C (aluguel, serviços domésticos, venda entre pessoas)','backlog',false,22,'Fora do MVP — depende de validação B2B primeiro.','[]'),
('w06','gestao','wont','Definir modelo de cobrança (freemium / sob demanda / assinatura)','backlog',false,23,'Pendente — não bloqueia o MVP técnico, mas precisa ser decidido antes do go-to-market.','[]');
