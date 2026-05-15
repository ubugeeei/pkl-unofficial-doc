---
title: Semantics Reference
section: Reference
description: Evaluation, typechecking, imports, constraints, and renderer semantics.
order: 115
---

# Semantics Reference

This page describes the evaluation and checking model readers need when Pkl
modules become reusable contracts. It is written as a contract map, not as a
tutorial.

## Module Evaluation

A module evaluates to an object value made from exported top-level properties.
Module-level `local` bindings participate in expressions but do not render as
members.

Forward references between module properties are resolved through member lookup
rather than by file order alone.

## Imports

Import declarations and `import("...")` expressions resolve through the source
graph. Relative paths are resolved from the importing path; `pkl:` URIs refer to
standard modules.

Cycles and missing sources produce diagnostics instead of silently falling back.

## Objects

Object values store properties, elements, and entries. Member lookup works for
module objects, explicit object literals, typed objects, and object amendments.

Amendments start from a base object and merge override members.

## Classes

Class declarations create object contracts. Important semantic pieces are:

- class properties and defaults
- typed object expressions
- inheritance and extension points
- method declarations and calls
- method parameter and return annotations

## Callables

Function declarations and lambda expressions evaluate with argument bindings.
Callable values preserve lexical captures for scalar, object, and callable
bindings.

Parameter annotations and return annotations are checked at call boundaries.

## Typechecking

Typechecking connects annotations to values. The most common reader-facing
checks are:

- primitive annotations
- nullable annotations
- collection generics
- union types
- `is` guard narrowing
- null guard narrowing
- class property contracts
- callable parameter and return contracts
- imported class metadata
- constrained annotations

## Constraints

Constrained annotations should be treated as part of the public contract. Use
them where a bad value should fail before generated output reaches another
system.

## Rendering

Rendering turns the evaluated module value into an output format. Use
**Output Formats** for PCF, JSON, YAML, plist, properties, and multiple-file
output behavior.
