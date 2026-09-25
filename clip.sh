#!/usr/bin/env bash
# Gera UM clipe Kling 3.0 (image_to_video, 1080p, áudio nativo, plano único) e já baixa/inspeciona.
# uso: [RES=4k] ./clip.sh <ID> <imagem-inicial.png> <segundos 3-15>   (RES default 1080p)
#   prompt lido de prompts/<ID>.txt ; saída clips/<ID>.mp4 + keyframes/<ID>_last.png (início do próximo)
set -euo pipefail
cd "$(dirname "$0")"
ID="$1"; IMG="$2"; DUR="$3"
mkdir -p clips keyframes
timeout 590 kling image_to_video --model kling-video-v3_0 --image "$IMG" --duration "$DUR" \
  --resolution "${RES:-1080p}" --imageCount 1 --prefer_multi_shots false --enable_audio true \
  --poll 570 -q "$(cat "prompts/$ID.txt")" > "clips/$ID.json" 2>&1
./fetch.sh "$ID"
