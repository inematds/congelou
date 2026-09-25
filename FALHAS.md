# FALHAS

| data | o que quebrou | menor correção | prompt \| infra |
|---|---|---|---|
| 2026-09-25 | Capa gerada pelo Codex (`gerar-capa --gerador auto`) saiu literal: folha congelada, sem relação com o vídeo | Pra projeto de vídeo, usar `--raw-in` com um quadro real do clipe principal | prompt |
| 2026-09-25 | Arquivo do prompt de freeze no clipboard (`thinclient_drives/.clipboard`) sumiu no meio da sessão | Copiar insumos do clipboard pro projeto logo no início (`prompts/`) | infra |
