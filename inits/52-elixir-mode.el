;;; 52-elixir-mode.el --- elixir-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; autoload
(autoload 'elixir-mode "elixir-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.exs?$" . elixir-mode))

(with-eval-after-load 'elixir-mode
  (require 'flycheck-elixir))

(defun my/elixir-mode-setup ()
  "Setup for elixir-mode."
  (my/common-mode-init)
  (smartparens-mode)
  (setq tab-width 2)
  (setq tab-stop-list (my/tab-stop-list-creator tab-width))
  (flycheck-mode))
(add-hook 'elixir-mode-hook #'my/elixir-mode-setup)

(defun my/insert-elixir-chain-arrow ()
  (interactive)
  (insert "|>"))

(defun my/insert-elixir-patern-match-arrow ()
  (interactive)
  (insert "->"))

(defun my/insert-elixir-map-arrow ()
  (interactive)
  (insert "=>"))

;;; 52-elixir-mode.el ends here
