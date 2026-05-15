---
title: Getting Started
section: Learn
description: Install the Pkl CLI, run a module, then choose a learning path.
order: 10
---

# Getting Started

Install the Pkl CLI first. This site is an unofficial Pkl language guide, so the
learning path should start from the official `pkl` command rather than this
repository's implementation tools.

## Installation

### 1. Install Pkl

Use the [official Pkl CLI documentation](https://pkl-lang.org/main/current/pkl-cli/index.html)
to choose the install path for your OS and environment. The official page covers
native downloads, package-managed installs, Mise setup, Windows setup, and the
Java executable.

This guide does not assume a particular platform or install manager.

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

If you are editing this repository rather than learning Pkl as a language, use
the **Tooling** page for local implementation commands.

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
2. Read **Modules and Imports** before splitting a configuration across files.
3. Read **Authoring Templates** before designing base modules and environment overlays.
4. Read **Objects and Collections** when you need nested output, listings, mappings, or amendments.
5. Read **Functions and Control Flow** when derived values start to repeat.
6. Read **Types and Constraints** before relying on class contracts, callable signatures, nullable values, unions, or numeric predicates.
7. Read **Classes and Methods** when object contracts need defaults, inheritance, or behavior.
8. Read **Constraints in Practice** before turning validation into reusable rules.
9. Read **Evaluation and Output** to understand `parse`, `check`, `eval`, PCF, and current renderer gaps.
10. Read **Debugging and Diagnostics** when a module parses but does not check, evaluate, or render as expected.
11. Use **Language Spec** and **Coverage Status** when this site needs to distinguish language behavior from editorial coverage.

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
| "How should I make reusable config?" | Authoring Templates |
| "How do nested values render?" | Objects and Collections |
| "Where should I put derived logic?" | Functions and Control Flow |
| "Which annotations are enforced?" | Types and Constraints |
| "How do I model an object contract?" | Classes and Methods |
| "How do I make constraints reusable?" | Constraints in Practice |
| "Which command should I run?" | Evaluation and Output |
| "How do I debug a failing module?" | Debugging and Diagnostics |
| "Is this Apple Pkl compatible yet?" | Compatibility |
