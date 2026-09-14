# Agent instructions

`ocrpoc-spacy-layout` is a **small Python proof of concept**. It uses
`spacy-layout` (Docling under the hood) to turn a local PDF path into a
structured dict: full text, page layout, labeled spans, tables, and
markdown. The only product code is `src/pdf_processor.py`, covered by
`tests/test_pdf_processor.py`.

This is not a production OCR platform, service, or document pipeline.

## When not to use this repository

Do **not** treat this repo as:

- A production OCR / document-ingestion path (no queue, API, auth, or SLA)
- A place to add Cloudflare Workers, Pages, Durable Objects, or any other
  hosted deploy unless this repo already owns that path (it does not)
- A reason to add Docker or `.devcontainer` as the default Cloud Agent
  sandbox (see Cloud section)
- A spaCy training or pretrained-NER project (`PDFProcessor` uses
  `spacy.blank("en")`, not `en_core_web_*`)

Use this repo to understand `spaCyLayout` output, extend the local CLI
PoC, or fix tests. For real scanned-PDF operations, use whatever
production OCR path the org already runs.

## Hybrid environments

| Environment | How dependencies install | Runtime |
| --- | --- | --- |
| Mac workstation | `uv sync --extra dev --frozen --no-default-groups` | Python 3.10+ via uv |
| Cursor Cloud Agent | [`.cursor/install.sh`](.cursor/install.sh) | Same uv command |

`README.md` and `CONTRIBUTING.md` still show `python -m venv` +
`pip install -r requirements.txt` / `pip install -e .[dev]`. That pip
path is human-facing and **legacy for agents**. Cloud and GitHub Actions
use **uv + `pyproject.toml` + `uv.lock`**.

`requirements.txt` is a flattened pip mirror of most runtime deps plus
some (not all) dev tools. It can drift from the lockfile. Do not invent
a second install story; if pip and uv disagree, **uv.lock wins**.

Never `uv sync --all-extras` on Linux/Cloud: the `macos` extra pulls
`pyobjc` and fails.

No Node toolchain is required.

## Input / output contract (`PDFProcessor`)

`PDFProcessor` lives in `src/pdf_processor.py`.

**Init:** `spacy.blank("en")` + `spaCyLayout(self.nlp)`. No pretrained
spaCy pipeline is loaded.

**Input:** a filesystem path to a PDF (`process_pdf(pdf_path)`). The
`__main__` CLI downloads three public sample PDFs into `data/pdfs/`
first (IRS f1040, a W3C table example, a W3C dummy).

**Return value of `process_pdf`:** a JSON-serializable `dict`, not a raw
spaCy `Doc`. Internally a `Doc` is built; the public contract is:

| Key | Meaning |
| --- | --- |
| `filename` | `os.path.basename(pdf_path)` |
| `text` | `doc.text` — full extracted text |
| `layout` | `{ "pages": [ { page_no, width, height }, ... ] }` |
| `spans` | list from `doc.spans["layout"]` — label, text, token/char offsets, optional bbox + heading |
| `tables` | list from `doc._.tables` — offsets, optional bbox, `data` as `DataFrame.to_dict("records")` or `None` |
| `markdown` | `doc._.markdown` |

`save_results(results, output_file)` writes a JSON list of those dicts
(default CLI path: `data/processed_results.json`).

Programmatic usage (same as README):

```python
from src.pdf_processor import PDFProcessor

processor = PDFProcessor()
result = processor.process_pdf("path/to/document.pdf")
print(result["text"], result["layout"], result["tables"], result["markdown"])
processor.save_results([result], "output.json")
```

CLI (README, still valid; prefer `uv run` so the project env is used):

```bash
uv run python src/pdf_processor.py
```

That downloads samples, processes them, and writes
`data/processed_results.json`. First live parse can download Docling /
Hugging Face weights (see quirks).

## Common commands

Match CI (MNPPI `public-quality.yml` Python profile):

```bash
# Install (Cloud + local agent path)
uv sync --extra dev --frozen --no-default-groups

# Tests (pyproject already adds coverage + junit; fail-under 80)
uv run --frozen pytest

# Format / lint / types / security (same as CI)
uv run --frozen black --check --diff src tests
uv run --frozen flake8 src tests --count --max-complexity=10 --max-line-length=88 --statistics
uv run --frozen mypy
uv run --frozen bandit -r src
```

README examples `pytest` / `python src/pdf_processor.py` work after the
uv env is synced (`uv run ...` is the reliable form).

## Known quirks

- **No spaCy model download for tests.** `PDFProcessor` uses
  `spacy.blank("en")`. Tests mock `layout_processor`; do not add
  `spacy download` to Cloud install.
- **Docling / HF weights on first real PDF.** A live `process_pdf()`
  (or the CLI) can fetch large parser/OCR models. That is expected and
  slow; it is not required to run the unit suite.
- **`test_download_pdf` hits the network** (W3C dummy PDF). Needs
  egress; writes then deletes a file under `data/pdfs/`.
- **Large PDFs and memory.** Parsing is CPU/RAM heavy (torch, OpenCV,
  Docling). Do not commit multi‑MB sample PDFs. Do not batch huge
  scans in Cloud just to “try it.”
- **Stale sibling docs.** `.github/copilot-instructions.md` and
  `docs/ai_documentation.md` still mention `samples/` and older test
  commands. The code writes `data/pdfs/` and `data/processed_results.json`
  (gitignored). Prefer this file + `src/pdf_processor.py`.
- **`macos` extra** is workstation-only (Vision/CoreML). Skip on Cloud.

## Cursor Cloud specific instructions

- Bootstrap is [`.cursor/environment.json`](.cursor/environment.json)
  (`install`: `bash .cursor/install.sh`). Install-script style only:
  no snapshot IDs, no custom Dockerfile, no `start` / `terminals`
  (this PoC has no long-running service).
- `.cursor/install.sh` must stay idempotent and must match CI:
  `uv sync --extra dev --frozen --no-default-groups`. Do not run
  pytest or model downloads in `install`.
- Do not add Docker or `.devcontainer` as the default Cloud sandbox.
- After install, `uv run --frozen pytest` is the verification command.
- `data/pdfs/` and `data/processed_results.json` are gitignored; keep
  them that way. Do not commit large sample PDFs.
- Egress: unit tests need HTTPS for the W3C dummy PDF. Live CLI also
  needs IRS / W3C sample URLs plus whatever Docling/HF hosts the first
  parse hits. Do not put secrets in env files to “fix” that.
- This run’s environment is repository-backed (`source: Repository`)
  via the committed `.cursor/environment.json`. Edits belong in that
  file on a branch, not as invented dashboard snapshot IDs.

## Guardrails

- Do not put secrets, tokens, or credentials in the repo, Cloud
  `environment.json`, install scripts, logs, or chat output.
- Do not commit large sample PDFs or processed dumps (`data/pdfs/`,
  `data/processed_results.json` are ignored on purpose).
- Do not invent a Cloudflare (or other cloud) deploy for this PoC.
  `docs/deployment.md` is generic local/Docker/hyperscaler notes, not
  an owned production path.
- Do not expand this into a web app, API, or OCR platform unless the
  user explicitly asks.
- Keep changes scoped: one processor module, pytest, uv. Prefer
  documenting truth over rewriting README/CONTRIBUTING in the same PR
  unless asked.
