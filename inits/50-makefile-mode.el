;;; 50-makefile-mode.el --- makefile-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(add-to-list 'auto-mode-alist '("Makefile$" . makefile-mode))

(add-hook 'makefile-mode-hook '(lambda()
                                 (setq indent-tabs-mode t)))

;;; 50-makefile-mode.el ends here
