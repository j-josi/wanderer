# LAYER: Development Runtime
# PURPOSE: Starts full local development stack (web, db, search)
# EXECUTION: during active development sessions
# FREQUENCY: frequent (daily usage)

#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

cleanup_done=0

cleanup() {
    if [ "$cleanup_done" -eq 1 ]; then
        return
    fi
    cleanup_done=1
    echo -e "\ndev environment stopped"
    kill 0
}

trap cleanup SIGINT SIGTERM EXIT

# ---------------- Environment ----------------

export ORIGIN=http://localhost:3000
export MEILI_URL=http://127.0.0.1:7700
export MEILI_MASTER_KEY=vODkljPcfFANYNepCHyDyGjzAMPcdHnrb6X5KyXQPWo
export PUBLIC_POCKETBASE_URL=http://127.0.0.1:8090
export PUBLIC_VALHALLA_URL=https://valhalla1.openstreetmap.de
export POCKETBASE_ENCRYPTION_KEY=fde406459dc1f6ca6f348e1f44a9a2af
export MEILI_NO_ANALYTICS=true
export BODY_SIZE_LIMIT=Infinity
export PUBLIC_DISABLE_SIGNUP=false

# ---------------- Services ----------------

(cd "$ROOT_DIR/search" && ./meilisearch --master-key "$MEILI_MASTER_KEY") &
(cd "$ROOT_DIR/db" && ./pocketbase serve) &
(cd "$ROOT_DIR/web" && npm run dev -- --port 3000 --host) 2>&1 | sed 's/^/[web] /' &

wait