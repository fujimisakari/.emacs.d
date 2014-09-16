;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                              python-mode設定                               ;;
;;;--------------------------------------------------------------------------;;;

(require 'python)

;; imenuが動かなかったので対応
(semantic-mode 1)

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

(add-hook 'python-mode-hook
          (lambda ()
            (mode-init-func)
            (setq imenu-create-index-function #'python-imenu-create-index)))
