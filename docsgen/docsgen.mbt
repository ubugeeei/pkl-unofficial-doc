///|
pub(all) struct DocPage {
  slug : String
  href : String
  path : String
  source_path : String
  title : String
  section : String
  description : String
  order : Int
  html : String
}

///|
pub(all) struct RenderedPage {
  path : String
  html : String
}

///|
pub(all) struct SiteAsset {
  path : String
  content : String
}

///|
fn html_escape(value : String) -> String {
  value
  .replace_all(old="&", new="&amp;")
  .replace_all(old="<", new="&lt;")
  .replace_all(old=">", new="&gt;")
  .replace_all(old="\"", new="&quot;")
}

///|
fn metadata_value(fm : @markdown.Frontmatter?, key : String) -> String? {
  match fm {
    Some(frontmatter) => {
      for entry in frontmatter.entries {
        let (entry_key, value) = entry
        if entry_key == key {
          return Some(value)
        }
      }
      None
    }
    None => None
  }
}

///|
fn metadata_string(
  fm : @markdown.Frontmatter?,
  key : String,
  default : String,
) -> String {
  match metadata_value(fm, key) {
    Some(value) => value
    None => default
  }
}

///|
fn metadata_int(
  fm : @markdown.Frontmatter?,
  key : String,
  default : Int,
) -> Int {
  match metadata_value(fm, key) {
    Some(value) => @string.parse_int(value) catch { _ => default }
    None => default
  }
}

///|
fn trim_prefix(value : String, prefix : String) -> String {
  if value.has_prefix(prefix) {
    String::unsafe_substring(value, start=prefix.length(), end=value.length())
  } else {
    value
  }
}

///|
fn trim_suffix(value : String, suffix : String) -> String {
  if value.has_suffix(suffix) {
    String::unsafe_substring(
      value,
      start=0,
      end=value.length() - suffix.length(),
    )
  } else {
    value
  }
}

///|
fn slug_from_path(path : String) -> String {
  trim_suffix(trim_prefix(path, "docs/content/"), ".md")
}

///|
fn href_from_slug(slug : String) -> String {
  if slug == "index" {
    "index.html"
  } else if slug.has_suffix("/index") {
    trim_suffix(slug, "index")
  } else {
    slug + ".html"
  }
}

///|
fn path_from_slug(slug : String) -> String {
  if slug == "index" {
    "index.html"
  } else {
    slug + ".html"
  }
}

///|
fn fallback_title(source : String) -> String {
  for line in source.split("\n") {
    let text = line.trim().to_owned()
    if text.has_prefix("# ") {
      return String::unsafe_substring(text, start=2, end=text.length())
    }
  }
  "Untitled"
}

///|
fn substring(text : String, start : Int, end : Int) -> String {
  String::unsafe_substring(text, start~, end~)
}

///|
fn find_from(text : String, needle : String, start : Int) -> Int? {
  if start >= text.length() {
    return None
  }
  let rest = substring(text, start, text.length())
  match rest.find(needle) {
    Some(index) => Some(start + index)
    None => None
  }
}

///|
fn replace_all(text : String, old : String, new : String) -> String {
  if old.is_empty() {
    return text
  }
  let out = StringBuilder::new()
  let mut pos = 0
  while true {
    match find_from(text, old, pos) {
      Some(index) => {
        out.write_string(substring(text, pos, index))
        out.write_string(new)
        pos = index + old.length()
      }
      None => {
        out.write_string(substring(text, pos, text.length()))
        return out.to_string()
      }
    }
  }
  out.to_string()
}

///|
fn decode_code_html(text : String) -> String {
  replace_all(
    replace_all(
      replace_all(
        replace_all(replace_all(text, "&lt;", "<"), "&gt;", ">"),
        "&quot;",
        "\"",
      ),
      "&#39;",
      "'",
    ),
    "&amp;",
    "&",
  )
}

///|
fn escape_code_html(text : String) -> String {
  let out = StringBuilder::new()
  for char in text {
    match char {
      '&' => out.write_string("&amp;")
      '<' => out.write_string("&lt;")
      '>' => out.write_string("&gt;")
      '"' => out.write_string("&quot;")
      '\'' => out.write_string("&#39;")
      _ => out.write_char(char)
    }
  }
  out.to_string()
}

///|
fn is_alpha(char : Char) -> Bool {
  (char >= 'a' && char <= 'z') || (char >= 'A' && char <= 'Z')
}

///|
fn is_digit(char : Char) -> Bool {
  char >= '0' && char <= '9'
}

///|
fn is_ident_start(char : Char) -> Bool {
  is_alpha(char) || char == '_' || char == '`'
}

///|
fn is_ident_part(char : Char) -> Bool {
  is_alpha(char) || is_digit(char) || char == '_' || char == '-' || char == '`'
}

///|
fn is_pkl_keyword(text : String) -> Bool {
  match text {
    "module"
    | "import"
    | "as"
    | "amends"
    | "extends"
    | "class"
    | "typealias"
    | "function"
    | "local"
    | "let"
    | "new"
    | "if"
    | "else"
    | "is"
    | "for"
    | "when"
    | "trace"
    | "read"
    | "read?"
    | "external"
    | "abstract"
    | "open"
    | "hidden"
    | "fixed"
    | "const" => true
    _ => false
  }
}

///|
fn is_pkl_type(text : String) -> Bool {
  match text {
    "Any"
    | "Unknown"
    | "Nothing"
    | "String"
    | "Boolean"
    | "Bool"
    | "Int"
    | "Float"
    | "Number"
    | "Duration"
    | "DataSize"
    | "Listing"
    | "Mapping"
    | "Dynamic"
    | "Typed"
    | "Regex"
    | "Pair"
    | "Set" => true
    _ => false
  }
}

///|
fn is_pkl_literal(text : String) -> Bool {
  match text {
    "true" | "false" | "null" => true
    _ => false
  }
}

///|
fn next_non_space(chars : Array[Char], start : Int) -> Char? {
  let mut pos = start
  while pos < chars.length() {
    let char = chars[pos]
    if char != ' ' && char != '\t' {
      return Some(char)
    }
    pos += 1
  }
  None
}

///|
fn write_code_token(
  out : StringBuilder,
  class_name : String,
  text : String,
) -> Unit {
  out.write_string("<span class=\"")
  out.write_string(class_name)
  out.write_string("\">")
  out.write_string(escape_code_html(text))
  out.write_string("</span>")
}

