;;; 28-flycheck.el --- flycheck設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(flycheck-define-checker textlint
  "textlint."
  :command ("textlint" "--format" "unix"
            source-inplace)
  :error-patterns
  ((warning line-start (file-name) ":" line ":" column ": "
            (id (one-or-more (not (any " "))))
            (message (one-or-more not-newline)
                     (zero-or-more "\n" (any " ") (one-or-more not-newline)))
            line-end))
  :modes (text-mode markdown-mode))
(add-to-list 'flycheck-checkers 'textlint)

;;; 29-flycheck.el ends here

