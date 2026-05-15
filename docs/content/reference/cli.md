---
title: CLI Reference
section: Reference
description: Pkl command-line workflow for evaluation, testing, projects, packages, and server mode.
order: 100
---

# CLI Reference

The `pkl` command is the baseline interface for learning, CI, and deployment.
Even if a project eventually uses a language binding, the CLI is still the best
place to confirm behavior because examples can be reproduced without host
application code.

## Command Map

| Command | Use |
| --- | --- |
| `pkl eval` | Evaluate modules and render output. |
| `pkl test` | Run Pkl test modules. |
| `pkl repl` | Explore expressions interactively. |
| `pkl server` | Start evaluator server mode for tools and integrations. |
| `pkl project resolve` | Resolve project dependencies. |
| `pkl project package` | Build a package from `PklProject`. |
| `pkl download-package` | Download a package and its metadata. |
| `pkl analyze imports` | Inspect import relationships. |

## Evaluation

`pkl eval` turns a module into rendered data. The default output is useful for
humans; use `--format` or `-f` when another tool consumes the result.

```bash
pkl eval config.pkl
pkl eval --format json config.pkl
pkl eval -f yaml --output-path build/config.yaml config.pkl
```

Use explicit output paths in build scripts so generated files are easy to diff
and clean.

## Multiple Outputs

Modules can describe multiple files. Keep the output root separate from source
files.

```bash
pkl eval --multiple-file-output-path build/generated files.pkl
```

## Tests

Use `pkl test` for executable examples, package contracts, and regression
coverage.

```bash
pkl test tests/*.pkl
pkl test --junit-reports build/test-results tests/*.pkl
```

Tests should live close to reusable templates and packages because they explain
the contract better than prose alone.

## Projects and Packages

Project commands make dependencies and package metadata explicit.

```bash
pkl project resolve
pkl project package
pkl download-package package://example.com/config/service@1.0.0
```

Use `PklProject` once imports start crossing package boundaries or when a
module needs a stable package URI.

## Resources and Security

Resource reads should be intentional. In automation, prefer explicit allowlists
over broad filesystem access.

```bash
pkl eval --allowed-resources file:/workspace/config/ config.pkl
pkl eval --properties-file local.properties config.pkl
```

When a module uses organization-specific URI schemes, pair the command with an
external reader and document the scheme in the project.

## Server Mode

`pkl server` is for long-running tools that need repeated evaluation. Editors,
build tools, and host-language clients can use it to avoid process startup cost
for every request.

```bash
pkl server
```

Reach for server mode after the CLI workflow is already clear; it should not be
the first abstraction a reader has to learn.

## REPL

The REPL is useful for checking expressions, constraints, and object amendments
without creating a file for every experiment.

```bash
pkl repl
```

Use it for quick exploration, then move the result back into a module or a test.