///|
fn highlight_pkl_line(line : String) -> String {
  let out = StringBuilder::new()
  let chars = line.to_array()
  let len = chars.length()
  let mut pos = 0
  while pos < len {
    let char = chars[pos]
    if char == '/' && pos + 1 < len && chars[pos + 1] == '/' {
      write_code_token(out, "tok-comment", substring(line, pos, len))
      pos = len
    } else if char == '"' {
      let start = pos
      pos += 1
      let mut escaped = false
      while pos < len {
        let current = chars[pos]
        if escaped {
          escaped = false
        } else if current == '\\' {
          escaped = true
        } else if current == '"' {
          pos += 1
          break
        }
        pos += 1
      }
      write_code_token(out, "tok-string", substring(line, start, pos))
    } else if is_digit(char) {
      let start = pos
      pos += 1
      while pos < len && (is_digit(chars[pos]) || chars[pos] == '.') {
        pos += 1
      }
      write_code_token(out, "tok-number", substring(line, start, pos))
    } else if is_ident_start(char) {
      let start = pos
      pos += 1
      while pos < len && is_ident_part(chars[pos]) {
        pos += 1
      }
      let word = substring(line, start, pos)
      if is_pkl_keyword(word) {
        write_code_token(out, "tok-keyword", word)
      } else if is_pkl_type(word) {
        write_code_token(out, "tok-type", word)
      } else if is_pkl_literal(word) {
        write_code_token(out, "tok-literal", word)
      } else {
        match next_non_space(chars, pos) {
          Some(':') | Some('=') => write_code_token(out, "tok-property", word)
          Some('(') => write_code_token(out, "tok-call", word)
          _ => out.write_string(escape_code_html(word))
        }
      }
    } else {
      match char {
        '{' | '}' | '[' | ']' | '(' | ')' | ',' | '.' =>
          write_code_token(
            out,
            "tok-punctuation",
            substring(line, pos, pos + 1),
          )
        ':' | '=' | '+' | '-' | '*' | '/' | '|' | '?' | '!' | '<' | '>' =>
          write_code_token(out, "tok-operator", substring(line, pos, pos + 1))
        _ => out.write_char(char)
      }
      pos += 1
    }
  }
  out.to_string()
}

///|
fn highlight_pkl(source : String) -> String {
  let out = StringBuilder::new()
  out.write_string("<pre class=\"highlight pkl-highlight\"><code>")
  let mut first = true
  for line in source.split("\n") {
    if first {
      first = false
    } else {
      out.write_char('\n')
    }
    out.write_string("<span class=\"line\">")
    out.write_string(highlight_pkl_line(line.to_owned()))
    out.write_string("</span>")
  }
  out.write_string("</code></pre>")
  out.to_string()
}

///|
fn highlight_plain(source : String) -> String {
  let out = StringBuilder::new()
  out.write_string("<pre class=\"highlight plain-highlight\"><code>")
  let mut first = true
  for line in source.split("\n") {
    if first {
      first = false
    } else {
      out.write_char('\n')
    }
    out.write_string("<span class=\"line\">")
    out.write_string(escape_code_html(line.to_owned()))
    out.write_string("</span>")
  }
  out.write_string("</code></pre>")
  out.to_string()
}

///|
fn highlight_code(lang : String, source : String) -> String {
  let highlighted = match lang {
    "pkl" => highlight_pkl(source)
    "bash" | "sh" | "shell" => @highlight_bash.highlight_bash(source)
    "moonbit" | "mbt" => @highlight_moonbit.highlight_moonbit(source)
    "json" => @highlight_json.highlight_json(source)
    _ => highlight_plain(source)
  }
  replace_all(
    highlighted, "</span>\n<span class=\"line\">", "</span><span class=\"line\">",
  )
}

///|
fn code_language_label(lang : String) -> String {
  if lang.is_empty() {
    "text"
  } else {
    lang
  }
}

///|
fn trim_code_block_tail(source : String) -> String {
  let mut text = source
  while text.has_suffix("\n") || text.has_suffix("\r") {
    if text.has_suffix("\n") {
      text = trim_suffix(text, "\n")
    } else {
      text = trim_suffix(text, "\r")
    }
  }
  text
}

///|
fn render_code_block(lang : String, source : String) -> String {
  let label = code_language_label(lang)
  let code = trim_code_block_tail(source)
  "<div class=\"code-block\" data-language=\"" +
  html_escape(label) +
  "\"><div class=\"code-block-toolbar\"><span class=\"code-language\">" +
  html_escape(label) +
  "</span><button class=\"copy-code-button\" type=\"button\" aria-label=\"Copy code\">Copy</button></div>" +
  highlight_code(lang, code) +
  "</div>"
}

///|
fn highlight_code_blocks(html : String) -> String {
  let open_marker = "<pre><code class=\"language-"
  let lang_end_marker = "\">"
  let close_marker = "</code></pre>"
  let out = StringBuilder::new()
  let mut pos = 0
  while true {
    match find_from(html, open_marker, pos) {
      Some(start) => {
        let lang_start = start + open_marker.length()
        match find_from(html, lang_end_marker, lang_start) {
          Some(lang_end) => {
            let code_start = lang_end + lang_end_marker.length()
            match find_from(html, close_marker, code_start) {
              Some(code_end) => {
                out.write_string(substring(html, pos, start))
                let lang = decode_code_html(
                  substring(html, lang_start, lang_end),
                )
                let code = decode_code_html(
                  substring(html, code_start, code_end),
                )
                out.write_string(render_code_block(lang, code))
                pos = code_end + close_marker.length()
              }
              None => {
                out.write_string(substring(html, pos, html.length()))
                return out.to_string()
              }
            }
          }
          None => {
            out.write_string(substring(html, pos, html.length()))
            return out.to_string()
          }
        }
      }
      None => {
        out.write_string(substring(html, pos, html.length()))
        return out.to_string()
      }
    }
  }
  out.to_string()
}

///|
fn install_tab_button(id : String, label : String, selected : Bool) -> String {
  "<button class=\"tab-button\" type=\"button\" role=\"tab\" id=\"tab-" +
  id +
  "\" aria-controls=\"panel-" +
  id +
  "\" aria-selected=\"" +
  (if selected { "true" } else { "false" }) +
  "\" tabindex=\"" +
  (if selected { "0" } else { "-1" }) +
  "\">" +
  html_escape(label) +
  "</button>"
}

///|
fn install_tab_panel(
  id : String,
  label : String,
  summary : String,
  code : String,
  selected : Bool,
) -> String {
  "<section class=\"tab-panel\" role=\"tabpanel\" id=\"panel-" +
  id +
  "\" aria-labelledby=\"tab-" +
  id +
  "\"" +
  (if selected { "" } else { " hidden" }) +
  "><h3>" +
  html_escape(label) +
  "</h3><p>" +
  html_escape(summary) +
  "</p>" +
  render_code_block("bash", code) +
  "</section>"
}

