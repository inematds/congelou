#!/usr/bin/env bash
# Junta os clipes (com o áudio nativo da Kling) num vídeo final 1920x1080/24fps, loudnorm -14 LUFS.
# uso: ./montar.sh [A B C D]   (default: A B C D)  -> congelou_final.mp4
# Do 2º clipe em diante corta 2 quadros (~0.083s) do início: eles começam no último quadro do anterior.
set -euo pipefail
cd "$(dirname "$0")"
CLIPS=("$@"); [ ${#CLIPS[@]} -gt 0 ] || CLIPS=(A B C D)
OUT="${OUT:-congelou_final.mp4}"
V="scale=-2:1080,crop=1920:1080,fps=24,format=yuv420p,setsar=1"
A="aresample=48000,aformat=channel_layouts=stereo"
IN=(); FC=""; CAT=""
for i in "${!CLIPS[@]}"; do
  if [ "$i" -eq 0 ]; then IN+=(-i "clips/${CLIPS[$i]}.mp4"); else IN+=(-ss 0.083 -i "clips/${CLIPS[$i]}.mp4"); fi
  FC+="[$i:v]$V,setpts=PTS-STARTPTS[v$i];[$i:a]$A,asetpts=PTS-STARTPTS[a$i];"
  CAT+="[v$i][a$i]"
done
FC+="${CAT}concat=n=${#CLIPS[@]}:v=1:a=1[v][ac];[ac]loudnorm=I=-14:TP=-1.5:LRA=11[a]"
ffmpeg -v error -y "${IN[@]}" -filter_complex "$FC" -map "[v]" -map "[a]" \
  -c:v libx264 -preset slow -crf 20 -c:a aac -b:a 192k -movflags +faststart "$OUT"
ffprobe -v error -show_entries stream=codec_type,width,height -show_entries format=duration -of compact "$OUT"
