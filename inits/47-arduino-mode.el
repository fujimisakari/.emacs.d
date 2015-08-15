;;; 47-arduino-mode.el --- arduino-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; 基本設定
(add-hook 'arduino-mode-hook
          '(lambda()
             (mode-init-func)
             (skk-mode t)))

;;; 47-arduino-mode.el ends here
