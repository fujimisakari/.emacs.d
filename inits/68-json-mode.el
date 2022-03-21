;;; 68-json-mode.el --- json-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'json-mode)

(defun json-jq-format (beg end)
  (interactive "r")
  (shell-command-on-region beg end "jq ." nil t))

;;; 68-json-mode.el ends here
