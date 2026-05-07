---
name: format-markdown
description: Standardize Markdown files for clear structure, readable formatting, and correct English grammar. Use when Codex needs to clean up Obsidian notes, voice-note captures, fleeting thoughts, brain dumps, rough drafts, or any Markdown content while preserving the original meaning, YAML frontmatter, wikilinks, tags, embeds, tasks, note-taking intent, filename-matched H1 headings, and punctuation standards.
---

# Format Markdown

Clean Markdown notes so they are easy to read, grammatically correct, and useful in an Obsidian digital brain. Edit the target Markdown file directly unless the user asks for a preview.

## Workflow

1. Read the whole note before editing.
2. Preserve the author's intent, facts, tone, and uncertainty. Do not add new claims.
3. Preserve Obsidian-specific syntax exactly where possible:
   - YAML frontmatter keys and values
   - `[[wikilinks]]`, `[[links|aliases]]`, `#tags`, `![[embeds]]`
   - task checkboxes (`- [ ]`, `- [x]`), callouts (`> [!note]`), block references, and code fences
4. Improve grammar, punctuation, spelling, and sentence flow.
5. Structure the note with clear headings, short paragraphs, and bullet lists where they improve legibility.
6. Ensure the single H1 heading matches the Markdown filename exactly, excluding the `.md` extension, with every word capitalized.
7. Remove filler from voice capture, such as repeated words, false starts, and transcription artifacts, without removing meaningful nuance.
8. Keep personal or reflective notes in the user's voice; make them clearer, not corporate.
9. Save the formatted Markdown.

## Formatting Standard

- Use exactly one H1 heading.
- Make the H1 text match the file name exactly, excluding the `.md` extension.
- Capitalize every word in the H1 heading, including short words such as "a", "an", "the", "of", "to", and "and".
- Use sentence case for H2 and lower headings unless a proper noun or acronym requires different capitalization.
- Keep paragraphs short: usually 1-3 sentences.
- Prefer bullets for captured thoughts, decisions, actions, examples, and lists.
- Use numbered lists only for ordered steps or priority.
- Normalize spacing:
  - One blank line between headings, paragraphs, lists, and callouts.
  - No trailing whitespace.
  - No excessive blank lines.
- Use fenced code blocks for commands, snippets, logs, or structured examples.
- Do not use em dashes (`—`). Replace them with commas, colons, parentheses, or separate sentences.
- Use British English by default unless the note already clearly uses another dialect.

## Obsidian Note Handling

If the note is a fleeting thought or voice note, prefer this structure when it fits naturally:

```markdown
# Clear Title Matching File Name

Brief cleaned summary or opening thought.

## Key points

- ...

## Actions

- [ ] ...

## Related

- [[Existing link]]
```

Do not force every note into this template. For journal-style or reflective notes, keep a natural narrative structure.

## Safety Rules

- Do not change dates, names, commands, URLs, file paths, quoted text, or technical identifiers unless clearly correcting punctuation around them.
- Do not use em dashes in edited notes, including headings.
- Do not delete YAML frontmatter or metadata fields.
- Do not invent links, tags, action items, conclusions, or context.
- If a sentence is ambiguous, lightly copy-edit it rather than choosing a new meaning.
- If content appears sensitive, keep it intact and avoid unnecessary restatement in the final response.

## Completion Response

After editing, respond briefly with:

- The file path changed.
- A short summary of formatting improvements.
- Any ambiguity that was intentionally left unchanged.
