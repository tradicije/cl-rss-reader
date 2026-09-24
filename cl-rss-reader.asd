(asdf:defsystem "cl-rss-reader"
  :description "A local-first Linux RSS and Atom reader."
  :author "cl-rss-reader contributors"
  :license "AGPL-3.0-or-later"
  :version "0.1.0-dev"
  :depends-on ("cxml-klacks" "cl-date-time-parser")
  :serial t
  :components ((:file "src/packages")
               (:file "src/model")
               (:file "src/application")
               (:file "src/parser/xml")
               (:file "src/parser/feed")))
