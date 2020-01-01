;;; 20-company.el --- company設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; (require 'company-box)
;; (add-hook 'company-mode-hook 'company-box-mode)

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;; (require 'company-posframe)
;; (company-posframe-mode 1)

(setq company-idle-delay 1)
(setq company-minimum-prefix-length 1)

(set-face-attribute 'company-tooltip nil :foreground "gray75" :background "gray20")
(set-face-attribute 'company-tooltip-annotation nil :foreground "MediumPurple1" :background "gray20")
(set-face-attribute 'company-tooltip-annotation-selection nil :foreground "white" :background "SlateBlue2")
(set-face-attribute 'company-tooltip-selection nil :foreground "white" :background "SlateBlue2")
(set-face-attribute 'company-scrollbar-fg nil :background "SlateBlue2")
(set-face-attribute 'company-scrollbar-bg nil :background "gray40")

;;; 20-company.el ends here
