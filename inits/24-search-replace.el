;;; 24-search-replace.el --- 検索・置換設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; moccur検索
(when (require 'color-moccur nil t)
  (set-face-background 'moccur-face "pale green") ; 検索結果に対応した色
  (setq moccur-split-word t) ; スペース区切りでAND検索
  ;; ディレクトリ検索のとき除外するファイル
  (setq dmoccur-exclusion-mask
        (append '("\\~$" "\\.svn\\/\*" "\\.DS_Store" "\\.pyc$" "^#.+#$") dmoccur-exclusion-mask))
  (require 'moccur-edit nil t)
  ;; Migemoを利用できる環境であればMigemoを使う
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (setq moccur-use-migemo t)))

;; ローマ字のまま日本語をインクリメンタルサーチする(C/Migemoを使う)
(when (and (executable-find "cmigemo")
           (require 'migemo nil t))
  ;; cmigemoを使う
  (setq migemo-command "/usr/local/bin/cmigemo")
  ;; migemoのコマンドラインオプション
  (setq migemo-options '("-q" "--emacs"))
  ;; migemo辞書の場所
  (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
  ;; cmigemoで必須の設定
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  ;; キャッシュの設定
  (setq migemo-use-pattern-alist t)
  (setq migemo-use-frequent-pattern-alist t)
  (setq migemo-pattern-alist-length 1000)
  (setq migemo-coding-system 'utf-8-unix)
  ;; migemoを起動する
  (migemo-init))

;; allの拡張
(require 'all-ext)

;; 複数のgrepバッファを扱う
(require 'grep-a-lot)
;; (grep-a-lot-setup-keys)

;; grep検索結果を編集できるようにする
(require 'grep-edit)

;; igrep設定
(require 'igrep)
;; igrepに-Ou8オプションを付けると出力がUTF-8になる
(igrep-define lgrep (igrep-use-zgrep nil)(igrep-regex-option "-n -Ou8"))
(igrep-find-define lgrep (igrep-use-zgrep nil)(igrep-regex-option "-n -Ou8"))

;;; 24-search-replace.el ends here
