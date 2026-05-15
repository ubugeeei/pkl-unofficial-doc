# pkl-unofficial-doc

Unofficial documentation for the Pkl language.

This repository is not the official Apple Pkl documentation. The reader-facing
docs start from the official `pkl` CLI and separate learning material,
reference material, and compatibility notes.

## Commands

Generate the static site:

```bash
moon run docsgen/main --target js -- docs/content docs/dist
```

Serve the generated site:

```bash
moon run docsserve/main --target native -- docs/dist 4173
```

Run checks:

```bash
moon fmt
moon check --deny-warn --target js
moon test --target js
moon info
```

Deploy to Void:

```bash
pnpm install
vpx void project link pkl-unofficial-doc
vpx void deploy
```

The Void config runs the MoonBit docs generator and treats `docs/dist` as a
static output directory. If the site is already generated,
`vpx void deploy --dir docs/dist` can publish the pre-built directory directly.

Open `http://127.0.0.1:4173/index.html`.
