#!/usr/bin/env bash
# scripts/new-project.sh
# Usage: bash scripts/new-project.sh <project-name>
# Creates a new project from BaseProject with git initialized.
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

PROJECT_NAME="${1:-}"
if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: bash scripts/new-project.sh <project-name>"
  echo "Example: bash scripts/new-project.sh nifty-compression-alerts"
  exit 1
fi

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$(dirname "$BASE_DIR")/$PROJECT_NAME"

echo ""
echo "[+] Creating new project: $PROJECT_NAME"
echo "[+] Location: $TARGET_DIR"

# Clone structure (not git clone — we want a fresh git history)
rsync -a \
  --exclude='.git' \
  --exclude='node_modules' \
  --exclude='__pycache__' \
  --exclude='*.pyc' \
  --exclude='.env' \
  "$BASE_DIR/" "$TARGET_DIR/"

cd "$TARGET_DIR"

# Fresh git repo
git init
git add .
git commit -m "chore: initialize from BaseProject template"

echo ""
echo "[+] Project created at $TARGET_DIR"
echo ""
echo "Next steps:"
echo "  cd $TARGET_DIR"
echo "  bash scripts/setup.sh          # install tools if not already installed"
echo "  ccr code                       # start Claude Code with model routing"
echo "  /setup-matt-pocock-skills      # configure issue tracker etc."
echo "  /grill-with-docs               # build CONTEXT.md for this project"
echo ""
echo "Then fill in CONTEXT.md with your domain glossary."
echo ""
