;;; 60-spaceline.el --- spaceline設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'spaceline-config)
(require 'spaceline-all-the-icons)

(spaceline-helm-mode 1)
(spaceline-all-the-icons-theme)

(setq spaceline-all-the-icons-slim-render nil
      spaceline-all-the-icons-highlight-file-name nil
      spaceline-all-the-icons-icon-set-modified 'toggle
      spaceline-all-the-icons-separator-type 'slant)

(set-face-foreground 'spaceline-highlight-face "white")
(set-face-background 'spaceline-highlight-face "#4f57f9")

(spaceline-toggle-all-the-icons-modified-on)
(spaceline-toggle-all-the-icons-buffer-size-off)
(spaceline-toggle-all-the-icons-projectile-off)
(spaceline-toggle-all-the-icons-org-clock-current-task-off)
(spaceline-toggle-all-the-icons-which-function-on)
(spaceline-toggle-all-the-icons-buffer-path-off)
(spaceline-toggle-all-the-icons-git-ahead-on)
(spaceline-toggle-all-the-icons-git-status-on)
(spaceline-toggle-all-the-icons-region-info-off)
(spaceline-toggle-all-the-icons-flycheck-status-off)
(spaceline-toggle-all-the-icons-flycheck-status-info-off)

;;; 60-spaceline.el ends here

