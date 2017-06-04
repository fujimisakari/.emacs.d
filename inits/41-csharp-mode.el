;;; 41-csharp-mode.el --- csharp-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; (require 'omnisharp)

;; ;; C#モードフック
;; (add-hook 'csharp-mode-hook
;;           '(lambda()
;;              (setq comment-column 40)
;;              (setq c-basic-offset 4)
;;              (setq tab-width 4)
;;              (setq indent-tabs-mode nil)
;;              ;; (font-lock-add-magic-number)
;;              ;; オフセットの調整
;;              (c-set-offset 'substatement-open 0)
;;              (c-set-offset 'case-label '+)
;;              (c-set-offset 'arglist-intro '+)
;;              (c-set-offset 'arglist-close 0)
;;              ;; (hl-line-mode)
;;              (common-mode-init)
;;              (flycheck-mode 1)
;;              (omnisharp-mode)
;;              (setq csharp-want-imenu nil)))

;; (setq omnisharp-server-executable-path (expand-file-name "~/projects/OmniSharpServer/OmniSharp/bin/Debug/OmniSharp.exe"))

;; (setq flycheck-check-syntax-automatically '(mode-enabled save idle-change))
;; (setq flycheck-idle-change-delay 2)

;;; 41-csharp-mode.el ends here
