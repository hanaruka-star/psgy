# Git Workflow Convention — ParkingLink

## Branch naming

| Pattern | Example |
|---------|---------|
| `feature/<topic>` | `feature/production-readiness` |
| `fix/<issue>` | `fix/watchlist-badge` |
| `docs/<topic>` | `docs/test-plan` |

## Commit message format

```
type: short description (CPxx)
```

Optional body (blank line after subject):

```
feat: add watchlist FCM notifications (CP29)

- Cloud Function on parking_lots create
- Foreground/background/deep-link handling
- Settings toggle for potential-lot alerts
```

### Types

| Type | When to use |
|------|-------------|
| `feat` | New user-facing feature or checkpoint deliverable |
| `refactor` | Code structure change, no behavior change |
| `perf` | Performance improvement |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `test` | Tests only |
| `chore` | Tooling, deps, CI (no product code) |
| `security` | Rules, auth, secrets handling |

### Checkpoint rule

**After every checkpoint (CP), commit immediately** — do not batch multiple CPs into one session without commits.

1. Finish CP scope  
2. Run `flutter analyze` (+ `flutter test` if applicable)  
3. `git add` relevant files  
4. Commit with `(CPxx)` in subject  
5. Push branch if collaborating  

## Workflow per checkpoint

```bash
git checkout -b feature/my-cp
# ... implement CP ...
flutter analyze && flutter test
git add -A
git commit -m "$(cat <<'EOF'
feat: description of checkpoint (CPxx)

EOF
)"
git push -u origin feature/my-cp
gh pr create --title "feat: ... (CPxx)" --body "..."
```

## Pull requests

- One CP per PR when possible; larger epics may span CP19–CP22 in one PR with **multiple commits** preserved.
- PR title mirrors latest commit or epic: `feat: production readiness (CP19–CP29)`.
- Require green `flutter analyze` before merge.

## Files to never commit

- `android/key.properties`, `*.jks`, `*.keystore`
- `android/build/`
- `.env`, credentials, API keys
- Local-only `project_structure.txt` unless team agrees

## Current epic branch

`feature/production-readiness` — CP19 through CP30 (UI polish → watchlist/FCM → test plan).
