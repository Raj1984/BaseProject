# CLAUDE.md — BaseProject
# Master behavioral rules. Loaded every session. Keep this file under 2KB.
# Anything larger than 2KB → move to .claude/skills/ (progressive disclosure).
# User instructions always override this file.

## ─── TOKEN EFFICIENCY (drona23/claude-token-efficient) ───────────────────────
- Think before acting. Read files before writing code.
- Prefer targeted edits over full-file rewrites.
- Do not re-read a file unless it may have changed since last read.
- Skip files over 100KB unless explicitly required.
- No sycophantic openers or closing fluff.
- Run tests / verify before declaring a task done.
- One tool call should answer the question — don't chain redundant reads.

## ─── CODE DISCIPLINE (Karpathy / multica-ai) ────────────────────────────────
- State assumptions explicitly. Ask rather than guess.
- When ambiguity exists, present multiple interpretations — don't pick silently.
- Push back when a simpler approach exists; say so before implementing.
- No features beyond what was asked (YAGNI).
- No abstractions for single-use code.
- Do not touch adjacent code, comments, or formatting that is not part of the task.
- Every changed line must trace directly to the user's request.
- Define verifiable success criteria and loop until met.

## ─── CODEBASE NAVIGATION — MANDATORY (token-savior MCP) ─────────────────────
# token-savior MCP must be installed. See .mcp.json.
- ALWAYS reach for token-savior tools FIRST:
    find_symbol · get_function_source · get_class_source
    search_codebase · get_dependencies · get_change_impact
- Only fall back to Read/Grep when token-savior genuinely cannot answer.
- If you catch yourself reaching for grep to locate code → STOP, use find_symbol.
- For impact analysis before ANY refactor: get_change_impact("<SymbolName>").

## ─── CONTEXT MANAGEMENT ──────────────────────────────────────────────────────
- Watch the statusline for context %. At 60% → run /compact with preservation hints.
- Never let auto-compaction fire at 93% — compact deliberately at 60–70%.
- Compact format: /compact Keep: <current module>, <key decision>, <last migration>
- Use the researcher subagent (.claude/agents/researcher.yaml) for read-heavy tasks.
- Subagents run in fresh context windows — intermediate grep/read output stays there.

## ─── UNIVERSAL DOMAIN RULES (Indian Equity Derivatives) ─────────────────────
# These NEVER change across projects. Never assume — always use these values.
- NIFTY  : lot=50,  strike_step=50,  expiry=Thursday weekly
- BANKNIFTY: lot=15, strike_step=100, expiry=last-Thursday monthly
- FINNIFTY: lot=40,  strike_step=50,  expiry=Tuesday weekly
- Market hours: 09:15–15:30 IST (Asia/Kolkata)
- Primary broker: Zerodha Kite. Secondary: Dhan HQ (stub only).
- NSE data: bhavcopy + Kite API. No Yahoo Finance for Indian derivatives.
- VIX proxy: India VIX (not CBOE VIX).
- Never modify backtesting logic when asked to change only scanner logic.
- All signal-engine changes require a backtest verification step before "done".
- Cross-system agreement rule: S10 + Alert system must agree before any trade signal.

## ─── GIT & BRANCH DISCIPLINE ─────────────────────────────────────────────────
- Every feature / fix goes on its own branch via git worktree (Superpowers handles this).
- Never push directly to main.
- Commit messages: <type>(<scope>): <description>  [feat|fix|refactor|test|chore]
- Before any destructive git command (reset --hard, clean, push -f) → ask first.

## ─── PROJECT-SPECIFIC RULES (fill per project) ──────────────────────────────
# Copy this block into each cloned project's CLAUDE.md and fill it in.
# Run /grill-with-docs at session start to auto-populate CONTEXT.md + ADRs.
#
# ## Project: <name>
# - Key module boundaries: ...
# - Domain glossary additions: ...
# - Do not touch: ...
