;;; 19-anzu.el --- anzu-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'anzu)
(global-anzu-mode +1)

(custom-set-variables
 '(anzu-mode-lighter "")
 '(anzu-deactivate-region t)
 '(anzu-search-threshold 1000)
 '(anzu-replace-to-string-separator " => "))

;;; 19-anzu.el ends here
