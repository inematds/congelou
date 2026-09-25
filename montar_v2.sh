#!/usr/bin/env bash
# Montagem com RAMPA de câmera lenta no último clipe (o que retoma depois do freeze):
#   RAMP[0 .. S1]  → muito lenta (1/SLOW1 da velocidade, quadros interpolados)
#   RAMP[S1 .. S2] → lenta (1/SLOW2)
#   RAMP[S2 .. fim]→ velocidade natural
# Áudio dos trechos lentos: esticado e com o tom mais grave (efeito slow-mo clássico).
# uso:
#   ./montar_v2.sh                                   # v2: A B C2 + rampa em D2 -> congelou_v2.mp4
#   CLIPS="M1 M2:8.0" RAMP=M3 OUT=microondas.mp4 ./montar_v2.sh   # v3 (M2 cortado em 8s)
# ajustes: S1=1.4 S2=2.4 SLOW1=5 SLOW2=2
set -euo pipefail
cd "$(dirname "$0")"
read -r -a CL <<< "${CLIPS:-A B C2}"
RAMP="${RAMP:-D2}"; OUT="${OUT:-congelou_v2.mp4}"
S1="${S1:-1.4}"; S2="${S2:-2.4}"; SLOW1="${SLOW1:-5}"; SLOW2="${SLOW2:-2}"
TAG="$(basename "$OUT" .mp4)"
mkdir -p build
V="scale=-2:1080,crop=1920:1080,format=yuv420p,setsar=1"
A="aresample=48000,aformat=channel_layouts=stereo"
ENC=(-c:v libx264 -preset medium -crf 18 -r 24 -c:a pcm_s16le)
# atempo só aceita 0.5..100: quebra o fator numa cadeia (ex.: 0.4 -> atempo=0.5,atempo=0.8)
atempo () { python3 -c "
t=float('$1'); f=[]
while t<0.5: f.append(0.5); t/=0.5
f.append(round(t,4)); print(','.join('atempo=%s'%x for x in f))"; }
MI="minterpolate=fps=24:mi_mode=mci:mc_mode=aobmc:vsbmc=1"
SEGS=()

# trechos normais (do 2º em diante corta 2 quadros repetidos da emenda)
# um item pode ter corte no fim: "M2:8.0" usa o clipe M2 só até 8.0s
for i in "${!CL[@]}"; do
  ID="${CL[$i]%%:*}"; TO=(); [[ "${CL[$i]}" == *:* ]] && TO=(-to "${CL[$i]#*:}")
  SS=(); [ "$i" -gt 0 ] && SS=(-ss 0.083)
  ffmpeg -v error -y "${SS[@]}" "${TO[@]}" -i "clips/$ID.mp4" -vf "$V,fps=24" -af "$A" "${ENC[@]}" "build/${TAG}_$i.mkv"
  SEGS+=("build/${TAG}_$i.mkv")
done
# rampa: muito lento -> lento -> natural
ffmpeg -v error -y -ss 0.083 -to "$S1" -i "clips/$RAMP.mp4" -vf "$V,setpts=${SLOW1}*PTS,$MI" \
  -af "$A,asetrate=48000*0.5,aresample=48000,$(atempo "$(python3 -c "print(2/$SLOW1)")")" "${ENC[@]}" "build/${TAG}_ra.mkv"
ffmpeg -v error -y -ss "$S1" -to "$S2" -i "clips/$RAMP.mp4" -vf "$V,setpts=${SLOW2}*PTS,$MI" \
  -af "$A,asetrate=48000*0.75,aresample=48000,$(atempo "$(python3 -c "print(1/0.75/$SLOW2)")")" "${ENC[@]}" "build/${TAG}_rb.mkv"
ffmpeg -v error -y -ss "$S2" -i "clips/$RAMP.mp4" -vf "$V,fps=24" -af "$A" "${ENC[@]}" "build/${TAG}_rc.mkv"
SEGS+=("build/${TAG}_ra.mkv" "build/${TAG}_rb.mkv" "build/${TAG}_rc.mkv")

# junta tudo, normaliza áudio
IN=(); CAT=""; n=0
for f in "${SEGS[@]}"; do IN+=(-i "$f"); CAT+="[$n:v][$n:a]"; n=$((n+1)); done
ffmpeg -v error -y "${IN[@]}" -filter_complex "${CAT}concat=n=$n:v=1:a=1[v][ac];[ac]loudnorm=I=-14:TP=-1.5:LRA=11[a]" \
  -map "[v]" -map "[a]" -c:v libx264 -preset slow -crf 20 -c:a aac -b:a 192k -movflags +faststart "$OUT"
for f in "${SEGS[@]}"; do printf "%-28s %ss\n" "$f" "$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f")"; done
ffprobe -v error -show_entries stream=codec_type,width,height -show_entries format=duration -of compact "$OUT"
