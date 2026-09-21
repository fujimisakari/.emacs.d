;;; 01-installer.el --- installer設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Emacs Lisp のパッケージマネージャー
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("jcs-elpa" . "https://jcs-emacs.github.io/jcs-elpa/packages/") t)
;; (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;; (package-refresh-contents) ;; list-packagesしなくてもpackage-installできるように

;; 自動バイトコンパイル
(require 'auto-async-byte-compile)
;; 自動バイトコンパイルを無効にするファイル名の正規表現
;; init.el / early-init.el を除外するのは必須。これらが .elc になると
;; `user-init-file' が init.elc を指し、custom-file 未設定のため
;; `custom-save-all' がバイナリの .elc を編集しようとして
;; "Wrong type argument: stringp" で失敗する (M-x package-install が壊れる)。
(setq auto-async-byte-compile-exclude-files-regexp
      "\\(inits\\|main\\|junk\\|site-lisp\\|/early-init\\.el\\'\\|/init\\.el\\'\\)")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)

;;; 01-installer.el ends here
