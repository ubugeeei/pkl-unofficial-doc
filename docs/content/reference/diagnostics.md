---
title: Diagnostics Reference
section: Reference
description: Diagnostic stages, failure shapes, current messages, and future editor integration.
order: 118
---

# Diagnostics Reference

Diagnostics are grouped by stage. The same source file can pass one stage and
fail the next.

## Parse Diagnostics

Parse diagnostics mean the source cannot be reduced into the semantic program
model.

Typical causes:

- malformed object bodies
- missing delimiters
- unsupported declaration forms that are not yet tolerated
- invalid string or interpolation shapes

Parser diagnostics are closest to syntax and should not require import or
stdlib context.

## Unsupported Syntax

The parser can preserve accepted-but-not-semantic syntax as unsupported spans.
This lets compatibility work move forward without pretending every accepted
construct evaluates.

User-facing docs should call this out explicitly: parse acceptance is not the
same thing as language support.

## Typecheck Diagnostics

Typecheck diagnostics mean the source is syntactically valid but violates a
contract.

Examples:

```pkl
name: String = 1
port: Int(isBetween(1, 65535)) = 70000
```

Current diagnostics cover primitive mismatches, missing members, invalid calls,
class contract failures, union narrowing failures, and selected constrained
annotation failures.

## Evaluation Diagnostics

Evaluation diagnostics happen when runtime behavior cannot produce a value.

Common cases:

- missing imports
- cyclic imports
- invalid member lookup
- rejected runtime constraints
- unsupported stdlib calls

## Renderer Diagnostics

PCF rendering is implemented for the current value graph. JSON, YAML,
properties, and plist rendering are roadmap work, so format-specific failures
should be treated as missing feature work rather than Pkl model failures.

## Future Shape

The CST preserves source positions, so diagnostics can grow into editor-grade
messages with spans, related locations, and code actions. The current docs keep
the stage model stable so richer diagnostics can slot into the same workflow.
