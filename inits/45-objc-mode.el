;;; 45-objc-mode.el --- objc-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; 基本設定
(add-hook 'objc-mode-hook
          '(lambda()
             (common-mode-init)
             (setq c-basic-offset 4)
             (setq tab-width 4)
             (setq indent-tabs-mode nil)))

;; revelとコンフリクトするので一旦コメント
;; .hファイルをobjc-modeで開く
;; (add-to-list 'magic-mode-alist
;;              `(,(lambda ()
;;                   (and (string= (file-name-extension buffer-file-name) "h")
;;                        (re-search-forward "@\\<interface\\>"
;;                                           magic-mode-regexp-match-limit t)))
;;                . objc-mode))

;; 共通設定
(defvar xcode:sdk "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk")
(defvar xcode:framework (concat xcode:sdk "/System/Library/Frameworks"))
(defvar project-root-path (gethash "objc-project-root-path" private-env-hash))
(defvar project-pch-path (gethash "objc-project-pch-path" private-env-hash))
(defvar option-framework (concat xcode:framework (concat " -F " project-root-path)))
(defvar clang-base-options (list "--root-path" project-root-path "--framework" option-framework "--sdk" xcode:sdk))
(require 'em-glob) ; Pathを参照する時ワイルドカードを利用するため

;; ff-find-other-fileの検索対象にFrameworkの.hファイルを含めるようにする
(setq xcode:frameworks (concat xcode:sdk "/System/Library/Frameworks"))
(setq cc-search-directories (list "." xcode:frameworks))
(defadvice ff-get-file-name (around ff-get-file-name-framework
                                    (search-dirs
                                     fname-stub
                                     &optional suffix-list))
  "Search for Mac framework headers as well as POSIX headers."
  (or
   (if (string-match "\\(.*?\\)/\\(.*\\)" fname-stub)
       (let* ((framework (match-string 1 fname-stub))
              (header (match-string 2 fname-stub))
              (fname-stub (concat framework ".framework/Headers/" header)))
         ad-do-it))
   ad-do-it))
(ad-enable-advice 'ff-get-file-name 'around 'ff-get-file-name-framework)
(ad-activate 'ff-get-file-name)

;; ff-find-other-fileで.hファイルと.mファイルをトグルできるようにする
(require 'find-file) ;; for the "cc-other-file-alist" variable
(nconc (cadr (assoc "\\.h\\'" cc-other-file-alist)) '(".m" ".mm"))

;; .hと.mを左右に並べて開く
(defun open-header-and-method-file ()
  (interactive)
  (other-window-or-split)
  (ff-find-other-file))

;; コード補完
;; (require 'emaXcode)
;; (setq xcode:foundation (concat xcode:framework "/Foundation.framework/Headers/"))
;; (setq xcode:uikit (concat xcode:framework "/UIKit.framework/Headers/"))
;; (setq emaXcode-yas-objc-header-directories-list (list xcode:foundation xcode:uikit))

;;;コード整形できるようにする
(require 'clang-format)

;; quickrunにclangでの実行環境を追加
(add-to-list 'quickrun-file-alist '("\\.m$" . "objc/clang"))
(quickrun-add-command "objc/clang"
                      '((:command . "clang")
                        (:exec    . ("%c -fobjc-arc -framework Foundation %s -o %e" "%e"))
                        (:remove  . ("%e")))
                      :default "objc")

;;; 45-objc-mode.el ends here
