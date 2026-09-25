# LOG — congelou (frango vivo + time freeze)

Via: **assinatura Kling AI do usuário** (CLI `kling`, conta SVIP/Pro). Nada de Magnific/RunComfy.
Ref de rosto: `ref/nei.jpg` (cópia de ~/projetos/explicavideos/guia/assets/nei.jpg).

- 2026-09-25 14:5x k1 still (gemini-3-pro-image, 2k 16:9) OK — 20 créditos (7973.8 → 7953.8)
- 2026-09-25 clip A submetido (kling-video-v3_0, 5s, 1080p, audio, single shot)
- 14:55 clip A OK (60 créd, 5.04s, audio aac) → A_last.png; clip B submetido (8s)
- 14:59 clip B OK (96 créd, 8.04s) → B_last.png; clip C submetido (15s, freeze, single shot)
- 15:04 clip C OK (180 créd, 15.04s, freeze funcionou: frango suspenso + órbita) → C_last.png; clip D submetido (10s, estrago)
- 15:10 clip D OK (120 créd, 10.04s; cozinha deriva um pouco pro genérico) → montagem
- 15:12 FINAL congelou_final.mp4 38.0s 1920x1080, -14.8 LUFS. Total ~476 créditos Kling (7973.8 → 7497.8). Capa refeita com quadro real do freeze (Codex gerou folha congelada, off-topic).
- 15:15 publicado: repo inematds/congelou (e6d507a), guia PT/EN/ES 200; portal 6a4feae, inemabuscas f6d2bb4, inemapro-mono 10af3aa
- 16:09 V2 pedida: galinha sai na hora, freeze total (inclusive ele, só câmera), volta em câmera muito lenta → natural. Reusa A,B. C2 submetido (12s)
- 16:10 V3 pedida: prato no microondas, sai gato vivo assustado, eu viro/derrubo tudo. Estilo v2 (freeze total + rampa slow-mo).
- 16:11 k3 OK (20 créd); M1 submetido (8s)
- 16:13 C2 OK (144 créd, 12s; freeze total + órbita dramática; fundo clareia no fim) → D2 submetido (10s)
- 16:14 M1 OK (96 créd, 8s) → M2 submetido (12s, gato + freeze)
- 16:15 D2 OK (120 créd, 10s; cozinha deriva p/ genérica) → montagem v2
- 16:18 M2 OK (144 créd) mas órbita termina de cabeça p/ baixo e prato desliza no freeze → corta em 8.0s, M3 parte de M2_cut.png; v2 montada 41.2s
- 16:22 M3 OK (120 créd, 10s) → montagem v3
- 16:24 v3 microondas.mp4 32.2s -14.5 LUFS publicada no guia. Créditos restantes 6853.8
- 16:28 v2 ATUALIZADA a pedido: câmera lenta interpolada → 4 paradas (anda 0.3s / trava 0.8→0.4s, som some na trava). 37.6s. Sem custo Kling. Backup slow-mo em build/.
- 17:02 V3 REFEITA (usuário não gostou): gato sai ANTES de pôr o prato, derruba o prato; congelamentos em 4K nítidos, vários momentos; sem interpolação
- 17:04 k4 OK (20 créd). N1 submetido 4K 4s (medir custo 4K)
- 17:08 N1 OK 4K (3856x2148) 4s = 140 créd → 4K custa 35 créd/s (~3x 1080p)
- 17:10 N1_nitido OK (20 créd) → N2 freeze 1 submetido 4K 8s
- 17:15 N2 (260 créd) FALHOU: prato continua caindo no freeze e câmera quase parada. Troca: freeze = still 4K nítido + movimento de câmera no ffmpeg; áudio do N2 reaproveitado
- 17:18 F1 (freeze 1) OK: still 4K 5504px nítido + push-in ffmpeg 8s, som do N2 (custo 20). N3 submetido 4K 4s a partir de F1
- 17:24 N3 OK 4K (140 créd) mas giro borrado ~2.5s → usar só N3[0:2.2]. F2 (impacto do prato, still 4K gerado) OK 20 créd. N5 submetido 4K 8s a partir de F2
- 20:04 N5 OK 4K 8s (280 créd). Montagem v3 nova 4K: N1 F1 N3c F2 N5
- 20:05 v3 NOVA publicada: microondas.mp4 4K 29s -14.7 LUFS (N1 F1 N3c F2 N5). Custo v3 refeita ≈ 880 créd (N2 260 perdido). Saldo 6023.8