///|
fn install_tabs_html() -> String {
  "<div class=\"install-tabs\" data-tabs><div class=\"tab-list\" role=\"tablist\" aria-label=\"Pkl installation methods\">" +
  install_tab_button("nix", "Nix", true) +
  install_tab_button("mise", "Mise", false) +
  install_tab_button("macos", "macOS", false) +
  install_tab_button("linux", "Linux", false) +
  install_tab_button("windows", "Windows", false) +
  install_tab_button("java", "Java", false) +
  "</div><div class=\"tab-panels\">" +
  install_tab_panel(
    "nix", "Nix", "Use the nixpkgs package for reproducible shells, profile installs, or project flakes.",
    "# Try Pkl without installing it globally\nnix shell nixpkgs#pkl -c pkl --version\n# Install it into your user profile\nnix profile install nixpkgs#pkl\npkl --version\n# Add to a dev shell\n# packages = [ pkgs.pkl ];",
    true,
  ) +
  install_tab_panel(
    "mise", "Mise", "Versioned install for macOS, Linux, and Windows.", "# Install and activate Pkl globally\nmise use -g pkl@0.31.1\npkl --version\n# Or activate it in the current project\nmise use pkl@0.31.1",
    false,
  ) +
  install_tab_panel(
    "macos", "macOS", "Use the native executable directly, or use Homebrew if that is how the machine is managed.",
    "# Apple Silicon\ncurl -L -o pkl https://github.com/apple/pkl/releases/download/0.31.1/pkl-macos-aarch64\nchmod +x pkl\n./pkl --version\n# Intel\ncurl -L -o pkl https://github.com/apple/pkl/releases/download/0.31.1/pkl-macos-amd64\nchmod +x pkl\n./pkl --version\n# Package-manager option\nbrew install pkl",
    false,
  ) +
  install_tab_panel(
    "linux", "Linux", "Use the glibc native executable for common distributions, or the Alpine build for musl-based environments.",
    "# aarch64\ncurl -L -o pkl https://github.com/apple/pkl/releases/download/0.31.1/pkl-linux-aarch64\nchmod +x pkl\n./pkl --version\n# amd64\ncurl -L -o pkl https://github.com/apple/pkl/releases/download/0.31.1/pkl-linux-amd64\nchmod +x pkl\n./pkl --version\n# Alpine amd64\ncurl -L -o pkl https://github.com/apple/pkl/releases/download/0.31.1/pkl-alpine-linux-amd64\nchmod +x pkl\n./pkl --version",
    false,
  ) +
  install_tab_panel(
    "windows", "Windows", "Use Windows Package Manager, or download the native executable manually.",
    "# Windows Package Manager\nwinget install Apple.Pkl\npkl --version\n# Manual native executable\nInvoke-WebRequest https://github.com/apple/pkl/releases/download/0.31.1/pkl-windows-amd64.exe -OutFile pkl.exe\n.\\pkl.exe --version",
    false,
  ) +
  install_tab_panel(
    "java", "Java", "Use the Java executable when a Java 17+ runtime is the most portable option.",
    "# macOS / Linux\ncurl -L -o jpkl https://repo1.maven.org/maven2/org/pkl-lang/pkl-cli-java/0.31.1/pkl-cli-java-0.31.1.jar\nchmod +x jpkl\n./jpkl --version\n# Windows\nInvoke-WebRequest https://repo1.maven.org/maven2/org/pkl-lang/pkl-cli-java/0.31.1/pkl-cli-java-0.31.1.jar -OutFile jpkl.bat\n.\\jpkl.bat --version",
    false,
  ) +
  "</div></div>"
}

///|
fn expand_components(html : String) -> String {
  replace_all(html, "<p>{{ install-tabs }}</p>", install_tabs_html())
}

///|
pub fn page_from_markdown(path : String, source : String) -> DocPage {
  let parsed = @markdown.parse(source)
  let frontmatter = parsed.document.frontmatter
  let slug = slug_from_path(path)
  let title = metadata_string(frontmatter, "title", fallback_title(source))
  DocPage::{
    slug,
    href: href_from_slug(slug),
    path: path_from_slug(slug),
    source_path: path,
    title,
    section: metadata_string(frontmatter, "section", "Guides"),
    description: metadata_string(frontmatter, "description", ""),
    order: metadata_int(frontmatter, "order", 1000),
    html: expand_components(
      highlight_code_blocks(@markdown.render_html(parsed.document)),
    ),
  }
}

///|
fn copy_pages(pages : Array[DocPage]) -> Array[DocPage] {
  let copied : Array[DocPage] = []
  for page in pages {
    copied.push(page)
  }
  copied
}

///|
fn sorted_pages(pages : Array[DocPage]) -> Array[DocPage] {
  let copied = copy_pages(pages)
  copied.sort_by(fn(left, right) {
    if left.order < right.order {
      -1
    } else if left.order > right.order {
      1
    } else if left.title < right.title {
      -1
    } else if left.title > right.title {
      1
    } else {
      0
    }
  })
  copied
}

///|
fn depth_prefix(path : String) -> String {
  let mut prefix = ""
  for char in path {
    if char == '/' {
      prefix = prefix + "../"
    }
  }
  prefix
}

///|
fn nav_href(current : DocPage, target : DocPage) -> String {
  depth_prefix(current.path) + target.href
}

///|
fn nav_html(current : DocPage, pages : Array[DocPage]) -> String {
  let items : Array[String] = []
  let sorted = sorted_pages(pages)
  let mut last_section = ""
  for page in sorted {
    if page.section != last_section {
      if last_section != "" {
        items.push("</div>")
      }
      items.push(
        "<div class=\"nav-section\"><p class=\"nav-section-title\">" +
        html_escape(page.section) +
        "</p>",
      )
      last_section = page.section
    }
    let active = if page.slug == current.slug { " is-active" } else { "" }
    items.push(
      "<a class=\"nav-link" +
      active +
      "\" href=\"" +
      html_escape(nav_href(current, page)) +
      "\"><span>" +
      html_escape(page.title) +
      "</span></a>",
    )
  }
  if last_section != "" {
    items.push("</div>")
  }
  items.join("")
}

///|
fn page_nav_link(
  current : DocPage,
  target : DocPage,
  label : String,
  rel : String,
  class_name : String,
) -> String {
  "<a class=\"page-nav-link " +
  class_name +
  "\" rel=\"" +
  rel +
  "\" href=\"" +
  html_escape(nav_href(current, target)) +
  "\"><span>" +
  label +
  "</span><strong>" +
  html_escape(target.title) +
  "</strong></a>"
}

///|
fn page_nav_html(current : DocPage, pages : Array[DocPage]) -> String {
  let sorted = sorted_pages(pages)
  let mut index = -1
  let mut cursor = 0
  for page in sorted {
    if page.slug == current.slug {
      index = cursor
    }
    cursor += 1
  }
  if index < 0 {
    return ""
  }
  let links : Array[String] = []
  if index > 0 {
    links.push(
      page_nav_link(current, sorted[index - 1], "Previous", "prev", "is-prev"),
    )
  }
  if index + 1 < sorted.length() {
    links.push(
      page_nav_link(current, sorted[index + 1], "Next", "next", "is-next"),
    )
  }
  if links.length() == 0 {
    ""
  } else {
    "<nav class=\"page-nav\" aria-label=\"Page navigation\">" +
    links.join("") +
    "</nav>"
  }
}

