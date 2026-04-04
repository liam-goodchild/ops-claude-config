---
name: commit-and-push
description: Stage, commit, and push changes to origin
disable-model-invocation: true
---

You have EXPLICIT authorisation to stage, commit, and push.

1. Run `git branch --show-current`. If on `main` or `master`, STOP — tell the user to switch to a feature branch.

2. Run `git status` and `git diff`. If there are no changes, STOP — tell the user there is nothing to commit. Flag any files that should not be in version control (secrets, .env, credentials, binaries) and ask before proceeding.

3. If ≤3 changed files, propose a single commit with a one-line message. If >3, group files into logical commits and propose a message for each. Wait for user confirmation.

4. For each agreed group: stage only those files with `git add <files>`, then commit. Messages: short sentence, no semantic prefixes, no trailing period, under 72 characters. Use HEREDOC format.

5. Run `git push origin HEAD`. If no upstream, use `git push -u origin $(git branch --show-current)`. Report success or failure.
