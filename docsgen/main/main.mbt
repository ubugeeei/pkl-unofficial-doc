///|
fn usage() -> Unit {
  println("usage: docsgen [content-dir] [dist-dir]")
}

///|
fn fail(message : String) -> Unit {
  println(message)
  @sys.exit(1)
}

///|
fn join_path(base : String, name : String) -> String {
  if base.has_suffix("/") {
    base + name
  } else {
    base + "/" + name
  }
}

///|
fn relative_path(root : String, path : String) -> String {
  let prefix = if root.has_suffix("/") { root } else { root + "/" }
  if path.has_prefix(prefix) {
    String::unsafe_substring(path, start=prefix.length(), end=path.length())
  } else {
    path
  }
}

///|
fn parent_dir(path : String) -> String? {
  match path.rev_find("/") {
    Some(index) => Some(String::unsafe_substring(path, start=0, end=index))
    None => None
  }
}

///|
fn ensure_dir(path : String) -> Unit {
  @fs.create_dir(path) catch {
    _ => fail("failed to create \{path}")
  }
}

///|
fn ensure_parent(path : String) -> Unit {
  match parent_dir(path) {
    Some(dir) => ensure_dir(dir)
    None => ()
  }
}

///|
fn is_markdown_file(path : String) -> Bool {
  path.has_suffix(".md")
}

///|
fn collect_markdown_files(dir : String, out : Array[String]) -> Unit {
  let entries = @fs.read_dir(dir) catch {
    _ => {
      fail("failed to read \{dir}")
      []
    }
  }
  entries.sort()
  for entry in entries {
    let path = join_path(dir, entry)
    let is_directory = @fs.is_dir(path) catch { _ => false }
    if is_directory {
      collect_markdown_files(path, out)
    } else if is_markdown_file(path) {
      out.push(path)
    }
  }
}

///|
fn load_pages(content_dir : String) -> Array[@docsgen.DocPage] {
  let paths : Array[String] = []
  collect_markdown_files(content_dir, paths)
  let pages : Array[@docsgen.DocPage] = []
  for path in paths {
    let source = @fs.read_file_to_string(path) catch {
      _ => {
        fail("failed to read \{path}")
        ""
      }
    }
    let relative = relative_path(content_dir, path)
    pages.push(@docsgen.page_from_markdown("docs/content/" + relative, source))
  }
  pages
}

///|
fn write_text(path : String, content : String) -> Unit {
  ensure_parent(path)
  @fs.write_string_to_file(path, content) catch {
    _ => fail("failed to write \{path}")
  }
}

///|
fn write_bytes(path : String, content : Bytes) -> Unit {
  ensure_parent(path)
  @fs.write_bytes_to_file(path, content) catch {
    _ => fail("failed to write \{path}")
  }
}

///|
fn copy_asset_dir(asset_dir : String, dist_dir : String) -> Unit {
  if !@fs.path_exists(asset_dir) {
    return
  }
  let entries = @fs.read_dir(asset_dir) catch {
    _ => {
      fail("failed to read \{asset_dir}")
      []
    }
  }
  entries.sort()
  for entry in entries {
    let source = join_path(asset_dir, entry)
    let is_directory = @fs.is_dir(source) catch { _ => false }
    if is_directory {
      copy_asset_dir(source, join_path(dist_dir, entry))
    } else if entry != "README.md" {
      let content = @fs.read_file_to_bytes(source) catch {
        _ => {
          fail("failed to read \{source}")
          b""
        }
      }
      write_bytes(join_path(dist_dir, entry), content)
    }
  }
}

///|
fn main {
  let args = @sys.get_cli_args()
  let (content_dir, dist_dir) = if args.length() == 1 {
    ("docs/content", "docs/dist")
  } else if args.length() == 3 {
    (args[1], args[2])
  } else {
    usage()
    @sys.exit(1)
    ("", "")
  }

  ensure_dir(dist_dir)
  let pages = load_pages(content_dir)
  for rendered in @docsgen.render_site(pages) {
    write_text(join_path(dist_dir, rendered.path), rendered.html)
  }
  for asset in @docsgen.site_assets() {
    write_text(join_path(dist_dir, asset.path), asset.content)
  }
  copy_asset_dir("docs/assets", join_path(dist_dir, "assets"))
  println("generated \{pages.length()} pages into \{dist_dir}")
}
