;;; 52-elixir-mode.el --- elixir-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'elixir-mode)
(require 'alchemist)
(require 'flycheck-elixir)

(add-hook 'elixir-mode-hook
          '(lambda()
             (common-mode-init)
             (smartparens-mode)
             (setq tab-width 2)
             (setq tab-stop-list (tab-stop-list-creator tab-width))
             (ac-alchemist-setup)
             (flycheck-mode)))

;; TODO
;; code skelton
;; alchemist設定

;; dokumento

(defun insert-elixir-chain-arrow ()
  (interactive)
  (insert "|>"))

(defun insert-elixir-patern-match-arrow ()
  (interactive)
  (insert "->"))

(defun insert-elixir-map-arrow ()
  (interactive)
  (insert "=>"))

;;; 52-elixir-mode.el ends here
