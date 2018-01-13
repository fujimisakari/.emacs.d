;;; 33-python-mode.el --- python-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'python)

;; hook
(add-hook 'python-mode-hook
          '(lambda ()
             (common-mode-init)
             (jedi:setup)
             (setq imenu-create-index-function 'python-imenu-create-index)))

;; code checker
(add-hook 'find-file-hook 'flymake-find-file-hook)
(defun flymake-pyflakes-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "~/.emacs.d/bin/python-flymake.sh" (list local-file))))
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.py\\'" flymake-pyflakes-init))

;; isort
(require 'py-isort)
(setq py-isort-options '("--multi-line=3"))

;; code formatter
(require 'py-autopep8)
;; (setq py-autopep8-options '("--ignore=E221,E501,E701,E202"))
(setq py-autopep8-options '("--ignore=E501"))

;; jedi setup
(require 'jedi)
(setq jedi:complete-on-dot t)
(setq jedi:install-imenu t)
(setq python-environment-directory "~/.python-environments")
(jedi:install-server)

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
