;;; 38-js-mode.el --- js2-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; js2-mode
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$" . js2-mode))

(quickrun-set-default "js" "javascript/node")

(add-hook 'js2-mode-hook
          (lambda ()
            (setq js2-basic-offset 2)
            (common-mode-init)
            ;; (tern-mode t)
            (flycheck-mode)))

;; (eval-after-load 'tern
;;   '(progn
;;      (require 'tern-auto-complete)
;;      (tern-ac-setup)))

(setq js2-strict-trailing-comma-warning nil)
;; (setq js2-strict-missing-semi-warning nil)
;; (setq js2-missing-semi-one-line-override t)
;; (setq js2-strict-inconsistent-return-warning nil)

;;; 38-js-mode.el ends here
