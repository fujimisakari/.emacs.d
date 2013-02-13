;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               Wanderlust設定                               ;;
;;;--------------------------------------------------------------------------;;;

(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

;; アイコンを置くディレクトリ。初期設定は Emacs 固有のデフォルト値。
(setq wl-icon-directory "~/.emacs.d/elisp/wl/icons")

;; メールドラフトモードをWandarlustドラフトモードに
(autoload 'wl-user-agent-compose "wl-draft" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'wl-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'wl-user-agent
      'wl-user-agent-compose
      'wl-draft-send
      'wl-draft-kill
      'mail-send-hook))