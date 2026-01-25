;;; 70-wanderlust.el --- Wanderlust設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

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

;;; 70-wanderlust.el ends here
