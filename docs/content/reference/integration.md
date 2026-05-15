---
title: Integration Patterns
section: Reference
description: Practical patterns for using Pkl from applications, build systems, and deployment flows.
order: 102
---

# Integration Patterns

Integration is where Pkl stops being a language exercise and becomes part of a
build, deploy, or runtime boundary. Start with the smallest surface that gives
the host system the contract it needs.

## Build-Time Rendering

Render files during CI or release builds when the target system only needs JSON,
YAML, plist, properties, or PCF.

```bash
pkl eval --format json --output-path build/service.json config.pkl
```

This keeps application startup simple and makes configuration changes visible in
generated artifacts.

## Runtime Loading

Use Java, Kotlin, Swift, or Go bindings when the application needs to evaluate
Pkl at runtime and receive typed or dynamic values in memory.

| Host | Typical Use |
| --- | --- |
| Java | JVM services and build plugins |
| Kotlin | Kotlin services and Gradle-oriented projects |
| Swift | Apple-platform applications and Swift packages |
| Go | command-line tools and services with generated models |

Keep runtime loading strict: pin package dependencies, set resource policies,
and fail startup when configuration cannot be evaluated.

## Codegen

Codegen is strongest when a Pkl class is the contract between configuration
authors and application code.

```pkl
class ServiceConfig {
  name: String
  port: Int(isBetween(1, 65535))
}
```

Generated host types make refactors visible to the compiler. They also make
documentation and examples more valuable because package users can see the same
fields in Pkl and in host-language APIs.

## Server-Backed Tools

Use `pkl server` for tools that evaluate repeatedly:

- editors that need diagnostics and import resolution
- project generators that evaluate many related modules
- developer tools that preview multiple environments

Server-backed integrations should still expose a plain CLI fallback for CI and
debugging.

## External Data

When configuration depends on organization data, prefer a narrow external
reader over embedding ad hoc shell commands around Pkl.

```pkl
catalog = read("catalog:/services/api")
```

Document the scheme, the allowed resources, the failure mode, and whether the
reader is deterministic enough for CI.

## Package Boundary

Use packages when modules are shared across repositories or teams. A useful
package boundary includes:

- public classes and type aliases
- doc comments and Pkldoc output
- examples that can be evaluated
- tests that protect constraints
- versioned release notes for breaking changes

The goal is not only reuse. The goal is to make configuration contracts visible
and reviewable.
