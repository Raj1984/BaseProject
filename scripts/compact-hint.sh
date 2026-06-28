#!/usr/bin/env bash
# scripts/compact-hint.sh
# Prints the /compact command with context-aware preservation hints.
# Pipe output into your Claude Code session or just copy-paste it.
# Usage: bash scripts/compact-hint.sh [project-name]

PROJECT="${1:-$(basename "$(pwd)")}"

cat << EOF
/compact Keep: \
  current module=${PROJECT}, \
  active branch=$(git branch --show-current 2>/dev/null || echo "main"), \
  last changed files=$(git diff --name-only HEAD~1 2>/dev/null | head -3 | tr '\n' ',' | sed 's/,$//'), \
  lot sizes (NIFTY=50 BANKNIFTY=15 FINNIFTY=40), \
  broker=Zerodha-Kite-primary, \
  signal-agreement-rule=S10+Alert-must-agree, \
  walk-forward-windows=20-and-60-session
EOF
