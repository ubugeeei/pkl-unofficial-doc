---
title: Tooling
section: Contributing
description: Build, test, generate, and serve this documentation site.
order: 200
---

# Tooling

This page is repository maintenance material. The Learn path uses the official
`pkl` CLI; the commands here are only for building this static documentation
site.

## Generate

```bash
moon run docsgen/main --target js -- docs/content docs/dist
```

The docs source lives in Markdown under `docs/content`. The static site is
pre-rendered into `docs/dist` by `docsgen`, which uses `mizchi/markdown` for the
Markdown-to-HTML step.

## Serve

```bash
moon run docsserve/main --target native -- docs/dist 4173
```

`docsserve` is a small native MoonBit file server built on `moonbitlang/async`.
Change the final argument when port `4173` is already in use.

## Check

```bash
moon fmt
moon check --deny-warn --target js
moon test --target js
moon info
```

## Deploy

```bash
pnpm install
vpx void project link pkl-unofficial-doc
vpx void deploy
```

`void.json` declares this as a static Void app, uses the MoonBit docs generator
as the build command, and publishes `docs/dist`. The project link command is a
one-time local setup step. When `docs/dist` is already generated, use
`vpx void deploy --dir docs/dist` to upload the pre-built static directory.

## Site Shape

- `docs/content` is the editable Markdown source.
- `docs/assets` contains copied static assets.
- `docsgen` renders Markdown, navigation, CSS, and browser behavior.
- `docsserve` serves the generated `docs/dist` tree locally.

## Coverage Discipline

When the docs add or revise language behavior:

- Learn pages for workflow-level behavior
- Reference pages for syntax, semantics, API, and stdlib shape
- Coverage Status for remaining documentation gaps
- Compatibility for source links and official behavior boundaries

This keeps documentation tied to official Pkl behavior instead of drifting into
a parallel language.
