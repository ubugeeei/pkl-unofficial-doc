---
title: Tooling
section: Ecosystem
description: Official Pkl tools and the local static-site build workflow.
order: 200
---

# Tooling

This page separates Pkl tools from this site's authoring tools. Readers only
need the official `pkl` CLI and editor support. Contributors to this site also
need the static-site build commands.

## Pkl Tools

| Tool | Use |
| --- | --- |
| `pkl` CLI | evaluate, test, package, inspect, and run server mode |
| Pkldoc | generate package documentation from public contracts |
| VS Code extension | editor support for Visual Studio Code |
| IntelliJ plugin | editor support for IntelliJ Platform IDEs |
| Language Server | protocol layer for other editors |

Use **CLI Reference**, **Editor Support**, and **Documentation Tools** for the
reader-facing workflows.

## Site Source

The documentation source lives in Markdown under `docs/content`. The site is
pre-rendered into static HTML under `docs/dist`.

```bash
moon run docsgen/main --target js -- docs/content docs/dist
moon run docsserve/main --target native -- docs/dist 4173
```

The local server is only for previewing generated HTML. It is not a Pkl
installation path.

## Contributor Checks

Run the generator tests before changing site structure or Markdown components.

```bash
moon fmt
moon check --deny-warn --target js
moon test --target js
moon info
```

In the standalone documentation repository, the package scripts wrap the same
steps:

```bash
pnpm check
pnpm build
```

## Coverage Discipline

When a page changes user-facing behavior, update the affected area:

- Learn pages for workflow-level behavior
- Reference pages for CLI, integration, syntax, object model, semantics, API,
  and stdlib shape
- Ecosystem pages for editor support, Pkldoc, package documentation, and source
  alignment
- Coverage Status for known documentation gaps

This keeps documentation tied to actual reader jobs instead of growing into a
flat pile of notes.
