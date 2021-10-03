;;; 48-swift-mode.el --- swift-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'swift-mode)

(add-hook 'swift-mode-hook
          (lambda ()
            (common-mode-init)))

;; flymakeでシンタックス、文法チェック
(defvar swift-project-path (gethash "swift-project-root-path" private-env-hash))
(defvar swift-objc-header-path (gethash "swift-objc-header-path" private-env-hash))
(defvar swfit-flymake-command "~/.emacs.d/bin/swift-flymake.sh")
(defun flymake-swift-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name)))
         (objc-header-target (concat swift-objc-header-path "/*-Bridging-Header.h"))
         (objc-header-file-list (eshell-extended-glob objc-header-target)))
    (if (listp objc-header-file-list)
        (let ((objc-header-file (expand-file-name (car objc-header-file-list))))
          (list swfit-flymake-command (list swift-project-path local-file objc-header-file)))
      (list swfit-flymake-command (list swift-project-path local-file)))))
(add-to-list 'flymake-allowed-file-name-masks '("\\.swift\\'" flymake-swift-init))

;; flymake用のswiftパターンはないので追加
(add-to-list 'flymake-err-line-patterns
             '("^.+swift\:\\([0-9]+\\)\:\\([0-9]+\\)?\: \\(.+\\)$" nil 1 2 3))

;;; 48-swift-mode.el ends here
