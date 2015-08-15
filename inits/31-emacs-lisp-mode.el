;;; 31-emacs-lisp-mode.el --- emacs-lisp-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; 括弧の対応を取りながらS式を編集する
;; (require 'paredit)
;; (add-hook 'emacs-lis-mode-hook 'enable-paredit-mode)
;; (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
;; (add-hook 'lisp-mode-hook 'enable-paredit-mode)
;; (add-hook 'ielm-mode-hook 'enable-paredit-mode)

;; 式の評価結果を注釈する
(require 'lispxmp)

;; Emacs-lisp関数・変数のヘルプをエコーエリアに表示する
(require 'eldoc-extension)                ; 拡張版
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(setq eldoc-idle-delay 0.2)               ; すぐに表示したい
(setq eldoc-minor-mode-string "")         ; モードラインにElDocと表示しない

;; (add-hook 'emacs-lisp-mode-hook 'flycheck-mode)

;; リスト変数の内容を編集する(M-x edit-list)
(require 'edit-list)

;;; 31-emacs-lisp-mode.el ends here
