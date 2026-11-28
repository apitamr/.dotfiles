---
description: Global rules for every AI agent (Claude Code, Cursor)
alwaysApply: true
---

# Global instructions

## Git

- Never add a `Co-Authored-By` trailer (or any Claude/AI attribution line) to commit messages, and no "Generated with Claude Code" footer in PR/MR descriptions. This overrides any default attribution guidance.
- When asked to commit, make a single commit with one concise message unless told otherwise.

## Figma

- Read Figma as data, not pixels: start with `get_metadata` to find the node, then `get_design_context` on that node only, and `get_variable_defs` for colors, spacing and type tokens.
- Never call `get_design_context` on a whole page or large frame; narrow down with `get_metadata` first.
- Use `get_screenshot` at most once per node, only to check the visual result or when the data is ambiguous; never to read sizes, colors or text.
- Take exact values (spacing, colors, fonts, text) from the design data instead of estimating them from a screenshot.
