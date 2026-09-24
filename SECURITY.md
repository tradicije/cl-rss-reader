# Security policy

This project is at an early stage. Security fixes are welcome for all supported versions.

## Reporting a vulnerability

Please do not publish details of an unfixed vulnerability in a public issue. Use GitHub Security Advisories for a private report once the repository is published. If that option is unavailable, contact the maintainer through the public GitHub profile.

Include the affected version or commit, reproduction steps, impact, and a safe sample input when possible. Do not send private feed URLs, credentials, or a user's database.

## Security boundaries

Feeds are untrusted input. Parsers must disable external XML entity access and limit response sizes; redirects and HTTP timeouts must be bounded. Article content must never be executed as Lisp code or rendered as active HTML without sanitization.
