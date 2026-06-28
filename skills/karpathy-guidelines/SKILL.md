---
name: karpathy-guidelines
description: >
  Activates when the agent is about to start a coding task.
  Enforces the 4 Karpathy principles: Think Before Coding, Simplicity First,
  Surgical Changes, Goal-Driven Execution.
triggers:
  - before_code
  - on_task_start
---

# Karpathy Guidelines

Derived from Andrej Karpathy's observations on LLM coding pitfalls.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

- State assumptions explicitly. If uncertain → ASK, don't guess.
- When ambiguity exists, present multiple interpretations before picking one.
- Push back when a simpler approach exists.
- Stop and name what's unclear rather than charging forward.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "future-proofing" or "configurability" that wasn't requested.
- No error handling for scenarios that cannot happen.
- The test: would a senior engineer call this overcomplicated? If yes → simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

- Do NOT "improve" adjacent code, comments, or formatting.
- Do NOT refactor things that aren't broken.
- Match existing style even if you'd do it differently.
- If you notice unrelated dead code → MENTION it, don't delete it.
- When your changes create orphaned imports/vars → remove ONLY those.
- The test: every changed line must trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform imperative requests into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

**Karpathy's key insight:** Don't tell the AI what to do — give it success criteria
and watch it go. LLMs are exceptionally good at looping until they meet specific goals.
