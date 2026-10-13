# Project overview

Slides for the course "Programmazione assistita dall'Intelligenza Artificiale" (16 hours, 4 lessons of 4 hours), taught by Ing. Giancarlo
Degani at ITS Meccatronico Veneto. The slides are built with Slidev. The course follows "Elementi di programmazione e gestione dati"
(repository `its-programmazione`): students apply AI tools to C code they can already read, and the project of the C course is the case
study.

The goal is a clear, progressive understanding of how AI can assist programming, increase productivity and improve code quality, without replacing understanding.

# Repository layout

* `slides.md`: entry point (configuration and lesson list)
* `pages/`: one file per lesson
* `snippets/`: examples
* `reference/`: reference material (not versioned): use it as inspiration, never copy it verbatim; adapt and simplify it
* `components/`: Vue components
* `scripts/release.sh`: archive an edition

# Course-specific rules

* Tools used in class: LM Studio (local LLM), GitHub Copilot and continue.dev in CLion.
* The course is introductory: do not assume knowledge beyond what the C course covered.
* Always stress validating AI output: compile, test and check the logic of generated code.
* Use mind maps and diagrams where they help, as long as they stay simple.

# Common conventions

This section is identical in `its-programmazione` and `its-programmazione-ai`: keep the two copies aligned.

## Language

* Slide text is in Italian.
* Code is C. Identifiers, comments and output strings in the examples are in English, with no Italian words in the code.

## Slides

* Slides are Slidev (Markdown + Vue). Prefer headers over bold or italics for emphasis.
* Avoid embedded HTML: use pure Markdown and Slidev/Vue components.
* Keep slides concise: few bullets, short lines. Every slide must be fully visible, with nothing overflowing or overlapping. Split long code over several slides, or use a two-column layout (in two columns keep code lines under about 55 characters).
* Use Mermaid for diagrams.
* Do not suggest external interactive tools (Miro and similar): use what Slidev provides.

## Examples

* Examples live in `snippets/*/`, one folder per example, each a standalone CMake project that compiles on its own. Slides include them with `<<< @/snippets/...`, using `// #region name` to show only a part. Inline code in slides is limited to tiny fragments.
* One example illustrates one concept, and uses only topics already covered in the course.

## Course setup

* All the exercises are done in class, in pairs (pair programming), on the classroom laptops with CLion. There is no homework.
* npm is the only package manager.

## Before finishing a change

* Run markdownlint (configuration in `.markdownlint.json`, identical in both repositories) and a full `npm run build`.
