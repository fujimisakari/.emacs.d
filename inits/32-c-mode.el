;;; 32-c-mode.el --- c-mode -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'c-eldoc)
(require 'auto-complete-c-headers)
(require 'auto-complete-clang-async)

(add-hook 'c-mode-hook
          (lambda ()
            ;; basic
            (c-set-style "stroustrup")
            (common-mode-init)
            (flymake-mode t)
            (setq c-continued-statement-offset 0)
            ;; auto-complete-clang-async
            (setq ac-clang-complete-executable "~/.emacs.d/bin/clang-complete")
            (add-to-list 'ac-sources 'ac-source-clang-async)
            (ac-clang-launch-completion-process)
            ;; auto-complete-c-headers
            (add-to-list 'ac-sources 'ac-source-c-headers)
            ;; eldoc
            (c-turn-on-eldoc-mode)
            (setq c-eldoc-buffer-regenerate-time 60)))

;; flymake
(setq gcc-warning-options
      '("-Wall" "-Wextra" "-Wformat=2" "-Wstrict-aliasing=2" "-Wcast-qual"
      "-Wcast-align" "-Wwrite-strings" "-Wfloat-equal"
      "-Wpointer-arith" "-Wswitch-enum"
      ))

(setq gxx-warning-options
      `(,@gcc-warning-options "-Woverloaded-virtual" "-Weffc++")
      )

(setq gcc-cpu-options '("-msse" "-msse2" "-mmmx"))

(defun flymake-c-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name)))
       )
    (list "gcc" `(,@gcc-warning-options ,@gcc-cpu-options "-fsyntax-only" "-std=c99" ,local-file))
    ))
(push '(".+\\.c$" flymake-c-init) flymake-allowed-file-name-masks)

;; (defun flymake-c++-init ()
;;   (let* ((temp-file   (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;          (local-file  (file-relative-name
;;                        temp-file
;;                        (file-name-directory buffer-file-name))))
;;     (list "g++" `(,@gxx-warning-options ,@gcc-cpu-options "-fsyntax-only" "-std=c++0x" ,local-file))
;;     ))
;; (push '(".+\\.h$" flymake-c++-init) flymake-allowed-file-name-masks)
;; (push '(".+\\.cpp$" flymake-c++-init) flymake-allowed-file-name-masks)

;; (add-hook 'c++-mode-hook '(lambda () (flymake-mode t) (my-c-mode-common-hook)))

;; ファイルを保存したときに自動でコンパイルする
;; (defvar after-save-hook-command-alist
;;   '(("c" . "make")
;;     ))
;; (defun after-save-hook-command ()
;;   (let* ((filename (buffer-file-name))
;;        (extension (file-name-extension filename))
;;        (pair (assoc extension after-save-hook-command-alist))
;;        )
;;     (when pair
;;       (shell-command (format (cdr pair) filename)))
;;     ))
;; (add-hook 'after-save-hook 'after-save-hook-command)

;;; 32-c-mode.el ends here
