# Project overview

Slides for the course "Programmazione assistita dall'Intelligenza Artificiale" (16 hours, 4 lessons of 4 hours), taught by Ing. Giancarlo
Degani at ITS Meccatronico Veneto. The slides are built with Slidev. The course follows "Elementi di programmazione e gestione dati"
(repository `its-programmazione`): students apply AI tools to C code they can already read, and the project of the C course is the case
study.

The goal is a clear, progressive understanding of how AI can assist programming, increase productivity and improve code quality, without
replacing understanding.

# Repository layout

* `slides.md`: entry point (configuration, table of contents and lesson list)
* `pages/`: one file per lesson
* `snippets/`: examples
* `reference/`: reference material (not versioned): use it as inspiration, never copy it verbatim; adapt and simplify it
* `components/`: Vue components
* `scripts/`: `release.sh` (archive an edition), `set-slide-level.mjs` (table of contents levels), `sync-agents.mjs` (shared AI
  assistant configuration)
* `AGENTS.md`: instructions for AI assistants (this file); `.agents/skills/`: project skills. The common section below and the
  `its-slides` skill are copied from `its-programmazione`

Useful commands: `npm run dev`, `npm run build`, `npm run check:agents`.

# Course-specific rules

* Tools used in class: LM Studio (local LLM), GitHub Copilot and continue.dev in CLion.
* The course is introductory: do not assume knowledge beyond what the C course covered.
* Always stress validating AI output: compile, test and check the logic of generated code.
* Use mind maps and diagrams where they help, as long as they stay simple.
* This repository follows the setup taught in lesson 2: `AGENTS.md` as the shared baseline, tool-specific files as thin adapters, skills
  in `.agents/skills/`. Keep the slides and this setup consistent.

<!-- BEGIN common: generated from its-programmazione/agents/common.md, edit the source and run npm run sync:agents -->

# Common conventions

This section is shared by `its-programmazione` and `its-programmazione-ai`. The source is `its-programmazione/agents/common.md`: edit it
there, then run `npm run sync:agents` in both repositories.

## Language

* Slide text and diagrams (Mermaid and similar) are in Italian.
* All code is in English, wherever it appears: inline in slides and in `snippets/`. Code is C. Identifiers, comments and output strings
  are in English, with no Italian words in the code.

## Slides

* Slides are Slidev (Markdown + Vue). Prefer headers over bold or italics for emphasis.
* Avoid embedded HTML: use pure Markdown and Slidev/Vue components.
* Keep slides concise: few bullets, short lines. Every slide must be fully visible, with nothing overflowing or overlapping. Split long
  code over several slides, or use a two-column layout (in two columns keep code lines under about 55 characters).
* Use Mermaid for diagrams. Check that each diagram fits the slide and lower its `scale` if it does not. Diagrams in a two-column layout
  are centered by `style.css`.
* Images taken from other sources carry a short citation (for example `source: wikipedia.org`).
* Do not suggest external interactive tools (Miro and similar): use what Slidev provides.

## Lesson structure and table of contents

* `slides.md` lists the lessons with `src:`; slide 2 is the table of contents, `<Toc maxDepth="1" listStyle="none" />`, with
  `hideInToc: true`. Do not use `layout: table-of-contents`: it adds a second, unfiltered list.
* Each lesson file starts with a `layout: cover` slide whose heading is the lesson title shown in the table of contents. Every other slide
  of the lesson has `level: 2` in its frontmatter: run `node scripts/set-slide-level.mjs <file> --write` after adding slides.
* In a slide's frontmatter, leave a blank line before the closing `---`, otherwise markdownlint reads the last key as a heading.
* Leave a blank line between HTML lines (such as `<br>`) and a following Mermaid or `$$` block, otherwise the block is shown as plain text.

## Examples

* Examples live in `snippets/*/`, one folder per example, each a standalone CMake project that compiles on its own. Slides include them
  with `<<< @/snippets/...`, using `// #region name` to show only a part. Inline code in slides is limited to tiny fragments.
* One example illustrates one concept, and uses only topics already covered in the course.

## Course setup

* All the exercises are done in class, in pairs (pair programming), on the classroom laptops with CLion. There is no homework.
* npm is the only package manager.

## Workflow

* `master` is protected and publishes the slides on GitHub Pages: work on a branch and open a pull request.
* The revision plan for both courses is `../PIANO_REVISIONE.md`, in the workspace folder that contains the two repositories.
* AI assistant configuration: `AGENTS.md` is the only source of instructions; `CLAUDE.md` and `.github/copilot-instructions.md` only
  point to it. Project skills live in `.agents/skills/` (`.claude/skills` links there).

## Before finishing a change

* Run markdownlint (configuration in `.markdownlint.json`, identical in both repositories), a full `npm run build` and
  `npm run check:agents`. In `its-programmazione` also run `npm run check:snippets` and `npm run check:language`.

<!-- END common -->
