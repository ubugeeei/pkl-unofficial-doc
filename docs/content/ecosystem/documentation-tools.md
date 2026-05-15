---
title: Documentation Tools
section: Ecosystem
description: Pkldoc, package documentation, examples, and source comments for reusable Pkl packages.
order: 214
---

# Documentation Tools

Pkl documentation should be generated from the package contract wherever
possible. Narrative guides explain how to think; Pkldoc and source examples show
the exact API that package users can import.

## Pkldoc

Pkldoc turns public package members into browsable package documentation. It is
most useful when classes, type aliases, and exported properties have doc
comments that describe the contract.

```pkl
/// Shared service configuration consumed by deploy tooling.
class ServiceConfig {
  /// DNS label used by generated endpoints.
  name: String
  /// Public HTTP port.
  port: Int(isBetween(1, 65535)) = 8080
}
```

Treat generated documentation as part of the release artifact for reusable
packages.

## Package Documentation Shape

A package documentation set should answer five questions:

| Question | Source |
| --- | --- |
| What can I import? | package docs and public module list |
| What shape do I amend? | classes, type aliases, and examples |
| Which fields are required? | annotations and default values |
| What is safe to override? | modifiers and prose notes |
| How do I verify it? | `pkl test` examples |

## Examples as Tests

Examples should be short enough to read and real enough to evaluate.

```pkl
import "package://example.com/config/service@1.0.0#/Service.pkl" as service
amends service.Base
name = "api"
port = 8443
```

If an example cannot run, mark it as conceptual. Otherwise, keep it under a test
or fixture path and evaluate it in CI.

## Doc Comment Discipline

Use doc comments for exported contracts, not for every helper.

- Explain units, constraints, defaults, and operational meaning.
- Link deprecated members to replacements.
- Keep examples close to the class or package they document.
- Prefer one focused example over a long scenario that hides the contract.

## Unofficial Site Role

This site should not duplicate every generated package page. It should provide:

- learning paths for the language model
- reference pages for concepts that cross packages
- ecosystem pages that explain how CLI, Pkldoc, bindings, and editors fit
  together
- source links to official package documentation when exhaustive signatures
  matter