///|
fn top_links(current : DocPage, pages : Array[DocPage]) -> String {
  let links : Array[String] = []
  for page in sorted_pages(pages) {
    if page.slug == "learn/index" ||
      page.slug == "reference/api" ||
      page.slug == "reference/language" {
      links.push(
        "<a href=\"" +
        html_escape(nav_href(current, page)) +
        "\">" +
        html_escape(page.title) +
        "</a>",
      )
    }
  }
  links.join("")
}

///|
fn home_tracks_html() -> String {
  (
    #|<section class="track-grid" aria-label="Documentation paths">
    #|  <a class="track" href="learn/index.html"><span>Learn</span><strong>Build the first mental model.</strong><small>Values, objects, modules, imports, constraints, and rendering.</small></a>
    #|  <a class="track" href="reference/api.html"><span>API</span><strong>Map the implementation surface.</strong><small>Parser, evaluator, typechecker, analysis session, and renderer entry points.</small></a>
    #|  <a class="track" href="reference/language.html"><span>Spec</span><strong>Separate language rules from source notes.</strong><small>Syntax, semantics, compatibility notes, and official source links.</small></a>
    #|</section>
  )
}

///|
fn brand_mark_html() -> String {
  (
    #|<svg class="brand-mark" viewBox="0 0 520 360" role="img" aria-label="Pkl language specimen mark">
    #|  <g class="specimen-lines" aria-hidden="true">
    #|    <path d="M70 86H236"></path>
    #|    <path d="M70 123H188"></path>
    #|    <path d="M70 160H252"></path>
    #|    <path d="M70 197H216"></path>
    #|    <path d="M70 234H270"></path>
    #|  </g>
    #|  <path class="specimen-spine" d="M382 46c-64 0-73 48-73 82 0 32-23 43-54 52 31 9 54 20 54 52 0 34 9 82 73 82"></path>
    #|  <path class="specimen-echo" d="M408 66c-42 3-50 34-50 61 0 28-16 42-38 53 22 11 38 25 38 53 0 27 8 58 50 61"></path>
    #|  <path class="specimen-thread" d="M68 282c70-26 126-19 168 13 48 36 106 31 178-17">
    #|    <animate attributeName="opacity" values=".34;.58;.34" dur="10s" repeatCount="indefinite"></animate>
    #|  </path>
    #|</svg>
  )
}

///|
fn render_home_page(current : DocPage, pages : Array[DocPage]) -> String {
  let escaped_title = html_escape(page_title(current))
  let escaped_description = html_escape(current.description)
  let top = top_links(current, pages)
  let tracks = home_tracks_html()
  let mark = brand_mark_html()
  (
    $|<!doctype html>
    $|<html lang="en">
    $|<head>
    $|  <meta charset="utf-8">
    $|  <meta name="viewport" content="width=device-width, initial-scale=1">
    $|  <title>\{escaped_title}</title>
    $|  <meta name="description" content="\{escaped_description}">
    $|  <link rel="icon" type="image/svg+xml" href="assets/pkl-icon.svg">
    $|  <link rel="stylesheet" href="assets/site.css">
    $|</head>
    $|<body class="home-page" data-section="\{html_escape(current.section)}">
    $|  <main class="home-stage">
    $|    <section class="brand-system" aria-labelledby="home-title">
    $|      <div class="brand-copy">
    $|        <a class="home-brand" href="index.html" aria-label="Pkl home"><img src="assets/pkl-icon.svg" alt=""><span>Pkl</span><strong>Unofficial</strong></a>
    $|        <p class="home-kicker">Unofficial language documentation</p>
    $|        <h1 id="home-title">Pkl</h1>
    $|        <p class="home-lede">Learn Pkl's configuration model, read the language rules, and follow a clearer path through the ecosystem without confusing this site with Apple's official docs.</p>
    $|      </div>
    $|      \{mark}
    $|    </section>
    $|    <nav class="home-index" aria-label="Primary">\{top}</nav>
    $|    \{tracks}
    $|    <div class="home-meta" aria-label="Implementation stack">
    $|      <span>parser: mizchi/cst</span>
    $|      <span>analysis cache: mizchi/ripple</span>
    $|      <span>source: Markdown</span>
    $|    </div>
    $|    <article class="home-notes markdown-body">\{current.html}</article>
    $|  </main>
    $|  <script src="assets/site.js"></script>
    $|</body>
    $|</html>
  )
}

///|
fn page_title(current : DocPage) -> String {
  if current.slug == "index" {
    "Pkl"
  } else {
    current.title + " - Pkl"
  }
}

///|
fn render_page(current : DocPage, pages : Array[DocPage]) -> String {
  if current.slug == "index" {
    return render_home_page(current, pages)
  }
  let escaped_title = html_escape(page_title(current))
  let escaped_description = html_escape(current.description)
  let nav = nav_html(current, pages)
  let page_nav = page_nav_html(current, pages)
  let top = top_links(current, pages)
  (
    $|<!doctype html>
    $|<html lang="en">
    $|<head>
    $|  <meta charset="utf-8">
    $|  <meta name="viewport" content="width=device-width, initial-scale=1">
    $|  <title>\{escaped_title}</title>
    $|  <meta name="description" content="\{escaped_description}">
    $|  <link rel="icon" type="image/svg+xml" href="\{depth_prefix(current.path)}assets/pkl-icon.svg">
    $|  <link rel="stylesheet" href="\{depth_prefix(current.path)}assets/site.css">
    $|</head>
    $|<body data-section="\{html_escape(current.section)}">
    $|  <header class="topbar">
    $|    <a class="brand" href="\{depth_prefix(current.path)}index.html" aria-label="Pkl home"><img class="brand-logo" src="\{depth_prefix(current.path)}assets/pkl-icon.svg" alt=""><span>Pkl</span><strong>Unofficial</strong></a>
    $|    <nav class="topnav" aria-label="Primary">\{top}</nav>
    $|    <label class="search-box"><span>Search docs</span><input type="search" placeholder="Search docs" aria-label="Search docs"></label>
    $|    <button class="menu-button" type="button" aria-controls="site-shell" aria-expanded="false"><span></span><span></span></button>
    $|  </header>
    $|  <div id="site-shell" class="site-shell">
    $|    <aside class="sidebar" aria-label="Documentation navigation">\{nav}</aside>
    $|    <main class="content">
    $|      <article class="doc">
    $|        <header class="doc-header">
    $|          <p class="section-label">\{html_escape(current.section)}</p>
    $|          <h1>\{html_escape(current.title)}</h1>
    $|          <p>\{escaped_description}</p>
    $|        </header>
    $|        <div class="markdown-body">\{current.html}</div>
    $|        \{page_nav}
    $|      </article>
    $|    </main>
    $|  </div>
    $|  <script src="\{depth_prefix(current.path)}assets/site.js"></script>
    $|</body>
    $|</html>
  )
}

