;;; 20-company.el --- company設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; autoload
(autoload 'company-complete "company" nil t)
(autoload 'global-company-mode "company" nil t)

(defun my/company-setup ()
  "Setup company-mode after idle."
  (global-company-mode +1)
  (setq company-idle-delay 0.5)
  (setq company-minimum-prefix-length 1))

(run-with-idle-timer 1 nil #'my/company-setup)

;;; 20-company.el ends here
