;;; 60-doom-modeline.el --- doom-modeline設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'doom-modeline)
(doom-modeline-mode 1)


;; How wide the mode-line bar should be. It's only respected in GUI.
(setq doom-modeline-bar-width 10)

;; Determines the style used by `doom-modeline-buffer-file-name'.
;; Given ~/Projects/FOSS/emacs/lisp/comint.el
;;   truncate-with-project => emacs/l/comint.el
(setq doom-modeline-buffer-file-name-style 'truncate-with-project)

(doom-modeline-def-modeline 'main
    '(bar workspace-name window-number modals matches lsp checker vcs buffer-info remote-host word-count parrot selection-info)
    '(objed-state persp-name debug lsp github minor-modes input-method indent-info major-mode process))

(set-face-foreground 'doom-modeline-bar "#4f57f9")

;;; 60-doom-modeline.el ends here
