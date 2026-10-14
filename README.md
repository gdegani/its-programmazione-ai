# Programmazione Assistita dall'Intelligenza Artificiale

[![Deploy to GitHub Pages](https://github.com/gdegani/its-programmazione-ai/actions/workflows/deploy.yml/badge.svg)](https://github.com/gdegani/its-programmazione-ai/actions)
[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

Repository contenente le slide per il corso [**"Programmazione Assistita dall'Intelligenza Artificiale"**](https://gdegani.github.io/its-programmazione-ai/)tenuto presso la [**Fondazione ITS Academy Meccatronico Veneto**.](https://www.itsmeccatronico.it/)

**Slide online:** [https://gdegani.github.io/its-programmazione-ai/](https://gdegani.github.io/its-programmazione-ai/)

## Avvio della presentazione

Per avviare le slide localmente:

```bash
npm install
npm run dev
```

Quindi visita <http://localhost:3030> nel tuo browser.

## Contenuti

Le slide sono organizzate per lezioni e costruite con [Slidev](https://sli.dev/), che permette di creare presentazioni interattive utilizzando Markdown e Vue.

- **slides.md** - Indice principale delle lezioni
- **pages/** - Slide divise per lezione
- **reference/** - Materiale di riferimento

## Modifiche alle slide

Per modificare il contenuto, edita i file in Markdown nella cartella `pages/` o il file `slides.md`.

## Comandi

```bash
npm install                # install dependencies
npm run dev                # slides at http://localhost:3030
npm run build              # static site in dist/
npm run export             # PDF export (slides-export.pdf)
npm run release -- 2026-27 --dry-run   # see "Procedura di release"
```

Requisiti: Node.js (versione LTS) con npm, l'unico gestore di pacchetti usato dal progetto. Per l'export in PDF serve il browser Chromium di Playwright (`npx playwright install chromium` se manca). Per la release serve [GitHub CLI](https://cli.github.com) autenticata (`gh auth login`).

## Edizioni del corso

- **`master` contiene l'edizione in corso.** Le lezioni si fanno da qui e GitHub Pages mostra sempre questa versione.
- **Ogni edizione conclusa viene archiviata con un tag** `ed-AAAA-AA` (anno accademico, es. `ed-2026-27`), annotato e firmato, e con una [GitHub Release](https://github.com/gdegani/its-programmazione-ai/releases) che ha il PDF delle slide allegato.
- Il modulo segue il corso [its-programmazione](https://github.com/gdegani/its-programmazione) e usa la stessa convenzione: a fine edizione i due repository si archiviano con lo stesso tag.
- I tag `2026.01` e `2026.02` sono precedenti a questa convenzione.

## Procedura di release

Lo script [`scripts/release.sh`](scripts/release.sh) è lo stesso del repository `its-programmazione`: i due file vanno tenuti identici.

All'inizio di una nuova edizione, su `master`, aggiornare `coverDate` in [`slides.md`](slides.md) (es. `coverDate: "2026-2027"`): lo script lo controlla.

A fine edizione, quando tutte le modifiche sono su `master` (committate e pubblicate):

1. **Prova a vuoto**: esegue i controlli, esporta il PDF e genera le note, ma non crea né tag né release.

   ```bash
   npm run release -- 2026-27 --dry-run
   ```

2. **Controlla** in `release/` (ignorata da git) il PDF `its-programmazione-ai-ed-2026-27.pdf` e la bozza delle note `notes-ed-2026-27.md`, generata dai messaggi di commit dall'ultimo tag `ed-*`. Conviene modificarla.
3. **Pubblica** usando le note modificate:

   ```bash
   npm run release -- 2026-27 --notes-file release/notes-ed-2026-27.md
   ```

Lo script si ferma al primo errore. Controlla edizione, strumenti, branch `master` pulito e allineato con `origin/master`, tag libero e `coverDate`; poi esporta il PDF, prepara le note, crea e pubblica tag e GitHub Release.

La procedura completa, con la risoluzione dei problemi, è nel [README di its-programmazione](https://github.com/gdegani/its-programmazione#procedura-di-release).

## Ulteriori informazioni

Consulta la [documentazione di Slidev](https://sli.dev/) per scoprire tutte le funzionalità disponibili.
