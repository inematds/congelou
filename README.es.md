# 🥶 Congelou

**🇧🇷 [Português](README.md) · 🇺🇸 [English](README.en.md) · 🇪🇸 [Español](README.es.md)**

[![Congelou](guia/assets/banner.jpg)](https://inematds.github.io/congelou/guia/es/)

Corto de **38s con efecto time freeze**, hecho 100% con la **suscripción Kling AI** del autor mediante el CLI oficial `kling`:
pongo un pollo a asar, tomo un café, abro el horno, el pollo sale **vivo**, me asusto y **todo se congela**.
Cuando el tiempo vuelve, llega el desastre.

## 📖 Guía de uso

Guía completa (landing + paso a paso + cómo repetir con otra historia): **https://inematds.github.io/congelou/guia/es/**

🎬 Videos: [v1 original](guia/assets/congelou.mp4) · [v2 congelamiento total + cámara lenta](guia/assets/congelou_v2.mp4) · [v3 gato en el microondas](guia/assets/microondas.mp4)

## Cómo funciona

```
foto del rostro → keyframe k1 → clip A → último cuadro → clip B → clip C (freeze) → clip D → ffmpeg → final
```

| Archivo | Función |
|---|---|
| `keyframe.sh` | still inicial con tu rostro (Nano Banana Pro dentro de Kling) |
| `clip.sh` | un clip Kling 3.0 (1080p, audio nativo, plano único) + descarga + último cuadro |
| `fetch.sh` | descarga el resultado, mide el audio, genera contact sheet y `keyframes/X_last.png` |
| `montar.sh` | une los clips, 1920×1080/24fps, loudnorm -14 LUFS |
| `prompts/` | `k1.txt`, `A.txt`…`D.txt` y la plantilla `freeze_effect_template_en.md` |
| `LOG.md`, `job_ids.txt` | registro de cada generación y su costo |

```bash
kling login
./keyframe.sh ref/nei.jpg prompts/k1.txt
./clip.sh A keyframes/k1.png 5
./clip.sh B keyframes/A_last.png 8
./clip.sh C keyframes/B_last.png 15
./clip.sh D keyframes/C_last.png 10
./montar.sh A B C D
```

Costo medido (plan Pro): 12 créditos/s en Kling 3.0 a 1080p con audio. La película completa costó ~476 créditos.

---
[INEMA.CLUB](https://inema.club)
