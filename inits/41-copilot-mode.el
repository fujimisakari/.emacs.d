;;; 41-copilot-mode --- copilot-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'copilot)

;; 大きなファイルでもCopilotを使用したい場合、copilot-max-charの制限を引き上げることができます。例えば、5,000,000文字に設定してみると良いでしょう
(setq copilot-max-char 5000000)

;; (add-hook 'prog-mode-hook 'copilot-mode)

;;; 41-copilot-mode ends here
