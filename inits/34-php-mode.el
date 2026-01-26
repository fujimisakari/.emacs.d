;;; 34-php-mode.el --- php-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; autoload
(autoload 'php-mode "php-mode" nil t)

(defun my/php-mode-setup ()
  "Setup for php-mode."
  (common-mode-init)
  ;; (setq tab-width 4)
  (flymake-mode-off)
  ;; (flycheck-mode)
  (setq indent-tabs-mode nil)
  (setq c-hungry-delete-key nil)
  (setq ac-sources '(ac-source-php)))
(add-hook 'php-mode-hook #'my/php-mode-setup)

(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))

(defun web-php-mode-toggle ()
  (interactive)
  (if (eq major-mode 'php-mode)
      (web-mode)
    (php-mode)))

(defun insert-php-arrow-for-instance ()
  (interactive)
  (insert "->"))

(defun insert-php-arrow-for-array ()
  (interactive)
  (insert "=>"))

(defun insert-php-script-tag ()
  (interactive)
  (insert "<?php  ?>"))

(defun insert-php-short-tag ()
  (interactive)
  (insert "<?=  ?>"))

;;; 34-php-mode.el ends here
