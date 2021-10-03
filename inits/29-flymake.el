;;; 28-flymake.el --- flymake設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(flymake-mode-off)
;; (require 'flymake)
;; ;; (require 'flymake-cursor) ; minibufferにエラーメッセージを表示させる

;; ;; メッセージはposframeで表示させる
;; (require 'flymake-posframe)
;; (add-hook 'flymake-mode-hook 'flymake-posframe-mode)
;; (set-face-foreground 'flymake-posframe-foreground-face "white")
;; (set-face-background 'flymake-posframe-background-face "#4f57f9")

;; ;; 文法チェックの頻度の設定
;; (setq flymake-no-changes-timeout 1)

;; ;; 改行時に文法チェックを行うかどうかの設定
;; (setq flymake-start-syntax-check-on-newline nil)

;; ;; syntax checkが異常終了しても無視する
;; (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
;;   (setq flymake-check-was-interrupted t))
;; (ad-activate 'flymake-post-syntax-check)

;; ;; javaとhtml, xmlはflymakeは起動しないようにする
;; (delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks)
;; (delete '("\\.xml\\'" flymake-xml-init) flymake-allowed-file-name-masks)
;; (delete '("\\.java\\'" flymake-simple-make-java-init flymake-simple-java-cleanup) flymake-allowed-file-name-masks)
;; (delete '("\\.cs\\'" flymake-simple-make-init) flymake-allowed-file-name-masks)

;;; 29-flymake.el ends here
