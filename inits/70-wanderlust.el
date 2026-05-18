;;; 70-wanderlust.el --- Wanderlust設定 -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; offlineimap で同期した ~/Maildir をリードオンリーで参照する用途。
;; 送信機能・IMAP/POP/SMTP 設定は利用しないため省略している。

;;; Code:

;; HTML パートを表示しない (mime-setup ロード前に設定する必要あり)
(setq mime-setup-enable-inline-html nil)

(with-eval-after-load 'wl
  ;; --- 基本設定 ---

  ;; Maildir のパス
  (setq elmo-maildir-folder-path "~/Maildir")

  ;; Message-ID 生成に利用される。読み取り専用でも警告回避のため設定
  (setq wl-from (gethash "work-mail-address" private-env-hash))

  ;; `wl-summary-goto-folder' の時に選択するデフォルトフォルダ
  (setq wl-default-folder "%inbox")

  ;; フォルダ名補完時に使用するデフォルトのスペック
  (setq wl-default-spec "")

  ;; 終了時に確認する
  (setq wl-interactive-exit t)

  ;; 非同期でフォルダチェック
  (setq wl-folder-check-async t)

  ;; 警告無しに開けるメールサイズの最大値 (デフォルト: 30K)
  (setq elmo-message-fetch-threshold 15000000)


  ;; --- サマリ設定 ---

  ;; サマリバッファの左にフォルダバッファを表示 (3ペイン表示)
  (setq wl-stay-folder-window t)
  ;; フォルダウィンドウの幅 (デフォルト: 20)
  (setq wl-folder-window-width 30)

  ;; サマリ内の移動で未読メッセージがないと次のフォルダに移動するのを抑制
  (setq wl-auto-select-next nil)

  ;; 未読メッセージを優先的に読む
  (setq wl-summary-move-order 'unread)

  ;; サマリ終了時に次のフォルダに移る動きを抑制
  (setq wl-summary-exit-next-move nil)

  ;; サマリモードに入った直後に最下部にカーソルを移動
  (add-hook 'wl-summary-prepared-hook #'wl-summary-display-bottom)

  ;; メールDBに content-type を加える
  (setq elmo-msgdb-extra-fields
        (cons "content-type" elmo-msgdb-extra-fields))

  ;; 一覧表示フォーマット: 一時マーク 永続マーク 添付マーク 日付 枝 [ (子の数) 差出人 ] 件名
  (setq wl-summary-line-format "%T%P%1@%M/%D(%W)%h:%m %t%[%17(%c %f%) %] %#%~%s")

  ;; 添付ファイルがある場合は「@」を表示
  (setq wl-summary-line-format-spec-alist
        (append wl-summary-line-format-spec-alist
                '((?@ (wl-summary-line-attached)))))

  ;; sentディレクトリでは差出人表示を宛先に差し替える
  (setq wl-summary-showto-folder-regexp "^\\+sent$")

  ;; サマリ表示は切り詰めない
  (setq wl-summary-width nil)
  (setq wl-subject-length-limit nil)

  ;; スレッドを常に展開した状態で表示する
  (setq wl-thread-insert-opened t)

  ;; リファイル等で参照するフィールド
  (dolist (extra-fields '("newsgroups" "mailing-list" "list-id" "x-ml-name" "reply-to"
                          "sender" "x-mail-count" "x-ml-count" "x-sequence"))
    (add-to-list 'elmo-msgdb-extra-fields extra-fields))


  ;; --- メール表示設定 ---

  ;; 全てのヘッダを非表示にした上で、表示するヘッダだけ選択する
  (setq wl-message-ignored-field-list '(".*:"))
  (setq wl-message-visible-field-list
        '("^To:" "^From:" "^Cc:" "^Date:" "^Subject:" "User-Agent:" "X-Mailer:" "Content-Type:"))
  (setq wl-message-sort-field-list
        '("^To:" "^From:" "^Cc:" "^Date:" "^Subject:" "User-Agent:" "X-Mailer:" "Content-Type:")))

;; ファイル名が日本語の添付ファイルをデコードする [semi-gnus-ja: 4332]
(defun my/mime-entity-filename-decode (orig-fun &rest args)
  "Decode eworded file name for *BROKEN* MUA."
  (let ((ret (apply orig-fun args)))
    (when (stringp ret)
      (setq ret (eword-decode-string ret t)))
    ret))
(with-eval-after-load 'mime
  (advice-add 'mime-entity-filename :around #'my/mime-entity-filename-decode))

;;; 70-wanderlust.el ends here
