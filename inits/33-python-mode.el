;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                              python-mode設定                               ;;
;;;--------------------------------------------------------------------------;;;

(require 'python)

;; code checker
(add-hook 'find-file-hook 'flymake-find-file-hook)
(defun flymake-pyflakes-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "~/.emacs.d/bin/pycheckers"  (list local-file))))
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.py\\'" flymake-pyflakes-init))

;; code formatter
(require 'py-autopep8)
(setq py-autopep8-options '("--ignore=E221,E501,E701,E202"))

;; jedi setup
(require 'jedi)
(setq jedi:complete-on-dot t)
(setq jedi:install-imenu t)

;; hook
(semantic-mode 1)
(add-hook 'python-mode-hook
          '(lambda ()
            (mode-init-func)
            (jedi:setup)))
            ;; (setq imenu-create-index-function #'python-imenu-create-index)))
