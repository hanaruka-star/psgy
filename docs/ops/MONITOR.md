# PL-Monitor Operations

## Overview

PL-Monitor is a Flutter Web dashboard used for ecosystem monitoring and presentation.

- URL: `http://localhost:8080`
- Runtime manager: PM2
- PM2 process: `id:5` / `parkinglink-monitor`

## Run / Restart

```bash
pm2 status
pm2 logs parkinglink-monitor --lines 200
pm2 restart parkinglink-monitor
pm2 stop parkinglink-monitor
pm2 start parkinglink-monitor
```

## Health Verification

1. Confirm PM2 process is `online`.
2. Open `http://localhost:8080`.
3. Verify map/data widgets load without stale placeholders.

## Feature Usage

### Filter

- Use filter panel to narrow by area, lot type, and status.
- Validate that filtered results update map/list consistently.

### Admin Panel

- Use admin controls for operational diagnostics and quick checks.
- Limit access to trusted operators only.

### Presentation Mode

- Use during demos or command-center display.
- Ensure filter state is set before entering presentation mode.

## Update Procedure

Use the update script:

```bash
~/update_monitor.sh
```

Suggested post-update checks:

1. `pm2 status` confirms process is online.
2. Dashboard loads at `http://localhost:8080`.
3. Basic filter interaction still works.
