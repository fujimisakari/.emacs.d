;;; 31-emacs-lisp-mode.el --- emacs-lisp-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun my/elisp-mode-setup ()
  "Setup for emacs-lisp and lisp modes."
  (my/common-mode-init)
  (turn-on-eldoc-mode))

;; emacs-lisp-mode
(add-hook 'emacs-lisp-mode-hook #'my/elisp-mode-setup)

;; lisp-interaction-mode-hook
(add-hook 'lisp-interaction-mode-hook #'my/elisp-mode-setup)

;; lisp-mode-hook
(add-hook 'lisp-mode-hook #'my/elisp-mode-setup)

;; 式の評価結果を注釈する
(autoload 'lispxmp "lispxmp" nil t)

;; リスト変数の内容を編集する(M-x edit-list)
(autoload 'edit-list "edit-list" nil t)

;;; 31-emacs-lisp-mode.el ends here
