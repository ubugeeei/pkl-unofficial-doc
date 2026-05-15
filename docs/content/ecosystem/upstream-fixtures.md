---
title: Source Alignment
section: Ecosystem
description: How this site uses official docs, examples, package docs, release notes, and fixtures.
order: 205
---

# Source Alignment

This site should be opinionated about structure while staying humble about
truth. Apple Pkl, the official CLI, official package docs, and release notes are
the upstream sources. This site reorganizes and explains them.

Here, Apple Pkl means the
[apple/pkl](https://github.com/apple/pkl) repository and the tools it publishes.
The mizchi-origin MoonBit port is a useful unofficial comparison target, but it
does not define the language.

## Source Types

| Source | Use |
| --- | --- |
| Official language reference | exact language behavior and terminology |
| Official CLI docs | command names, flags, output behavior, and install paths |
| Official tools docs | editor, Language Server, Pkldoc, and build integrations |
| Package docs | exhaustive signatures for stdlib and bindings |
| Release notes | behavior changes across versions |
| Examples and fixtures | runnable confirmation that prose matches behavior |
| MoonBit port notes | downstream comparison notes only |

## How to Write From Sources

Do not copy upstream page structure. Use sources to decide what must be true,
then write around this site's reader jobs:

- Learn: how to use the feature
- Reference: exact syntax, command, or semantic rule
- Ecosystem: how the feature fits tooling, docs, editors, or integrations
- Coverage Status: what this site still has not explained well

## Examples and Fixtures

Examples should either run with the current CLI or clearly say that they are
conceptual. Prefer short examples that isolate one idea.

```bash
pkl eval config.pkl
pkl test tests/*.pkl
```

When behavior is subtle, keep a fixture or test near the docs source so future
edits do not silently change the lesson.

## Linking Policy

Link to official sources when:

- command flags or installation details can change
- package signatures are exhaustive
- language behavior depends on a precise version
- an editor or binding has its own release cadence
- MoonBit port behavior differs from apple/pkl behavior

Keep the local prose focused on orientation, tradeoffs, and learning order.
