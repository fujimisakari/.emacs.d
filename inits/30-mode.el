;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                              モードの基本設定                              ;;
;;;--------------------------------------------------------------------------;;;

(defun mode-init-func()
  (skk-mode t)
  (setq indent-level 4)
  (c-toggle-hungry-state 1))

(require 'flymake)
(require 'flymake-cursor) ; minibufferにエラーメッセージを表示させる
;; 文法チェックの頻度の設定
(setq flymake-no-changes-timeout 1)
;; 改行時に文法チェックを行うかどうかの設定
(setq flymake-start-syntax-check-on-newline nil)
;; 自動でリアルタイムの文法チェックを有効
;; (add-hook 'c-mode-common-hook (lambda() (flymake-mode t)))
;; syntax checkが異常終了しても無視する
(defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
  (setq flymake-check-was-interrupted t))
(ad-activate 'flymake-post-syntax-check)
;; javaとhtml, xmlはflymakeは起動しないようにする
(delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks)
(delete '("\\.xml\\'" flymake-xml-init) flymake-allowed-file-name-masks)
(delete '("\\.java\\'" flymake-simple-make-java-init flymake-simple-java-cleanup) flymake-allowed-file-name-masks)

;; emacs-lisp-mode
(add-hook 'emacs-lisp-mode-hook 'mode-init-func)

;; text-mode
(add-hook 'text-mode-hook 'mode-init-func)

;; ruby-mode
(add-hook 'ruby-mode-hook 'mode-init-func)

;; dired-mode
(add-hook 'dired-mode-hook
          '(lambda()
             (hl-line-mode t)))

;; org-mode
(add-hook 'org-mode-hook
          '(lambda()
             (skk-mode)))

;; org-remember-mode
(add-hook 'org-remember-mode-hook
          '(lambda()
             (skk-mode)))
