;;; 52-elixir-mode.el --- elixir-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'elixir-mode)
(require 'flycheck-elixir)

(defun my/elixir-mode-setup ()
  "Setup for elixir-mode."
  (common-mode-init)
  (smartparens-mode)
  (setq tab-width 2)
  (setq tab-stop-list (tab-stop-list-creator tab-width))
  (flycheck-mode))
(add-hook 'elixir-mode-hook #'my/elixir-mode-setup)

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
