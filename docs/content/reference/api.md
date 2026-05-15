---
title: Integration API
section: Reference
description: Choose between the CLI, server mode, language bindings, code generation, and resource readers.
order: 101
---

# Integration API

Pkl usually enters a system through one of five surfaces: the CLI, `pkl server`,
host-language bindings, generated types, or external resource readers. This
page is a routing guide for choosing the surface before reading the exhaustive
official package or binding documentation.

## Surface Matrix

| Surface | Best For | Avoid When |
| --- | --- | --- |
| CLI | build scripts, CI checks, one-shot rendering, package publishing | the host process needs many repeated evaluations |
| `pkl server` | editors, long-running tools, repeated evals with lower startup overhead | a shell command is simpler and startup cost is irrelevant |
| Java / Kotlin | JVM services, Gradle builds, typed configuration loading | the runtime cannot carry a JVM dependency |
| Swift | Apple-platform apps, Swift Package Manager projects | the configuration is only used at build time |
| Go | services and command-line tools that want native Go values | dynamic output is enough and codegen adds maintenance cost |
| Codegen | stable host-language contracts from Pkl classes | schemas are still changing every commit |
| External readers | custom URI schemes, secrets, service discovery, generated data | ordinary file, env, or property reads are enough |

## CLI as the Boundary

Use the CLI when a process can treat Pkl as an external compiler for
configuration.

```bash
pkl eval --format json --output-path build/service.json config.pkl
pkl test tests/*.pkl
pkl project package
```

The CLI boundary is easy to cache, easy to run in CI, and easy to debug because
it uses the same commands a reader can reproduce locally.

## Server Mode

`pkl server` keeps an evaluator process available for client tooling. It is the
right abstraction when a program needs repeated evaluations, dependency graph
reuse, or editor-style responsiveness.

Good candidates:

- editor integrations that evaluate snippets or resolve imports repeatedly
- build tools that evaluate many related modules
- language services that need diagnostics without starting a new process each
  time

## Language Bindings

Use a binding when the host program owns evaluation and wants Pkl values inside
the process.

| Binding | Typical Shape |
| --- | --- |
| Java | evaluator manager, module sources, generated or dynamic values |
| Kotlin | Kotlin-friendly APIs over the JVM evaluator |
| Swift | Swift Package Manager integration and generated Swift models |
| Go | generated Go types and runtime evaluation helpers |

Bindings should still preserve the same discipline as CLI usage: keep module
paths explicit, decide resource access up front, and treat evaluation failures
as configuration errors rather than ordinary missing defaults.

## Codegen

Codegen turns Pkl classes into host-language types. Prefer it when:

- the Pkl module is a stable contract consumed by application code
- refactors should fail at compile time in the host language
- generated documentation and host types need to stay aligned

Avoid codegen while the shape is exploratory. In that phase, render JSON or YAML
from the CLI and stabilize the Pkl classes first.

## External Resource Readers

External readers let tools provide custom resource schemes to `read`, `read?`,
and `read*`.

```pkl
secrets = read("vault:/services/api")
```

Use them for organization-specific sources such as secret stores, inventory
systems, or generated catalogs. Keep the URI scheme narrow and document the
allowlist required to use it.

## Choosing a Surface

| Need | Start With |
| --- | --- |
| "Render config during a deploy" | CLI |
| "Validate package tests in CI" | CLI |
| "Evaluate many modules from one tool" | `pkl server` |
| "Load config inside a JVM service" | Java or Kotlin binding |
| "Use typed config in an iOS app" | Swift binding |
| "Use typed config in a Go service" | Go binding and Codegen |
| "Read from a custom source" | External resource reader |

## Related Pages

- **CLI Reference** covers concrete commands and options.
- **Projects Reference** covers packages, dependencies, and publishing shape.
- **Resources Reference** covers `read`, `read?`, `read*`, URI schemes, and
  allowlists.
- **Documentation Tools** covers Pkldoc and package documentation.
