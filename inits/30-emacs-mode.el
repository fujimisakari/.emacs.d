;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                            emacs-lisp-mode関連                             ;;
;;;--------------------------------------------------------------------------;;;

;; 括弧の対応を取りながらS式を編集する
(require 'paredit)
(add-hook 'emacs-lis-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)

;; 式の評価結果を注釈する
(require 'lispxmp)
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)

;; Emacs-lisp関数・変数のヘルプをエコーエリアに表示する
(require 'eldoc-extension)                ; 拡張版
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(setq eldoc-idle-delay 0.2)               ; すぐに表示したい
(setq eldoc-minor-mode-string "")         ; モードラインにElDocと表示しない

;; リスト変数の内容を編集する(M-x edit-list)
(require 'edit-list)
