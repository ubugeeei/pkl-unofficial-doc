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

A small repro helps decide whether the failure belongs in parser, typechecker,
evaluator, renderer, or docs.

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
in Apple Pkl docs but behaves differently in your local toolchain, check
**Compatibility**, release notes, and the official CLI before assuming the
example is wrong.

## Compare Upstream Fixtures

Use the upstream scripts when a behavior is expected to match Apple Pkl.

```bash
./scripts/upstream-parse-suite.sh
./scripts/upstream-smoke.sh
```

Parse-only success means the parser accepted the fixture. It does not guarantee
that typechecking, evaluation, stdlib calls, or output rendering match upstream.

## Read Plain Diagnostics

Diagnostics are plain text today. A good debugging note should include:

- the command that failed
- the smallest source that fails
- whether imports are involved
- whether the expected behavior comes from official docs, release notes, or an upstream fixture
- whether the failure is parse, check, eval, or render

The CST keeps source spans internally, so richer editor diagnostics can be added
without changing this high-level workflow.
