;;; 45-objc-mode.el --- objc-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; 基本設定
(add-hook 'objc-mode-hook
          '(lambda()
             (common-mode-init)
             (auto-complete-mode)
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

;; auto-complete-clangでコード補完
(require 'auto-complete-clang)
(defvar auto-complete-option-command "~/.emacs.d/bin/objc-auto-complete.py")
(defun auto-complete-option ()
  (let* ((search-target-file (concat project-pch-path "*.pch"))
         (pch-file (eshell-extended-glob search-target-file)))
    (if (listp pch-file)
        (let* ((pch-include-option (list "--pch" (expand-file-name (car pch-file))))
               (clang-options (append clang-base-options pch-include-option)))
          (shell-command-to-string (message "%s" (push auto-complete-option-command clang-options))))
      "")))
(setq ac-clang-flags (split-string (replace-regexp-in-string "\n+$" "" (auto-complete-option)) ","))
(setq ac-clang-auto-save t)

(set-face-foreground 'ac-clang-candidate-face "#fff")
(set-face-background 'ac-clang-candidate-face "#444")
(set-face-foreground 'ac-clang-selection-face "#fff")
(set-face-background 'ac-clang-selection-face "#4f57f9")

;;; flymakeで文法チェック
(defvar flymake-command "~/.emacs.d/bin/objc-flymake.py")
(defun flymake-objc-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name)))
         (search-target-file (concat project-pch-path "*.pch"))
         (pch-file (eshell-extended-glob search-target-file)))
    (if (listp pch-file)
        (let ((pch-include-option (list "--pch" (expand-file-name (car pch-file)))))
          (list flymake-command (append clang-base-options pch-include-option (list "--targetfile" local-file))))
      (list flymake-command (append clang-base-options (list "--targetfile" local-file))))))

(defun flymake-display-err-minibuffer ()
  (interactive)
  (let* ((line-no (flymake-current-line-no))
         (line-err-info-list
          (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list
        (let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
               (full-file (flymake-ler-full-file
                           (nth (1- count) line-err-info-list)))
               (text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)))
      (setq count (1- count)))))

(defun flymake-display-err-minibuffer-safe ()
  (ignore-errors flymake-display-err-minibuffer))

;; もともとのパターンにマッチしなかったので追加
(setq flymake-err-line-patterns
      (cons
       '("\\(.+\\):\\([0-9]+\\):\\([0-9]+\\): \\(.+\\)" 1 2 3 4)
       flymake-err-line-patterns))

;; 拡張子 m と h に対して flymake を有効にする設定
(add-hook 'objc-mode-hook
          (lambda ()
            (push '("\\.m$" flymake-objc-init) flymake-allowed-file-name-masks)
            (push '("\\.h$" flymake-objc-init) flymake-allowed-file-name-masks)
            ;; 存在するファイルかつ書き込み可能ファイル時のみ flymake-mode を有効にします
            (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
                (flymake-mode t))))

;;;コード整形できるようにする
(require 'clang-format)

;; quickrunにclangでの実行環境を追加
(add-to-list 'quickrun-file-alist '("\\.m$" . "objc/clang"))
(quickrun-add-command "objc/clang"
                      '((:command . "clang")
                        (:exec    . ("%c -fobjc-arc -framework Foundation %s -o %e" "%e"))
                        (:remove  . ("%e")))
                      :default "objc")

;; Xcodeのドキュメント検索
(require 'helm-xcdoc)
(setq helm-xcdoc-command-path "/Applications/Xcode.app/Contents/Developer/usr/bin/docsetutil")
(setq helm-xcdoc-document-path "~/Library/Developer/Shared/Documentation/DocSets/com.apple.adc.documentation.AppleiOS8.1.iOSLibrary.docset")

;;; 45-objc-mode.el ends here
