;;; 53-typescript-mode.el --- typescript-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; autoload
(autoload 'typescript-mode "typescript-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))

;;; 53-typescript-mode.el ends here
