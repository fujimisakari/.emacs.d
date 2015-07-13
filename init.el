;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                          各設定ファイルの読み込み                          ;;
;;;--------------------------------------------------------------------------;;;

;;; load-path を追加する関数を定義

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))
;; site-lispとconfディレクトリをサブディレクトリごとload-pathに追加する
(add-to-load-path "site-lisp" "elpa" "el-get" "private/env")

;; 個人環境変数の読み込み
(require 'private-env)

;; init loader
(require 'init-loader)
(init-loader-load "~/.emacs.d/inits")   ; 設定ファイルがあるディレクトリを指定
(put 'set-goal-column 'disabled nil)

;; after init
(add-hook 'after-init-hook
          (lambda ()
            ;; 不要なメニューを非表示
            (define-key global-map [menu-bar Anything] 'undefined)
            (define-key global-map [menu-bar SKK] 'undefined)
            (define-key global-map [menu-bar file] 'undefined)
            (define-key global-map [menu-bar options] 'undefined)
            (define-key global-map [menu-bar tools] 'undefined)
            (define-key global-map [menu-bar javascript] 'undefined)
            (define-key global-map [menu-bar summary] 'undefined)
            (define-key global-map [menu-bar edit] 'undefined)
            (define-key global-map [menu-bar YASnippet] 'undefined)
            (define-key global-map [menu-bar w3m] 'undefined)
            ;; ブラウザはmacを使用する
            (setq browse-url-browser-function 'browse-url-generic)
            (setq browse-url-generic-program
                  (if (file-exists-p "/usr/bin/open")
                      "/usr/bin/open"))
            ;; show init time
            (message "init time: %.3f sec"
                     (float-time (time-subtract after-init-time before-init-time)))))
