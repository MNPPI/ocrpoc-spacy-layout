#!/usr/bin/env bash
# Idempotent Cloud Agent bootstrap for ocrpoc-spacy-layout (Python / uv).
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${repo_root}"

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="${HOME}/.local/bin:${PATH}"
fi

echo "Using uv $(uv --version)"
uv sync
echo "Cloud Agent bootstrap complete."