///|
pub fn render_site(pages : Array[DocPage]) -> Array[RenderedPage] {
  let rendered : Array[RenderedPage] = []
  for page in sorted_pages(pages) {
    rendered.push(RenderedPage::{
      path: page.path,
      html: render_page(page, pages),
    })
  }
  rendered
}

///|
pub fn site_assets() -> Array[SiteAsset] {
  [
    SiteAsset::{ path: "assets/site.css", content: site_css() },
    SiteAsset::{ path: "assets/site.js", content: site_js() },
  ]
}

///|
fn site_js() -> String {
  (
    #|const button = document.querySelector(".menu-button");
    #|const shell = document.querySelector("#site-shell");
    #|const search = document.querySelector(".search-box input");
    #|const links = Array.from(document.querySelectorAll(".nav-link"));
    #|const copyButtons = Array.from(document.querySelectorAll(".copy-code-button"));
    #|
    #|const copyTextWithSelection = (text) => {
    #|  const textarea = document.createElement("textarea");
    #|  textarea.value = text;
    #|  textarea.setAttribute("readonly", "");
    #|  textarea.style.position = "fixed";
    #|  textarea.style.top = "0";
    #|  textarea.style.left = "0";
    #|  textarea.style.width = "1px";
    #|  textarea.style.height = "1px";
    #|  textarea.style.opacity = "0";
    #|  document.body.appendChild(textarea);
    #|  textarea.focus();
    #|  textarea.select();
    #|  textarea.setSelectionRange(0, textarea.value.length);
    #|  try {
    #|    return document.execCommand("copy");
    #|  } finally {
    #|    textarea.remove();
    #|  }
    #|};
    #|
    #|const copyText = async (text) => {
    #|  if (copyTextWithSelection(text)) return true;
    #|  try {
    #|    if (navigator.clipboard) {
    #|      await navigator.clipboard.writeText(text);
    #|      return true;
    #|    }
    #|  } catch {}
    #|  return false;
    #|};
    #|
    #|const selectCode = (code) => {
    #|  const selection = window.getSelection();
    #|  if (!selection) return false;
    #|  const range = document.createRange();
    #|  range.selectNodeContents(code);
    #|  selection.removeAllRanges();
    #|  selection.addRange(range);
    #|  return true;
    #|};
    #|
    #|if (button && shell) {
    #|  button.addEventListener("click", () => {
    #|    const expanded = button.getAttribute("aria-expanded") === "true";
    #|    button.setAttribute("aria-expanded", expanded ? "false" : "true");
    #|    shell.classList.toggle("is-open", !expanded);
    #|  });
    #|}
    #|
    #|if (search) {
    #|  search.addEventListener("input", () => {
    #|    const query = search.value.trim().toLowerCase();
    #|    for (const link of links) {
    #|      link.hidden = query.length > 0 && !link.textContent.toLowerCase().includes(query);
    #|    }
    #|  });
    #|}
    #|
    #|for (const copyButton of copyButtons) {
    #|  copyButton.addEventListener("click", async () => {
    #|    const block = copyButton.closest(".code-block");
    #|    const code = block ? block.querySelector("pre code") : null;
    #|    if (!code) return;
    #|    const lines = Array.from(code.querySelectorAll(".line"));
    #|    const text = lines.length > 0 ? lines.map((line) => line.textContent).join("\n") : code.textContent.replace(/\n$/, "");
    #|    const previousText = copyButton.textContent;
    #|    const previousState = copyButton.dataset.state || "";
    #|    try {
    #|      const copied = await copyText(text);
    #|      if (!copied) throw new Error("Clipboard unavailable");
    #|      copyButton.textContent = "Copied";
    #|      copyButton.dataset.state = "copied";
    #|    } catch {
    #|      selectCode(code);
    #|      copyButton.textContent = "Selected";
    #|      copyButton.dataset.state = "selected";
    #|    }
    #|    window.setTimeout(() => {
    #|      copyButton.textContent = previousText || "Copy";
    #|      copyButton.dataset.state = previousState;
    #|    }, 1400);
    #|  });
    #|}
    #|
    #|for (const group of document.querySelectorAll("[data-tabs]")) {
    #|  const tabButtons = Array.from(group.querySelectorAll('[role="tab"]'));
    #|  const panels = Array.from(group.querySelectorAll('[role="tabpanel"]'));
    #|  const activate = (selected) => {
    #|    for (const tabButton of tabButtons) {
    #|      const active = tabButton === selected;
    #|      tabButton.setAttribute("aria-selected", active ? "true" : "false");
    #|      tabButton.tabIndex = active ? 0 : -1;
    #|    }
    #|    for (const panel of panels) {
    #|      panel.hidden = panel.id !== selected.getAttribute("aria-controls");
    #|    }
    #|  };
    #|  for (const tabButton of tabButtons) {
    #|    tabButton.addEventListener("click", () => activate(tabButton));
    #|    tabButton.addEventListener("keydown", (event) => {
    #|      const current = tabButtons.indexOf(tabButton);
    #|      const next = event.key === "ArrowRight" ? current + 1 : event.key === "ArrowLeft" ? current - 1 : current;
    #|      if (next === current) return;
    #|      event.preventDefault();
    #|      const wrapped = (next + tabButtons.length) % tabButtons.length;
    #|      tabButtons[wrapped].focus();
    #|      activate(tabButtons[wrapped]);
    #|    });
    #|  }
    #|}
  )
}

