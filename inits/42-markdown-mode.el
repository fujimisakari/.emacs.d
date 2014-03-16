;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                             markdown-mode関連                              ;;
;;;--------------------------------------------------------------------------;;;

(require 'markdown-mode)

(defun markdown-header-list ()
  "Show Markdown Formed Header list through temporary buffer."
  (interactive)
  (occur "^\\(#+\\|.*\n===+\\|.*\n\---+\\)")
  (other-window 1))
(define-key markdown-mode-map (kbd "C-c C-s") 'markdown-header-list)
