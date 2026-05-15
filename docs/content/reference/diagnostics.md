---
title: Diagnostics Reference
section: Reference
description: Diagnostic stages, failure shapes, and editor-facing debugging workflow.
order: 118
---

# Diagnostics Reference

Diagnostics are grouped by stage. The same source file can pass one stage and
fail the next.

## Parse Diagnostics

Parse diagnostics mean the source cannot be read as Pkl syntax.

Typical causes:

- malformed object bodies
- missing delimiters
- invalid string or interpolation shapes

Parser diagnostics are closest to syntax and should not require import or
stdlib context.

## Typecheck Diagnostics

Typecheck diagnostics mean the source is syntactically valid but violates a
contract.

Examples:

```pkl
name: String = 1
port: Int(isBetween(1, 65535)) = 70000
```

Common diagnostics cover primitive mismatches, missing members, invalid calls,
class contract failures, union narrowing failures, and constrained annotation
failures.

## Evaluation Diagnostics

Evaluation diagnostics happen when runtime behavior cannot produce a value.

Common cases:

- missing imports
- cyclic imports
- invalid member lookup
- rejected runtime constraints
- failed resource reads

## Renderer Diagnostics

Renderer diagnostics happen after evaluation, when a value cannot be represented
in the requested format or the output path cannot be written.

## Editor Shape

Good editor diagnostics should point to the failing source span, name the stage,
include related import locations when useful, and keep the CLI command
reproducible.
