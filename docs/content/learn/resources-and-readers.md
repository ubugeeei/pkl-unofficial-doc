---
title: Resources and Readers
section: Learn
description: Read environment values, external properties, files, URLs, and custom resource schemes.
order: 67
---

# Resources and Readers

Pkl modules can read external resources when configuration needs to cross the
boundary from source files into the environment around them. Treat reads as an
explicit dependency: they are convenient, but they also affect reproducibility
and security policy.

## Basic Reads

`read()` fails when the resource is unavailable. `read?()` returns `null`, which
lets the module choose a fallback.

```pkl
path = read("env:PATH")
port = read?("prop:PORT")?.toInt() ?? 8080
environment = read?("env:APP_ENV") ?? "local"
```

## Globbed Reads

`read*()` reads multiple matching resources and returns a mapping. It is useful
for structured environment or property sets, but should be scoped narrowly.

```pkl
appEnvironment = read*("env:APP_*")
featureFlags = read*("prop:feature.*")
```

## Built-in Schemes

Common resource schemes include `env:`, `prop:`, `file:`, `http:`, `https:`,
`modulepath:`, and `package:`. Relative resource URIs resolve against the
enclosing module URI.

## Allowlists

The CLI and embedding APIs can restrict resource access. Keep allowlists tight:
grant the schemes and paths a module actually needs instead of giving every
module full file-system or network access.

```bash
pkl eval app.pkl --allowed-resources env:,prop:,file:/workspace/config/
```

## External Readers

External readers extend the module or resource URI schemes available to an
evaluator. They are configured outside the language, then called by ordinary
`read()` or `import` expressions.

```bash
pkl eval app.pkl --external-resource-reader vault=./vault-reader
```

## Design Rule

If a value should be reviewed with the module, keep it in source. If a value
belongs to the runtime environment, read it through a named scheme and document
that dependency near the module entry point.
