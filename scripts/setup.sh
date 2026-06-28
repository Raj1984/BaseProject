#!/usr/bin/env bash
# scripts/setup.sh
# One-shot setup for BaseProject.
# Run once after cloning: bash scripts/setup.sh
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[+]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[✗]${NC} $1"; exit 1; }

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║        BaseProject Setup Script               ║"
echo "║  Superpowers + mattpocock + karpathy + tokens    ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# ── Prereqs ──────────────────────────────────────────────────────────────────
info "Checking prerequisites..."
command -v node >/dev/null 2>&1 || error "Node.js not found. Install from https://nodejs.org"
# On Windows, python.org installs as 'python' not 'python3'
if command -v python3 >/dev/null 2>&1; then
  PYTHON=python3
elif command -v python >/dev/null 2>&1; then
  PYTHON=python
else
  error "Python 3 not found."
fi
command -v claude >/dev/null 2>&1 || warn "Claude Code not found. Install: npm install -g @anthropic-ai/claude-code"
command -v git >/dev/null 2>&1 || error "Git not found."

NODE_VER=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VER" -lt 18 ]; then
  error "Node.js 18+ required. Current: $(node -v)"
fi
info "Prerequisites OK (Node $(node -v), Python $($PYTHON --version))"

# ── 1. Claude Code global plugins ────────────────────────────────────────────
echo ""
info "Step 1/6: Installing Claude Code plugins..."
if command -v claude >/dev/null 2>&1; then
  warn "Run these manually inside a Claude Code session:"
  echo ""
  echo "  # Superpowers (workflow orchestration)"
  echo "  /plugin install superpowers@claude-plugins-official"
  echo ""
  echo "  # claude-mem (cross-session memory)"
  echo "  /plugin marketplace add thedotmack/claude-mem"
  echo "  /plugin install claude-mem@claude-mem"
  echo ""
else
  warn "Claude Code not installed — skipping plugin step."
fi

# ── 2. mattpocock skills ──────────────────────────────────────────────────────
echo ""
info "Step 2/6: Installing mattpocock skills..."
if command -v npx >/dev/null 2>&1; then
  npx skills@latest add mattpocock/skills --yes 2>/dev/null || \
    warn "mattpocock skills install failed — run manually: npx skills@latest add mattpocock/skills"
  info "mattpocock skills installed."
else
  warn "npx not found — skipping mattpocock skills."
fi

# ── 3. token-savior MCP ───────────────────────────────────────────────────────
echo ""
info "Step 3/6: Installing token-savior MCP..."
VENV_PATH="$HOME/.local/token-savior-venv"
# Windows venvs use Scripts/, Unix use bin/
if [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* || "$OSTYPE" == "win32"* ]]; then
  VENV_BIN="$VENV_PATH/Scripts"
else
  VENV_BIN="$VENV_PATH/bin"
fi
if [ ! -d "$VENV_PATH" ]; then
  $PYTHON -m venv "$VENV_PATH"
  "$VENV_BIN/pip" install --quiet token-savior
  info "token-savior installed at $VENV_PATH"
else
  info "token-savior venv already exists at $VENV_PATH — skipping."
fi

# Update .mcp.json with actual path
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MCP_JSON="$PROJECT_ROOT/.mcp.json"
if [ -f "$MCP_JSON" ]; then
  # Replace placeholder path with actual venv path
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s|/path/to/.local/token-savior-venv|$VENV_PATH|g" "$MCP_JSON"
    sed -i '' "s|/path/to/your/project|$PROJECT_ROOT|g" "$MCP_JSON"
  else
    sed -i "s|/path/to/.local/token-savior-venv|$VENV_PATH|g" "$MCP_JSON"
    sed -i "s|/path/to/your/project|$PROJECT_ROOT|g" "$MCP_JSON"
  fi
  info ".mcp.json updated with real paths."
fi

