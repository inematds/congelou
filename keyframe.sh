#!/usr/bin/env bash
# Keyframe inicial com o SEU rosto, pela sua assinatura Kling AI (Nano Banana Pro dentro da Kling).
# uso: ./keyframe.sh <foto-do-rosto.jpg> <prompts/k1.txt> [saida=keyframes/k1.png]
set -euo pipefail
cd "$(dirname "$0")"
FOTO="$1"; PROMPT="$2"; OUT="${3:-keyframes/k1.png}"
mkdir -p keyframes
RES=$(timeout 300 kling image_to_image --model gemini-3-pro-image --image "$FOTO" \
  --img_resolution 2k --aspect_ratio 16:9 --image_count 1 --poll 240 -q "$(cat "$PROMPT")" 2>/dev/null)
URL=$(python3 -c 'import json,sys; t=sys.stdin.read(); j=json.loads(t[t.index("{\"ok\""):]); w=j["body"]["generations"][0]["result"]["works"][0]; print(w.get("urlWithoutWatermark") or w["url"])' <<<"$RES")
curl -sf -o "$OUT" "$URL"
echo "ok -> $OUT"
