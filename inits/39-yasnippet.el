;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               yasnippet設定                                ;;
;;;--------------------------------------------------------------------------;;;

(require 'yasnippet-config)
(yas/setup "~/.emacs.d/site-lisp/yasnippet-0.6.1c")
(setq yas/trigger-key (kbd "C-c @"))
(global-set-key (kbd "C-x y") 'yas/register-oneshot-snippet)
(global-set-key (kbd "C-x C-y") 'yas/expand-oneshot-snippet)
