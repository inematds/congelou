# FALHAS

| data | o que quebrou | menor correção | prompt \| infra |
|---|---|---|---|
| 2026-09-25 | Freeze gerado pela Kling (M2, N2) deixa objetos soltos se mexendo (prato cai/gira) e câmera quase parada; slow-mo por interpolação borra | Freeze = still 4K nítido (`nitido.sh`) + movimento de câmera no ffmpeg (`freeze.sh`) | prompt |
| 2026-09-25 | Laço de espera com `pgrep -f "clip.sh N5"` casou com ele mesmo e nunca terminou | Esperar pelo arquivo de saída/`run_in_background` do próprio comando, não por pgrep do nome | infra |
| 2026-09-25 | `.gitignore` com `congelou_v*.mp4` (sem `/`) bloqueou também `guia/assets/congelou_v2.mp4` — commit saiu sem o vídeo | Ancorar padrões da raiz com `/` e conferir `git status` antes do commit | prompt |
| 2026-09-25 | Órbita do freeze (M2) terminou de cabeça pra baixo — último quadro inutilizável como início do próximo clipe | Cortar o clipe no último quadro em pé (`M2:8.0`) e encadear dali | prompt |
| 2026-09-25 | Capa gerada pelo Codex (`gerar-capa --gerador auto`) saiu literal: folha congelada, sem relação com o vídeo | Pra projeto de vídeo, usar `--raw-in` com um quadro real do clipe principal | prompt |
| 2026-09-25 | Arquivo do prompt de freeze no clipboard (`thinclient_drives/.clipboard`) sumiu no meio da sessão | Copiar insumos do clipboard pro projeto logo no início (`prompts/`) | infra |
