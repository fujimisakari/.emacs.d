;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                  Info設定                                  ;;
;;;--------------------------------------------------------------------------;;;

;; 日本語マニュアルの導入
(setq Info-directory-list
    (list "~/.emacs.d/info/" "~/.emacs.d/info/emacs-info/" "~/.emacs.d/info/wl/"))
(auto-compression-mode t)    ; 日本語infoを読めるようになる

;; キーバインド設定
(eval-after-load "info"
  '(progn
     (define-key Info-mode-map "f" 'Info-history-forward)
     (define-key Info-mode-map "b" 'Info-history-back)))
