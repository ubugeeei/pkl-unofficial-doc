---
title: Editor Support
section: Ecosystem
description: VS Code, IntelliJ, Language Server, and CLI-backed editor workflows.
order: 212
---

# Editor Support

Editor support should make Pkl feel like a language, not a text format. Install
it early so syntax errors, imports, doc comments, and package boundaries are
visible while the module is still small.

## Tool Map

| Tool | Best For |
| --- | --- |
| VS Code extension | quick editing, syntax support, diagnostics, and common workflows |
| IntelliJ plugin | larger projects in IntelliJ IDEA, GoLand, PyCharm, and related IDEs |
| Language Server | editor integrations that speak LSP |
| Pkldoc | browsing package documentation generated from public contracts |
| CLI | reproducible checks that match CI |

## Recommended Setup

1. Install the Pkl CLI.
2. Install the editor extension or plugin for the editor you actually use.
3. Keep a `PklProject` at the package boundary when dependencies matter.
4. Run the CLI commands from the terminal so editor diagnostics and CI agree.

```bash
pkl eval config.pkl
pkl test tests/*.pkl
pkl analyze imports config.pkl
```

## What the Editor Should Help With

- syntax highlighting and structural navigation
- diagnostics from parsing, imports, types, and evaluation
- import resolution across project roots and package dependencies
- doc comments for public classes, properties, and type aliases
- navigation from usage sites to package documentation

When an editor disagrees with the CLI, trust the CLI first and reduce the module
until the difference is small enough to report.

## LSP Integrations

The Language Server is the right layer for new editor integrations. Treat it as
the protocol boundary: the editor owns UI, while the server owns language
diagnostics, symbol information, and project-level context.

## Documentation Loop

Editor support and documentation should reinforce each other:

- doc comments explain public fields before readers jump to prose docs
- Pkldoc exposes package contracts generated from source
- examples stay runnable with `pkl eval`
- tests protect the examples that documentation relies on
