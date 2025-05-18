;;; 60-doom-modeline.el --- doom-modeline設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'doom-modeline)
(doom-modeline-mode 1)

(setq doom-modeline-bar-width 10)
(setq doom-modeline-buffer-file-name-style 'relative-from-project)

(doom-modeline-def-segment branch
  "現在のGitブランチを取得する。"
  (let ((branch (magit-get-current-branch)))
    (if branch
        (propertize (concat " " branch " ") 'face '(:foreground "green" :weight bold))
      "")))

(doom-modeline-def-segment buffer-name
  "Combined information about the current buffer."
  (concat
   (doom-modeline-spc)
   (doom-modeline--buffer-mode-icon)
   (doom-modeline--buffer-name)))

(doom-modeline-def-modeline 'main
    '(bar workspace-name window-number modals matches lsp vcs buffer-info buffer-position remote-host word-count parrot selection-info)
    '(objed-state persp-name battery grip irc mu4e gnus github debug repl minor-modes input-method indent-info major-mode buffer-encoding process))

(doom-modeline-def-modeline 'minimal
  '(bar matches buffer-info-simple)
  '(media-info major-mode))

(doom-modeline-def-modeline 'dired
  '(bar branch buffer-name buffer-position word-count parrot selection-info)
  '(major-mode))

(add-to-list 'doom-modeline-mode-alist '(dired-mode . dired))

;;; 60-doom-modeline.el ends here
