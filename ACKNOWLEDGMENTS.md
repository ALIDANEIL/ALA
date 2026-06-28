# Acknowledgments

ALA stands on the shoulders of a lot of open-source work. This file
credits the projects whose code, assets, or designs are included in or
adapted by this repository, and notes their licenses.

If you believe something here is mis-attributed or missing, please open an
issue — it will be corrected promptly.

---

## Adapted / borrowed code

Portions of this project were adapted from other open-source repositories.
Their original authors retain copyright over the adapted portions, under the
licenses noted below.

The sources below are under permissive licenses (MIT / Apache-2.0), which permit
this use as long as their original copyright and license notices are preserved.
The full license texts are kept in [`licenses/`](licenses/).

- **[opencode](https://github.com/anomalyco/opencode)** — open-source AI coding
  agent (originally [opencode-ai/opencode](https://github.com/opencode-ai/opencode),
  archived Sep 2025; now maintained at `anomalyco/opencode`). Copyright © the
  opencode authors. **MIT License.** Adapted for agent-loop / tool-execution
  patterns and UI concepts.
- **[llmfit](https://github.com/AlexsJones/llmfit)** by **Alex Jones** — the
  engine behind the Cookbook's model download / serve / "What Fits?" feature.
  Copyright © Alex Jones. **MIT License.** Adapted in `services/hwfit/`
  (hardware detection, quant-aware fit scoring, model catalog),
  `routes/cookbook_*.py`, `routes/hwfit_routes.py`, `static/js/cookbook*.js`,
  and `scripts/ala-cookbook`.
- **[Tongyi DeepResearch](https://github.com/Alibaba-NLP/DeepResearch)** by
  **Alibaba-NLP / Tongyi Lab** — the multi-step deep-research agent pipeline.
  Copyright © Alibaba-NLP / Tongyi Lab. **Apache-2.0.** Adapted for ALA's
  Deep Research feature (`services/research/`, `src/research_handler.py`,
  `routes/research_routes.py`, `services/search/`). Full text in
  [`licenses/DeepResearch-Apache-2.0.txt`](licenses/DeepResearch-Apache-2.0.txt).

---

## Bundled via Docker Compose

These services are pulled as images by the project's `docker-compose.yml`
and run alongside ALA on `docker compose up`. They are not modified —
just composed.

| Service | Image | Purpose | License |
|---|---|---|---|
| [SearXNG](https://github.com/searxng/searxng) | `searxng/searxng:2026.5.31-7159b8aed` (pinned tag; see compose) | Default metasearch backend | AGPL-3.0 |
| [ChromaDB](https://github.com/chroma-core/chroma) | `chromadb/chroma:latest` | Vector store for memory / RAG | Apache-2.0 |
| [ntfy](https://github.com/binwiederhier/ntfy) | `binwiederhier/ntfy` | Push notifications (self-hosted reminders) | Apache-2.0 / GPL-2.0 |

## Bundled front-end libraries

Vendored in `static/lib/` and served directly:

| Library | Purpose | License |
|---|---|---|
| [highlight.js](https://github.com/highlightjs/highlight.js) v11.9.0 | Code syntax highlighting | BSD-3-Clause |
