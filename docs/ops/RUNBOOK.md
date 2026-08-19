# ParkingLink Ops Runbook

## Daily Ops Checklist

1. Check PM2 process health (`parkinglink-monitor`, `parkinglink-survey-bot`).
2. Verify monitor URL is accessible (`http://localhost:8080`).
3. Validate Telegram bot responds to `/start`.
4. Validate recent pipeline sync is within expected latency.
5. Spot-check Firestore and Storage accessibility.

## PM2 Restart Procedures

```bash
pm2 status
pm2 restart parkinglink-monitor
pm2 restart parkinglink-survey-bot
pm2 save
```

If a process is down:

```bash
pm2 start parkinglink-monitor
pm2 start parkinglink-survey-bot
```

## Log Inspection

```bash
pm2 logs parkinglink-monitor --lines 200
pm2 logs parkinglink-survey-bot --lines 200
```

For continuous watch:

```bash
pm2 logs parkinglink-monitor
pm2 logs parkinglink-survey-bot
```

## Rollback Procedure

When an update causes regressions:

1. Stop affected process.
2. Roll back code to last known stable version.
3. Re-run deployment/update script.
4. Restart PM2 process.
5. Validate health checks before closing incident.

Example commands:

```bash
pm2 stop parkinglink-monitor
pm2 stop parkinglink-survey-bot
# rollback code in respective repo/workdir
~/update_monitor.sh
~/update_bot.sh
pm2 restart parkinglink-monitor
pm2 restart parkinglink-survey-bot
pm2 status
```

## Incident Notes

- Always record timestamp, root cause, mitigation, and final verification.
- Track repeat incidents to prioritize permanent fixes.
