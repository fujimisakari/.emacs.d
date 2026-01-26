;;; 24-search-replace.el --- 検索・置換設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; moccur検索
(autoload 'moccur-grep-find "color-moccur" nil t)
(with-eval-after-load 'color-moccur
  (setq moccur-split-word t) ; スペース区切りでAND検索
  ;; ディレクトリ検索のとき除外するファイル
  (setq dmoccur-exclusion-mask
        (append '("\\~$" "\\.svn\\/\*" "\\.DS_Store" "\\.pyc$" "^#.+#$") dmoccur-exclusion-mask))
  (require 'moccur-edit nil t))

;; allの拡張
(autoload 'all "all-ext" nil t)
(with-eval-after-load 'all-ext)

;; 複数のgrepバッファを扱う
(autoload 'grep-a-lot-setup-keys "grep-a-lot" nil t)
;; (grep-a-lot-setup-keys)

;;; 24-search-replace.el ends here
