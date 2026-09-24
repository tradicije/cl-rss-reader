# Contributing

Thanks for your interest. The project is in the technical planning stage and does not have a stable API yet.

## How to contribute

1. Open an issue before starting substantial changes or new features.
2. In pull requests, explain the problem and the intended behavior.
3. Keep Common Lisp code simple and readable; this is also an educational project.
4. Do not add cloud services, telemetry, accounts, a server, web UI, or a webview dependency.
5. Explain the maintenance status, license, and Fedora availability of any proposed dependency.
6. Keep parser fixtures small and free of personal data.

## Style

Respect the existing package boundaries, use small functions, and document public APIs. Never call `eval` on feed content or user data. Do not render feed HTML as active content without sanitizing it.

Build and test commands will be documented when an initial ASDF system exists. Until then, contributions to the plan and documentation are welcome.

By submitting a contribution, you agree that it may be distributed under AGPL-3.0-or-later.
