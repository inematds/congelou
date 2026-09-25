#!/usr/bin/env bash
# Montagem com PARADAS depois do freeze (sem câmera lenta, sem interpolação):
#   o clipe da retomada anda um pedaço em velocidade normal, TRAVA num quadro parado,
#   anda de novo, trava... (N paradas, cada vez mais curtas) e segue natural.
#   Nas paradas o som some; volta junto com o movimento.
# uso:
#   ./montar_paradas.sh                                     # v2: A B C2 + paradas em D2 -> congelou_v2.mp4
#   CLIPS="M1 M2:8.0" RAMP=M3 OUT=microondas.mp4 ./montar_paradas.sh
#   STOPS="anda:parada ..." em segundos (default 4 paradas: 0.3s andando, 0.8→0.4s parado)
set -euo pipefail
cd "$(dirname "$0")"
read -r -a CL <<< "${CLIPS:-A B C2}"
RAMP="${RAMP:-D2}"; OUT="${OUT:-congelou_v2.mp4}"
read -r -a ST <<< "${STOPS:-0.3:0.8 0.3:0.65 0.3:0.5 0.3:0.4}"
TAG="$(basename "$OUT" .mp4)_p"
mkdir -p build
V="scale=-2:1080,crop=1920:1080,format=yuv420p,setsar=1,fps=24"
A="aresample=48000,aformat=channel_layouts=stereo"
ENC=(-c:v libx264 -preset medium -crf 18 -r 24 -c:a pcm_s16le)
SEGS=()

# trechos normais; "M2:8.0" usa o clipe só até 8.0s; do 2º em diante corta 2 quadros repetidos da emenda
for i in "${!CL[@]}"; do
  ID="${CL[$i]%%:*}"; TO=(); [[ "${CL[$i]}" == *:* ]] && TO=(-to "${CL[$i]#*:}")
  SS=(); [ "$i" -gt 0 ] && SS=(-ss 0.083)
  ffmpeg -v error -y "${SS[@]}" "${TO[@]}" -i "clips/$ID.mp4" -vf "$V" -af "$A" "${ENC[@]}" "build/${TAG}_$i.mkv"
  SEGS+=("build/${TAG}_$i.mkv")
done

# paradas: anda (velocidade normal) + segura o último quadro em silêncio
T=0.083; k=0
for s in "${ST[@]}"; do
  PLAY="${s%%:*}"; HOLD="${s#*:}"
  ffmpeg -v error -y -ss "$T" -t "$PLAY" -i "clips/$RAMP.mp4" \
    -vf "$V,tpad=stop_mode=clone:stop_duration=$HOLD" \
    -af "$A,afade=t=out:st=$(python3 -c "print(max(0,$PLAY-0.04))"):d=0.04,apad=pad_dur=$HOLD" \
    "${ENC[@]}" "build/${TAG}_s$k.mkv"
  SEGS+=("build/${TAG}_s$k.mkv")
  T=$(python3 -c "print($T+$PLAY)"); k=$((k+1))
done
# segue natural até o fim
ffmpeg -v error -y -ss "$T" -i "clips/$RAMP.mp4" -vf "$V" -af "$A" "${ENC[@]}" "build/${TAG}_fim.mkv"
SEGS+=("build/${TAG}_fim.mkv")

# junta tudo, normaliza áudio
IN=(); CAT=""; n=0
for f in "${SEGS[@]}"; do IN+=(-i "$f"); CAT+="[$n:v][$n:a]"; n=$((n+1)); done
ffmpeg -v error -y "${IN[@]}" -filter_complex "${CAT}concat=n=$n:v=1:a=1[v][ac];[ac]loudnorm=I=-14:TP=-1.5:LRA=11[a]" \
  -map "[v]" -map "[a]" -c:v libx264 -preset slow -crf 20 -c:a aac -b:a 192k -movflags +faststart "$OUT"
for f in "${SEGS[@]}"; do printf "%-28s %ss\n" "$f" "$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f")"; done
ffprobe -v error -show_entries stream=codec_type,width,height -show_entries format=duration -of compact "$OUT"
