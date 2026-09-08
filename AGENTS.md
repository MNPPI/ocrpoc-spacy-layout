# Agent instructions

`ocrpoc-spacy-layout` converts PDFs into structured spaCy layout data. It is a
Python proof of concept.

## Hybrid environments

| Environment | How dependencies install | Runtime |
| --- | --- | --- |
| Mac workstation | `uv sync` | Python 3.10+ via uv |
| Cursor Cloud Agent | [`.cursor/install.sh`](.cursor/install.sh) | Same `uv sync` path |

No Node toolchain is required. Do not add Docker or `.devcontainer` as the
default Cloud Agent sandbox. Do not put secrets in the repo or chat output.

## Common commands

- Install: `uv sync`
- Tests: `uv run pytest`
- See `README.md` for CLI usage examples.
