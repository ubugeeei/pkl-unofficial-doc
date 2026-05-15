---
title: API Reference
section: Reference
description: CLI, package, and integration surfaces readers commonly need.
order: 100
---

# API Reference

Pkl's most visible API is the `pkl` command-line interface. This page keeps the
reader-facing surfaces in one place: CLI evaluation, expression evaluation,
output rendering, project/package files, and embedding points.

## CLI Shape

```text
pkl <subcommand> [options] [modules]
```

Common commands:

| Command | Use |
| --- | --- |
| `pkl eval` | Evaluate one or more modules and render output. |
| `pkl repl` | Start an interactive session. |
| `pkl test` | Run modules that extend `pkl:test`. |
| `pkl project` | Work with project/package metadata. |
| `pkl server` | Run the message-passing server for embeddings. |

## Evaluation

```bash
pkl eval config.pkl
pkl eval -x service.port config.pkl
pkl eval -f json -o config.json config.pkl
```

Use `-x` for a single expression, `-f` for a renderer, and `-o` when output
should be written to a file.

## Output Formats

| Format | Example |
| --- | --- |
| PCF | `pkl eval config.pkl` |
| JSON | `pkl eval -f json config.pkl` |
| YAML | `pkl eval -f yaml config.pkl` |
| Properties | `pkl eval -f properties config.pkl` |
| Plist | `pkl eval -f plist config.pkl` |

## Project and Packages

Pkl projects use `PklProject` metadata to describe package name, version,
dependencies, package URI, and evaluator settings. Package imports use
`package://` URIs and resolve through package metadata.

Keep project-level setup separate from module syntax:

- module files teach values, objects, types, imports, and output
- project files teach dependency and package boundaries
- CLI flags decide how evaluated modules are rendered

## Embedding Surface

The `pkl server` command exposes Pkl through a message-passing protocol used by
language bindings and tools. Treat the server as an integration boundary: the
language contract still lives in modules, types, evaluation, imports, and output
rendering.
