;;; 39-slime-mode.el --- slime-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(when (require 'slime nil t)

  (add-hook 'lisp-mode-hook (lambda ()
                              (slime-mode t)
                              (setq indent-tabs-mode nil)
                              (unless show-paren-mode
                                (show-paren-mode))))
  (add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))

  (slime-setup '(slime-repl slime-fancy slime-banner slime-fuzzy slime-indentation))
  (setq slime-autodoc-use-multiline-p t)
  (setq slime-net-coding-system 'utf-8-unix) ;; 日本語利用のための設定（Lisp 環境側の対応も必要）

  (require 'ac-slime)
  (add-hook 'slime-mode-hook 'set-up-slime-ac)
  (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)

  ;; 括弧の対応を取りながらS式を編集する
  ;; (add-hook 'slime-repl-mode-hook 'enable-paredit-mode)

  ;; roswell設定
  (load (expand-file-name "~/.roswell/impls/ALL/ALL/quicklisp/slime-helper.el"))
  (setq inferior-lisp-program "ros -L sbcl -Q run"))

;;; 39-slime-mode.el ends here
