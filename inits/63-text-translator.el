;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                  自動翻訳                                  ;;
;;;--------------------------------------------------------------------------;;;

;; 言語を自動判別して複数のWeb翻訳サービスを同時に使う
(require 'text-translator)
(setq text-translator-auto-selection-func
      'text-translator-translate-by-auto-selection-enja)
(global-set-key (kbd "C-l C-;") 'text-translator-all-by-auto-selection)  ; 自動翻訳