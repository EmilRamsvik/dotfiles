#!/usr/bin/env bash
# Export all Keyboard Maestro macro groups to keyboard-maestro/*.kmmacros
# (diffable XML, one file per group) and commit if anything changed.
#
# Run manually, from a Keyboard Maestro macro on a timer, or via launchd/cron:
#   ~/dotfiles/scripts/export-km-macros.sh
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${DOTFILES_DIR}/keyboard-maestro"
mkdir -p "$OUT_DIR"

if osascript "${DOTFILES_DIR}/scripts/export-km-macros.applescript" "$OUT_DIR"; then
    echo "Exported macro groups to ${OUT_DIR}"
else
    # Fallback: snapshot the raw macro plist as XML. One big file with some
    # UUID/usage-counter churn, but better than no backup at all.
    echo "AppleScript export failed; falling back to plist snapshot" >&2
    plutil -convert xml1 -o "${OUT_DIR}/macros-backup.xml" \
        "${HOME}/Library/Application Support/Keyboard Maestro/Keyboard Maestro Macros.plist"
fi

cd "$DOTFILES_DIR"
if [ -n "$(git status --porcelain -- keyboard-maestro)" ]; then
    git add keyboard-maestro
    git commit -m "Update Keyboard Maestro macro export ($(date +%Y-%m-%d))"
    echo "Committed updated macro export"
else
    echo "No macro changes to commit"
fi
