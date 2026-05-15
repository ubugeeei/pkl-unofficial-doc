///|
fn usage() -> Unit {
  println("usage: docsserve [dist-dir] [port]")
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
fn strip_query(path : String) -> String {
  match path.rev_find("?") {
    Some(index) => String::unsafe_substring(path, start=0, end=index)
    None => path
  }
}

///|
fn trim_leading_slash(path : String) -> String {
  if path.has_prefix("/") {
    String::unsafe_substring(path, start=1, end=path.length())
  } else {
    path
  }
}

///|
fn is_safe_route(path : String) -> Bool {
  !(path == "/.." ||
  path.has_prefix("/../") ||
  path.has_suffix("/..") ||
  path.contains("/../") ||
  path.contains("\\"))
}

///|
fn route_to_relative(path : String) -> String? {
  let route = strip_query(path)
  if !is_safe_route(route) {
    return None
  }
  let relative = trim_leading_slash(route)
  if relative == "" {
    Some("index.html")
  } else if relative.has_suffix("/") {
    Some(relative + "index.html")
  } else {
    Some(relative)
  }
}

///|
fn content_type(path : String) -> String {
  if path.has_suffix(".html") {
    "text/html; charset=utf-8"
  } else if path.has_suffix(".css") {
    "text/css; charset=utf-8"
  } else if path.has_suffix(".js") {
    "text/javascript; charset=utf-8"
  } else if path.has_suffix(".svg") {
    "image/svg+xml"
  } else if path.has_suffix(".png") {
    "image/png"
  } else if path.has_suffix(".jpg") || path.has_suffix(".jpeg") {
    "image/jpeg"
  } else if path.has_suffix(".webp") {
    "image/webp"
  } else if path.has_suffix(".ico") {
    "image/x-icon"
  } else if path.has_suffix(".json") {
    "application/json; charset=utf-8"
  } else if path.has_suffix(".txt") {
    "text/plain; charset=utf-8"
  } else if path.has_suffix(".wasm") {
    "application/wasm"
  } else {
    "application/octet-stream"
  }
}

///|
async fn resolve_file(root : String, request_path : String) -> String? {
  match route_to_relative(request_path) {
    None => None
    Some(relative) => {
      let direct = join_path(root, relative)
      if @fs.exists(direct) {
        match @fs.kind(direct) {
          Regular => Some(direct)
          Directory => {
            let index = join_path(direct, "index.html")
            if @fs.exists(index) {
              Some(index)
            } else {
              None
            }
          }
          _ => None
        }
      } else if !relative.has_suffix(".html") {
        let index = join_path(root, relative + "/index.html")
        if @fs.exists(index) {
          Some(index)
        } else {
          None
        }
      } else {
        None
      }
    }
  }
}

///|
async fn send_text(
  conn : @http.ServerConnection,
  code : Int,
  reason : String,
  text : String,
) -> Unit {
  conn.send_response(code, reason, extra_headers={
    "Content-Type": "text/plain; charset=utf-8",
  })
  conn.write(text)
  conn.end_response()
}

///|
async fn send_file(conn : @http.ServerConnection, path : String) -> Unit {
  let file = @fs.open(path, mode=ReadOnly)
  defer file.close()
  conn.send_response(200, "OK", extra_headers={
    "Content-Type": content_type(path),
    "Content-Length": file.size().to_string(),
  })
  conn.write_reader(file)
  conn.end_response()
}

///|
fn is_supported_method(meth : @http.RequestMethod) -> Bool {
  meth is Get
}

///|
async fn serve(
  server : @http.Server,
  root~ : String,
  log? : (String) -> Unit = println,
) -> Unit {
  server.run_forever((request, _body, conn) => {
    guard is_supported_method(request.meth) else {
      send_text(conn, 405, "Method Not Allowed", "Method Not Allowed\n")
      return
    }
    match resolve_file(root, request.path) {
      Some(path) => {
        log("\{request.path} -> \{path}")
        send_file(conn, path)
      }
      None => {
        log("\{request.path} -> 404")
        send_text(conn, 404, "Not Found", "Not Found\n")
      }
    }
  })
}

///|
async fn main {
  let args = @env.args()
  let (root, port) = match args {
    [] | [_] => ("docs/dist", "4173")
    [_, root] => (root, "4173")
    [_, root, port] => (root, port)
    _ => {
      usage()
      return
    }
  }
  let addr = @socket.Addr::parse("127.0.0.1:\{port}")
  let server = @http.Server(addr)
  println("serving \{root} at http://127.0.0.1:\{port}/")
  serve(server, root~) catch {
    err => println("server terminated: \{err}")
  }
}

///|
test "routes resolve to static html entries" {
  match route_to_relative("/") {
    Some(path) => inspect(path, content="index.html")
    None => inspect("none", content="index.html")
  }
  match route_to_relative("/learn/") {
    Some(path) => inspect(path, content="learn/index.html")
    None => inspect("none", content="learn/index.html")
  }
  match route_to_relative("/reference/api.html?from=search") {
    Some(path) => inspect(path, content="reference/api.html")
    None => inspect("none", content="reference/api.html")
  }
}

///|
test "routes reject traversal and windows separators" {
  inspect(is_safe_route("/learn/index.html"), content="true")
  inspect(is_safe_route("/../moon.mod.json"), content="false")
  inspect(is_safe_route("/learn/../../moon.mod.json"), content="false")
  inspect(is_safe_route("/learn\\index.html"), content="false")
}

///|
test "content types cover generated docs assets" {
  inspect(content_type("index.html"), content="text/html; charset=utf-8")
  inspect(content_type("assets/site.css"), content="text/css; charset=utf-8")
  inspect(content_type("assets/pkl-icon.svg"), content="image/svg+xml")
}
