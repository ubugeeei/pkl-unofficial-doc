---
title: Evaluation and Output
section: Learn
description: Evaluate Pkl modules and choose output formats with the Pkl CLI.
order: 70
---

# Evaluation and Output

Pkl evaluation turns a module into a structured value. For language learning,
use the official `pkl` CLI as the baseline. Implementation-stage commands for
this repository live in **Tooling**.

## Evaluate a Module

```bash
pkl eval config.pkl
```

When no format is set, the default renderer chooses PCF. This is useful while
learning because the output keeps Pkl's object/listing/mapping shape visible.

```pkl
name = "api"
port = 8080
tags = new Listing {
  "pkl"
  "configuration"
}
```

## Evaluate an Expression

Use `-x` when you only need one value from a module:

```bash
pkl eval -x name config.pkl
pkl eval -x port config.pkl
```

## Render for a Consumer

Use `-f` to choose an output format:

```bash
pkl eval -f json config.pkl
pkl eval -f yaml config.pkl
```

Use `-o` when the output should be written to a file:

```bash
pkl eval -f json -o config.json config.pkl
```

## Validation

```bash
pkl eval config.pkl
```

Evaluation must parse the module, resolve imports, enforce type annotations, and
run constraints before output is produced. If a constraint fails, fix the source
instead of treating rendering as a separate step.

## Implementation Boundary

This documentation repository has lower-level generator and site tooling for
contributors. The learning model still starts from the language-level `pkl eval`
behavior and only calls out source differences when they affect compatibility.

## Output Formats

Pkl's CLI supports multiple renderers through `-f`. This documentation treats
PCF, JSON, YAML, properties, plist, and related formats as language-facing output
contracts. The port's implementation status page tracks which of those contracts
are implemented locally.

| Format | CLI Usage |
| --- | --- |
| PCF | `pkl eval config.pkl` |
| JSON | `pkl eval -f json config.pkl` |
| YAML | `pkl eval -f yaml config.pkl` |
| properties | `pkl eval -f properties config.pkl` |
| plist | `pkl eval -f plist config.pkl` |

## Diagnostics

Diagnostics surface from the stage that failed: syntax, import resolution,
typing, constraints, evaluation, or rendering. Keep the smallest failing module
nearby, then compare the behavior with **Compatibility** and official CLI
behavior when something differs from this site's explanation.
