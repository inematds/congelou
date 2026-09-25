#!/usr/bin/env bash
# CONGELAMENTO determinístico: uma foto nítida (de nitido.sh, 4K+) vira um clipe onde NADA se mexe
# e só a "câmera" anda (aproximação + deslize suave, com easing). Sem IA de vídeo: não borra, não deriva.
# O som vem de outro clipe (ex.: um freeze da Kling, que já traz silêncio + zumbido).
# uso: ./freeze.sh <foto.png> <clipe-do-som.mp4> <saida-ID> [segundos=8]
#   movimento via env (centros normalizados 0..1 e zoom):
#   Z1=1.0 Z2=1.3  CX1=0.5 CY1=0.5  CX2=0.4 CY2=0.4
set -euo pipefail
cd "$(dirname "$0")"
IMG="$1"; SND="$2"; ID="$3"; DUR="${4:-8}"
Z1="${Z1:-1.0}"; Z2="${Z2:-1.3}"; CX1="${CX1:-0.5}"; CY1="${CY1:-0.5}"; CX2="${CX2:-0.4}"; CY2="${CY2:-0.4}"
N=$(python3 -c "print(int(round($DUR*24)))")
P="(on/($N-1))"; E="($P*$P*(3-2*$P))"                     # smoothstep 0..1
Z="($Z1+($Z2-$Z1)*$E)"
CX="($CX1+($CX2-$CX1)*$E)"; CY="($CY1+($CY2-$CY1)*$E)"
# upscale 2x antes do zoompan: elimina o "tremido" de arredondamento do zoompan
ffmpeg -v error -y -loop 1 -framerate 24 -t "$DUR" -i "$IMG" -i "$SND" \
  -filter_complex "[0:v]scale=7680:4320:flags=lanczos,zoompan=z='$Z':x='max(0,min(iw-iw/zoom,$CX*iw-iw/zoom/2))':y='max(0,min(ih-ih/zoom,$CY*ih-ih/zoom/2))':d=1:s=3840x2160:fps=24,format=yuv420p,setsar=1[v]" \
  -map "[v]" -map 1:a -t "$DUR" -c:v libx264 -preset medium -crf 16 -c:a aac -b:a 192k -shortest "clips/$ID.mp4"
ffprobe -v error -show_entries stream=codec_type,width,height -show_entries format=duration -of compact "clips/$ID.mp4"
