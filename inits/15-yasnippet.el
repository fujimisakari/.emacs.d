;;; 15-yasnippet.el --- yasnippet設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'yasnippet)
;; ~/.emacs.d/にsnippetsというフォルダを作っておきましょう
(setq yas-snippet-dirs
      '("~/.emacs.d/share/snippets"))
(yas-global-mode 0)
(yas-load-directory "~/.emacs.d/share/snippets")

;; ;; 単語展開キーバインド (ver8.0から明記しないと機能しない)
;; ;; (setqだとtermなどで干渉問題ありでした)
;; ;; もちろんTAB以外でもOK 例えば "C-;"とか
;; (custom-set-variables '(yas-trigger-key "TAB"))

;;; 15-yasnippet.el ends here
