# Common Lisp RSS Reader

Working repository name: **cl-rss-reader**. The application name has not been chosen yet.

A Linux-first, local-first desktop RSS/Atom reader written primarily in Common Lisp. The goal is a small native application for everyday use and a practical project for learning Common Lisp.

## Principles

- A native Linux desktop window; no browser UI, local web server, Electron, or webview.
- No accounts, cloud sync, telemetry, or required server.
- User data stays local in SQLite, using XDG Base Directory locations.
- RSS and Atom feeds map to one shared article model.
- Linux and Wayland are primary; GTK should work across desktop environments, not only KDE.
- All application UI text, documentation, and contributor communication in the repository are in English.
- Licensed under AGPL-3.0-or-later.

## Status

Planning. Application implementation has not started. Proposed technical decisions and project structure are in the [technical plan](docs/technical-plan.md).

## Planned v0.1 scope

Add and remove feeds, RSS 2.0 and Atom, manual refresh, feed and date-sorted article lists, author/date/summary/content display, read/unread, star/unstar, open links in the system browser, and a local SQLite database.

Automatic refresh, OPML, search, notifications, content extraction, and Lisp filter DSL are later features.

## Development

The proposed environment is Fedora Linux with SBCL, Quicklisp, GTK 4, and SQLite. Build and run instructions will be added once the initial ASDF system exists.

## Contributing and security

See [CONTRIBUTING.md](CONTRIBUTING.md) and [SECURITY.md](SECURITY.md).

## License

This project is distributed under the GNU Affero General Public License, version 3 or later. See [LICENSE](LICENSE).
