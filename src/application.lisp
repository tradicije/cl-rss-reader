(in-package #:rss-reader.application)

(defstruct (application-state
             (:constructor make-application-state ()))
  "In-memory application state. Persistence will replace this storage layer."
  (feeds '() :type list)
  (articles '() :type list))

(defun add-feed (state feed)
  "Add FEED unless a feed with the same URL is already present."
  (if (find (feed-url feed) (state-feeds state)
            :key #'feed-url
            :test #'string=)
      nil
      (progn
        (push feed (state-feeds state))
        feed)))

(defun remove-feed (state feed-id)
  "Remove a feed and its articles. Return the removed feed, if found."
  (let ((feed (find feed-id (state-feeds state)
                    :key #'feed-id
                    :test #'equal)))
    (when feed
      (setf (state-feeds state)
            (remove feed-id (state-feeds state)
                    :key #'feed-id
                    :test #'equal)
            (state-articles state)
            (remove feed-id (state-articles state)
                    :key #'article-feed-id
                    :test #'equal)))
    feed))

(defun add-articles (state new-articles)
  "Add new articles, skipping entries already known by feed and source ID."
  (let ((added '()))
    (dolist (article new-articles)
      (unless (find-if (lambda (existing)
                         (and (equal (article-feed-id existing)
                                     (article-feed-id article))
                              (equal (article-source-id existing)
                                     (article-source-id article))))
                       (state-articles state))
        (push article (state-articles state))
        (push article added)))
    (nreverse added)))

(defun articles-for-feed (state feed-id)
  "Return articles for FEED-ID, newest publication dates first."
  (sort (remove-if-not (lambda (article)
                         (equal feed-id (article-feed-id article)))
                       (copy-list (state-articles state)))
        #'>
        :key (lambda (article)
               (or (article-published-at article) 0))))

(defun unread-articles (state)
  "Return all unread articles."
  (remove-if #'article-read-p (state-articles state)))

(defun starred-articles (state)
  "Return all starred articles."
  (remove-if-not #'article-starred-p (state-articles state)))

(defun mark-read (article)
  "Mark ARTICLE as read and return it."
  (setf (article-read-p article) t))

(defun mark-unread (article)
  "Mark ARTICLE as unread and return it."
  (setf (article-read-p article) nil))

(defun star-article (article)
  "Star ARTICLE and return it."
  (setf (article-starred-p article) t))

(defun unstar-article (article)
  "Unstar ARTICLE and return it."
  (setf (article-starred-p article) nil))
