;;; 48-swift-mode.el --- swift-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'swift-mode)

(add-hook 'swift-mode-hook
          (lambda ()
            (mode-init-func)
            (flycheck-mode)
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
(add-to-list 'flycheck-checkers 'swift)
(setq flycheck-swift-sdk-path
      (replace-regexp-in-string "\n+$" ""
                                (shell-command-to-string "xcrun --show-sdk-path --sdk macosx")))

;; flymakeで文法チェック
;; (defvar objc-header-path "/Users/fujimo/dev/workspace_ios/swift-rss-sample/RSSReader")
;; (defvar swfit-flymake-command "~/.emacs.d/bin/swift-flymake.py")
;; (defun flymake-swift-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name)))
;;          (objc-header-target (concat objc-header-path "*-Bridging-Header.h"))
;;          (objc-header-file (eshell-extended-glob objc-header-target)))
;;     (if (listp objc-header-file)
;;         (let ((objc-header-option (list "--objcheader" (expand-file-name (car objc-header-file)))))
;;           (list swfit-flymake-command (append objc-header-option (list "--targetfile" local-file))))
;;       (list swfit-flymake-command (list "--targetfile" local-file)))))
;; (add-to-list 'flymake-allowed-file-name-masks '("\\.swift\\'" flymake-swift-init))

;; ;; flymake用のswiftパターンはないので追加
;; (add-to-list 'flymake-err-line-patterns
;;              '("^.+swift\:\\([0-9]+\\)\:\\([0-9]+\\)\: \\(error\\|warning\\)\: \\(.+\\)$" nil 1 2 4))

;;; 48-swift-mode.el ends here
