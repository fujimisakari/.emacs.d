;;; 48-swift-mode.el --- swift-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'swift-mode)

(add-hook 'swift-mode-hook
          (lambda ()
            (mode-init-func)
            (auto-complete-mode)))

;; 補完
(require 'auto-complete-swift)
(push 'ac-source-swift-complete ac-sources)

;; tagジャンプ
(defun helm-etags-select-other-window (reinit)
  (interactive "P")
  (other-window-or-split)
  (helm-etags-select reinit))

;; flycheckで文法チェック
;; (add-to-list 'flycheck-checkers 'swift)
;; (setq flycheck-swift-sdk-path
;;       (replace-regexp-in-string "\n+$" ""
;;                                 (shell-command-to-string "xcrun --show-sdk-path --sdk macosx")))

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
             '("^.+swift\:\\([0-9]+\\)\:\\([0-9]+\\)?\: \\(error\\|warning\\)\: \\(.+\\)$" nil 1 2 4))

;;; 48-swift-mode.el ends here
