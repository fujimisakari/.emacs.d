;;; 59-lsp-mode.el --- lsp-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'lsp-mode)
(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)

;; mode
(dolist (v '(go-mode-hook c-mode-hook))
  (add-hook v
            '(lambda()
               (lsp)
               (lsp-deferred)
               (lsp-completion-mode))))

;; general
(setq lsp-session-file (expand-file-name (locate-user-emacs-file "../.lsp-session-v1")))
(setq lsp-print-io nil)
(setq lsp-trace nil)
(setq lsp-auto-guess-root t)
;; (setq lsp-document-sync-method 'incremental) ;; always send incremental document
(setq lsp-response-timeout 5)
(setq lsp-enable-completion-at-point nil)
(setq lsp-enable-file-watchers nil)
(setq lsp-prefer-capf t)
(setq lsp-ui-flycheck-enable t)

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

;; face
(set-face-foreground 'lsp-ui-peek-selection "white")
(set-face-background 'lsp-ui-peek-selection "#4f57f9")

(set-face-foreground 'lsp-ui-peek-header "white")
(set-face-background 'lsp-ui-peek-header "SlateBlue2")

(set-face-foreground 'lsp-ui-peek-footer "white")
(set-face-background 'lsp-ui-peek-footer "SlateBlue2")

(set-face-foreground 'lsp-ui-peek-filename "CornflowerBlue")
(set-face-foreground 'lsp-ui-peek-line-number "gray45")
(set-face-background 'lsp-ui-peek-peek "gray15")
(set-face-background 'lsp-ui-peek-highlight "DarkOliveGreen2")

;; customize
(defun lsp-find-definition-other-window ()
  (interactive)
  (when (one-window-p)
    (progn
      (split-window-horizontally)
      (other-window 1)))
  (lsp-find-definition))

(defun lsp-ui-peek--goto-xref-custom-other-window ()
  (interactive)
  (if (one-window-p)
      (lsp-ui-peek--goto-xref nil t))
  (lsp-ui-peek--goto-xref))

;; treemacs
;; lsp-treemacs-errors-list を q で閉じたあとに Treemacs のウィンドウが裏で残らず、完全に削除させる
(defun my/lsp-treemacs--open-error-list (orig-fn &rest args)
  "Open the LSP error list in a normal window, not a side window."
  (let ((display-buffer-alist
         '(("\\*LSP Error List\\*"
            (display-buffer-reuse-window display-buffer-pop-up-window)))))
    (apply orig-fn args)))

(with-eval-after-load 'lsp-treemacs
  (advice-add 'lsp-treemacs--open-error-list :around #'my/lsp-treemacs--open-error-list))

(defun my/fully-remove-lsp-error-list ()
  "Forcefully remove all windows showing *LSP Error List*, clearing window state."
  (interactive)
  (let ((buf (get-buffer "*LSP Error List*")))
    (when buf
      (dolist (win (get-buffer-window-list buf nil t))
        ;; 念のため quit-restore info をクリア
        (set-window-parameter win 'quit-restore nil)
        (set-window-dedicated-p win nil)
        (delete-window win))
      (kill-buffer buf)
      (setq lsp-treemacs-error-list-current nil))))

(with-eval-after-load 'lsp-treemacs
  (define-key lsp-treemacs-error-list-mode-map (kbd "q") #'my/fully-remove-lsp-error-list))

(setq display-buffer-base-action
      '((display-buffer-reuse-window display-buffer-pop-up-window)))
