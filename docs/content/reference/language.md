---
title: Language Spec
section: Reference
description: Syntax and semantic rules separated from implementation notes.
order: 110
---

# Language Spec

This page is the reader-facing shape of the language contract. The official Pkl
documentation and CLI behavior remain the source of truth; this page exists to
make the concepts easier to scan.

## Syntax Map

Use **Syntax Reference** for the compact grammar map. The high-level shape is:

- values: comments, scalar literals, strings, null, durations, data sizes, and
  interpolation
- modules: declarations, imports, relations, bindings, and declarations
- module system: source graphs, `pkl:` built-ins, cache boundaries, and
  relation failures
- expressions: literals, access, calls, lambdas, conditionals, operators, and
  object construction
- object bodies: properties, shorthand object members, listings, mappings, and
  amendments
- types: primitives, nullable types, collections, unions, aliases, classes, and
  constrained annotations
- resources: resource reads, globbed reads, resource policies, and external
  readers
- projects: `PklProject`, dependency resolution, package metadata, and package
  URIs
- advanced syntax: generators, spreads, predicates, receiver keywords,
  annotations, casts, and glob patterns

## Expressions

The parser accepts integer arithmetic, booleans, strings, `null`, identifiers,
parentheses, object literals, collection literals, member access, calls,
lambdas, conditionals, imports, and a broad slice of upstream parser fixtures.
Use **Operators Reference** for precedence and narrowing behavior.

## Modules

Supported module-level forms include:

- `module` declarations
- `amends` and `extends` relations
- imports with aliases
- top-level properties
- `local` module bindings
- class, function, and typealias declarations for the implemented subset

Use **Module System Reference** for import resolution, source graph semantics,
`amends`, and `extends`.

## Types

Pkl typechecking covers primitive types, nullable types, collections, union-style
narrowing, class inheritance, imported class metadata, and constrained
annotations.

## Values

Use **Values Reference** for comments, numeric bases, booleans, strings,
interpolation, custom string delimiters, null handling, `Duration`, and
`DataSize`.

## Resources

Use **Resources Reference** for `read`, `read?`, `read*`, built-in URI schemes,
allowlists, caching, and external readers.

## Projects and Packages

Use **Projects Reference** for `PklProject`, package metadata, dependencies,
local package testing, package URIs, and publishing boundaries.

## Advanced Features

Use **Advanced Reference** for `new`, `let`, type tests, casts, annotations,
anonymous functions, generators, spreads, member predicates, receiver keywords,
glob patterns, name resolution, and reserved names.

## Semantic Model

Pkl evaluation produces a structured module value made from primitives, objects,
listings, mappings, classes, and callables.

The typechecker runs over the parsed program before evaluation and reports
diagnostics for mismatched annotations, missing members, invalid callable calls,
and supported constraint failures.

Imports tie semantics to a source graph: imported modules must be resolved,
checked, and evaluated before dependent expressions can complete.

## Standard Library

Use **Standard Library** for the `pkl:` modules, core built-ins, and links to the
official reference when behavior is too broad for this compact guide.

## Output Model

Use **Output Formats** for PCF, JSON, YAML, plist, properties, and the way CLI
renderers connect evaluated values to downstream files.

## Diagnostics

Diagnostics are grouped by stage: parse, unsupported syntax, typecheck,
evaluation, and renderer. Use **Diagnostics Reference** for the failure model and
editor-integration direction.

## Compatibility Boundary

The docs use three labels in prose:

- **Pkl model**: the language concept readers should learn.
- **Official source**: where upstream docs, examples, or CLI behavior define the
  rule.
- **Editorial note**: why this site presents or groups the material differently.

Every user-facing page should make the boundary clear when this site is
summarizing, reorganizing, or adding commentary around official material.

## Compatibility Notes

Compatibility notes should point readers back to official docs, release notes,
or source examples when exact behavior matters.
