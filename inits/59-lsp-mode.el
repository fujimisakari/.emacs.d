;;; 59-lsp-mode.el --- lsp-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'lsp-mode)
(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)

(require 'company-lsp)

;; hook
;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
;; (defun lsp-go-install-save-hooks ()
;;   (add-hook 'before-save-hook #'lsp-format-buffer t t)
;;   (add-hook 'before-save-hook #'lsp-organize-imports t t))
;; (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; go-mode設定
(add-hook 'go-mode-hook
          '(lambda()
             (lsp)
             (lsp-deferred)
             (push '(company-lsp :with company-yasnippet) company-backends)))

(setq global-flycheck-mode nil)

;; general
(setq lsp-session-file (expand-file-name (locate-user-emacs-file "../.lsp-session-v1")))
(setq lsp-print-io nil)
(setq lsp-trace nil)
(setq lsp-auto-guess-root t)
;; (setq lsp-document-sync-method 'incremental) ;; always send incremental document
(setq lsp-response-timeout 5)
(setq lsp-prefer-flymake 'flymake)
(setq lsp-enable-completion-at-point nil)
(setq lsp-ui-flycheck-enable nil)
(setq lsp-enable-file-watchers nil)

;; lsp-ui-doc
(setq lsp-ui-doc-enable nil)
(setq lsp-ui-doc-use-webkit t)

;; lsp-ui-sideline
(setq lsp-ui-sideline-enable nil)
(setq lsp-ui-sideline-ignore-duplicate t)
(setq lsp-ui-sideline-show-symbol t)
(setq lsp-ui-sideline-show-hover t)
(setq lsp-ui-sideline-show-diagnostics nil)
(setq lsp-ui-sideline-show-code-actions nil)

;; lsp-ui-imenu
(setq lsp-ui-imenu-enable nil)

(defun lsp-find-definition-other-window ()
  (interactive)
  (when (one-window-p)
    (progn
      (split-window-horizontally)
      (other-window 1)))
  (lsp-find-definition))

;;; 59-lsp-mode.el ends here
