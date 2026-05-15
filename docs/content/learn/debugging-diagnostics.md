---
title: Debugging and Diagnostics
section: Learn
description: How to reduce broken Pkl modules, classify failures, and read diagnostics.
order: 75
---

# Debugging and Diagnostics

When a Pkl module fails, first decide which stage failed: parse, typecheck,
evaluation, import resolution, or rendering.

## Stage the Failure

Start with the official CLI behavior.

```bash
pkl eval config.pkl
pkl eval -f json config.pkl
```

If evaluation fails before output appears, classify the error by reading the
diagnostic: syntax, import resolution, typing, constraints, evaluation, or
rendering. Contributor-only stage commands live in **Tooling**.

## Reduce the Module

Keep the smallest file that still fails.

```pkl
class Service {
  port: Int(isBetween(1, 65535))
}
service: Service = new Service {
  port = 70000
}
```

A small repro helps decide whether the failure is syntax, typechecking,
evaluation, rendering, or documentation.

## Check Import Graphs

For import failures, reduce the graph to two files and evaluate the importing
module.

```pkl
// base.pkl
name = "api"
```

```pkl
// main.pkl
import "base.pkl" as base
name = base.name
```

```bash
pkl eval main.pkl
```

Missing sources, invalid URIs, and import cycles should produce diagnostics
instead of silent fallback values.

## Watch the Compatibility Boundary

Some syntax parses before the semantic layer supports it. If a feature appears
in Apple Pkl docs but fails in your current toolchain, check **Coverage Status**
and the relevant official source before assuming the example is wrong.

## Compare Official Behavior

Use the official CLI when a behavior should match Apple Pkl exactly.

```bash
pkl eval config.pkl
pkl test tests/*.pkl
```

If the official CLI and another tool disagree, keep the reduced source, command,
tool versions, and expected output together.

## Read Plain Diagnostics

Diagnostics are plain text today. A good debugging note should include:

- the command that failed
- the smallest source that fails
- whether imports are involved
- whether the expected behavior comes from an official source or a local example
- whether the failure is parse, check, eval, or render

Editor integrations should expose the same stage model with source spans,
related import locations, and a reproducible CLI command.
