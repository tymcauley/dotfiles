#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ -f cfg.mk ]]; then
    echo "cfg.mk already exists, refusing to overwrite" >&2
    exit 1
fi

case "$(uname -s)" in
    Darwin) OS=macos ;;
    Linux)  OS=linux ;;
    *)      echo "unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

cat config/cfg.common.mk "config/cfg.$OS.mk" > cfg.mk
echo "wrote cfg.mk, edit to taste, then run 'make'"
