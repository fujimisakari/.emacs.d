;;; 48-swift-mode.el --- swift-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'swift-mode)

(defun my/swift-mode-setup ()
  "Setup for swift-mode."
  (common-mode-init))
(add-hook 'swift-mode-hook #'my/swift-mode-setup)

;;; 48-swift-mode.el ends here
