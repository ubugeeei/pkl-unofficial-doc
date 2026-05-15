///|
test "page metadata comes from markdown frontmatter" {
  let page = page_from_markdown(
    "docs/content/learn/index.md",
    (
      #|---
      #|title: Learning Path
      #|section: Learn
      #|description: A guided route through Pkl.
      #|order: 20
      #|---
      #|
      #|# Learning Path
      #|
      #|Start from values, then modules.
    ),
  )
  inspect(page.slug, content="learn/index")
  inspect(page.href, content="learn/")
  inspect(page.path, content="learn/index.html")
  inspect(page.title, content="Learning Path")
  inspect(page.section, content="Learn")
  inspect(page.description, content="A guided route through Pkl.")
  inspect(page.order, content="20")
  inspect(page.html.contains("<h1>Learning Path</h1>"), content="true")
}

///|
test "code blocks are statically syntax highlighted" {
  let page = page_from_markdown(
    "docs/content/learn/highlight.md",
    (
      #|---
      #|title: Highlight
      #|section: Learn
      #|description: Highlight test
      #|order: 1
      #|---
      #|
      #|```pkl
      #|module app.config
      #|name = "api"
      #|port: Int = 8080
      #|```
      #|
      #|```bash
      #|moon test --target js
      #|```
      #|
      #|```moonbit
      #|fn main { println("ok") }
      #|```
    ),
  )
  inspect(
    page.html.contains("<pre class=\"highlight pkl-highlight\""),
    content="true",
  )
  inspect(page.html.contains("class=\"code-block\""), content="true")
  inspect(page.html.contains("class=\"copy-code-button\""), content="true")
  inspect(page.html.contains("aria-label=\"Copy code\""), content="true")
  inspect(
    page.html.contains("<span class=\"code-language\">pkl</span>"),
    content="true",
  )
  inspect(
    page.html.contains("<span class=\"line\"></span></code></pre>"),
    content="false",
  )
  inspect(page.html.contains("tok-keyword\">module</span>"), content="true")
  inspect(page.html.contains("tok-type\">Int</span>"), content="true")
  inspect(
    page.html.contains("tok-string\">&quot;api&quot;</span>"),
    content="true",
  )
  inspect(page.html.contains("<code class=\"language-pkl\">"), content="false")
  inspect(page.html.contains("<code class=\"language-bash\">"), content="false")
  inspect(
    page.html.contains("<code class=\"language-moonbit\">"),
    content="false",
  )
  inspect(page.html.contains("<span class=\"line\">"), content="true")
}

