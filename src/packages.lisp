(defpackage #:rss-reader.model
  (:use #:cl)
  (:export #:feed
           #:make-feed
           #:feed-id
           #:feed-url
           #:feed-title
           #:feed-site-url
           #:feed-last-refreshed-at
           #:article
           #:make-article
           #:article-id
           #:article-feed-id
           #:article-source-id
           #:article-title
           #:article-url
           #:article-author
           #:article-published-at
           #:article-summary
           #:article-content
           #:article-read-p
           #:article-starred-p
           #:article-created-at))

(defpackage #:rss-reader.application
  (:use #:cl)
  (:import-from #:rss-reader.model
                #:feed
                #:feed-id
                #:feed-url
                #:feed-title
                #:article
                #:article-feed-id
                #:article-source-id
                #:article-published-at
                #:article-read-p
                #:article-starred-p)
  (:export #:application-state
           #:make-application-state
           #:state-feeds
           #:state-articles
           #:add-feed
           #:remove-feed
           #:add-articles
           #:articles-for-feed
           #:unread-articles
           #:starred-articles
           #:mark-read
           #:mark-unread
           #:star-article
           #:unstar-article))
