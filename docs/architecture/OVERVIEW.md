# Architecture Overview

> Auto-maintained. Update via `/grill-with-docs` or `/improve-codebase-architecture`.

## System Diagram

```
[Data Sources]          [Signal Engines]        [Output Layer]
 NSE bhavcopy    ──►   ZCT Engine        ──►   Alert Pipeline
 Kite API        ──►   S10 Signal        ──►   Telegram Bot
 India VIX       ──►   MP Magnet         ──►   OI Dashboard
 OI / PCR data   ──►   Compression Scan  ──►   Backtest Reports
```

## Module Inventory
<!-- Fill this in. Format: module | language | owns | depends on -->

| Module | Lang | Owns | Depends On |
|--------|------|------|------------|
| volatility.py | Python | 5 vol estimators + regime | pandas, numpy |
| technicals.py | Python | BB, RSI, ATR, MACD | pandas |
| zct_volume.py | Python | Liquidity gate, vol classifier | - |
| zct_engine.py | Python | ZCT breakout signals | volatility, technicals, zct_volume |
| zct_scanner.py | Python | NSE universe scan | zct_engine |
| zct_backtest.py | Python | Walk-forward backtester | zct_engine |
| market-alert.mjs | Node.js | Alert dispatch + S10 | Kite, MP Magnet |
| mpMagnetSignal.js | Node.js | Max Pain gravity model | NSE proxy |

## Key Constraints
- NSE proxy required (Node.js + tough-cookie) — NSE blocks direct API calls
- No Yahoo Finance for Indian derivatives
- Zerodha Kite = primary. Dhan HQ = secondary stub (not live)
- Signal agreement rule: S10 + Alert must agree before dispatch

## Known Technical Debt
<!-- List here, maintain via /improve-codebase-architecture -->
