;; -*- Emacs-lisp -*-

(defun open-browse-by-url ()
  "w3m上のリンクやURL文字列をブラウザで開く"
  (interactive)
  (setq w3m-url (w3m-print-this-url))
  (if (> (length w3m-url) 0)
      (browse-url w3m-url browse-url-new-window-flag)
    (browse-url-at-point)))
