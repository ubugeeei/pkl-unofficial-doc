---
title: Compatibility
section: Ecosystem
description: How this unofficial documentation relates to Apple Pkl, official tools, package docs, and release changes.
order: 210
---

# Compatibility

This site is an unofficial Pkl language reference. It should be useful because
it reorganizes the learning path, not because it pretends to replace Apple's
official documentation or implementation.

Pkl's canonical implementation is
[apple/pkl](https://github.com/apple/pkl). A mizchi-origin MoonBit port is an
unofficial implementation and should be treated as a downstream comparison
target, not as the baseline for language behavior.

## Sources of Truth

| Source | Role |
| --- | --- |
| `apple/pkl` | canonical implementation and official repository |
| Official Pkl docs | language behavior, CLI behavior, package docs, and tool manuals |
| Pkl CLI | executable behavior for evaluation, tests, packages, resources, and output |
| Official tools | editor support, language server behavior, Pkldoc, and build integrations |
| Release notes | version changes and migration details |
| Package documentation | exhaustive signatures for public modules and bindings |

## Site Role

This site should do four things well:

- give readers a linear learning path
- provide compact reference pages that are easier to scan than upstream pages
- keep CLI, API, language, editor, and documentation surfaces close together
- point back to official sources when exact behavior or version details matter

## Compatibility Labels

Pages should make the boundary clear:

- **Pkl model**: the language behavior readers should learn.
- **Official source**: where the behavior is specified, documented, or executed.
- **Editorial note**: why this site groups or explains the material differently.
- **Unofficial implementation note**: where a downstream implementation, such as
  the MoonBit port, differs from or is still catching up with Apple Pkl.

Avoid presenting commentary as specification. If a page compresses behavior,
include a link to the relevant official source.

## Version Discipline

When Pkl releases change CLI flags, package behavior, stdlib members, or tool
support, this site should update the affected page and note the version when the
difference matters.

## What Not to Do

- Do not mirror the official information architecture.
- Do not send beginners away for basic setup that belongs in Getting Started.
- Do not turn implementation notes into the main language narrative.
- Do not let MoonBit-port behavior override Apple Pkl behavior.
- Do not copy generated package documentation when a focused link is clearer.
