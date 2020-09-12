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

;; mode設定
(dolist (v '(go-mode-hook c-mode-common-hook))
  (add-hook v
            '(lambda()
               (lsp)
               (lsp-deferred)
               (push '(company-lsp :with company-yasnippet) company-backends))))

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


;; company-lspを稼働させるための対応
(defcustom lsp-completion-show-detail t
  "Whether or not to show detail of completion candidates."
  :type 'boolean
  :group 'lsp-mode)

(defconst lsp--completion-item-kind
  [nil
   "Text"
   "Method"
   "Function"
   "Constructor"
   "Field"
   "Variable"
   "Class"
   "Interface"
   "Module"
   "Property"
   "Unit"
   "Value"
   "Enum"
   "Keyword"
   "Snippet"
   "Color"
   "File"
   "Reference"
   "Folder"
   "EnumMember"
   "Constant"
   "Struct"
   "Event"
   "Operator"
   "TypeParameter"])


(defun lsp--sort-completions (completions)
  "Sort COMPLETIONS."
  (sort
   completions
   (-lambda ((&CompletionItem :sort-text? sort-text-left :label label-left)
             (&CompletionItem :sort-text? sort-text-right :label label-right))
     (if (equal sort-text-left sort-text-right)
         (string-lessp label-left label-right)
       (string-lessp sort-text-left sort-text-right)))))

(defun lsp--annotate (item)
  "Annotate ITEM detail."
  (-let (((&CompletionItem :detail? :kind?) (plist-get (text-properties-at 0 item)
                                                       'lsp-completion-item)))
    (concat (when (and lsp-completion-show-detail detail?)
              (concat " " (s-replace "\r" "" detail?)))
            (when-let (kind-name (and kind? (aref lsp--completion-item-kind kind?)))
              (format " (%s)" kind-name)))))


(defun lsp--resolve-completion (item)
  "Resolve completion ITEM."
  (cl-assert item nil "Completion item must not be nil")
  (or (-first 'identity
              (condition-case _err
                  (lsp-foreach-workspace
                   (when (lsp:completion-options-resolve-provider?
                          (lsp--capability :completionProvider))
                     (lsp-request "completionItem/resolve" item)))
                (error)))
      item))

;;; 59-lsp-mode.el ends here
