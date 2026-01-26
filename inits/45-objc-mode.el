;;; 45-objc-mode.el --- objc-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; autoload
(autoload 'clang-format-region "clang-format" nil t)

;; 基本設定
(defun my/objc-mode-setup ()
  "Setup for objc-mode."
  (common-mode-init)
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode nil))
(add-hook 'objc-mode-hook #'my/objc-mode-setup)

;; .hと.mを左右に並べて開く
(defun open-header-and-method-file ()
  (interactive)
  (other-window-or-split)
  (ff-find-other-file))

;; objc-mode (cc-mode) 読み込み後の設定
(with-eval-after-load 'cc-mode
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

  (defun my/ff-get-file-name-framework (orig-fun search-dirs fname-stub &optional suffix-list)
    "Search for Mac framework headers as well as POSIX headers."
    (or
     (when (string-match "\\(.*?\\)/\\(.*\\)" fname-stub)
       (let* ((framework (match-string 1 fname-stub))
              (header (match-string 2 fname-stub))
              (new-fname-stub (concat framework ".framework/Headers/" header)))
         (funcall orig-fun search-dirs new-fname-stub suffix-list)))
     (funcall orig-fun search-dirs fname-stub suffix-list)))
  (advice-add 'ff-get-file-name :around #'my/ff-get-file-name-framework)

  ;; ff-find-other-fileで.hファイルと.mファイルをトグルできるようにする
  (require 'find-file) ;; for the "cc-other-file-alist" variable
  (nconc (cadr (assoc "\\.h\\'" cc-other-file-alist)) '(".m" ".mm")))

;; quickrunにclangでの実行環境を追加
(with-eval-after-load 'quickrun
  (add-to-list 'quickrun-file-alist '("\\.m$" . "objc/clang"))
  (quickrun-add-command "objc/clang"
                        '((:command . "clang")
                          (:exec    . ("%c -fobjc-arc -framework Foundation %s -o %e" "%e"))
                          (:remove  . ("%e")))
                        :default "objc"))

;;; 45-objc-mode.el ends here
