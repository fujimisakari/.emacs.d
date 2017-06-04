;;; 47-arduino-mode.el --- arduino-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; 基本設定
(add-hook 'arduino-mode-hook
          '(lambda()
             (common-mode-init)))

;;; 47-arduino-mode.el ends here
