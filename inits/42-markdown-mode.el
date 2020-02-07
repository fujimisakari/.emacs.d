;;; 42-markdown-mode.el --- markdown-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'markdown-mode)

(add-hook 'markdown-mode-hook
          (lambda ()
            (common-mode-init)))

(defun markdown-header-list ()
  "Show Markdown Formed Header list through temporary buffer."
  (interactive)
  (occur "^\\(#+\\|.*\n===+\\|.*\n\---+\\)")
  (other-window 1))

;; プレビュー
(defun markdown-preview-by-eww ()
  (interactive)
  (message (buffer-file-name))
  (call-process "grip" nil nil nil
                (buffer-file-name)
                "--export"
                "/tmp/grip.html")
  (let ((buf (current-buffer)))
    (eww-open-file "/tmp/grip.html")))

(set-face-foreground 'markdown-header-face-1 "lime green")
(set-face-foreground 'markdown-header-face-2 "orchid1")
(set-face-foreground 'markdown-header-face-3 "CornflowerBlue")
(set-face-foreground 'markdown-header-face-4 "orange")
(set-face-foreground 'markdown-header-face-5 "turquoise")
(set-face-attribute 'markdown-header-face-1 nil :bold nil :height 1.8)
(set-face-attribute 'markdown-header-face-2 nil :bold nil :height 1.2)
(set-face-attribute 'markdown-header-face-3 nil :bold nil :height 1.1)
(set-face-attribute 'markdown-code-face nil :family my-global-font :foreground "HotPink" :background "gray15" :bold nil)

;;; 42-markdown-mode.el ends here
