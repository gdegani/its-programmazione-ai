#!/usr/bin/env bash
#
# Archive a finished edition of the course (the same script is used by
# its-programmazione and its-programmazione-ai: keep the two copies identical):
#   1. pre-flight checks (master, clean tree, in sync with origin, tag free)
#   2. export the slides to PDF
#   3. generate the release notes (or use the ones provided)
#   4. create and push a signed annotated tag ed-AAAA-AA
#   5. create the GitHub Release with the PDF attached
#
# Usage: scripts/release.sh AAAA-AA [--notes-file FILE] [--dry-run]
#   e.g. npm run release -- 2026-27 --dry-run

set -euo pipefail

usage() {
    cat <<EOF
Usage: $(basename "$0") AAAA-AA [--notes-file FILE] [--dry-run]

  AAAA-AA           academic year of the edition, e.g. 2026-27
  --notes-file FILE use FILE as release notes instead of the generated ones
  --dry-run         run checks, export and notes, but do not tag or publish
EOF
}

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
info() { printf '    %s\n' "$*"; }
die()  { printf '\033[1;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

# --- Arguments ---------------------------------------------------------------

EDITION=""
NOTES_FILE=""
DRY_RUN=0

while [ $# -gt 0 ]; do
    case "$1" in
        --notes-file) [ $# -ge 2 ] || die "--notes-file requires a file"
                      NOTES_FILE="$2"; shift 2 ;;
        --dry-run)    DRY_RUN=1; shift ;;
        -h|--help)    usage; exit 0 ;;
        -*)           usage; die "unknown option: $1" ;;
        *)            [ -z "$EDITION" ] || die "edition given twice"
                      EDITION="$1"; shift ;;
    esac
done

[ -n "$EDITION" ] || { usage; exit 1; }
[[ "$EDITION" =~ ^([0-9]{4})-([0-9]{2})$ ]] || die "edition must be AAAA-AA, e.g. 2026-27"

START_YEAR="${BASH_REMATCH[1]}"
END_YY="${BASH_REMATCH[2]}"
EXPECTED_YY=$(printf '%02d' $(( (10#$START_YEAR + 1) % 100 )))
[ "$END_YY" = "$EXPECTED_YY" ] || die "inconsistent years: expected $START_YEAR-$EXPECTED_YY"

TAG="ed-$EDITION"
TITLE="Edizione $START_YEAR/$END_YY"
COVER_DATE="$START_YEAR-$(( 10#$START_YEAR + 1 ))"

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"

REPO=$(basename "$ROOT")
COURSE_TITLE=$(sed -n 's/^title: *//p' slides.md | head -1)
[ -n "$COURSE_TITLE" ] || die "title not found in slides.md"

OUT_DIR="release"
PDF_BASE="$OUT_DIR/$REPO-$TAG"
PDF="$PDF_BASE.pdf"

# --- Pre-flight checks -------------------------------------------------------

step "Pre-flight checks for $TAG"

for cmd in git gh npm; do
    command -v "$cmd" >/dev/null || die "'$cmd' not found"
done
gh auth status >/dev/null 2>&1 || die "gh is not authenticated: run 'gh auth login'"
[ -d node_modules ] || die "dependencies missing: run 'npm ci'"

BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "(detached)")
[ "$BRANCH" = "master" ] || die "releases are made from master (current: $BRANCH)"

[ -z "$(git status --porcelain --untracked-files=no)" ] \
    || die "uncommitted changes in tracked files: commit or stash them first"

git fetch --quiet origin master
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/master)
[ "$LOCAL" = "$REMOTE" ] \
    || die "master is not in sync with origin/master: push or pull first"

git rev-parse -q --verify "refs/tags/$TAG" >/dev/null \
    && die "tag $TAG already exists locally"
git ls-remote --exit-code --tags origin "refs/tags/$TAG" >/dev/null 2>&1 \
    && die "tag $TAG already exists on origin"

grep -q "coverDate: \"$COVER_DATE\"" slides.md \
    || die "coverDate in slides.md does not match the edition (expected \"$COVER_DATE\")"

if [ -n "$NOTES_FILE" ]; then
    [ -f "$NOTES_FILE" ] || die "notes file not found: $NOTES_FILE"
fi

info "branch master @ $(git rev-parse --short HEAD), in sync with origin"
info "tag $TAG is free, coverDate is $COVER_DATE"

# --- PDF export --------------------------------------------------------------

step "Exporting slides to $PDF"

mkdir -p "$OUT_DIR"
rm -f "$PDF"
npm run --silent export -- --output "$PDF_BASE" \
    || die "export failed (if Chromium is missing: npx playwright install chromium)"
[ -f "$PDF" ] || die "export did not produce $PDF"
info "$(du -h "$PDF" | cut -f1) written"

# --- Release notes -----------------------------------------------------------

step "Release notes"

if [ -z "$NOTES_FILE" ]; then
    NOTES_FILE="$OUT_DIR/notes-$TAG.md"
    PREV_TAG=$(git describe --tags --abbrev=0 --match 'ed-*' HEAD 2>/dev/null || true)
    if [ -n "$PREV_TAG" ]; then
        RANGE="$PREV_TAG..HEAD"
        CHANGES_TITLE="Modifiche rispetto a $PREV_TAG"
    else
        RANGE="HEAD"
        CHANGES_TITLE="Modifiche"
    fi

    # Dependency bumps, merges and housekeeping are noise for the course history.
    CHANGES=$(git log --no-merges --format='- %s' "$RANGE" \
        | grep -v -i -E '^- (bump|merge|chores?$|cleanup$)' || true)

    {
        echo "Corso \"$COURSE_TITLE\" - ITS Meccatronico Veneto, edizione $START_YEAR/$END_YY."
        echo
        echo "## $CHANGES_TITLE"
        echo
        echo "${CHANGES:-- Nessuna modifica ai contenuti}"
        echo
        echo "## Allegati"
        echo
        echo "- \`$(basename "$PDF")\`: slide del corso in PDF"
        echo "- Source code (zip / tar.gz): slide in formato Slidev ed esempi in \`snippets/\`"
    } > "$NOTES_FILE"
    info "generated $NOTES_FILE (edit it and pass it with --notes-file to customise)"
else
    info "using $NOTES_FILE"
fi

echo
sed 's/^/    | /' "$NOTES_FILE"

if [ "$DRY_RUN" -eq 1 ]; then
    step "Dry run: stopping before tag and release"
    info "PDF:   $PDF"
    info "Notes: $NOTES_FILE"
    exit 0
fi

# --- Tag and GitHub Release --------------------------------------------------

step "Creating tag $TAG"
# The tag is signed when tag.gpgSign is enabled in the git configuration.
git tag -a "$TAG" -m "$TITLE"
git push origin "$TAG"

step "Creating GitHub Release $TAG"
if ! gh release create "$TAG" "$PDF" \
        --verify-tag --title "$TITLE" --notes-file "$NOTES_FILE"; then
    die "release creation failed; the tag is already pushed. Retry with:
    gh release create $TAG $PDF --verify-tag --title \"$TITLE\" --notes-file $NOTES_FILE"
fi

step "Done"
info "$(gh release view "$TAG" --json url --jq .url)"
