;;; 32-c-mode.el --- c-mode -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(add-hook 'c-mode-hook
          (lambda ()
            (c-set-style "stroustrup")
            (common-mode-init)))

(custom-set-variables
 '(ac-clang-cflags '("-I/usr/include")))

(require 'ccls)
(setq ccls-executable "/usr/local/bin/ccls")

;;; 32-c-mode.el ends here
