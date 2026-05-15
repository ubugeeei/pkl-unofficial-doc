---
title: Output Formats
section: Reference
description: PCF output today, planned JSON/YAML/properties/plist renderers, and renderer compatibility rules.
order: 130
---

# Output Formats

Evaluation produces a runtime value graph. A renderer turns that graph into a
document format.

## PCF

PCF is the implemented format today.

```pkl
name = "api"
ports = new Listing {
  8080
  9090
}
```

The renderer emits Pkl Configuration Format for:

- primitive values
- module-level object members
- nested objects
- listings
- mappings
- typed object values after implemented class default materialization

## JSON

JSON is roadmap work. The planned behavior is to emit a JSON document
equivalent to Apple Pkl's `pkl eval -f json` output for the implemented value
graph.

Important rules to preserve:

- Listing becomes array
- Mapping keys must become JSON object keys
- Null maps to JSON null
- hidden/local members should be omitted once implemented

## YAML

YAML is roadmap work. It should use the same value graph as JSON while obeying
YAML document conventions and scalar escaping rules.

## Java Properties

Properties output is roadmap work. It matters for JVM and Spring-style
configuration consumers, where nested data is flattened into dotted keys.

## plist

plist is not implemented. Treat it as a compatibility target after the JSON and
YAML renderer rules are settled.

## Renderer Discipline

Renderer work should not change evaluation semantics. If a value renders
incorrectly, keep the debugging question precise:

- is the runtime value wrong?
- is only PCF output wrong?
- is the planned format unsupported?
- does Apple Pkl have a special-case conversion rule?

Use upstream gold files where possible for byte-for-byte compatibility.
