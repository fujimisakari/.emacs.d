;;; 67-protobuf-mode.el --- protobuf-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'protobuf-mode)

(defconst my-protobuf-style
  '((c-basic-offset . 2)
    (indent-tabs-mode . nil)))

(add-hook 'protobuf-mode-hook
          (lambda () (c-add-style "my-style" my-protobuf-style t)))

(defun protobuf-mode ()
  "Major mode for editing Protocol Buffers description language.

The hook `c-mode-common-hook' is run with no argument at mode
initialization, then `protobuf-mode-hook'.

Key bindings:
\\{protobuf-mode-map}"
  (interactive)
  (kill-all-local-variables)
  (set-syntax-table protobuf-mode-syntax-table)
  (setq major-mode 'protobuf-mode
        mode-name "Protocol-Buffers"
        local-abbrev-table protobuf-mode-abbrev-table
        abbrev-mode t)
  (use-local-map protobuf-mode-map)
  (c-initialize-cc-mode t)
  (if (fboundp 'c-make-emacs-variables-local)
      (c-make-emacs-variables-local))
  (c-init-language-vars protobuf-mode)
  (c-common-init 'protobuf-mode)
  (easy-menu-add protobuf-menu)
  (c-run-mode-hooks 'c-mode-common-hook 'protobuf-mode-hook)
  (c-update-modeline))

;;; 67-protobuf-mode.el ends here