# Register with Claude Code
if command -v claude >/dev/null 2>&1; then
  claude mcp add token-savior --scope user \
    -e WORKSPACE_ROOTS="$PROJECT_ROOT" \
    -e TOKEN_SAVIOR_CLIENT=claude-code \
    -e TOKEN_SAVIOR_PROFILE=core \
    -- "$VENV_BIN/token-savior" 2>/dev/null || \
    warn "MCP registration failed — register manually (see README)."
  info "token-savior registered with Claude Code."
fi

# ── 4. claude-code-router ─────────────────────────────────────────────────────
echo ""
info "Step 4/6: Installing claude-code-router..."
if npm list -g @musistudio/claude-code-router >/dev/null 2>&1; then
  info "claude-code-router already installed."
else
  npm install -g @musistudio/claude-code-router 2>/dev/null || \
    warn "claude-code-router install failed — run: npm install -g @musistudio/claude-code-router"
  info "claude-code-router installed."
fi

# Copy router config
ROUTER_CONFIG_DIR="$HOME/.claude-code-router"
mkdir -p "$ROUTER_CONFIG_DIR"
if [ ! -f "$ROUTER_CONFIG_DIR/config.json" ]; then
  cp "$PROJECT_ROOT/.claude-code-router/config.json" "$ROUTER_CONFIG_DIR/config.json"
  info "Router config copied to $ROUTER_CONFIG_DIR/config.json"
  warn "Edit $ROUTER_CONFIG_DIR/config.json and add your API keys."
else
  warn "Router config already exists at $ROUTER_CONFIG_DIR/config.json — not overwritten."
fi

# ── 5. global settings.json ───────────────────────────────────────────────────
echo ""
info "Step 5/6: Setting up global Claude Code settings..."
CLAUDE_SETTINGS_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_SETTINGS_DIR"
SETTINGS_FILE="$CLAUDE_SETTINGS_DIR/settings.json"

if [ ! -f "$SETTINGS_FILE" ]; then
  cp "$PROJECT_ROOT/.claude/settings.json" "$SETTINGS_FILE"
  # Fix hook path
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s|/path/to/project|$PROJECT_ROOT|g" "$SETTINGS_FILE"
  else
    sed -i "s|/path/to/project|$PROJECT_ROOT|g" "$SETTINGS_FILE"
  fi
  info "settings.json created at $SETTINGS_FILE"
else
  warn "~/.claude/settings.json already exists — not overwritten. Manually merge if needed."
fi

# ── 6. shell profile ─────────────────────────────────────────────────────────
echo ""
info "Step 6/6: Adding shell env vars..."
PROFILE_LINE='export MAX_THINKING_TOKENS=8000'

for PROFILE in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile"; do
  if [ -f "$PROFILE" ] && ! grep -q "MAX_THINKING_TOKENS" "$PROFILE"; then
    echo "" >> "$PROFILE"
    echo "# BaseProject: cap Claude Code extended thinking" >> "$PROFILE"
    echo "$PROFILE_LINE" >> "$PROFILE"
    info "Added MAX_THINKING_TOKENS=8000 to $PROFILE"
    break
  fi
done

# chmod hook
chmod +x "$PROJECT_ROOT/.claude/hooks/bash-filter.sh" 2>/dev/null || true

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║                 Setup Complete!                  ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  1. Add API keys to ~/.claude-code-router/config.json"
echo "  2. Start Claude Code via:  ccr code"
echo "  3. In Claude Code, install plugins (see Step 1 output above)"
echo "  4. Run:  /setup-matt-pocock-skills"
echo "  5. Run:  /grill-with-docs  (builds CONTEXT.md for this project)"
echo "  6. Watch context%: statusline shows 'ctx XX%' — compact at 60%"
echo ""
echo "Token reduction stack active:"
echo "  ✓ MAX_THINKING_TOKENS=8000  (caps reasoning token bleed)"
echo "  ✓ token-savior MCP          (symbol-level navigation, 89–99% savings)"
echo "  ✓ claude-code-router        (Haiku for research, Sonnet for code)"
echo "  ✓ bash-filter hook          (strips ANSI + noisy warnings)"
echo "  ✓ drona23 CLAUDE.md rules   (terse output, no fluff)"
echo "  ✓ Haiku researcher agent    (read tasks stay out of main context)"
echo ""
