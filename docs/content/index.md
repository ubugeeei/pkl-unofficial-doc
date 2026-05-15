---
title: Pkl
section: Overview
description: Unofficial documentation for the Pkl language.
order: 1
---

# Pkl

> This is an unofficial documentation site for the Pkl language. It is not the
> official Apple Pkl documentation.

The site is organized around three reader jobs:

- **Learn Pkl**: move from module shape to objects, collections, types,
  templates, functions, classes, constraints, imports, debugging, evaluation,
  and output.
- **Reference**: keep CLI usage, syntax, operators, modules, semantics,
  standard library expectations, diagnostics, and output formats easy to scan.
- **Language Spec**: separate syntax, operators, module rules, semantics,
  diagnostics, standard library expectations, output formats, and
  coverage notes so readers can tell what is language behavior and what is this
  site's editorial boundary.

## Why This Structure

The original Pkl docs mix learning material, reference material, and ecosystem
surfaces in ways that make it hard to choose a path. This version keeps the
learning flow linear, keeps reference pages scannable, and treats language rules
as a contract that can be compared with official Pkl behavior.

## Current Focus

This site treats Pkl as the primary subject. It teaches the language model
first, then marks source links, compatibility notes, and documentation coverage
where a reader needs to know how this unofficial site relates to the official
project.

## Map

- **Getting Started**: Pkl CLI installation, first module, and output rendering.
- **Authoring Templates**: how to shape reusable base modules and environment
  overlays.
- **Functions and Control Flow**: conditionals, operators, declarations,
  lambdas, and callable values.
- **Classes and Methods**: class contracts, defaults, inheritance, typed
  objects, and method calls.
- **Modules and Imports**: module declarations, `amends`, `extends`, aliases,
  source graphs, and cache boundaries.
- **Objects and Collections**: object bodies, member lookup, listings, mappings,
  amendments, and rendering shape.
- **Types and Constraints**: primitive annotations, nullable types, collection
  generics, unions, classes, callable annotations, and numeric constraints.
- **Constraints in Practice**: how to apply built-ins, type aliases, predicate
  factories, class property constraints, and callable boundaries.
- **Debugging and Diagnostics**: reduce failures through syntax, imports,
  typing, constraints, evaluation, and rendering.
- **Language Spec**: syntax map, operator rules, module system, semantic model,
  compatibility boundary, and official source links.
- **Standard Library**: `pkl:` modules, core built-ins, and how to approach the
  official standard library reference.
- **Source Alignment**: how this site uses official docs, examples, release
  notes, and fixtures without inheriting the upstream information architecture.
