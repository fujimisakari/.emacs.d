;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                             markdown-mode設定                              ;;
;;;--------------------------------------------------------------------------;;;

(require 'markdown-mode)

(defun markdown-header-list ()
  "Show Markdown Formed Header list through temporary buffer."
  (interactive)
  (occur "^\\(#+\\|.*\n===+\\|.*\n\---+\\)")
  (other-window 1))
