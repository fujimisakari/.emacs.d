;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                          各設定ファイルの読み込み                          ;;
;;;--------------------------------------------------------------------------;;;

;;; load-path を追加する関数を定義

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))
;; site-lispとconfディレクトリをサブディレクトリごとload-pathに追加する
(add-to-load-path "site-lisp" "elpa" "private/env")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'my-visual t)

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
            ;; show init time
            (message "init time: %.3f sec"
                     (float-time (time-subtract after-init-time before-init-time)))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(anzu-deactivate-region t)
 '(anzu-mode-lighter "")
 '(anzu-replace-to-string-separator " => ")
 '(anzu-search-threshold 1000)
 '(magit-log-margin '(t "%Y-%m-%d %H:%M" magit-log-margin-width t 12))
 '(package-selected-packages nil)
 '(package-vc-selected-packages
   '((vue-ts-mode :url "https://github.com/8uff3r/vue-ts-mode" :branch
                  "main")))
 '(tab-stop-list (my/tab-stop-list-creator 4)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-block-begin-line ((t (:foreground "gray30" :background "gray3" :slant italic))))
 '(org-block-end-line ((t (:foreground "gray30" :background "gray3" :slant italic)))))
