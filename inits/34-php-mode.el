;;; 34-php-mode.el --- php-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'php-mode)
(require 'ac-php)

(add-hook 'php-mode-hook
          (lambda()
            (mode-init-with-skk)
            ;; (setq tab-width 4)
            (flymake-mode-off)
            ;; (flycheck-mode)
            (setq indent-tabs-mode nil)
            (setq c-hungry-delete-key nil)
            (setq ac-sources '(ac-source-php))))

(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))

(defun web-php-mode-toggle ()
  (interactive)
  (if (eq major-mode 'php-mode)
      (web-mode)
    (php-mode)))

(defun insert-arrow-for-instance ()
  (interactive)
  (insert "->"))

(defun insert-arrow-for-array ()
  (interactive)
  (insert "=>"))

(defun insert-php-script-tag ()
  (interactive)
  (insert "<?php  ?>"))

(defun insert-php-short-tag ()
  (interactive)
  (insert "<?=  ?>"))

;; タブインデント単位で削除できるようにする
(defun indent-dedent-line-p ()
  "Check if De-indent current line."
  (interactive "*")
  (when (and (<= (point-marker) (save-excursion
                                  (back-to-indentation)
                                  (point-marker)))
             (> (current-column) 0))
    t))

(defun indent-dedent-line-backspace (arg)
  "De-indent current line."
  (interactive "*p")
  (if (indent-dedent-line-p)
      (backward-delete-char-untabify tab-width)
    (delete-backward-char arg)))
(put 'indent-dedent-line-backspace 'delete-selection 'supersede)

;;; 34-php-mode.el ends here
