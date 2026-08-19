# Telegram Survey Bot Operations

## Overview

Telegram Survey Bot collects surveying lot submissions from field users.

- Runtime: Node.js
- Bot project path: `~/parkinglink_bot`
- PM2 process: `id:7` / `parkinglink-survey-bot`

## Run / Restart

```bash
cd ~/parkinglink_bot
pm2 status
pm2 logs parkinglink-survey-bot --lines 200
pm2 restart parkinglink-survey-bot
pm2 stop parkinglink-survey-bot
pm2 start parkinglink-survey-bot
```

## Full Survey Flow

The expected flow is:

1. `ten` (name)
2. `dia diem` (location)
3. `loai` (lot type)
4. `gia` (price)
5. `anh` (photo)
6. `GPS`

An incomplete flow should be resumed safely and not corrupt existing records.

## Supported Commands

- `/start` — starts or resets conversation flow
- `/lich` — survey history lookup
- `/mysurveys` — list submissions by current Telegram user

## Update Procedure

Use the update script:

```bash
~/update_bot.sh
```

Suggested post-update checks:

1. `pm2 status` shows `parkinglink-survey-bot` online.
2. Bot responds to `/start`.
3. A test submission reaches pipeline targets.
