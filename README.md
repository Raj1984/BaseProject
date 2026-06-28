# BaseProject

**Universal base project template for development.**  
Clone this to start any new project in the `JobAISearch` ecosystem.

---

## What's Inside

```
BaseProject/
│
├── CLAUDE.md                        ← Master behavior rules (always loaded)
│                                      Merged: karpathy + drona23 + domain rules
│
├── CONTEXT.md                       ← Domain glossary template (fill per project)
│                                      Built/maintained via /grill-with-docs
│
├── .mcp.json                        ← token-savior MCP registration
│
├── .claude/
│   ├── settings.json                ← Thinking cap (8K) + context% statusline
│   ├── agents/
│   │   ├── researcher.yaml          ← Haiku subagent: cheap read-heavy tasks
│   │   └── backtester.yaml          ← Sonnet subagent: backtest isolation
│   └── hooks/
│       └── bash-filter.sh           ← Strips ANSI + dedupes noisy bash output
│
├── .claude-plugin/                  ← Superpowers plugin marker
├── .claude-code-router/
│   └── config.json                  ← Model routing (Haiku/Sonnet/Opus/Gemini)
│
├── skills/
│   └── karpathy-guidelines/
│       └── SKILL.md                 ← 4 Karpathy principles as a Claude skill
│
├── docs/
│   ├── ADRs/
│   │   └── ADR-000-template.md      ← Architecture Decision Record template
│   └── architecture/
│       └── OVERVIEW.md              ← Module map + system diagram template
│
└── scripts/
    ├── setup.sh                     ← One-shot install of all tools
    ├── new-project.sh               ← Bootstrap a new project from this base
    └── compact-hint.sh              ← Generate /compact command with smart hints
```

---

## First-Time Setup (Run Once)

```bash
bash scripts/setup.sh
```

This installs:
- **token-savior** MCP (symbol-level navigation, 89–99% token savings on reads)
- **claude-code-router** (routes to Haiku/Sonnet/Opus/Gemini by task type)
- **mattpocock/skills** (engineering slash commands)
- Configures global `~/.claude/settings.json` with thinking cap + statusline
- Adds `MAX_THINKING_TOKENS=8000` to shell profile

Then manually inside a Claude Code session:
```
/plugin install superpowers@claude-plugins-official
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem@claude-mem
/setup-matt-pocock-skills
```

---

## Starting a New Project

```bash
bash scripts/new-project.sh my-new-project
cd ../my-new-project
ccr code                        # start Claude Code with model routing
/grill-with-docs                # builds CONTEXT.md + ADRs for this project
```

---

## How the Three Frameworks Layer

| Framework | Role | When It Activates |
|---|---|---|
| **Superpowers** | Session workflow orchestration | Automatic at session start |
| **mattpocock/skills** | Engineering commands | You invoke (`/grill-with-docs`, `/tdd`, etc.) |
| **karpathy-guidelines** | Behavioral guardrails | Passive — always in CLAUDE.md |

They don't conflict. Karpathy = *how Claude behaves*, mattpocock = *commands you invoke*, Superpowers = *session structure*.

---

## Token Reduction Stack

| Tool | Type | Savings | Status |
|---|---|---|---|
| `MAX_THINKING_TOKENS=8000` | env var | 20–40% on simple tasks | ✅ Auto via setup.sh |
| context% statusline | built-in | Prevents blind auto-compaction | ✅ Auto via settings.json |
| `token-savior` MCP | MCP server | 89–99% on symbol reads | ✅ Auto via setup.sh |
| `claude-code-router` | proxy | 3–5x on routed turns | ✅ Auto via setup.sh |
| `bash-filter.sh` hook | hook | 40–60% on noisy bash | ✅ Auto via settings.json |
| `drona23` rules in CLAUDE.md | behavior | 4–12% output reduction | ✅ In CLAUDE.md |
| Haiku researcher agent | subagent | 40–70% on read tasks | ✅ In .claude/agents/ |
| `claude-mem` plugin | plugin | Cross-session savings | 🔧 Manual install |
| `ooples/token-optimizer-mcp` | MCP | 20–70% on repeat reads | 🔧 Optional |
| `rtk` bash filter | binary | 60–90% on log dumps | 🔧 Optional |

---

## Daily Workflow

```
ccr code                      # Start (routes cheap tasks to Haiku automatically)
/grill-with-docs              # Session start: confirm domain model
                              # Superpowers: brainstorm → spec → plan → execute
/compact at 60% context       # bash scripts/compact-hint.sh → copy output
Use the researcher agent      # "Use the researcher agent to find all callers of X"
/improve-codebase-architecture  # Weekly: architecture health check
```

---

## Domain Rules (Never Change)

| Index | Value |
|---|---|
| NIFTY lot | 50 |
| BANKNIFTY lot | 15 |
| FINNIFTY lot | 40 |
| Market hours | 09:15–15:30 IST |
| NIFTY expiry | Thursday weekly |
| BANKNIFTY expiry | Last Thursday monthly |
| FINNIFTY expiry | Tuesday weekly |
| Primary broker | Zerodha Kite |
| Secondary broker | Dhan HQ (stub) |
| Data source | NSE bhavcopy + Kite API |

---

## Token Tool References

| Tool | GitHub | Install |
|---|---|---|
| token-savior | [Mibayy/token-savior](https://github.com/Mibayy/token-savior) | `pip install token-savior` |
| drona23 rules | [drona23/claude-token-efficient](https://github.com/drona23/claude-token-efficient) | In CLAUDE.md |
| claude-code-router | [musistudio/claude-code-router](https://github.com/musistudio/claude-code-router) | `npm install -g @musistudio/claude-code-router` |
| claude-mem | [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | Plugin install |
| ooples MCP | [ooples/token-optimizer-mcp](https://github.com/ooples/token-optimizer-mcp) | Optional |
| rtk | [rtk-ai/rtk](https://github.com/rtk-ai/rtk) | Optional |

## Workflow References

| Tool | GitHub |
|---|---|
| Superpowers | [obra/superpowers](https://github.com/obra/superpowers) |
| mattpocock skills | [mattpocock/skills](https://github.com/mattpocock/skills) |
| karpathy-guidelines | [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) |
