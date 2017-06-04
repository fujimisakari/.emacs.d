;;; 31-emacs-lisp-mode.el --- emacs-lisp-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; emacs-lisp-mode
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (common-mode-init)
            (turn-on-eldoc-mode)))

;; lisp-interaction-mode-hook
(add-hook 'lisp-interaction-mode-hook
          (lambda ()
            (common-mode-init)
            (turn-on-eldoc-mode)))

;; lisp-mode-hook
(add-hook 'lisp-mode-hook
          (lambda ()
            (common-mode-init)
            (turn-on-eldoc-mode)))

;; 式の評価結果を注釈する
(require 'lispxmp)

;; Emacs-lisp関数・変数のヘルプをエコーエリアに表示する
(require 'eldoc-extension)        ; 拡張版
(setq eldoc-idle-delay 0.2)       ; すぐに表示したい
(setq eldoc-minor-mode-string "") ; モードラインにElDocと表示しない

;; リスト変数の内容を編集する(M-x edit-list)
(require 'edit-list)

;; 括弧の対応を取りながらS式を編集する
;; (require 'paredit)
;; (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
;; (add-hook 'lisp-interaction-mode-hook 'disable-paredit-mode)

;;; 31-emacs-lisp-mode.el ends here
