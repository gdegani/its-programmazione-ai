// Adds `level: 2` to the frontmatter of every slide in a file except the
// first one, leaving all untouched slides' raw text byte-identical. Used
// so the table of contents (slide 2, <Toc maxDepth="1" />) shows only the
// first slide of each lezione as a "chapter" — see PIANO_REVISIONE.md, C4.
// Usage: node scripts/set-slide-level.mjs <file.md> [--write]
import { parseSync, stringify } from '@slidev/parser/core'
import { readFileSync, writeFileSync } from 'node:fs'
import YAML from 'yaml'

const path = process.argv[2]
const write = process.argv.includes('--write')
const raw = readFileSync(path, 'utf-8')
const parsed = parseSync(raw, path)

// Rebuild a slide's raw text with the new frontmatter, keeping a blank line
// before the closing `---` fence: without it, markdownlint (and a plain
// Markdown reader) parses "last-yaml-key\n---" as a setext heading, since a
// slide's frontmatter block is not a file-leading YAML block it recognizes.
function rebuildRaw(slide) {
  const yamlText = slide.frontmatterDoc.toString().trim()
  const contentText = slide.content.trim() ? `\n${slide.content.trim()}\n` : ''
  let raw = `---\n${yamlText}\n\n---\n${contentText}`
  if (slide.note) raw += `\n<!--\n${slide.note.trim()}\n-->\n`
  slide.raw = raw
}

let changed = 0
parsed.slides.forEach((slide, idx) => {
  if (idx === 0) return // first slide of the file: stays chapter-level (1)
  if (slide.frontmatter.level != null) return // already explicit, don't touch
  if (!slide.frontmatterDoc) {
    slide.frontmatterDoc = YAML.parseDocument('level: 2\n')
  } else {
    slide.frontmatterDoc.set('level', 2)
  }
  slide.frontmatter.level = 2
  rebuildRaw(slide)
  changed++
})

const out = stringify(parsed)
console.log(`${path}: ${changed} slide(s) changed out of ${parsed.slides.length}`)
if (write) writeFileSync(path, out)
else process.stdout.write('\n--- would write (use --write to apply) ---\n')
