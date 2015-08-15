;;; 42-markdown-mode.el --- markdown-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'markdown-mode)

(defun markdown-header-list ()
  "Show Markdown Formed Header list through temporary buffer."
  (interactive)
  (occur "^\\(#+\\|.*\n===+\\|.*\n\---+\\)")
  (other-window 1))

;;; 42-markdown-mode.el ends here