///|
fn site_css() -> String {
  (
    #|:root {
    #|  color-scheme: dark;
    #|  --paper: #090b07;
    #|  --bg: var(--paper);
    #|  --surface: #12150f;
    #|  --surface-raised: #171b13;
    #|  --ink: #edf2df;
    #|  --muted: #9ba48b;
    #|  --quiet: #626b55;
    #|  --line: rgba(237, 242, 223, 0.15);
    #|  --line-strong: rgba(237, 242, 223, 0.32);
    #|  --accent: #c8d987;
    #|  --accent-deep: #6b9543;
    #|  --accent-warm: #d0b36a;
    #|  --code: #070806;
    #|  --code-text: #edf2df;
    #|  --code-keyword: #d6e891;
    #|  --code-string: #d0b36a;
    #|  --code-number: #9fc46d;
    #|  --code-type: #b9dcd4;
    #|  --code-comment: #737c67;
    #|  --code-property: #e4e8d4;
    #|  --code-call: #c8d987;
    #|  --code-operator: #aab49b;
    #|}
    #|
    #|* {
    #|  box-sizing: border-box;
    #|}
    #|
    #|html {
    #|  scroll-behavior: smooth;
    #|}
    #|
    #|body {
    #|  margin: 0;
    #|  background: var(--paper);
    #|  color: var(--ink);
    #|  font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    #|  letter-spacing: 0;
    #|}
    #|
    #|a {
    #|  color: inherit;
    #|  text-decoration: none;
    #|}
    #|
    #|body.home-page {
    #|  background: var(--paper);
    #|}
    #|
    #|.home-stage {
    #|  position: relative;
    #|  width: min(1240px, 100%);
    #|  min-height: 100vh;
    #|  margin: 0 auto;
    #|  padding: clamp(34px, 6vw, 76px) clamp(20px, 4vw, 42px) 90px;
    #|}
    #|
    #|.brand-system {
    #|  display: grid;
    #|  grid-template-columns: minmax(0, 1fr) minmax(320px, 520px);
    #|  gap: clamp(36px, 7vw, 96px);
    #|  align-items: center;
    #|}
    #|
    #|.home-brand {
    #|  display: inline-flex;
    #|  align-items: center;
    #|  gap: 10px;
    #|  margin-bottom: clamp(42px, 8vh, 74px);
    #|  font-size: 15px;
    #|  font-weight: 720;
    #|}
    #|
    #|.home-brand img {
    #|  width: 28px;
    #|  height: 28px;
    #|}
    #|
    #|.home-brand strong {
    #|  border: 1px solid rgba(208, 179, 106, 0.42);
    #|  border-radius: 999px;
    #|  color: var(--accent-warm);
    #|  padding: 3px 8px;
    #|  font-size: 11px;
    #|  line-height: 1;
    #|}
    #|
    #|.home-index {
    #|  position: sticky;
    #|  top: 0;
    #|  z-index: 15;
    #|  display: flex;
    #|  flex-wrap: wrap;
    #|  gap: 18px;
    #|  justify-content: center;
    #|  border-top: 1px solid var(--line);
    #|  border-bottom: 1px solid var(--line);
    #|  margin-top: clamp(42px, 7vh, 70px);
    #|  padding: 13px 0;
    #|  background: rgba(9, 11, 7, 0.92);
    #|  backdrop-filter: blur(18px);
    #|  color: var(--muted);
    #|  font-size: 12px;
    #|  font-weight: 650;
    #|}
    #|
    #|.home-index a:hover {
    #|  color: var(--ink);
    #|  text-decoration: underline;
    #|  text-underline-offset: 4px;
    #|}
    #|
    #|.home-kicker {
    #|  margin: 0 0 18px;
    #|  color: var(--muted);
    #|  font-size: 12px;
    #|  font-weight: 780;
    #|  text-transform: uppercase;
    #|}
    #|
    #|.brand-copy h1 {
    #|  margin: 0;
    #|  font-size: clamp(52px, 8vw, 90px);
    #|  line-height: 0.96;
    #|  letter-spacing: 0;
    #|}
    #|
    #|.home-lede {
    #|  width: min(720px, 100%);
    #|  margin: 26px 0 0;
    #|  color: #d9deca;
    #|  font-size: clamp(17px, 1.8vw, 21px);
    #|  line-height: 1.48;
    #|}
    #|
    #|.brand-mark {
    #|  width: min(470px, 100%);
    #|  justify-self: center;
    #|  overflow: visible;
    #|}
    #|
    #|.brand-mark path,
    #|.brand-mark circle {
    #|  vector-effect: non-scaling-stroke;
    #|}
    #|
    #|.brand-mark .specimen-lines path {
    #|  fill: none;
    #|  stroke: rgba(237, 242, 223, 0.18);
    #|  stroke-width: 1;
    #|}
    #|
    #|.brand-mark .specimen-spine {
    #|  fill: none;
    #|  stroke: var(--accent);
    #|  stroke-width: 2.2;
    #|  stroke-linecap: round;
    #|  opacity: 0.78;
    #|}
    #|
    #|.brand-mark .specimen-echo {
    #|  fill: none;
    #|  stroke: rgba(200, 217, 135, 0.2);
    #|  stroke-width: 1;
    #|  stroke-linecap: round;
    #|}
    #|
    #|.brand-mark .specimen-thread {
    #|  fill: none;
    #|  stroke: var(--accent-deep);
    #|  stroke-width: 1.2;
    #|  stroke-linecap: round;
    #|  opacity: 0.55;
    #|}
    #|
    #|.track-grid {
    #|  display: grid;
    #|  grid-template-columns: repeat(3, minmax(0, 1fr));
    #|  gap: 1px;
    #|  margin-top: clamp(38px, 6vh, 62px);
    #|  background: var(--line);
    #|}
    #|
    #|.track {
    #|  display: grid;
    #|  align-content: start;
    #|  gap: 10px;
    #|  min-height: 190px;
    #|  background: var(--paper);
    #|  padding: 20px 20px 22px 0;
    #|}
    #|
    #|.track + .track {
    #|  padding-left: 20px;
    #|}
    #|
    #|.track span {
    #|  color: var(--muted);
    #|  font-size: 12px;
    #|  font-weight: 780;
    #|  text-transform: uppercase;
    #|}
    #|
    #|.track strong {
    #|  max-width: 330px;
    #|  font-size: clamp(20px, 2.4vw, 30px);
    #|  line-height: 1.08;
    #|}
    #|
    #|.track small {
    #|  max-width: 330px;
    #|  color: var(--muted);
    #|  font-size: 14px;
    #|  line-height: 1.48;
    #|}
    #|
    #|.track:hover strong {
    #|  text-decoration: underline;
    #|  text-underline-offset: 4px;
    #|}
    #|
    #|.home-meta {
    #|  display: flex;
    #|  flex-wrap: wrap;
    #|  gap: 10px 24px;
    #|  border-top: 1px solid var(--line);
    #|  border-bottom: 1px solid var(--line);
    #|  margin-top: 46px;
    #|  padding: 13px 0;
    #|  color: var(--muted);
    #|  font-size: 12px;
    #|  font-weight: 680;
    #|}
    #|
    #|.home-notes {
    #|  width: min(760px, 100%);
    #|  margin-top: 44px;
    #|  padding-bottom: 0;
    #|}
    #|
    #|.topbar {
    #|  position: sticky;
    #|  top: 0;
    #|  z-index: 20;
    #|  display: flex;
    #|  align-items: center;
    #|  justify-content: space-between;
    #|  width: min(1480px, 100%);
    #|  min-height: 58px;
    #|  margin: 0 auto;
    #|  padding: 14px clamp(24px, 4vw, 52px) 12px;
    #|  background: rgba(9, 11, 7, 0.92);
    #|  border-bottom: 1px solid var(--line);
    #|  backdrop-filter: blur(18px);
    #|}
    #|
    #|.brand,
    #|.topnav {
    #|  display: flex;
    #|  align-items: center;
    #|}
    #|
    #|.brand {
    #|  gap: 10px;
    #|  font-weight: 700;
    #|  font-size: 15px;
    #|}
    #|
    #|.brand-logo {
    #|  width: 26px;
    #|  height: 26px;
    #|}
    #|
    #|.brand strong {
    #|  border: 1px solid rgba(208, 179, 106, 0.42);
    #|  border-radius: 999px;
    #|  color: var(--accent-warm);
    #|  padding: 3px 8px;
    #|  font-size: 11px;
    #|  line-height: 1;
    #|}
    #|
    #|.topnav {
    #|  gap: 4px;
    #|}
    #|
    #|.topnav a {
    #|  padding: 9px 12px;
    #|  color: var(--muted);
    #|  font-size: 13px;
    #|  font-weight: 500;
    #|}
    #|
    #|.topnav a:hover {
    #|  color: var(--ink);
    #|  text-decoration: underline;
    #|  text-underline-offset: 4px;
    #|}
    #|
    #|.search-box {
    #|  position: relative;
    #|  display: flex;
    #|  align-items: center;
    #|  width: min(240px, 24vw);
    #|}
    #|
    #|.search-box span {
    #|  position: absolute;
    #|  width: 1px;
    #|  height: 1px;
    #|  overflow: hidden;
    #|  clip: rect(0, 0, 0, 0);
    #|}
    #|
    #|.search-box input {
    #|  width: 100%;
    #|  height: 34px;
    #|  border: 1px solid var(--line);
    #|  border-radius: 999px;
    #|  background: transparent;
    #|  padding: 0 13px;
    #|  color: var(--ink);
    #|  font: inherit;
    #|  font-size: 13px;
    #|}
    #|
    #|.search-box input:focus {
    #|  border-color: var(--line-strong);
    #|  outline: 2px solid rgba(243, 239, 230, 0.1);
    #|}
    #|
    #|.menu-button {
    #|  display: none;
    #|  width: 38px;
    #|  height: 38px;
    #|  border: 1px solid var(--line);
    #|  border-radius: 6px;
    #|  background: var(--surface);
    #|  padding: 9px;
    #|}
    #|
    #|.menu-button span {
    #|  display: block;
    #|  height: 2px;
    #|  margin: 5px 0;
    #|  background: var(--ink);
    #|}
    #|
    #|.site-shell {
    #|  display: grid;
    #|  grid-template-columns: minmax(270px, 310px) minmax(0, 1fr);
    #|  gap: clamp(44px, 5vw, 96px);
    #|  width: min(1480px, 100%);
    #|  margin: 0 auto;
    #|  padding: 34px clamp(24px, 4vw, 52px) 80px;
    #|}
    #|
    #|.sidebar {
    #|  position: sticky;
    #|  top: 92px;
    #|  align-self: start;
    #|  max-height: calc(100vh - 112px);
    #|  overflow: auto;
    #|  padding: 8px 0 24px;
    #|}
    #|
    #|.nav-section + .nav-section {
    #|  margin-top: 18px;
    #|}
    #|
    #|.nav-section-title {
    #|  margin: 0 0 8px;
    #|  color: var(--muted);
    #|  font-size: 12px;
    #|  font-weight: 500;
    #|  text-transform: none;
    #|}
    #|
    #|.nav-link {
    #|  display: grid;
    #|  gap: 3px;
    #|  padding: 8px 0 8px 12px;
    #|  border-left: 2px solid transparent;
    #|}
    #|
    #|.nav-link span {
    #|  font-size: 14px;
    #|  font-weight: 450;
    #|}
    #|
    #|.nav-link:hover,
    #|.nav-link.is-active {
    #|  border-left-color: var(--ink);
    #|}
    #|
    #|.content {
    #|  min-width: 0;
    #|}
    #|
    #|.eyebrow,
    #|.section-label {
    #|  margin: 0 0 12px;
    #|  color: var(--muted);
    #|  font-size: 12px;
    #|  font-weight: 500;
    #|  text-transform: none;
    #|}
    #|
    #|.doc {
    #|  width: min(1000px, 100%);
    #|  padding-bottom: 80px;
    #|}
    #|
    #|.home-doc {
    #|  margin-top: 38px;
    #|}
    #|
    #|.doc-header {
    #|  padding: 12px 0 24px;
    #|  border-bottom: 1px solid var(--line);
    #|}
    #|
    #|.doc-header h1 {
    #|  margin: 0;
    #|  font-size: clamp(30px, 4vw, 44px);
    #|  line-height: 1.1;
    #|}
    #|
    #|.doc-header p:last-child {
    #|  width: min(720px, 100%);
    #|  margin: 16px 0 0;
    #|  color: var(--muted);
    #|  font-size: 17px;
    #|  line-height: 1.55;
    #|}
    #|
    #|.markdown-body {
    #|  padding-top: 28px;
    #|  font-size: 16px;
    #|  line-height: 1.78;
    #|}
    #|
    #|.markdown-body h1 {
    #|  display: none;
    #|}
    #|
    #|.markdown-body h2 {
    #|  margin: 44px 0 12px;
    #|  font-size: 24px;
    #|  line-height: 1.2;
    #|}
    #|
    #|.markdown-body h3 {
    #|  margin: 30px 0 8px;
    #|  font-size: 20px;
    #|}
    #|
    #|.markdown-body p,
    #|.markdown-body ul,
    #|.markdown-body ol {
    #|  color: #d5d0c6;
    #|}
    #|
    #|.markdown-body a {
    #|  color: var(--ink);
    #|  font-weight: 650;
    #|  text-decoration: underline;
    #|  text-decoration-thickness: 1px;
    #|  text-underline-offset: 3px;
    #|}
    #|
    #|.markdown-body code {
    #|  border-radius: 4px;
    #|  background: var(--surface);
    #|  padding: 0.16em 0.36em;
    #|  font: 0.92em ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    #|}
    #|
    #|.markdown-body pre {
    #|  overflow: auto;
    #|  border-radius: 6px;
    #|  background: var(--code);
    #|  padding: 12px 16px 13px;
    #|  color: var(--code-text);
    #|}
    #|
    #|.markdown-body pre code {
    #|  background: transparent;
    #|  padding: 0;
    #|  color: inherit;
    #|  display: block;
    #|  line-height: 1.42;
    #|}
    #|
    #|.markdown-body .code-block {
    #|  overflow: hidden;
    #|  border: 1px solid rgba(237, 242, 223, 0.12);
    #|  border-radius: 6px;
    #|  margin: 20px 0;
    #|  background: var(--code);
    #|}
    #|
    #|.markdown-body .code-block-toolbar {
    #|  display: flex;
    #|  align-items: center;
    #|  justify-content: space-between;
    #|  gap: 12px;
    #|  min-height: 32px;
    #|  border-bottom: 1px solid rgba(237, 242, 223, 0.1);
    #|  padding: 4px 8px 4px 12px;
    #|  color: var(--code-comment);
    #|  font: 12px ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    #|}
    #|
    #|.markdown-body .code-language {
    #|  overflow: hidden;
    #|  text-overflow: ellipsis;
    #|  white-space: nowrap;
    #|  letter-spacing: 0;
    #|}
    #|
    #|.copy-code-button {
    #|  flex: 0 0 auto;
    #|  border: 1px solid rgba(237, 242, 223, 0.18);
    #|  border-radius: 4px;
    #|  background: rgba(237, 242, 223, 0.04);
    #|  padding: 4px 8px;
    #|  color: var(--code-text);
    #|  font: inherit;
    #|  cursor: pointer;
    #|}
    #|
    #|.copy-code-button:hover,
    #|.copy-code-button:focus-visible {
    #|  border-color: rgba(237, 242, 223, 0.34);
    #|  background: rgba(237, 242, 223, 0.08);
    #|}
    #|
    #|.copy-code-button[data-state="copied"] {
    #|  border-color: rgba(200, 217, 135, 0.42);
    #|  color: var(--accent);
    #|}
    #|
    #|.copy-code-button[data-state="selected"] {
    #|  border-color: rgba(208, 179, 106, 0.42);
    #|  color: var(--accent-warm);
    #|}
    #|
    #|.markdown-body .code-block pre {
    #|  margin: 0;
    #|  border-radius: 0;
    #|  border: 0;
    #|}
    #|
    #|.markdown-body .install-tabs {
    #|  margin: 18px 0 28px;
    #|  border: 1px solid var(--line);
    #|  background: rgba(18, 21, 15, 0.72);
    #|  overflow: hidden;
    #|}
    #|
    #|.markdown-body .tab-list {
    #|  display: flex;
    #|  gap: 0;
    #|  overflow-x: auto;
    #|  border-bottom: 1px solid var(--line);
    #|  background: rgba(7, 8, 6, 0.36);
    #|}
    #|
    #|.markdown-body .tab-button {
    #|  appearance: none;
    #|  border: 0;
    #|  border-right: 1px solid var(--line);
    #|  background: transparent;
    #|  color: var(--muted);
    #|  padding: 10px 14px;
    #|  font: inherit;
    #|  font-size: 0.86rem;
    #|  cursor: pointer;
    #|  white-space: nowrap;
    #|}
    #|
    #|.markdown-body .tab-button[aria-selected="true"] {
    #|  color: var(--ink);
    #|  background: rgba(200, 217, 135, 0.09);
    #|}
    #|
    #|.markdown-body .tab-button:focus-visible {
    #|  outline: 2px solid var(--accent);
    #|  outline-offset: -2px;
    #|}
    #|
    #|.markdown-body .tab-panel {
    #|  padding: 16px;
    #|}
    #|
    #|.markdown-body .tab-panel[hidden] {
    #|  display: none;
    #|}
    #|
    #|.markdown-body .tab-panel h3 {
    #|  margin-top: 0;
    #|  font-size: 1rem;
    #|}
    #|
    #|.markdown-body .tab-panel p {
    #|  margin-top: 0;
    #|}
    #|
    #|.markdown-body .highlight {
    #|  background: var(--code) !important;
    #|  color: var(--code-text) !important;
    #|}
    #|
    #|.markdown-body .highlight .line {
    #|  display: block;
    #|  min-height: 1.42em;
    #|}
    #|
    #|.tok-keyword {
    #|  color: var(--code-keyword);
    #|  font-weight: 650;
    #|}
    #|
    #|.tok-string {
    #|  color: var(--code-string);
    #|}
    #|
    #|.tok-number,
    #|.tok-literal {
    #|  color: var(--code-number);
    #|}
    #|
    #|.tok-type {
    #|  color: var(--code-type);
    #|}
    #|
    #|.tok-comment {
    #|  color: var(--code-comment);
    #|  font-style: italic;
    #|}
    #|
    #|.tok-property {
    #|  color: var(--code-property);
    #|}
    #|
    #|.tok-call {
    #|  color: var(--code-call);
    #|}
    #|
    #|.tok-punctuation,
    #|.tok-operator {
    #|  color: var(--code-operator);
    #|}
    #|
    #|.markdown-body table {
    #|  width: 100%;
    #|  border-collapse: collapse;
    #|  margin: 24px 0;
    #|  font-size: 14px;
    #|}
    #|
    #|.markdown-body th,
    #|.markdown-body td {
    #|  border-bottom: 1px solid var(--line);
    #|  padding: 10px 12px;
    #|  text-align: left;
    #|}
    #|
    #|.markdown-body blockquote {
    #|  margin: 24px 0;
    #|  border-left: 3px solid var(--accent);
    #|  padding-left: 16px;
    #|  color: var(--muted);
    #|}
    #|
    #|.page-nav {
    #|  display: grid;
    #|  grid-template-columns: repeat(2, minmax(0, 1fr));
    #|  gap: 24px;
    #|  margin-top: 54px;
    #|  border-top: 1px solid var(--line);
    #|  padding-top: 18px;
    #|}
    #|
    #|.page-nav-link {
    #|  display: grid;
    #|  gap: 6px;
    #|  color: var(--ink);
    #|  text-decoration: none;
    #|}
    #|
    #|.page-nav-link span {
    #|  color: var(--muted);
    #|  font-size: 12px;
    #|  font-weight: 500;
    #|  text-transform: none;
    #|}
    #|
    #|.page-nav-link strong {
    #|  font-size: 16px;
    #|  line-height: 1.3;
    #|}
    #|
    #|.page-nav-link.is-next {
    #|  text-align: right;
    #|}
    #|
    #|.page-nav-link:hover strong,
    #|.page-nav-link:focus-visible strong {
    #|  text-decoration: underline;
    #|  text-underline-offset: 4px;
    #|}
    #|
    #|@media (max-width: 920px) {
    #|  .topnav {
    #|    display: none;
    #|  }
    #|
    #|  .search-box {
    #|    width: min(220px, 38vw);
    #|  }
    #|
    #|  .menu-button {
    #|    display: block;
    #|  }
    #|
    #|  .site-shell {
    #|    grid-template-columns: 1fr;
    #|    gap: 0;
    #|    padding: 18px 20px 64px;
    #|  }
    #|
    #|  .sidebar {
    #|    display: none;
    #|    position: static;
    #|    max-height: none;
    #|    border-bottom: 1px solid var(--line);
    #|    margin-bottom: 20px;
    #|  }
    #|
    #|  .site-shell.is-open .sidebar {
    #|    display: block;
    #|  }
    #|
    #|  .brand-system {
    #|    grid-template-columns: 1fr;
    #|  }
    #|
    #|  .brand-mark {
    #|    width: min(360px, 100%);
    #|  }
    #|
    #|  .home-index {
    #|    justify-content: flex-start;
    #|  }
    #|
    #|  .track-grid {
    #|    grid-template-columns: 1fr;
    #|  }
    #|
    #|  .track,
    #|  .track + .track {
    #|    min-height: 0;
    #|    padding: 18px 0;
    #|  }
    #|}
    #|
    #|@media (max-width: 560px) {
    #|  .topbar {
    #|    padding: 12px 16px;
    #|  }
    #|
    #|  .brand strong,
    #|  .search-box {
    #|    display: none;
    #|  }
    #|
    #|  .brand-copy h1 {
    #|    font-size: 50px;
    #|  }
    #|
    #|  .page-nav {
    #|    grid-template-columns: 1fr;
    #|  }
    #|
    #|  .page-nav-link.is-next {
    #|    text-align: left;
    #|  }
    #|
    #|}
  )
}
