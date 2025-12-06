---
description: Generate a commit message based on staged changes
---

Analyze the current git changes and generate a commit message.

Here are the staged changes:
!`git diff --cached`

Here are the unstaged changes:
!`git diff`

Here is the git status:
!`git status`

Based on the changes above, generate a concise and descriptive commit message following conventional commit format (e.g., feat:, fix:, refactor:, docs:, chore:).

The commit message should:
1. Have a clear, concise subject line (max 50 chars)
2. Explain the "why" not just the "what"
3. Use imperative mood ("add" not "added")

Output only the git commit command ready to run, like:
```
git commit -m "type: subject line"
```

If changes need more context, use multi-line format:
```
git commit -m "type: subject line" -m "longer description if needed"
```
