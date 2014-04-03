;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               slime-mode設定                               ;;
;;;--------------------------------------------------------------------------;;;

(when (require 'slime nil t)

  (add-hook 'lisp-mode-hook (lambda ()
                              (slime-mode t)
                              (setq indent-tabs-mode nil)
                              (unless show-paren-mode
                                (show-paren-mode))))
  (add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))

  ;; sbclをデフォルトのCommon Lisp処理系に設定(Clozure CLにする場合はccl)
  (setq inferior-lisp-program "sbcl")
  (slime-setup '(slime-repl slime-fancy slime-banner))
  (setq slime-net-coding-system 'utf-8-unix) ;; 日本語利用のための設定（Lisp 環境側の対応も必要）
  (require 'ac-slime)
  (add-hook 'slime-mode-hook 'set-up-slime-ac)
  (add-hook 'slime-repl-mode-hook 'set-up-slime-ac))
