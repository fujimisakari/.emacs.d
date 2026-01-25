;;; 24-search-replace.el --- 検索・置換設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; moccur検索
(when (require 'color-moccur nil t)
  (setq moccur-split-word t) ; スペース区切りでAND検索
  ;; ディレクトリ検索のとき除外するファイル
  (setq dmoccur-exclusion-mask
        (append '("\\~$" "\\.svn\\/\*" "\\.DS_Store" "\\.pyc$" "^#.+#$") dmoccur-exclusion-mask))
  (require 'moccur-edit nil t))

;; allの拡張
(require 'all-ext)

;; 複数のgrepバッファを扱う
(require 'grep-a-lot)
;; (grep-a-lot-setup-keys)

;;; 24-search-replace.el ends here
