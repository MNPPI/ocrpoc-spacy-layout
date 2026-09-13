#!/usr/bin/env bash
# Idempotent Cloud Agent bootstrap for ocrpoc-spacy-layout (Python / uv).
# Matches MNPPI public-quality Python CI:
#   uv sync --extra dev --frozen --no-default-groups
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${repo_root}"

# Find a previously installed uv on later runs before deciding to bootstrap.
export PATH="${HOME}/.local/bin:${PATH}"

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="${HOME}/.local/bin:${PATH}"
fi

if [[ ! -f "${repo_root}/uv.lock" ]]; then
  echo "error: uv.lock is missing; Cloud/CI bootstrap requires the lockfile." >&2
  exit 1
fi

echo "Using uv $(uv --version)"

# --extra dev: pytest, black, flake8, bandit, mypy (not default extras)
# --frozen: honor uv.lock; do not rewrite it during bootstrap
# --no-default-groups: same as CI; this project uses extras, not PEP 735 groups
# Do not --all-extras: macos extra installs pyobjc and fails on Linux.
# Do not download spaCy/Docling models here. PDFProcessor uses spacy.blank("en");
# unit tests mock spaCyLayout. First live process_pdf() may fetch Docling weights.
uv sync --extra dev --frozen --no-default-groups

echo "Cloud Agent bootstrap complete."
