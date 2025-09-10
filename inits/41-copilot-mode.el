;;; 41-copilot-mode --- copilot-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'copilot)

;; 大きなファイルでもCopilotを使用したい場合、copilot-max-charの制限を引き上げることができます。例えば、5,000,000文字に設定してみると良いでしょう
(setq copilot-max-char 5000000)

(defun my/copilot-indent-offset ()
  "Return indentation offset explicitly for Copilot."
  (or
   ;; 優先的に使われる
   (bound-and-true-p copilot-indent-offset)

   ;; go-mode 対策
   (and (derived-mode-p 'go-mode) (bound-and-true-p go-tab-width))

   ;; fallback
   (and (bound-and-true-p tab-width) tab-width)

   ;; それでも無ければデフォルト
   4))
(advice-add 'copilot--infer-indentation-offset :override #'my/copilot-indent-offset)

;; (add-hook 'prog-mode-hook 'copilot-mode)

;;; 41-copilot-mode ends here
