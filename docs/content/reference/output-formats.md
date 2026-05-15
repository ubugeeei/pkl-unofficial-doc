---
title: Output Formats
section: Reference
description: PCF, JSON, YAML, properties, plist, and multiple-file output behavior.
order: 130
---

# Output Formats

Evaluation produces a runtime value graph. A renderer turns that graph into a
document format.

## PCF

PCF keeps Pkl's own object, listing, and mapping shape visible. It is the most
useful format while learning the language model.

```pkl
name = "api"
ports = new Listing {
  8080
  9090
}
```

PCF is useful for:

- primitive values
- module-level object members
- nested objects
- listings
- mappings
- typed object values after class defaults are materialized

## JSON

Use JSON when another program consumes generated configuration.

Important rules:

- Listing becomes array
- Mapping keys must become JSON object keys
- Null maps to JSON null
- hidden/local members should not become public output

## YAML

Use YAML when the downstream system expects human-edited configuration. YAML
shares the same value model as JSON while adding its own scalar and document
conventions.

## Java Properties

Properties output matters for JVM and Spring-style consumers, where nested data
is flattened into dotted keys.

## plist

plist is useful for Apple-platform tooling and configuration handoff.

## Multiple Files

Use multiple-file output when one Pkl module describes several generated files.
Keep generated files under a dedicated output directory.

```bash
pkl eval --multiple-file-output-path build/generated files.pkl
```

## Renderer Discipline

Renderer work should not change evaluation semantics. If a value renders
incorrectly, keep the debugging question precise:

- is the runtime value wrong?
- is only PCF output wrong?
- is the chosen format unable to represent the value?
- does Apple Pkl have a special-case conversion rule?

Use official CLI output as the compatibility baseline when exact formatting
matters.
