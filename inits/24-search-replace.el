;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                             検索・置換関連                                 ;;
;;;--------------------------------------------------------------------------;;;

;; moccur検索
;; (install-elisp-from-emacswiki color-moccur.el)
;; (install-elisp-from-emacswiki moccur-edit.el)
(when (require 'color-moccur nil t)
  (global-set-key (kbd "C-M-o") 'occur-by-moccur)
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
(global-set-key (kbd "C-l f") 'moccur-grep-find)

;; ローマ字のまま日本語をインクリメンタルサーチする(C/Migemoを使う)
(when (and (executable-find "cmigemo")
           (require 'migemo nil t))
  ;; cmigemoを使う
  (setq migemo-command "/usr/local/bin/cmigemo")
  ;; migemoのコマンドラインオプション
  (setq migemo-options '("-q" "--emacs" "-i" "\a"))
  ;; migemo辞書の場所
  (setq migemo-dictionary "../share/migemo/utf-8/migemo-dict")
  ;; cmigemoで必須の設定
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  ;; キャッシュの設定
  (setq migemo-use-pattern-alist t)
  (setq migemo-use-frequent-pattern-alist t)
  (setq migemo-pattern-alist-length 1000)
  (setq migemo-coding-system 'utf-8-unix)
  ;; migemoを起動する
  ;; (migemo-init)
  )

;; allの拡張
(require 'all-ext)

;; 複数のgrepバッファを扱う
(require 'grep-a-lot)
;; (grep-a-lot-setup-keys)

;; grepコマンドパラメータを変更する
(grep-apply-setting 'grep-command "grep -nHr -e \"\" .")
(setq grep-find-command "find . -type f -not -name \"*.svn*\" -and  -not -name \"*.elc\" -and -not -name \"*.zsh_history\"  -print0 | xargs -0 -e grep -nHr -e \"\"")

;; grep検索結果を編集できるようにする
(require 'grep-edit)

;; igrep設定
(require 'igrep)
;; igrepに-Ou8オプションを付けると出力がUTF-8になる
(igrep-define lgrep (igrep-use-zgrep nil)(igrep-regex-option "-n -Ou8"))
(igrep-find-define lgrep (igrep-use-zgrep nil)(igrep-regex-option "-n -Ou8"))
