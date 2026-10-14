---
name: its-slides
description: Procedures for the ITS course slide repositories (its-programmazione, its-programmazione-ai) - adding a lesson, adding slides or diagrams, including a C example from snippets/, and the checks to run before committing. Use when editing slides.md, pages/*.md, snippets/ or style.css in these repositories.
---

# ITS course slides

Procedures for `its-programmazione` and `its-programmazione-ai`. The rules they apply are in `AGENTS.md`; this skill only lists the steps.
Source: `its-programmazione/.agents/skills/its-slides/`, copied to the other repository by `npm run sync:agents`.

## Add a lesson

1. Create `pages/<lesson>.md`. Its first slide is the chapter title shown in the table of contents:

   ```md
   ---
   layout: cover

   ---

   # N - Lesson title
   ```

2. Add the lesson to `slides.md`, after the previous one:

   ```md
   ---
   src: ./pages/<lesson>.md
   title: Lesson title

   ---
   ```

3. Write the slides (Italian text, English code), then run `node scripts/set-slide-level.mjs pages/<lesson>.md --write`, so that only the
   first slide appears in the table of contents.

## Add slides to an existing lesson

* Give each new slide `level: 2` in its frontmatter, or rerun `node scripts/set-slide-level.mjs <file> --write` (it skips slides that
  already have a level).
* Leave a blank line before the `---` that closes a slide's frontmatter.

## Add a diagram

* Mermaid, labels in Italian. After `<br>` or other HTML lines, leave a blank line before the opening fence.
* Build and look at the slide: if the diagram overflows, lower `scale` in ```` ```mermaid {scale: 0.8} ````.
* For an image taken from another source, add a short citation (for example `source: wikipedia.org`).

## Include a C example (its-programmazione)

1. Create `snippets/exampleNN/` with `main.c` and `CMakeLists.txt`, a standalone CMake project; identifiers, comments and strings in
   English.
2. Mark the part to show with `// #region name` and `// #endregion name`.
3. Include it in the slide with `<<< @/snippets/exampleNN/main.c#name c {*}{lines:true}`.
4. Run `npm run check:snippets` and `npm run check:language`.

## Before committing

1. `npx markdownlint-cli2` on the changed Markdown files.
2. `npm run build`.
3. `npm run check:agents`; in `its-programmazione` also `npm run check:snippets` and `npm run check:language`.
4. For visual changes, open the slides with `npm run dev` and check every changed slide: nothing overflowing or overlapping.

## Publish

`master` is protected and publishes the slides on GitHub Pages: commit on a branch, push it and open a pull request; merge only when the
user asks.
