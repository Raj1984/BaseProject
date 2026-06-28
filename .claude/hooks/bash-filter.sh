#!/usr/bin/env bash
# .claude/hooks/bash-filter.sh
# Strips ANSI color codes and dedupes repeated warning lines before Claude reads
# bash tool output. Cuts 40–60% of noise from pip install, npm install,
# NSE data fetch scripts, and terraform/pytest output.
#
# Wired via .claude/settings.json → hooks.PostToolUse → Bash matcher.

cat \
  | sed 's/\x1b\[[0-9;]*[mGKHF]//g' \
  | sed 's/\r/\n/g' \
  | grep -v '^[[:space:]]*$' \
  | awk '
      /^(WARNING|DeprecationWarning|UserWarning|FutureWarning)/ { warnings[$0]++; next }
      { print }
      END {
        if (length(warnings) > 0) {
          print "--- [bash-filter: " length(warnings) " unique warnings suppressed] ---"
          for (w in warnings) {
            if (warnings[w] > 1) printf "[x%d] %s\n", warnings[w], w
            else print w
          }
        }
      }
    ' \
  | head -500
