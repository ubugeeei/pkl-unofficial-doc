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
  inspect(
    home.html.contains("<meta property=\"og:title\" content=\"Pkl\">"),
    content="true",
  )
  inspect(
    home.html.contains(
      "<meta property=\"og:image\" content=\"https://pkl-unofficial-doc.void.app/assets/og-image.png\">",
    ),
    content="true",
  )
  inspect(
    home.html.contains(
      "<meta name=\"twitter:card\" content=\"summary_large_image\">",
    ),
    content="true",
  )
  inspect(
    home.html.contains("pkl-mbt object grammar brand mark"),
    content="false",
  )
  inspect(home.html.contains("<span>pkl-mbt</span>"), content="false")
  inspect(
    home.html.contains("MoonBit port / documentation sourcebook"),
    content="false",
  )
  inspect(home.html.contains("read the MoonBit package API"), content="false")
  inspect(home.html.contains("A calm, modern"), content="false")
  inspect(home.html.contains("hero-card"), content="false")
  inspect(home.html.contains("class=\"hero\""), content="false")
  inspect(home.html.contains("hero-lede"), content="false")
  inspect(
    home.html.contains("Documentation for the MoonBit implementation"),
    content="false",
  )
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
  inspect(home.html.contains("https://github.com/apple/pkl"), content="true")
  inspect(
    home.html.contains("https://github.com/ubugeeei/pkl-unofficial-doc"),
    content="true",
  )
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
  let learn = rendered[1]
  inspect(learn.html.contains("class=\"sidebar\""), content="true")
  inspect(
    learn.html.contains(
      "<meta property=\"og:title\" content=\"Learning Path - Pkl\">",
    ),
    content="true",
  )
  inspect(
    learn.html.contains(
      "<meta property=\"og:url\" content=\"https://pkl-unofficial-doc.void.app/learn/\">",
    ),
    content="true",
  )
  inspect(
    learn.html.contains(
      "<meta name=\"twitter:image\" content=\"https://pkl-unofficial-doc.void.app/assets/og-image.png\">",
    ),
    content="true",
  )
  inspect(learn.html.contains("https://github.com/apple/pkl"), content="true")
  inspect(
    learn.html.contains("https://github.com/ubugeeei/pkl-unofficial-doc"),
    content="true",
  )
  inspect(learn.html.contains("<small>Learn Pkl</small>"), content="false")
  inspect(learn.html.contains("<small>API surface</small>"), content="false")
  inspect(learn.html.contains("<small>Language rules</small>"), content="false")
  inspect(learn.html.contains("<small>"), content="false")
  inspect(learn.html.contains("class=\"page-nav\""), content="true")
  inspect(
    learn.html.contains("rel=\"prev\" href=\"../index.html\""),
    content="true",
  )
  inspect(
    learn.html.contains("<span>Previous</span><strong>Home</strong>"),
    content="true",
  )
  inspect(
    learn.html.contains("rel=\"next\" href=\"../reference/api.html\""),
    content="true",
  )
  inspect(
    learn.html.contains("<span>Next</span><strong>API</strong>"),
    content="true",
  )
  let language = rendered[3]
  inspect(language.html.contains("class=\"page-nav\""), content="true")
  inspect(
    language.html.contains("rel=\"prev\" href=\"../reference/api.html\""),
    content="true",
  )
  inspect(language.html.contains("rel=\"next\""), content="false")
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
  inspect(
    css.contains("grid-template-columns: repeat(4, minmax(0, 1fr));"),
    content="true",
  )
  inspect(
    css.contains("grid-template-columns: repeat(3, minmax(0, 1fr));"),
    content="false",
  )
  inspect(
    css.contains(
      ".track-grid {\n  display: grid;\n  grid-template-columns: repeat(4, minmax(0, 1fr));\n  gap: 0;\n  margin-top: clamp(38px, 6vh, 62px);\n  border-top: 1px solid var(--line);\n  border-bottom: 1px solid var(--line);",
    ),
    content="true",
  )
  inspect(
    css.contains(
      ".track-grid {\n  display: grid;\n  grid-template-columns: repeat(4, minmax(0, 1fr));\n  gap: 1px;",
    ),
    content="false",
  )
  inspect(css.contains(".track:first-child"), content="true")
  inspect(css.contains(".source-links"), content="true")
  inspect(css.contains(".topbar {\n  position: sticky;"), content="true")
  inspect(css.contains(".home-index {\n  position: sticky;"), content="true")
  inspect(
    css.contains(
      ".nav-section-title {\n  margin: 0 0 8px;\n  color: var(--muted);\n  font-size: 12px;\n  font-weight: 500;\n  text-transform: none;",
    ),
    content="true",
  )
  inspect(
    css.contains(".nav-link span {\n  font-size: 14px;\n  font-weight: 450;"),
    content="true",
  )
  inspect(css.contains("backdrop-filter: blur(18px);"), content="true")
  inspect(css.contains(".page-nav"), content="true")
  inspect(css.contains(".copy-code-button"), content="true")
  inspect(css.contains(".install-tabs"), content="true")
  inspect(css.contains(".tab-button"), content="true")
  inspect(js.contains("navigator.clipboard.writeText"), content="true")
  inspect(js.contains("document.execCommand(\"copy\")"), content="true")
  inspect(js.contains("querySelectorAll(\".line\")"), content="true")
  inspect(
    js.contains("document.querySelectorAll(\"[data-tabs]\")"),
    content="true",
  )
  inspect(js.contains("Copied"), content="true")
  inspect(js.contains("Selected"), content="true")
}

