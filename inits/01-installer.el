;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                             インストーラー設定                              ;;
;;;--------------------------------------------------------------------------;;;

;;; Emacs Lispインストーラーの設定例定
;; (install-elisp "http://www.emacswiki.org/emacs/download/auto-install.el")
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/site-lisp/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

;;; Emacs Lisp のパッケージマネージャー
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;; (package-refresh-contents) ;; list-packagesしなくてもpackage-installできるように
(package-initialize)

;;; 自動バイトコンパイル
(require 'auto-async-byte-compile)
;; 自動バイトコンパイルを無効にするファイル名の正規表現
;(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
