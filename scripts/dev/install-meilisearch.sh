# LAYER: Project Tool / External Service
# PURPOSE: Installs the project-specific search engine (Meilisearch v1.43.0)
# EXECUTION: only when local search service is required for development
# FREQUENCY: optional / environment-dependent

#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

MEILI_VERSION="v1.43.0"
OS="$(uname -s)"
ARCH="$(uname -m)"

get_asset_name() {
  case "$OS" in
    Darwin)
      if [ "$ARCH" = "arm64" ]; then
        echo "meilisearch-macos-apple-silicon"
      else
        echo "meilisearch-macos-amd64"
      fi
      ;;
    Linux)
      case "$ARCH" in
        x86_64)
          echo "meilisearch-linux-amd64"
          ;;
        aarch64 | arm64)
          echo "meilisearch-linux-aarch64"
          ;;
        riscv64)
          echo "meilisearch-linux-riscv64"
          ;;
        *)
          echo "unsupported"
          ;;
      esac
      ;;
    *)
      echo "unsupported"
      ;;
  esac
}

ASSET=$(get_asset_name)

if [ "$ASSET" = "unsupported" ]; then
  echo "Unsupported OS/architecture: $OS $ARCH"
  exit 1
fi

URL="https://github.com/meilisearch/meilisearch/releases/download/${MEILI_VERSION}/${ASSET}"

curl -L "$URL" -o meilisearch
chmod +x meilisearch

mv meilisearch "$ROOT_DIR/search/meilisearch"