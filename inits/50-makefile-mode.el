;;; 50-makefile-mode.el --- makefile-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(add-to-list 'auto-mode-alist '("Makefile\\'" . makefile-mode))

(defun my/makefile-mode-setup ()
  "Setup for makefile-mode."
  (common-mode-init)
  (setq indent-tabs-mode t))
(add-hook 'makefile-mode-hook #'my/makefile-mode-setup)

;;; 50-makefile-mode.el ends here
