#!/usr/bin/env bash
# uso: ./fetch.sh X   -> lê clips/X.json, baixa clips/X.mp4, gera X_sheet.png e keyframes/X_last.png
set -euo pipefail
cd "$(dirname "$0")"
X="$1"
read -r ST GID URL < <(python3 - "$X" <<'EOF'
import json,sys
t=open(f'clips/{sys.argv[1]}.json').read()
j=json.loads(t[t.index('{"ok"'):])
g=j['body']['generations'][0]
w=(g.get('result') or {}).get('works') or [{}]
print(g['status'], g['generationId'], w[0].get('urlWithoutWatermark') or w[0].get('url') or '-')
EOF
)
echo "status=$ST"
[ "$ST" = COMPLETED ] || { tail -c 800 "clips/$X.json"; exit 1; }
echo "clip_$X $GID" >> job_ids.txt
curl -sf -o "clips/$X.mp4" "$URL"
ffprobe -v error -show_entries stream=codec_type,width,height,r_frame_rate -show_entries format=duration -of compact "clips/$X.mp4"
ffmpeg -hide_banner -i "clips/$X.mp4" -af volumedetect -vn -f null /dev/null 2>&1 | grep -E 'mean_volume|max_volume' | sed 's/.*\] //'
D=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "clips/$X.mp4")
ffmpeg -v error -y -sseof -0.1 -i "clips/$X.mp4" -frames:v 1 -update 1 "keyframes/${X}_last.png"
ffmpeg -v error -y -i "clips/$X.mp4" -vf "fps=8/$D,scale=480:-1,tile=4x2" -frames:v 1 "clips/${X}_sheet.png"
kling account -q
