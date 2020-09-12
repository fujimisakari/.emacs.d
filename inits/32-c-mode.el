;;; 32-c-mode.el --- c-mode -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'c-eldoc)
(require 'flycheck)

(add-hook 'c-mode-hook
          (lambda ()
            ;; basic
            (c-set-style "stroustrup")
            (common-mode-init)
            (flycheck-mode t)
            (flymake-mode-off)
            ;; eldoc
            (c-turn-on-eldoc-mode)
            (setq c-eldoc-buffer-regenerate-time 60)))

(custom-set-variables
 '(ac-clang-cflags '("-I/usr/include")))

(flycheck-define-checker c/c++
  "A C/C++ checker using g++."
  :command ("g++" "-Wall" "-Wextra" source)
  :error-patterns  ((error line-start
                           (file-name) ":" line ":" column ":" " エラー: " (message)
                           line-end)
                    (warning line-start
                           (file-name) ":" line ":" column ":" " 警告: " (message)
                           line-end))
  :modes (c-mode c++-mode))

;;; 32-c-mode.el ends here
