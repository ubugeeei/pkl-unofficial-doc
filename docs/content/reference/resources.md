---
title: Resources Reference
section: Reference
description: Resource reads, nullable reads, globbed reads, URI schemes, allowlists, and external readers.
order: 116
---

# Resources Reference

Resources connect a Pkl module to data outside the source file.

## Read Forms

| Form | Result |
| --- | --- |
| `read("uri")` | Reads one resource or fails |
| `read?("uri")` | Reads one resource or returns `null` when absent |
| `read*("glob")` | Reads all matching resources into a mapping |

## Built-in Schemes

| Scheme | Typical use |
| --- | --- |
| `env:` | Environment variables |
| `prop:` | CLI properties passed with `-p` |
| `file:` | Local file-system resources |
| `http:` / `https:` | Network resources |
| `modulepath:` | Module-path resources |
| `package:` | Resources from packages |

## Caching

Resource reads are cached in memory. A repeated read of the same URI returns the
same value during one evaluation.

## Allowlist

Resource access is checked against the `--allowed-resources` policy. Embedded
evaluators configure the same idea through their security manager.

```bash
pkl eval app.pkl --allowed-resources env:,prop:,file:/workspace/config/
```

## External Readers

External readers add custom URI schemes for resources or modules. They are
registered outside the language through CLI flags or embedding APIs.

```bash
pkl eval app.pkl --external-resource-reader vault=./vault-reader
```

## Failure Modes

- `read()` fails when the resource is absent or disallowed.
- `read?()` turns absence into `null`, but it does not make an unsafe resource
  policy safe.
- `read*()` can change when the environment or file tree changes, so glob
  narrowly.
