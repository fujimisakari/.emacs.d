;;; 01-installer.el --- installer設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Emacs Lispインストーラーの設定
;; (install-elisp "http://www.emacswiki.org/emacs/download/auto-install.el")
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/site-lisp/")
  ;; (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

;; Emacs Lisp のパッケージマネージャー
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("jcs-elpa" . "https://jcs-emacs.github.io/jcs-elpa/packages/") t)
;; (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;; (package-refresh-contents) ;; list-packagesしなくてもpackage-installできるように

;; el-get
(setq el-get-dir "~/.emacs.d/el-get/")
;; (add-to-list 'el-get-recipe-path "~/.emacs.d/el-get/recipes")
;; (unless (require 'el-get nil 'noerror)
;;   (with-current-buffer
;;       (url-retrieve-synchronously
;;        "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
;;     (goto-char (point-max))
;;     (eval-print-last-sexp)))
;; (el-get 'sync)

;; 自動バイトコンパイル
(require 'auto-async-byte-compile)
;; 自動バイトコンパイルを無効にするファイル名の正規表現
(setq auto-async-byte-compile-exclude-files-regexp "\\(inits\\|main\\|junk\\|site-lisp\\)")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)

;;; 01-installer.el ends here
