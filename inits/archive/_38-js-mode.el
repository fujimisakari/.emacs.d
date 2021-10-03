;;; 38-js-mode.el --- js2-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; js2-mode
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-jsx-mode))
(add-to-list 'interpreter-mode-alist '("node" . js2-jsx-mode))

(quickrun-set-default "js" "javascript/node")

(add-hook 'js2-mode-hook
          (lambda ()
            (common-mode-init)
            (flycheck-mode)
            (tern-mode t)
            (setq tab-width 2)
            (setq js-indent-level 2)
            (setq js2-basic-offset 2)
            (setq js-switch-indent-offset 2)))

;; visual setting
(set-face-foreground 'js2-function-param nil)
(set-face-foreground 'js2-function-call "lime green")
(set-face-foreground 'js2-external-variable "yellow")
(set-face-foreground 'js2-object-property nil)
(set-face-foreground 'js2-type-annotation "DeepSkyBlue")
(set-face-foreground 'js2-primitive-type "DeepSkyBlue")
(set-face-foreground 'js2-jsdoc-tag "DarkTurquoise")
(set-face-foreground 'js2-jsdoc-type "DeepSkyBlue")
(set-face-foreground 'js2-jsdoc-value nil)

;; (setq js2-strict-trailing-comma-warning nil)
;; (setq js2-strict-missing-semi-warning nil)
;; (setq js2-missing-semi-one-line-override t)
;; (setq js2-strict-inconsistent-return-warning nil)

;;; 38-js-mode.el ends here
