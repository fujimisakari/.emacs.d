;;; 59-lsp-mode.el --- lsp-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'lsp-mode)
(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)

;; hook
;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
;; (defun lsp-go-install-save-hooks ()
;;   (add-hook 'before-save-hook #'lsp-format-buffer t t)
;;   (add-hook 'before-save-hook #'lsp-organize-imports t t))
;; (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; mode設定
;; (setq lsp-language-id-configuration (append lsp-language-id-configuration '(protobuf-mode . "c")))
;; (dolist (v '(go-mode-hook c-mode-common-hook))
(dolist (v '(go-mode-hook))
  (add-hook v
            '(lambda()
               (lsp)
               (lsp-deferred)
               (lsp-completion-mode))))

(setq pglobal-flycheck-mode nil)

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
(setq lsp-prefer-capf t)

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
