#!/usr/bin/env bash
# Regenera um quadro (tipicamente o último de um clipe de ação, com motion blur) NÍTIDO,
# mantendo a composição idêntica — vira o início perfeito de um clipe de congelamento.
# Usa Nano Banana Pro dentro da assinatura Kling; a foto do rosto garante a identidade.
# uso: [IMGRES=4k|2k] ./nitido.sh <quadro.png> <saida.png> [foto-rosto=ref/nei.jpg]
set -euo pipefail
cd "$(dirname "$0")"
IN="$1"; OUT="$2"; FACE="${3:-ref/nei.jpg}"
P="Recreate image 1 as the exact same frame: identical composition, camera angle, framing, positions of every person, animal and object, poses, expressions, lighting and colors. Change ONLY the image quality: razor sharp, zero motion blur, crisp high detail like a 1/8000s high-speed photograph, every flying grain, droplet and hair perfectly frozen and in focus. The man's face must match the man in image 2 exactly (same face, glasses). Photorealistic. No text."
RES=$(timeout 300 kling image_to_image --model gemini-3-pro-image --image "$IN" --image "$FACE" \
  --img_resolution "${IMGRES:-4k}" --aspect_ratio 16:9 --image_count 1 --poll 240 -q "$P" 2>/dev/null)
URL=$(python3 -c 'import json,sys; t=sys.stdin.read(); j=json.loads(t[t.index("{\"ok\""):]); w=j["body"]["generations"][0]["result"]["works"][0]; print(w.get("urlWithoutWatermark") or w["url"])' <<<"$RES")
curl -sf -o "$OUT" "$URL"
echo "ok -> $OUT"