///|
test "rendered site shell exposes learning api and spec routes" {
  let pages = [
    page_from_markdown(
      "docs/content/index.md", "---\ntitle: Home\nsection: Start\ndescription: Overview\norder: 1\n---\n# Home",
    ),
    page_from_markdown(
      "docs/content/learn/index.md", "---\ntitle: Learning Path\nsection: Learn\ndescription: Learn Pkl\norder: 10\n---\n# Learning Path",
    ),
    page_from_markdown(
      "docs/content/reference/api.md", "---\ntitle: API\nsection: Reference\ndescription: API surface\norder: 20\n---\n# API",
    ),
    page_from_markdown(
      "docs/content/reference/language.md", "---\ntitle: Language Spec\nsection: Reference\ndescription: Language rules\norder: 30\n---\n# Language Spec",
    ),
  ]
  let rendered = render_site(pages)
  inspect(rendered.length(), content="4")
  let home = rendered[0]
  inspect(home.path, content="index.html")
  inspect(home.html.contains("Learning Path"), content="true")
  inspect(home.html.contains("API"), content="true")
  inspect(home.html.contains("Language Spec"), content="true")
  inspect(home.html.contains("data-section=\"Start\""), content="true")
  inspect(home.html.contains("<title>Pkl</title>"), content="true")
  inspect(home.html.contains("<h1 id=\"home-title\">Pkl</h1>"), content="true")
  inspect(home.html.contains("aria-label=\"Pkl home\""), content="true")
  inspect(home.html.contains("Unofficial"), content="true")
  inspect(
    home.html.contains("Unofficial language documentation"),
    content="true",
  )
  inspect(home.html.contains("assets/pkl-icon.svg"), content="true")
  inspect(home.html.contains("object grammar brand mark"), content="false")
  inspect(home.html.contains("documentation sourcebook"), content="false")
  inspect(home.html.contains("read the package API"), content="false")
  inspect(home.html.contains("A calm, modern"), content="false")
  inspect(home.html.contains("hero-card"), content="false")
  inspect(home.html.contains("class=\"hero\""), content="false")
  inspect(home.html.contains("hero-lede"), content="false")
  inspect(home.html.contains("implementation sourcebook"), content="false")
  inspect(home.html.contains("class=\"home-page\""), content="true")
  inspect(home.html.contains("<header"), content="false")
  inspect(home.html.contains("home-nav"), content="false")
  inspect(home.html.contains("home-stage"), content="true")
  inspect(home.html.contains("home-index"), content="true")
  inspect(home.html.contains("brand-system"), content="true")
  inspect(home.html.contains("brand-mark"), content="true")
  inspect(home.html.contains("specimen-spine"), content="true")
  inspect(home.html.contains("specimen-thread"), content="true")
  inspect(home.html.contains("animate"), content="true")
  inspect(home.html.contains("specimen-seal"), content="false")
  inspect(
    home.html.contains("<image href=\"assets/pkl-icon.svg\""),
    content="false",
  )
  inspect(home.html.contains("mark-field"), content="false")
  inspect(home.html.contains("mark-flow"), content="false")
  inspect(home.html.contains("mark-tokens"), content="false")
  inspect(home.html.contains("mark-pulse"), content="false")
  inspect(home.html.contains("sigil-orbit"), content="false")
  inspect(home.html.contains("<text"), content="false")
  inspect(home.html.contains("track-grid"), content="true")
  inspect(home.html.contains("home-lanes"), content="false")
  inspect(home.html.contains("home-gallery"), content="false")
  inspect(home.html.contains("cover-sheet"), content="false")
  inspect(home.html.contains("site-shell"), content="false")
  inspect(home.html.contains("class=\"topbar\""), content="false")
  inspect(home.html.contains("class=\"sidebar\""), content="false")
  inspect(home.html.contains("search-box"), content="false")
  inspect(home.html.contains("home-overview"), content="false")
  inspect(home.html.contains("doc-map"), content="false")
  inspect(home.html.contains("status-rail"), content="false")
  inspect(
    home.html.contains("<article class=\"home-notes markdown-body\">"),
    content="true",
  )
  inspect(home.html.contains("markdown-body"), content="true")
}

///|
test "site theme stays neutral and markdown first" {
  let css = site_assets()[0].content
  let js = site_assets()[1].content
  inspect(css.contains("color-scheme: dark"), content="true")
  inspect(css.contains("color-scheme: light"), content="false")
  inspect(css.contains("--ink"), content="true")
  inspect(css.contains("--accent"), content="true")
  inspect(css.contains("#c8d987"), content="true")
  inspect(css.contains("#6b9543"), content="true")
  inspect(css.contains("#df8b96"), content="false")
  inspect(css.contains("stroke-dasharray"), content="false")
  inspect(css.contains("mark-flow"), content="false")
  inspect(css.contains("mark-pulse"), content="false")
  inspect(css.contains("--jade"), content="false")
  inspect(css.contains("--moss"), content="false")
  inspect(css.contains("--amber"), content="false")
  inspect(css.contains("--rose"), content="false")
  inspect(css.contains("repeating-linear-gradient"), content="false")
  inspect(css.contains(".topbar {\n  position: sticky;"), content="true")
  inspect(css.contains(".home-index {\n  position: sticky;"), content="true")
  inspect(css.contains("backdrop-filter: blur(18px);"), content="true")
  inspect(css.contains(".copy-code-button"), content="true")
  inspect(js.contains("navigator.clipboard.writeText"), content="true")
  inspect(js.contains("document.execCommand(\"copy\")"), content="true")
  inspect(js.contains("Copied"), content="true")
  inspect(js.contains("Selected"), content="true")
}

