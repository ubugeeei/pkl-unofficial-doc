---
title: Tooling
section: Ecosystem
description: Official Pkl tools, editor integrations, documentation generators, and build integrations.
order: 200
---

# Tooling

This page is for Pkl users choosing tools around the Apple Pkl ecosystem. It is
not a contributor setup page for this documentation site, and it is not a page
about downstream implementations.

Use [apple/pkl](https://github.com/apple/pkl) and the official
[Pkl Tools](https://pkl-lang.org/main/current/tools.html) page as the authority
for releases, behavior, and compatibility.

## Tool Map

| Tool | Audience | Use it for |
| --- | --- | --- |
| `pkl` CLI | everyone | evaluating modules, rendering output, testing packages, running server mode, inspecting projects |
| Gradle Plugin | JVM teams | build-time evaluation, Java/Kotlin code generation, Pkldoc generation |
| Pkldoc | library authors | searchable package documentation from public Pkl modules and doc comments |
| IntelliJ Plugin | JetBrains users | completion, navigation, diagnostics, and refactoring in IntelliJ Platform IDEs |
| VS Code Extension | VS Code users | completion, diagnostics, formatting, and editor feedback |
| Neovim Plugin | Neovim users | editor support backed by the Pkl language server |
| Pkl Language Server | editor/plugin authors | low-level LSP integration for editor plugins |
| Code generators | application teams | typed Java, Kotlin, Swift, and Go-facing configuration APIs |

## Start With the CLI

The CLI is the operational center of Pkl. Learn it first, then add editor or
build integrations around the workflows you actually need.

| Command family | What it anchors |
| --- | --- |
| `pkl eval` | rendering configuration to JSON, YAML, plist, or other output formats |
| `pkl test` | validating examples, fixtures, and package contracts |
| `pkl repl` | exploring expressions and standard-library behavior |
| `pkl server` | embedding Pkl behind language bindings and long-running clients |
| project/package commands | dependency resolution, package metadata, and publishing workflows |

See **CLI Reference** for command shape and output behavior.

## Build and Documentation Tools

Use the **Gradle Plugin** when Pkl evaluation, Java/Kotlin code generation, or
Pkldoc generation needs to be part of a JVM build. It is the cleanest path for
teams that already rely on Gradle.

Use **Pkldoc** when you publish reusable Pkl modules. Pkldoc turns module names,
classes, functions, properties, and Markdown doc comments into navigable package
documentation.

Use **code generators** when application code should consume configuration
through typed APIs instead of raw maps. Pkl's official docs cover Java, Kotlin,
Swift, and Go-facing integration surfaces.

## Editor Tools

Editor support should be selected by editor, not by implementation.

- **IntelliJ Plugin** for JetBrains IDEs.
- **VS Code Extension** for VS Code.
- **Neovim Plugin** for Neovim.
- **Pkl Language Server** for plugin authors and editor integrations.

For day-to-day setup, use **Editor Support**. For protocol-level details, use
the official Language Server documentation.

## What This Page Is Not

This page should not list this site's Markdown generator, local preview server,
deployment command, or MoonBit implementation work. Those are contributor and
implementation concerns, not Pkl tooling for readers.

Use **Contributor Workflow** for documentation-site commands and
**Compatibility** for notes about unofficial implementations.
