---
title: Semantics Reference
section: Reference
description: Evaluation, typechecking, imports, constraints, and renderer semantics.
order: 115
---

# Semantics Reference

This page describes the language-level semantics a reader needs before relying
on a Pkl module in production. It is written as a contract map, not as a
tutorial.

## Module Evaluation

A module evaluates to an object value made from exported top-level properties.
Module-level `local` bindings participate in expressions but do not render as
members.

Forward references between module properties are part of the module evaluation
model.

## Imports

Import declarations and `import("...")` expressions resolve through a source
graph. Relative paths are resolved from the importing path; `pkl:` URIs refer to
standard-library modules.

Cycles and missing sources produce diagnostics instead of silently falling back.

## Objects

Object values store named members. Member lookup works for module objects,
explicit object literals, typed objects, and object amendments in the supported
slice.

Amendments start from a base object and merge override members.

## Classes

Class declarations create object contracts. The important semantics are:

- class properties
- property defaults
- typed object expressions
- inheritance
- method declarations and calls
- method parameter and return annotations

Use the official reference for exhaustive rules around generic classes, external
classes, and standard-library type integration.

## Callables

Function declarations and lambda expressions evaluate with argument bindings.
Callable values preserve lexical captures for scalar, object, and callable
bindings.

Parameter annotations and return annotations are checked at call boundaries.

## Typechecking

The typechecker covers the contracts readers usually depend on:

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

Syntax acceptance does not mean a value satisfies its semantic contract.

## Constraints

Constrained annotations are enforced during typechecking and evaluation for
values, object members, class properties, callable parameters, and callable
returns.

## Rendering

Renderers turn the evaluated value graph into PCF, JSON, YAML, plist,
properties, or another requested format. The top-level module value is the root
of that rendered output.
