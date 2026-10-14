// Keeps the AI assistant configuration shared by its-programmazione and
// its-programmazione-ai in sync. The source is always its-programmazione:
//   agents/common.md            -> block between the markers in AGENTS.md
//   .agents/skills/its-slides/  -> same path
//   scripts/sync-agents.mjs     -> same path (this script)
//   scripts/set-slide-level.mjs -> same path (used by the its-slides skill)
// It also checks that CLAUDE.md and .github/copilot-instructions.md point to
// AGENTS.md. Keep this file identical in both repositories.
// Usage: node scripts/sync-agents.mjs [--check]
import { cpSync, existsSync, readFileSync, readdirSync, rmSync, statSync, writeFileSync } from 'node:fs'
import { basename, dirname, join, relative, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const SOURCE_REPO = 'its-programmazione'
const SHARED = ['.agents/skills/its-slides', 'scripts/sync-agents.mjs', 'scripts/set-slide-level.mjs']
const BEGIN = '<!-- BEGIN common: generated from its-programmazione/agents/common.md, edit the source and run npm run sync:agents -->'
const END = '<!-- END common -->'
const BLOCK_RE = /<!-- BEGIN common[^>]*-->[\s\S]*?<!-- END common -->/

const check = process.argv.includes('--check')
const root = resolve(dirname(fileURLToPath(import.meta.url)), '..')
const source = basename(root) === SOURCE_REPO ? root : resolve(root, '..', SOURCE_REPO)
const problems = []

function listFiles(dir) {
  return readdirSync(dir, { recursive: true })
    .map(String)
    .filter(f => !f.split('/').includes('.DS_Store') && statSync(join(dir, f)).isFile())
    .sort()
}

function sameContent(a, b) {
  if (!existsSync(a) || !existsSync(b))
    return false
  if (statSync(a).isFile())
    return statSync(b).isFile() && readFileSync(a).equals(readFileSync(b))
  const fa = listFiles(a)
  const fb = listFiles(b)
  return fa.length === fb.length && fa.every((f, i) => f === fb[i] && readFileSync(join(a, f)).equals(readFileSync(join(b, f))))
}

function requirePointer(file) {
  const path = join(root, file)
  if (!existsSync(path) || !readFileSync(path, 'utf-8').includes('AGENTS.md'))
    problems.push(`${file} must exist and point to AGENTS.md`)
}

// 1. Common block in AGENTS.md
const agentsPath = join(root, 'AGENTS.md')
const commonPath = join(source, 'agents', 'common.md')
if (!existsSync(agentsPath) || !BLOCK_RE.test(readFileSync(agentsPath, 'utf-8'))) {
  problems.push('AGENTS.md must exist and contain the BEGIN/END common markers')
}
else if (!existsSync(commonPath)) {
  console.warn(`Source ${relative(root, commonPath)} not found: shared files not compared.`)
}
else {
  const agents = readFileSync(agentsPath, 'utf-8')
  const block = `${BEGIN}\n\n${readFileSync(commonPath, 'utf-8').trim()}\n\n${END}`
  // A function, not a string: a replacement string would turn "$$" into "$"
  const updated = agents.replace(BLOCK_RE, () => block)
  if (updated !== agents) {
    if (check)
      problems.push('AGENTS.md: common block differs from agents/common.md')
    else
      writeFileSync(agentsPath, updated)
  }

  // 2. Shared files and folders (nothing to copy in the source repository)
  if (source !== root) {
    for (const item of SHARED) {
      const from = join(source, item)
      const to = join(root, item)
      if (sameContent(from, to))
        continue
      if (check) {
        problems.push(`${item} differs from ${SOURCE_REPO}`)
      }
      else {
        rmSync(to, { recursive: true, force: true })
        cpSync(from, to, { recursive: true, filter: f => basename(f) !== '.DS_Store' })
      }
    }
  }
}

// 3. Adapters for the single tools
requirePointer('CLAUDE.md')
requirePointer('.github/copilot-instructions.md')

if (problems.length) {
  console.error(`AI assistant configuration out of sync:\n  - ${problems.join('\n  - ')}`)
  console.error(check ? 'Run npm run sync:agents to fix the generated parts.' : '')
  process.exit(1)
}
console.log(check ? 'AI assistant configuration in sync.' : 'AI assistant configuration synced.')
