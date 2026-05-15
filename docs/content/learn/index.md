---
title: Getting Started
section: Learn
description: Install the Pkl CLI, run a module, then choose a learning path.
order: 10
---

# Getting Started

Install the Pkl CLI first. This site is an unofficial Pkl language guide, so the
learning path starts from the official `pkl` command.

## Installation

### 1. Install Pkl

Choose the tab that matches your environment. Native executables are the default
choice for everyday use; the Java executable is useful when a Java 17+ runtime
is the easiest shared dependency.

{{ install-tabs }}

The commands mirror the current [official Pkl CLI installation notes](https://pkl-lang.org/main/current/pkl-cli/index.html),
but this page keeps the common paths together so setup does not require jumping
between pages.

For Nix, the package version follows the nixpkgs input or channel you choose.
Check [Nix package search](https://search.nixos.org/packages?query=pkl) or pin
nixpkgs when an exact Pkl version matters.

### 2. Confirm the CLI

```bash
pkl --version
```

### 3. Create a Module

Create `config.pkl`:

```pkl
name = "api"
port: Int(isBetween(1, 65535)) = 8080
tags = new Listing {
  "pkl"
  "configuration"
}
```

### 4. Evaluate It

```bash
pkl eval config.pkl
pkl eval -f json config.pkl
```

After the first module runs, move through the learning path below instead of
jumping straight into reference pages.

## IDE Support

Install editor support early, before modules become large enough that syntax
errors and missing imports are annoying to spot manually.

| Editor | Use |
| --- | --- |
| [VS Code](https://pkl-lang.org/vscode/current/index.html) | Pkl language support for Visual Studio Code. |
| [IntelliJ](https://pkl-lang.org/intellij/current/index.html) | Rich support for IntelliJ IDEA, GoLand, PyCharm, and other IntelliJ Platform editors. |
| [Language Server](https://pkl-lang.org/lsp/current/index.html) | LSP-backed language services for editor integrations. |
| [Tools overview](https://pkl-lang.org/main/current/tools.html) | Official index for CLI, Pkldoc, Gradle, and editor support. |

## First Module

Start with a tiny module and keep one mental model in view: Pkl evaluates a
module into structured data, while types and constraints make that data safer to
change.

```pkl
name = "api"
port: Int(isBetween(1, 65535)) = 8080
tags = new Listing {
  "pkl"
  "configuration"
}
```

## Learning Path

1. Read **Core Concepts** to understand modules, values, object bodies, and member lookup.
2. Read **Values and Literals** before adding type contracts.
3. Read **Modules and Imports** before splitting a configuration across files.
4. Read **Authoring Templates** before designing base modules and environment overlays.
5. Read **Objects and Collections** when you need nested output, listings, mappings, or amendments.
6. Read **Functions and Control Flow** when derived values start to repeat.
7. Read **Types and Constraints** before relying on class contracts, callable signatures, nullable values, unions, or numeric predicates.
8. Read **Classes and Methods** when object contracts need defaults, inheritance, or behavior.
9. Read **Constraints in Practice** before turning validation into reusable rules.
10. Read **Resources and Readers** before depending on environment, properties, files, URLs, or custom schemes.
11. Read **Projects and Packages** when modules need shared settings, dependencies, or published package boundaries.
12. Read **Advanced Language Features** when generators, spreads, predicates, receiver keywords, or glob patterns appear.
13. Read **Evaluation and Output** to understand `pkl eval`, output formats, and renderer behavior.
14. Read **Debugging and Diagnostics** when a module parses but does not check, evaluate, or render as expected.
15. Use **CLI Reference** when a workflow needs tests, packages, server mode, or resource policies.
16. Use **Integration API** when a host application needs Java, Kotlin, Swift, Go, Codegen, or external readers.
17. Use **Object Model** and **Annotations and Modifiers** when reusable packages need precise contracts.
18. Use **Editor Support** and **Documentation Tools** when package users need navigation, generated docs, and runnable examples.
19. Use **Language Spec** and **Coverage Status** when this site needs to distinguish language behavior from editorial coverage.

## Run the Pkl CLI

```bash
pkl eval config.pkl
pkl eval -f yaml config.pkl
```

The default renderer chooses PCF when no format is set. Use `-f json`, `-f yaml`,
or another supported renderer when you want output for a specific consumer.

## What to Read Next

| Need | Page |
| --- | --- |
| "What is a module?" | Modules and Imports |
| "How do literals, null, durations, and data sizes work?" | Values and Literals |
| "How should I make reusable config?" | Authoring Templates |
| "How do nested values render?" | Objects and Collections |
| "Where should I put derived logic?" | Functions and Control Flow |
| "Which annotations are enforced?" | Types and Constraints |
| "How do I model an object contract?" | Classes and Methods |
| "How do I make constraints reusable?" | Constraints in Practice |
| "How do I read environment values or files?" | Resources and Readers |
| "How do I structure reusable modules?" | Projects and Packages |
| "Where are generators, spreads, and predicates?" | Advanced Language Features |
| "Which command should I run?" | Evaluation and Output |
| "How do I test, package, or run server mode?" | CLI Reference |
| "How do I call Pkl from Java, Kotlin, Swift, or Go?" | Integration API |
| "How do amendments and receiver lookup really work?" | Object Model |
| "How do doc comments and modifiers shape a public package?" | Annotations and Modifiers |
| "How should editor support and generated docs fit together?" | Editor Support and Documentation Tools |
| "How do I debug a failing module?" | Debugging and Diagnostics |
| "Is this Apple Pkl compatible yet?" | Compatibility |
