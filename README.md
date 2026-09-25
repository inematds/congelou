# 🥶 Congelou

**🇧🇷 [Português](README.md) · 🇺🇸 [English](README.en.md) · 🇪🇸 [Español](README.es.md)**

[![Congelou](guia/assets/banner.jpg)](https://inematds.github.io/congelou/guia/)

Curta de **38s com efeito time freeze**, feito 100% pela **assinatura Kling AI** via CLI oficial `kling`:
coloco um frango para assar, tomo um café, abro o forno, o frango sai **vivo**, eu me assusto e **tudo congela**.
Quando o tempo volta, vem o estrago.

## 📖 Guia de uso

Guia completo (landing + passo a passo + como repetir com outro assunto): **https://inematds.github.io/congelou/guia/**

🎬 Vídeo: [`guia/assets/congelou.mp4`](guia/assets/congelou.mp4)

## Como funciona

```
foto do rosto → keyframe k1 → clipe A → último quadro → clipe B → clipe C (freeze) → clipe D → ffmpeg → final
```

| Arquivo | Função |
|---|---|
| `keyframe.sh` | still inicial com o seu rosto (Nano Banana Pro dentro da Kling) |
| `clip.sh` | um clipe Kling 3.0 (1080p, áudio nativo, plano único) + baixa + último quadro |
| `fetch.sh` | baixa o resultado, mede o áudio, gera contact sheet e `keyframes/X_last.png` |
| `montar.sh` | junta os clipes, 1920×1080/24fps, loudnorm -14 LUFS |
| `prompts/` | `k1.txt`, `A.txt`…`D.txt` e o template `freeze_effect_template_en.md` |
| `LOG.md`, `job_ids.txt` | registro de cada geração e custo |

```bash
kling login
./keyframe.sh ref/nei.jpg prompts/k1.txt
./clip.sh A keyframes/k1.png 5
./clip.sh B keyframes/A_last.png 8
./clip.sh C keyframes/B_last.png 15
./clip.sh D keyframes/C_last.png 10
./montar.sh A B C D
```

Custo medido (plano Pro): 12 créditos/s no Kling 3.0 1080p com áudio. O filme todo saiu por ~476 créditos.

---
[INEMA.CLUB](https://inema.club)
