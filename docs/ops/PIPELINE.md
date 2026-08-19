# Ecosystem Pipeline

## End-to-End Data Flow

```text
Telegram Survey Bot
  -> Google Sheets
    -> Apps Script onChange (~10s)
      -> Firestore
        -> Manual conversion in PL-Monitor Admin Tool
```

## Pipeline Components

### 1) Telegram -> Google Sheets

- Bot writes normalized survey payloads to Google Sheets.
- Typical delay target: under 5 seconds.

### 2) Google Sheets -> Firestore

- Apps Script `onChange` runs roughly every 10 seconds.
- Script transforms and pushes rows into Firestore collections.

### 3) Surveying -> Parking Lot conversion

- Manual process via Monitor Admin Tool
- Admin xoa `surveying_lot` (2 clicks)
- Owner tao `parking_lot` moi
- Ly do: mat do bai cao 10-20m, tranh merge sai

## Latency Targets

- Telegram -> Sheets: `< 5s`
- Sheets -> Firestore: `< 15s`
- Firestore -> Monitor visible result: `< 30s`

## Troubleshooting

## Common Issue: Telegram message received but no row in Sheets

- Check PM2 bot status/logs:
  - `pm2 status`
  - `pm2 logs parkinglink-survey-bot --lines 200`
- Verify bot credentials and sheet write permissions.

## Common Issue: Sheets row exists but Firestore not updated

- Check Apps Script trigger status and last execution result.
- Confirm `onChange` trigger is active and not paused.
- Validate script error logs and quota limits.

## Common Issue: Firestore updated but Monitor not reflecting

- Check monitor process:
  - `pm2 status`
  - `pm2 logs parkinglink-monitor --lines 200`
- Refresh monitor UI and verify filters are not hiding records.

## Common Issue: Surveying lot was removed but parking_lot not created

- Verify admin completed full 2-click remove flow in monitor.
- Confirm owner created a new `parking_lot` document after removal.
- Re-check monitor filter state to ensure the new lot is visible.
