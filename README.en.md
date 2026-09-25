# 🥶 Congelou

**🇧🇷 [Português](README.md) · 🇺🇸 [English](README.en.md) · 🇪🇸 [Español](README.es.md)**

[![Congelou](guia/assets/banner.jpg)](https://inematds.github.io/congelou/guia/en/)

A **38s short with a time-freeze effect**, made 100% with the author's **Kling AI subscription** through the official `kling` CLI:
I put a chicken in the oven to roast, have a coffee, open the oven, the chicken comes out **alive**, I get scared and **everything freezes**.
When time resumes, chaos follows.

## 📖 User guide

Full guide (landing + step by step + how to repeat with another story): **https://inematds.github.io/congelou/guia/en/**

🎬 Videos: [v1 original](guia/assets/congelou.mp4) · [v2 total freeze + slow motion](guia/assets/congelou_v2.mp4) · [v3 cat in the microwave](guia/assets/microondas.mp4)

## How it works

```
face photo → keyframe k1 → clip A → last frame → clip B → clip C (freeze) → clip D → ffmpeg → final
```

| File | Role |
|---|---|
| `keyframe.sh` | opening still with your face (Nano Banana Pro inside Kling) |
| `clip.sh` | one Kling 3.0 clip (1080p, native audio, single shot) + download + last frame |
| `fetch.sh` | downloads the result, measures audio, builds a contact sheet and `keyframes/X_last.png` |
| `montar.sh` | joins the clips, 1920×1080/24fps, loudnorm -14 LUFS |
| `prompts/` | `k1.txt`, `A.txt`…`D.txt` and the template `freeze_effect_template_en.md` |
| `LOG.md`, `job_ids.txt` | log of every generation and its cost |

```bash
kling login
./keyframe.sh ref/nei.jpg prompts/k1.txt
./clip.sh A keyframes/k1.png 5
./clip.sh B keyframes/A_last.png 8
./clip.sh C keyframes/B_last.png 15
./clip.sh D keyframes/C_last.png 10
./montar.sh A B C D
```

Measured cost (Pro plan): 12 credits/s for Kling 3.0 at 1080p with audio. The whole film took ~476 credits.

---
[INEMA.CLUB](https://inema.club)
