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

;; (setq company-box-doc-enable nil)

;;; 20-company.el ends here
