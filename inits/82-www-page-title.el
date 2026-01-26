;;; 82-www-page-title.el --- www-page-title設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun my/www-page-title-region-or-read-string ()
  (cond
   (mark-active
    (buffer-substring-no-properties (region-beginning) (region-end)))
   (t
    (read-string "Enter page url: "))))

(defun my/www-page-title-shell (url)
  (shell-command-to-string (format "curl -s '%s' | grep -o '<title>.*</title>'" url)))

(defun my/www-page-title ()
  (interactive)
  (let* ((url (www-page-title-region-or-read-string))
         (title-tag (www-page-title-shell url)))
    (string-match "<title>\\(.*\\)</title>" title-tag)
    (with-temp-buffer
      (insert (match-string 1 title-tag))
      (clipboard-kill-region (point-min) (point-max)))
    (message "copy to clipboard")))

;;; 82-www-page-title.el ends here
