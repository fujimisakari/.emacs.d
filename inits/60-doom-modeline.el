;;; 60-doom-modeline.el --- doom-modeline設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'doom-modeline)
(doom-modeline-mode 1)

(setq doom-modeline-bar-width 10)
(setq doom-modeline-buffer-file-name-style 'relative-from-project)

(doom-modeline-def-modeline 'main
    '(bar workspace-name window-number modals matches lsp vcs buffer-info buffer-position remote-host word-count parrot selection-info)
    '(objed-state persp-name battery grip irc mu4e gnus github debug repl minor-modes input-method indent-info major-mode buffer-encoding process))

(doom-modeline-def-modeline 'minimal
  '(bar matches buffer-info-simple)
  '(media-info major-mode))

(doom-modeline-def-modeline 'dired
  '(bar vcs buffer-info buffer-position word-count parrot selection-info)
  '(major-mode))

(add-to-list 'doom-modeline-mode-alist '(dired-mode . dired))

;;; 60-doom-modeline.el ends here
