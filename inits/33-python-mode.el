;;; 33-python-mode.el --- python-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'python)

;; hook
(add-hook 'python-mode-hook
          '(lambda ()
             (common-mode-init)
             (setq imenu-create-index-function 'python-imenu-create-index)))

;; isort
(require 'py-isort)
(setq py-isort-options '("--multi-line=3"))

;; code formatter
(require 'py-autopep8)
;; (setq py-autopep8-options '("--ignore=E221,E501,E701,E202"))
(setq py-autopep8-options '("--ignore=E501"))

;; docstring comment
(defun python-docstring-comment()
  (interactive)
  (let* ((begin-point (point-at-bol))
         (end-point (point-at-eol))
         (function-line (buffer-substring begin-point end-point))
         (space (format "    %s" (replace-regexp-in-string "def.*" "" function-line))))
    (goto-char end-point)
    (insert "\n")
    (insert (format "%s\"\"\"\n" space))
    (when (string-match ".*(\\(.+\\)):" function-line)
      (dolist (arg (split-string (match-string 1 function-line) ","))
        (if (not (equal arg "self"))
            (insert (format "%s:param TYPE %s:\n" space (replace-regexp-in-string "^\\s-+\\|\\s-+$\\|=.+$" "" arg))))))
    (insert (format "%s:rtype: TYPE\n" space))
    (insert (format "%s\"\"\"" space))))


(defun insert-python-arrow ()
  (interactive)
  (insert "->"))

;;; 33-python-mode.el ends here
