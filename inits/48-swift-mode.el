;;; 48-swift-mode.el --- swift-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'swift-mode)

(add-hook 'swift-mode-hook
          (lambda ()
            (common-mode-init)))

;;; 48-swift-mode.el ends here
