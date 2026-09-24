# Technical plan

Status: proposal for the first milestone; no application implementation exists yet. Before coding, verify Quicklisp availability, Fedora system packages, and upstream changes for the chosen libraries.

## Recommendations

| Layer | Recommendation | Why and trade-offs | Alternatives |
|---|---|---|---|
| Lisp implementation | SBCL | Mature, fast, actively released, strong Linux support, and a capable interactive debugger. It has the broadest practical Common Lisp examples and deployment experience. | CCL is a possible alternative, but SBCL is the most practical starting point and deployment target. |
| GUI | GTK 4 through `cl-gtk4` | GTK 4 is the current toolkit direction, supports Linux/Wayland, and is available as distro packages. The binding exposes GTK 4 and Libadwaita. The binding is much smaller and younger than GTK itself, so its maintenance and API coverage must be validated with a prototype. | `cl-cffi-gtk` is better documented and established, but targets GTK 3. GTK 3 remains available but is a weaker choice for a new Linux-first app. Qt/CommonQt/Qtools carry greater maintenance risk and offer a less direct path to contemporary Linux desktop integration. |
| HTTP | Dexador | An idiomatic Common Lisp client with HTTPS, timeouts, redirects, and status handling. A synchronous request in a worker thread is enough initially. | Drakma is mature and well documented, but Dexador is a practical choice for a new client. |
| XML | CXML, using its streaming Klacks interface | A mature, namespace-aware XML parser. Streaming avoids retaining the whole document as a DOM; parser code maps RSS and Atom into the same model without involving the GUI. | XMLS is smaller and easier to approach, but parses the whole document into memory and offers less detailed error reporting. |
| SQLite | Start with a small prototype comparing `cl-dbi` plus its SQLite3 driver and a direct `cl-sqlite` binding | SQLite is embedded and needs no server. DBI provides a database-independent interface but adds dependencies; a direct binding is smaller and can make SQL easier to learn. Confirm prepared statements, transactions, Fedora packaging, and current upstream health before committing to one. | CLSQL is an older, broader framework. A hand-written CFFI binding is unnecessary for the first milestone. |
| URL and browser | QURI plus UIOP or GIO | QURI handles URL parsing. Open article URLs through GIO/default application integration when the binding supports it; otherwise use `uiop:launch-program` with `xdg-open`. | Calling `xdg-open` directly is simple, though GIO gives a more direct desktop integration path. |
| XDG paths | GLib/GIO where practical, otherwise a small POSIX helper or verified XDG library | Config under `$XDG_CONFIG_HOME`, database under `$XDG_DATA_HOME`, cache under `$XDG_CACHE_HOME`, with specification defaults. Never hardcode home paths or put user data beside the executable. | A small helper avoids another runtime dependency and is easy to teach. |

## Maintenance and technical risks

GTK upstream is active and GTK 4 is its current stable API. That does not guarantee equivalent activity in the Common Lisp binding. `cl-gtk4` has far fewer commits than GTK itself, so an initial spike must prove application/window lifecycle, GTK list models, signals, URI launching, and Fedora GTK 4 compatibility. `cl-cffi-gtk` has more documentation and tutorials, but is based on GTK 3. Proceed with GTK 4 unless the spike exposes a practical blocker; if so, evaluate the GTK 3 binding before substantial UI work.

Dexador is a practical, actively used HTTP choice; Drakma is a stable alternative with extensive documentation. CXML is an established XML parser; XMLS is easier to read but loads complete documents. SQLite binding health and ergonomics are less certain: decide between `cl-dbi` and a direct binding only after a small read/write prototype.

## ASDF systems and project layout

The `cl-rss-reader` ASDF system loads the core. `cl-rss-reader/gui` adds the GTK adapter, and `cl-rss-reader/tests` is a separate test system. GTK must not be a dependency of the model or parser so those layers can be explored and tested independently in the REPL.

```text
cl-rss-reader/
├── cl-rss-reader.asd
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── SECURITY.md
├── CHANGELOG.md
├── docs/technical-plan.md
├── src/
│   ├── packages.lisp
│   ├── model/article.lisp
│   ├── model/feed.lisp
│   ├── config/xdg.lisp
│   ├── net/http.lisp
│   ├── parser/xml-helpers.lisp
│   ├── parser/rss.lisp
│   ├── parser/atom.lisp
│   ├── storage/sqlite.lisp
│   ├── storage/schema.lisp
│   ├── application/state.lisp
│   ├── application/feeds.lisp
│   ├── application/articles.lisp
│   ├── gui/gtk-app.lisp
│   ├── gui/feed-list.lisp
│   ├── gui/article-list.lisp
│   └── gui/article-view.lisp
├── tests/
│   ├── package.lisp
│   ├── parser-rss.lisp
│   ├── parser-atom.lisp
│   └── storage.lisp
└── resources/
    ├── icons/
    └── ui/
```

## Packages and application state

Use `rss-reader.model`, `rss-reader.config`, `rss-reader.net`, `rss-reader.parser`, `rss-reader.storage`, `rss-reader.application`, and `rss-reader.gui`. Each package exports a small public API; UI code never queries the database directly.

Application state is a CLOS object holding repositories/database access, the selected feed or filter, and the GTK list model. Application functions change state and notify the UI through simple callbacks or signals. Avoid a complex event bus in v0.1. HTTP refresh runs in a worker so it does not block GTK's main loop; results return to the GTK main context.

## Model and storage

`feed` stores the URL, title, site URL, and last refresh time. `article` stores feed ID, stable source ID (RSS GUID/Atom ID, with URL or hash fallback), title, URL, author, published-at, summary, content, read, starred, first-seen, and updated-at. A unique constraint on `(feed_id, source_id)` prevents duplicates. Normalize dates to UTC; leave unknown dates as NIL.

Minimal tables: `feeds` and `articles`, with indexes for feed/date and read/starred views. Enable SQLite foreign keys and store schema version in `PRAGMA user_version`. Treat feed HTML as untrusted. For v0.1, display text or sanitized content rather than injecting remote markup into active widgets.

## Smallest useful v0.1

One main window with a feed sidebar, article list, and reader pane. Add Feed accepts a URL, downloads it, and checks that it is RSS or Atom. Manual Refresh updates the selected feed or all feeds. Selecting an article opens it in the reader; controls mark it read/unread or starred/unstarred; its link opens in the system browser. Data survives restart. No OPML, scheduled refresh, search, folders, or notifications.

## Build and later distribution

Initially require a source checkout, SBCL, Quicklisp/ASDF, distro GTK 4 packages, and SQLite runtime/development packages. SBCL can save an image or executable, but it is not automatically static or self-contained: GTK, GLib, TLS certificates, SQLite, and Lisp runtime dependencies remain. A standalone binary is therefore not an early milestone. Later, Flatpak is a reasonable target using an appropriate runtime/SDK and GTK runtime, with the Lisp image bundled as app content. Review LGPL notices and transitive library obligations. An RPM may be the simpler Fedora development install.

## Common Lisp learning path

Use `defstruct` for feeds and articles; introduce CLOS classes for application state when their behavior and mutability justify them. Start parsing with `defun`, `let`, lists, association lists, and property lists. Use `mapcar`, `remove-if`, `remove-if-not`, and `sort` for normalization and views. Introduce conditions for network, XML, and storage errors. Delay macros until a repeated pattern cannot be expressed clearly with a function. A future filter DSL should interpret a restricted set of forms (operators and title/feed predicates), never `eval` external input.
