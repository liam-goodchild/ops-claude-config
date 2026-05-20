---
name: obsidian-vault
description: "Unified Obsidian vault workflow for Liam's Second Brain. Use for inbox triage, processing '00 - Inbox/' notes, source ingestion, Markdown cleanup, note formatting, MOC refreshes, vault consolidation, dead wikilinks, orphan notes, duplicate notes, tag vocabulary cleanup, YAML frontmatter normalization, and applying the LLM-maintained wiki workflow documented in the vault."
---

Use this as the single Obsidian workflow skill. Keep this skill lightweight: the source of truth for vault-specific rules is the vault file `99 - Meta/AI Formatting/LLM Vault Workflow.md`, with controlled tags in `99 - Meta/AI Formatting/tag-vocabulary.md`.

## Required context

Before editing vault notes, read these files when they exist:

1. `99 - Meta/AI Formatting/LLM Vault Workflow.md`
2. `99 - Meta/AI Formatting/tag-vocabulary.md`
3. Relevant templates under `99 - Meta/Templates/`

Do not duplicate those rules in the skill. Pinned inbox notes tagged `pinned` are intentionally retained in `00 - Inbox/` and must not be moved unless explicitly requested. Follow the vault workflow file for YAML frontmatter, Markdown structure, MOC conventions, source handling, status values, confidence values, and report locations.

## Helper commands

Use the bundled helper for deterministic inspection.

Inspect the vault:

```powershell
python "<skill-dir>\scripts\obsidian-vault-helper.py" inspect --vault "<vault-path>" --json
```

Inspect a single Markdown file before formatting:

```powershell
python "<skill-dir>\scripts\obsidian-vault-helper.py" inspect-file --file "<note.md>" --json
```

Omit `--vault` only if the default `~/Documents/Second Brain` exists.

## Route the task

- Inbox triage or source ingestion: inspect the vault, read inbox files, preserve source metadata, integrate durable knowledge into `02 - Notes/`, update relevant MOCs, and write `triage-report-YYYY-MM-DD.md`.
- Markdown formatting: inspect the target file, preserve YAML frontmatter, wikilinks, tags, embeds, tasks, code fences, dates, paths, and quoted text. Improve clarity without adding new claims, links, tags, action items, conclusions, or frontmatter unless explicitly asked.
- Vault consolidation: inspect the vault, use dead links/orphans/tags/frontmatter issues as the factual baseline, refresh MOCs, and write `vault-consolidation-YYYY-MM-DD.report.md` plus an `.actions.md` file if changes are made.
- MOC refresh: preserve Liam's existing organisation where possible, add notes under the most specific relevant section, and avoid creating new MOCs unless the report explains why.

## Default full-vault workflow

When Liam invokes this skill by name, asks to process the inbox, or asks for the full vault workflow without a narrower scope, do this exact sequence:

1. Read the required context files and inspect the vault with the helper.
2. Read every Markdown note in `00 - Inbox/` and the existing MOCs in `01 - MOCs/`.
3. Format inbox notes first.
   - Format pinned inbox notes in place.
   - Ensure pinned inbox notes include both `inbox` and `pinned` tags.
   - Preserve pinned inbox notes in `00 - Inbox/`.
4. Triage unpinned inbox notes.
   - Create durable notes in `02 - Notes/` for reusable knowledge.
   - Update an existing note when the inbox item is a small addition to an existing topic.
   - Preserve original unpinned inbox source files by moving them to `99 - Meta/AI Formatting/Processed Inbox Sources/YYYY-MM-DD/`; do not delete them.
   - Update new notes' `source` fields to point to the preserved processed source path when relevant.
5. Refresh relevant MOCs.
   - Add new durable notes under the most specific existing MOC sections.
   - Fix obvious MOC wikilink mismatches when the intended target clearly exists.
   - Preserve Liam's existing MOC structure.
6. Write `99 - Meta/AI Formatting/triage-report-YYYY-MM-DD.md`.
7. Run a final helper inspection.
8. Perform consolidation from the final inspection baseline.
   - Summarise remaining dead wikilinks, orphan notes, pinned inbox notes, frontmatter issues, and risk flags.
   - Make only safe non-destructive fixes, such as obvious MOC link target corrections.
   - Do not move pinned notes, rewrite archived journals at scale, remove image embeds, merge notes, or delete anything without explicit approval.
9. Write both:
   - `99 - Meta/AI Formatting/vault-consolidation-YYYY-MM-DD.report.md`
   - `99 - Meta/AI Formatting/vault-consolidation-YYYY-MM-DD.actions.md`
10. Finish with a concise summary of created notes, updated notes, refreshed MOCs, report paths, and remaining validation counts.

## Safety

- Do not delete, merge, archive, discard, or destructively split notes without explicit approval.
- Do not invent tags. Use `tag-vocabulary.md`; propose new tags under `## Pending Approval`.
- Preserve source/provenance fields from clippings where useful.
- Prefer new notes or source notes when uncertain rather than merging away information.
- Report ambiguity left unchanged.