///|
test "open graph image asset is present" {
  inspect(@fs.path_exists("docs/assets/og-image.svg"), content="true")
  inspect(@fs.path_exists("docs/assets/og-image.png"), content="true")
  let image = @fs.read_file_to_string("docs/assets/og-image.svg") catch {
    _ => ""
  }
  inspect(image.contains("viewBox=\"0 0 1200 630\""), content="true")
  inspect(image.contains("width=\"1200\""), content="true")
  inspect(image.contains("height=\"630\""), content="true")
  inspect(image.contains("pkl-icon.svg"), content="true")
  inspect(image.contains("Pkl"), content="true")
  inspect(image.contains("Unofficial language documentation"), content="true")
  inspect(image.contains("apple/pkl"), content="true")
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
test "code blocks use compact line rhythm" {
  let css = site_assets()[0].content
  inspect(css.contains("padding: 12px 16px 13px;"), content="true")
  inspect(
    css.contains(
      ".markdown-body pre code {\n  background: transparent;\n  padding: 0;\n  color: inherit;\n  display: block;\n  line-height: 1.42;",
    ),
    content="true",
  )
  inspect(
    css.contains(
      ".markdown-body .highlight .line {\n  display: block;\n  min-height: 1.42em;",
    ),
    content="true",
  )
  inspect(css.contains("min-height: 1.55em;"), content="false")
}

///|
test "documentation code samples do not render empty spacer lines" {
  let pages = [
    "docs/content/learn/advanced-language-features.md", "docs/content/learn/authoring-templates.md",
    "docs/content/learn/classes-and-methods.md", "docs/content/learn/constraints-in-practice.md",
    "docs/content/learn/core-concepts.md", "docs/content/learn/debugging-diagnostics.md",
    "docs/content/learn/functions-and-control-flow.md", "docs/content/learn/imports-and-modules.md",
    "docs/content/learn/index.md", "docs/content/learn/modules.md", "docs/content/learn/objects-and-collections.md",
    "docs/content/learn/projects-and-packages.md", "docs/content/learn/resources-and-readers.md",
    "docs/content/learn/types-and-constraints.md", "docs/content/learn/values-and-literals.md",
    "docs/content/reference/advanced.md", "docs/content/reference/module-system.md",
    "docs/content/reference/projects.md", "docs/content/reference/resources.md",
    "docs/content/reference/stdlib.md", "docs/content/reference/syntax.md", "docs/content/reference/values.md",
    "docs/content/reference/annotations-and-modifiers.md", "docs/content/reference/cli.md",
    "docs/content/reference/integration.md", "docs/content/reference/object-model.md",
    "docs/content/ecosystem/documentation-tools.md", "docs/content/ecosystem/editor-support.md",
  ]
  for path in pages {
    let source = @fs.read_file_to_string(path) catch { _ => "" }
    let page = page_from_markdown(path, source)
    inspect(page.html.contains("<span class=\"line\"></span>"), content="false")
    inspect(
      page.html.contains("</span>\n<span class=\"line\">"),
      content="false",
    )
  }
}

///|
test "documentation covers learning api language and ecosystem paths" {
  let expected = [
    "docs/content/learn/authoring-templates.md", "docs/content/learn/classes-and-methods.md",
    "docs/content/learn/constraints-in-practice.md", "docs/content/learn/debugging-diagnostics.md",
    "docs/content/learn/functions-and-control-flow.md", "docs/content/learn/modules.md",
    "docs/content/learn/objects-and-collections.md", "docs/content/learn/types-and-constraints.md",
    "docs/content/learn/imports-and-modules.md", "docs/content/learn/evaluation-and-output.md",
    "docs/content/learn/values-and-literals.md", "docs/content/learn/resources-and-readers.md",
    "docs/content/learn/projects-and-packages.md", "docs/content/learn/advanced-language-features.md",
    "docs/content/reference/syntax.md", "docs/content/reference/collections.md",
    "docs/content/reference/diagnostics.md", "docs/content/reference/module-system.md",
    "docs/content/reference/operators.md", "docs/content/reference/output-formats.md",
    "docs/content/reference/semantics.md", "docs/content/reference/stdlib.md", "docs/content/reference/api.md",
    "docs/content/reference/values.md", "docs/content/reference/resources.md", "docs/content/reference/projects.md",
    "docs/content/reference/advanced.md", "docs/content/reference/annotations-and-modifiers.md",
    "docs/content/reference/cli.md", "docs/content/reference/integration.md", "docs/content/reference/object-model.md",
    "docs/content/ecosystem/compatibility.md", "docs/content/ecosystem/contributor-workflow.md",
    "docs/content/ecosystem/upstream-fixtures.md", "docs/content/ecosystem/documentation-tools.md",
    "docs/content/ecosystem/editor-support.md",
  ]
  for path in expected {
    inspect(@fs.path_exists(path), content="true")
  }
  let language = @fs.read_file_to_string("docs/content/reference/language.md") catch {
    _ => ""
  }
  inspect(language.contains("Syntax Map"), content="true")
  inspect(language.contains("Semantic Model"), content="true")
  inspect(language.contains("CLI Reference"), content="true")
  inspect(language.contains("Object Model"), content="true")
  inspect(language.contains("Annotations and Modifiers"), content="true")
  inspect(language.contains("Integration API"), content="true")
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
  let getting_started = @fs.read_file_to_string("docs/content/learn/index.md") catch {
    _ => ""
  }
  inspect(getting_started.contains("Values and Literals"), content="true")
  inspect(getting_started.contains("Resources and Readers"), content="true")
  inspect(getting_started.contains("Projects and Packages"), content="true")
  inspect(
    getting_started.contains("Advanced Language Features"),
    content="true",
  )
  let values = @fs.read_file_to_string("docs/content/reference/values.md") catch {
    _ => ""
  }
  inspect(values.contains("Numbers"), content="true")
  inspect(values.contains("Durations"), content="true")
  inspect(values.contains("DataSize"), content="true")
  let resources = @fs.read_file_to_string("docs/content/reference/resources.md") catch {
    _ => ""
  }
  inspect(resources.contains("read?"), content="true")
  inspect(resources.contains("read*"), content="true")
  inspect(resources.contains("allowed-resources"), content="true")
  let projects = @fs.read_file_to_string("docs/content/reference/projects.md") catch {
    _ => ""
  }
  inspect(projects.contains("PklProject"), content="true")
  inspect(projects.contains("package://"), content="true")
  let advanced = @fs.read_file_to_string("docs/content/reference/advanced.md") catch {
    _ => ""
  }
  inspect(advanced.contains("When Generators"), content="true")
  inspect(advanced.contains("Spread Syntax"), content="true")
  inspect(advanced.contains("Member Predicates"), content="true")
  let cli = @fs.read_file_to_string("docs/content/reference/cli.md") catch {
    _ => ""
  }
  inspect(cli.contains("pkl eval"), content="true")
  inspect(cli.contains("pkl test"), content="true")
  inspect(cli.contains("pkl repl"), content="true")
  inspect(cli.contains("pkl server"), content="true")
  inspect(cli.contains("pkl project package"), content="true")
  inspect(cli.contains("pkl download-package"), content="true")
  inspect(cli.contains("--format"), content="true")
  let integration = @fs.read_file_to_string(
    "docs/content/reference/integration.md",
  ) catch {
    _ => ""
  }
  inspect(integration.contains("Java"), content="true")
  inspect(integration.contains("Kotlin"), content="true")
  inspect(integration.contains("Swift"), content="true")
  inspect(integration.contains("Go"), content="true")
  inspect(integration.contains("pkl server"), content="true")
  inspect(integration.contains("Codegen"), content="true")
  let object_model = @fs.read_file_to_string(
    "docs/content/reference/object-model.md",
  ) catch {
    _ => ""
  }
  inspect(object_model.contains("Late Binding"), content="true")
  inspect(object_model.contains("Amendments"), content="true")
  inspect(object_model.contains("this"), content="true")
  inspect(object_model.contains("outer"), content="true")
  inspect(object_model.contains("super"), content="true")
  let annotations = @fs.read_file_to_string(
    "docs/content/reference/annotations-and-modifiers.md",
  ) catch {
    _ => ""
  }
  inspect(annotations.contains("Doc Comments"), content="true")
  inspect(annotations.contains("@Deprecated"), content="true")
  inspect(annotations.contains("local"), content="true")
  inspect(annotations.contains("hidden"), content="true")
  inspect(annotations.contains("fixed"), content="true")
  inspect(annotations.contains("const"), content="true")
  let api = @fs.read_file_to_string("docs/content/reference/api.md") catch {
    _ => ""
  }
  inspect(api.contains("Integration API"), content="true")
  inspect(api.contains("AnalysisSession"), content="false")
  inspect(api.contains("mizchi/cst"), content="false")
  let editor_support = @fs.read_file_to_string(
    "docs/content/ecosystem/editor-support.md",
  ) catch {
    _ => ""
  }
  inspect(editor_support.contains("VS Code"), content="true")
  inspect(editor_support.contains("IntelliJ"), content="true")
  inspect(editor_support.contains("Language Server"), content="true")
  inspect(editor_support.contains("Pkldoc"), content="true")
  let doc_tools = @fs.read_file_to_string(
    "docs/content/ecosystem/documentation-tools.md",
  ) catch {
    _ => ""
  }
  inspect(doc_tools.contains("Pkldoc"), content="true")
  inspect(doc_tools.contains("package documentation"), content="true")
  inspect(doc_tools.contains("doc comments"), content="true")
  let tooling = @fs.read_file_to_string("docs/content/ecosystem/tooling.md") catch {
    _ => ""
  }
  inspect(tooling.contains("apple/pkl"), content="true")
  inspect(tooling.contains("canonical implementation"), content="true")
  inspect(tooling.contains("mizchi-origin MoonBit port"), content="true")
  inspect(tooling.contains("unofficial implementation"), content="true")
  let compatibility = @fs.read_file_to_string(
    "docs/content/ecosystem/compatibility.md",
  ) catch {
    _ => ""
  }
  inspect(compatibility.contains("apple/pkl"), content="true")
  inspect(compatibility.contains("canonical implementation"), content="true")
  inspect(compatibility.contains("mizchi-origin MoonBit port"), content="true")
  let source_alignment = @fs.read_file_to_string(
    "docs/content/ecosystem/upstream-fixtures.md",
  ) catch {
    _ => ""
  }
  inspect(source_alignment.contains("apple/pkl"), content="true")
  inspect(source_alignment.contains("MoonBit port"), content="true")
  inspect(source_alignment.contains("comparison target"), content="true")
}

///|
test "getting started begins with installation" {
  let source = @fs.read_file_to_string("docs/content/learn/index.md") catch {
    _ => ""
  }
  inspect(source.contains("## Installation"), content="true")
  inspect(source.contains("## IDE Support"), content="true")
  inspect(source.contains("## First Module"), content="true")
  inspect(
    source.contains("https://pkl-lang.org/main/current/tools.html"),
    content="true",
  )
  inspect(
    source.contains("https://pkl-lang.org/vscode/current/index.html"),
    content="true",
  )
  inspect(
    source.contains("https://pkl-lang.org/intellij/current/index.html"),
    content="true",
  )
  inspect(
    source.contains("https://pkl-lang.org/lsp/current/index.html"),
    content="true",
  )
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
  inspect(page.html.contains("class=\"install-tabs\""), content="true")
  inspect(page.html.contains("role=\"tablist\""), content="true")
  inspect(
    page.html.contains(
      "<button class=\"tab-button\" type=\"button\" role=\"tab\" id=\"tab-nix\"",
    ),
    content="true",
  )
  inspect(page.html.contains("id=\"panel-nix\""), content="true")
  inspect(page.html.contains("nixpkgs"), content="true")
  inspect(page.html.contains("pkl-macos-aarch64"), content="true")
  inspect(page.html.contains("pkl-linux-amd64"), content="true")
  inspect(page.html.contains("winget"), content="true")
  inspect(page.html.contains("Apple"), content="true")
  inspect(page.html.contains("pkl-cli-java-0.31.1.jar"), content="true")
  inspect(
    page.html.contains("Use the official Pkl CLI documentation"),
    content="false",
  )
  let installation_first = match source.find("## Installation") {
    Some(installation) =>
      match source.find("## First Module") {
        Some(first_module) => installation < first_module
        None => false
      }
    None => false
  }
  inspect(installation_first, content="true")
  let ide_before_first_module = match source.find("## IDE Support") {
    Some(ide) =>
      match source.find("## First Module") {
        Some(first_module) => ide < first_module
        None => false
      }
    None => false
  }
  inspect(ide_before_first_module, content="true")
}

///|
test "learn pages do not require repository implementation commands" {
  let learn_pages = [
    "docs/content/learn/index.md", "docs/content/learn/evaluation-and-output.md",
    "docs/content/learn/debugging-diagnostics.md", "docs/content/learn/resources-and-readers.md",
    "docs/content/learn/projects-and-packages.md",
  ]
  for path in learn_pages {
    let source = @fs.read_file_to_string(path) catch { _ => "" }
    inspect(source.contains("moon run"), content="false")
    inspect(source.contains("pkf run"), content="false")
  }
}
