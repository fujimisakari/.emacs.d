;;; 20-company.el --- company設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'company)

;; (require 'company-box)
;; (add-hook 'company-mode-hook 'company-box-mode)

;; (require 'company-posframe)
;; (company-posframe-mode 1)

(global-company-mode +1)
(setq company-idle-delay 0.5)
(setq company-minimum-prefix-length 1)

(set-face-attribute 'company-preview-common nil :foreground "gray75" :background "#4f57f9")
(set-face-attribute 'company-preview-search nil :foreground "white" :background "#4f57f9")
(set-face-attribute 'company-tooltip nil :foreground "gray75" :background "gray20")
(set-face-attribute 'company-tooltip-annotation nil :foreground "#6c6aff" :background "gray20")
(set-face-attribute 'company-tooltip-annotation-selection nil :foreground "white" :background "#4f57f9")
(set-face-attribute 'company-tooltip-selection nil :foreground "white" :background "#4f57f9")
(set-face-attribute 'company-scrollbar-fg nil :background "#4f57f9")
(set-face-attribute 'company-scrollbar-bg nil :background "gray40")

;;; 20-company.el ends here
