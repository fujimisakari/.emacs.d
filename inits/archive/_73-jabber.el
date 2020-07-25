;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                 jabber設定                                 ;;
;;;--------------------------------------------------------------------------;;;

;; (require 'jabber)

;; ;; アカウント設定
;; (setq jabber-account-list '(
;;                             ("ryou.fujimoto@jiro.asp"
;;                              (:password . "oEYyPsxNamJThsHtZV6n")
;;                              (:network-server . nil)
;;                              (:port . 5222)
;;                              (:connection-type . nil))
;;                             ))

;; ;; 履歴設定(which stored in ~/.emacs-jabber dir):
;; (setq
;;  jabber-history-enabled t
;;  jabber-use-global-history nil
;;  jabber-backlog-number 40
;;  jabber-backlog-days 30
;;  )

;; ;; 受信したメッセージをミニバッファに表示する
;; (define-jabber-alert echo "Show a message in the echo area"
;;   (lambda (msg)
;;     (unless (minibuffer-prompt)
;;       (message "%s" msg))))

;; ;; キーバインド設定
;; (define-key jabber-chat-mode-map (kbd "RET") 'newline)                    ; 新しい行
;; (define-key jabber-chat-mode-map (kbd "C-c RET")'jabber-chat-buffer-send) ; メッセージ送信

;; ;; C-c RET でリンクURLへ移動
;; (add-hook 'jabber-chat-mode-hook 'goto-address)

;; ;; プロンプト設定
;; (setq my-chat-prompt "[%t] %n>\n")
;; (when (featurep 'jabber)
;;   (setq
;;    jabber-chat-foreign-prompt-format my-chat-prompt
;;    jabber-chat-local-prompt-format my-chat-prompt
;;    jabber-groupchat-prompt-format my-chat-prompt
;;    jabber-muc-private-foreign-prompt-format "[%t] %n>\n"
;;    )
;;   )

;; ;; 外観設定
;; (set-face-foreground 'jabber-title-large "gray15")                 ; タイトル
;; (set-face-background 'jabber-title-large "#4f57f9")          ; タイトル(背景)
;; (set-face-foreground 'jabber-title-medium "light green")           ; ID(背景)
;; (set-face-foreground 'jabber-title-small "yellow")                 ; グループ名
;; (set-face-foreground 'jabber-activity-face "yellow")               ; モードラインの受信通知
;; (set-face-foreground 'jabber-activity-personal-face "dodgerblue")  ; 自分のOnlineステータス
;; (set-face-foreground 'jabber-chat-error "orange")                  ; チャットエラー
;; (set-face-foreground 'jabber-chat-prompt-foreign "red")            ; 相手のプロンプト
;; (set-face-foreground 'jabber-chat-prompt-local "dodgerblue")       ; 自分のプロンプト
;; (set-face-foreground 'jabber-chat-prompt-system "cyan")            ; システムからの通知
;; (set-face-foreground 'jabber-rare-time-face "gray15")              ; 時刻表示
;; (set-face-background 'jabber-rare-time-face "lime green")          ; 時刻表示(背景)
;; (set-face-foreground 'jabber-roster-user-away "lime green")        ; 離席中
;; (set-face-foreground 'jabber-roster-user-online "dodgerblue")      ; リストのがOnline
;; (set-face-bold-p 'jabber-rare-time-face t)                         ; 太字設定

;; ;; アバター設定
;; (setq jabber-vcard-avatars-retrieve nil)     ; roster画面ではアバターは非表示
;; (setq jabber-chat-buffer-show-avatar nil)    ; chat画面ではアバターは非表示
;; (setq jabber-display-menu nil)

;; ;; 起動時に読み込み
;; (jabber-connect-all)
