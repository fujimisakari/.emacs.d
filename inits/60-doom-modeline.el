;;; 60-doom-modeline.el --- doom-modeline設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'doom-modeline)
(doom-modeline-mode 1)

(setq doom-modeline-bar-width 10)
(setq doom-modeline-buffer-file-name-style 'truncate-with-project)

(set-face-background 'doom-modeline-bar "#4f57f9")
(set-face-foreground 'doom-modeline-project-dir "Yellow")
(set-face-foreground 'doom-modeline-buffer-modified "orchid1")

(doom-modeline-def-modeline 'main
    '(bar workspace-name window-number modals matches lsp checker vcs buffer-info buffer-position remote-host word-count parrot selection-info)
    '(objed-state persp-name battery grip irc mu4e gnus github debug repl minor-modes input-method indent-info major-mode buffer-encoding process))

(doom-modeline-def-modeline 'minimal
  '(bar matches buffer-info-simple)
  '(media-info major-mode))

(doom-modeline-def-modeline 'special
  '(bar window-number modals matches buffer-info buffer-position word-count parrot selection-info)
  '(objed-state battery irc-buffers debug minor-modes input-method indent-info major-mode buffer-encoding process))

(doom-modeline-def-modeline 'project
  '(bar window-number buffer-default-directory)
  '(battery irc mu4e gnus github debug minor-modes input-method major-mode process))

(doom-modeline-def-modeline 'dashboard
  '(bar window-number buffer-default-directory-simple)
  '(battery irc mu4e gnus github debug minor-modes input-method major-mode process))

(doom-modeline-def-modeline 'vcs
  '(bar window-number modals matches buffer-info buffer-position parrot selection-info)
  '(battery irc mu4e gnus github debug minor-modes major-mode buffer-encoding process))

(doom-modeline-def-modeline 'package
  '(bar window-number package)
  '(major-mode process))

(doom-modeline-def-modeline 'info
  '(bar window-number buffer-info info-nodes buffer-position parrot selection-info)
  '(major-mode buffer-encoding))

(doom-modeline-def-modeline 'media
  '(bar window-number buffer-size vcs buffer-info)
  '(media-info major-mode process))

(doom-modeline-def-modeline 'message
  '(bar window-number modals matches buffer-info-simple buffer-position word-count parrot selection-info)
  '(objed-state battery debug minor-modes input-method indent-info major-mode buffer-encoding))

(doom-modeline-def-modeline 'pdf
  '(bar window-number matches vcs buffer-info pdf-pages)
  '(major-mode process))

(doom-modeline-def-modeline 'org-src
  '(bar window-number modals matches vcs checker buffer-info-simple buffer-position word-count parrot selection-info)
  '(objed-state debug minor-modes input-method indent-info major-mode buffer-encoding process))

(doom-modeline-def-modeline 'helm
  '(bar helm-buffer-id helm-number helm-follow helm-prefix-argument)
  '(helm-help))

(doom-modeline-def-modeline 'timemachine
  '(bar window-number matches git-timemachine buffer-position word-count parrot selection-info)
  '(minor-modes indent-info major-mode buffer-encoding))

;;; 60-doom-modeline.el ends here
