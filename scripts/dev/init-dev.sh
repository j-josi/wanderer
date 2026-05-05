# LAYER: Project Bootstrap
# PURPOSE: Creates a fully working local development state from a fresh repository clone
# EXECUTION: after fresh clone, clean checkout, or full reset
# FREQUENCY: rarely (initial setup or reset)

#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

cd "$ROOT_DIR/web"
npm ci
npm run build

cd "$ROOT_DIR/docs"
npm ci
npm run build

cd "$ROOT_DIR/db"
go mod tidy && go build