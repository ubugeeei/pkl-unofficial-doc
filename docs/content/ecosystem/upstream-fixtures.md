---
title: Source Alignment
section: Contributing
description: How official Pkl docs, examples, fixtures, and release notes guide this site.
order: 205
---

# Source Alignment

This repository does not need to mirror Apple Pkl's documentation tree. It uses
official material as source evidence, then rewrites the learning path around
reader jobs.

## Source Types

| Source | Use |
| --- | --- |
| Official docs | Definitions, CLI options, language rules |
| Release notes | Version-specific behavior and migration notes |
| Examples | Reader-facing snippets and workflow shape |
| Fixtures | Exact syntax and rendering edge cases |
| CLI behavior | Final sanity check for runnable examples |

## Alignment Rules

- Do not copy the official information architecture.
- Do not present speculation as language behavior.
- Prefer small runnable examples over large excerpts.
- Link to official docs when exhaustive detail matters.
- Keep editorial commentary clearly separated from source behavior.

## Writing from Sources

Use official material to decide what must be explained, then write local docs
around this site's reader jobs:

- Learn: how to use the feature in context
- Reference: exact syntax or semantic rule
- Coverage Status: what this site still needs to explain
- Compatibility: how local wording maps to official Pkl

This keeps the site from inheriting the upstream information architecture while
still respecting upstream behavior.
