(in-package #:rss-reader.model)

(defstruct feed
  "A subscribed RSS or Atom source."
  id
  (url "" :type string)
  title
  site-url
  last-refreshed-at)

(defstruct article
  "A normalized entry from either an RSS or Atom feed."
  id
  feed-id
  source-id
  title
  url
  author
  ;; Publication and creation times are UTC universal-time integers or NIL.
  published-at
  summary
  content
  (read-p nil :type boolean)
  (starred-p nil :type boolean)
  created-at)
