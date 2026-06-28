# CONTEXT.md
# Shared domain language for this project.
# Generated/maintained via /grill-with-docs at session start.
# Claude reads this every session → uses correct terminology → fewer wasted tokens.

## Project
- **Name**: <fill in>
- **Purpose**: <one sentence>
- **Primary module**: <entry point file>

## Domain Glossary
<!-- Fill via /grill-with-docs. Example entries below. -->
<!--
- **ZCT** : Zero Compression Threshold — a coil/contraction setup in nifty_quant_lab
- **Grade A/B/C+** : Backtest quality tiers. C+ (VOL_CONTRACTION) has strongest edge.
- **Regime** : Market volatility regime — LOW / MEDIUM / HIGH, derived from rvol_20d
- **Max Pain** : Strike with maximum OI-weighted loss for option sellers at expiry
- **PCR** : Put-Call Ratio — OI-weighted, used as contrarian sentiment signal
- **MP Magnet** : Max Pain gravitational pull model, scores 0–100 (A+/A/B/C grades)
- **Smart Money** : FII/DII institutional flow signal
- **Absorption** : Volume pattern where price holds despite high sell volume
- **Walk-forward** : Backtest methodology: train on N sessions, test on next M sessions
-->

## Key Module Boundaries
<!-- Which file owns what. Claude must not cross these without asking. -->
<!--
- volatility.py      → 5 estimators (rvol_20d, rvol_60d, ewma_vol, parkinson_vol, gk_vol) + regime classification
- technicals.py      → Bollinger Bands, RSI (Wilder SMMA), ATR, MACD
- zct_volume.py      → Rupee-denominated liquidity gate, volume classifier, absorption detector
- zct_engine.py      → ZCT Breakout signal engine
- zct_scanner.py     → Full NSE universe scanner (~2,081 stocks)
- zct_backtest.py    → Walk-forward backtester (20/60 session windows)
- market-alert.mjs   → Alert pipeline with S10 signal engine + 3-gate volume filter
- mpMagnetSignal.js  → Max Pain Magnet scoring system
-->

## Architecture Decisions (ADRs)
<!-- See docs/ADRs/ for full records. Summary here. -->
<!--
- ADR-001: NSE proxy via Node.js + tough-cookie (NSE blocks direct API calls)
- ADR-002: Zerodha Kite as primary, Dhan HQ as secondary stub (not live)
- ADR-003: Walk-forward windows: 20-session (short) and 60-session (long)
- ADR-004: Grade C+ (VOL_CONTRACTION) selected as primary strategy after backtest analysis
-->

## Constraints
- <fill in any hard constraints: "never write to /config without confirmation", etc.>
