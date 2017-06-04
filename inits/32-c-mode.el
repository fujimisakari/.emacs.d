;;; 32-c-mode.el --- c-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; c, c++の基本設定
(add-hook 'c-mode-hook
          '(lambda ()
             (common-mode-init)
             (c-set-style "stroustrup")
             (flymake-mode t)))

;; fly-make設定
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
