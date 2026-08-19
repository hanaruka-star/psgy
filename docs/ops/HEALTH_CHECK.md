# Ecosystem Health Checklist

## Daily Health Check

- [ ] PM2 id:5 monitor -> online
- [ ] PM2 id:7 survey-bot -> online
- [ ] localhost:8080 accessible
- [ ] Telegram bot respond /start
- [ ] Last pipeline sync < 30s
- [ ] Firestore read/write ok
- [ ] Firebase Storage accessible

## Pipeline Lag Check

- [ ] Send test survey via Telegram
- [ ] Check Google Sheets (< 5s)
- [ ] Check Firestore (< 15s)
- [ ] Check Monitor map (< 30s)

## Cloud Function Check

- [ ] onParkingLotCreated -> active
- [ ] Last execution -> success
- [ ] No error logs in 24h

## App Health Check

- [ ] User App -> map loads
- [ ] Staff App -> login works
- [ ] Realtime sync < 2s
