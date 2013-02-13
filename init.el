;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                          各設定ファイルの読み込み                          ;;
;;;--------------------------------------------------------------------------;;;

;;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))
;; site-lispとconfディレクトリをサブディレクトリごとload-pathに追加する
(add-to-load-path "site-lisp" "elpa" "private")

;; 個人環境変数の読み込み
(require 'private-env)

(require 'init-loader)
(init-loader-load "~/.emacs.d/inits")   ; 設定ファイルがあるディレクトリを指定
(put 'set-goal-column 'disabled nil)
