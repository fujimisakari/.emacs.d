;;; 68-json-mode.el --- json-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(autoload 'json-mode "json-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))

(defun json-jq-format (beg end)
  (interactive "r")
  (shell-command-on-region beg end "jq ." nil t))

;;; 68-json-mode.el ends here
