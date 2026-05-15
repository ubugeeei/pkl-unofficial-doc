---
title: Compatibility
section: Contributing
description: How this documentation relates to official Pkl docs, examples, and release notes.
order: 210
---

# Compatibility

This site is an unofficial Pkl language reference. It should be honest about the
compatibility boundary: Pkl is the subject, and official Apple Pkl documentation,
release notes, and CLI behavior remain the source of truth.

## Sources of Truth

| Source | Role |
| --- | --- |
| Official Pkl docs | Primary language and tool documentation |
| Pkl CLI behavior | Practical baseline for Learn examples |
| Release notes | Version-specific changes and migration notes |
| Upstream examples | Source material for compact examples |
| This site | Reorganized learning path and commentary |

## Compatibility Checks

Use official sources in three ways:

- confirm that examples match current CLI behavior
- cite release-specific behavior when it matters
- avoid inventing semantics that are not present upstream

## Documentation Rule

Each page should distinguish:

- **Pkl model**: what the language concept means
- **Official source**: where upstream behavior is documented or demonstrated
- **Editorial note**: why this site groups or explains the topic differently

That split is the main reason this site should be easier to navigate than the
official docs while still respecting upstream behavior.