///|
test "documentation layout uses a wider desktop canvas" {
  let css = site_assets()[0].content
  inspect(css.contains("width: min(1480px, 100%);"), content="true")
  inspect(
    css.contains("grid-template-columns: minmax(270px, 310px) minmax(0, 1fr);"),
    content="true",
  )
  inspect(css.contains("gap: clamp(44px, 5vw, 96px);"), content="true")
  inspect(css.contains(".doc {\n  width: min(1000px, 100%);"), content="true")
}

///|
test "documentation covers learning api language and ecosystem paths" {
  let expected = [
    "docs/content/learn/authoring-templates.md", "docs/content/learn/classes-and-methods.md",
    "docs/content/learn/constraints-in-practice.md", "docs/content/learn/debugging-diagnostics.md",
    "docs/content/learn/functions-and-control-flow.md", "docs/content/learn/modules.md",
    "docs/content/learn/objects-and-collections.md", "docs/content/learn/types-and-constraints.md",
    "docs/content/learn/imports-and-modules.md", "docs/content/learn/evaluation-and-output.md",
    "docs/content/reference/syntax.md", "docs/content/reference/collections.md",
    "docs/content/reference/diagnostics.md", "docs/content/reference/module-system.md",
    "docs/content/reference/operators.md", "docs/content/reference/output-formats.md",
    "docs/content/reference/semantics.md", "docs/content/reference/stdlib.md", "docs/content/reference/api.md",
    "docs/content/ecosystem/compatibility.md", "docs/content/ecosystem/contributor-workflow.md",
    "docs/content/ecosystem/upstream-fixtures.md",
  ]
  for path in expected {
    inspect(@fs.path_exists(path), content="true")
  }
  let language = @fs.read_file_to_string("docs/content/reference/language.md") catch {
    _ => ""
  }
  inspect(language.contains("Syntax Map"), content="true")
  inspect(language.contains("Semantic Model"), content="true")
  inspect(language.contains("Compatibility Boundary"), content="true")
  let operators = @fs.read_file_to_string("docs/content/reference/operators.md") catch {
    _ => ""
  }
  inspect(operators.contains("Precedence Ladder"), content="true")
  let templates = @fs.read_file_to_string(
    "docs/content/learn/authoring-templates.md",
  ) catch {
    _ => ""
  }
  inspect(templates.contains("Template Contract"), content="true")
}

///|
test "getting started begins with installation" {
  let source = @fs.read_file_to_string("docs/content/learn/index.md") catch {
    _ => ""
  }
  inspect(source.contains("## Installation"), content="true")
  inspect(source.contains("## First Module"), content="true")
  inspect(
    source.contains("https://pkl-lang.org/main/current/pkl-cli/index.html"),
    content="true",
  )
  inspect(source.contains("brew install pkl"), content="false")
  inspect(source.contains("winget install Apple.Pkl"), content="false")
  inspect(source.contains("pkl --version"), content="true")
  inspect(source.contains("pkl eval config.pkl"), content="true")
  inspect(source.contains("moon run"), content="false")
  inspect(source.contains("pkf run"), content="false")
  inspect(source.contains("Install MoonBit"), content="false")
  let page = page_from_markdown("docs/content/learn/index.md", source)
  inspect(page.html.contains("<pre><code>"), content="false")
  inspect(page.html.contains("<ol start="), content="false")
  let installation_first = match source.find("## Installation") {
    Some(installation) =>
      match source.find("## First Module") {
        Some(first_module) => installation < first_module
        None => false
      }
    None => false
  }
  inspect(installation_first, content="true")
}

///|
test "learn pages do not require repository implementation commands" {
  let learn_pages = [
    "docs/content/learn/index.md", "docs/content/learn/evaluation-and-output.md",
    "docs/content/learn/debugging-diagnostics.md",
  ]
  for path in learn_pages {
    let source = @fs.read_file_to_string(path) catch { _ => "" }
    inspect(source.contains("moon run"), content="false")
    inspect(source.contains("pkf run"), content="false")
  }
}
