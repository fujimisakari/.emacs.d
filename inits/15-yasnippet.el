;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               yasnippet設定                                ;;
;;;--------------------------------------------------------------------------;;;

(require 'yasnippet)
;; ~/.emacs.d/にsnippetsというフォルダを作っておきましょう
(setq yas-snippet-dirs
      '("~/.emacs.d/share/snippets"))
(yas-global-mode 1)
(yas-load-directory "~/.emacs.d/share/snippets")

;; 単語展開キーバインド (ver8.0から明記しないと機能しない)
;; (setqだとtermなどで干渉問題ありでした)
;; もちろんTAB以外でもOK 例えば "C-;"とか
(custom-set-variables '(yas-trigger-key "TAB"))
