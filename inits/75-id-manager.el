;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               id-manager設定                               ;;
;;;--------------------------------------------------------------------------;;;

;; a,+  新規レコード追加
;; u,r  リロード
;; e,m  編集
;; d,-  削除
;; Enter    パスワード113コピー
;; S    パスワード114表示のトグル
;; T    更新日時でソート
;; N    アカウント115名でソート
;; I    アカウント116のIDでソート
;; M    メモの内容でソート
(autoload 'id-manager "id-manager" nil t)
(setq epa-file-cache-passphrase-for-symmetric-encryption t)  ; パスワードのキャッシュ
;; (setenv "GPG_AGENT_INFO" nil)                                ; minibufferでパスワードを入力する場合
(global-set-key (kbd "<f6>") 'id-manager)
