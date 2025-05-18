;;; 30-mode.el --- モードの基本設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun common-mode-init ()
  (rainbow-delimiters-mode)
  (eldoc-mode t))

;; zshはshell-script-modeで起動
(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))

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

;; 関数・変数のヘルプをエコーエリアに表示する
(require 'eldoc-extension)        ; 拡張版
(setq eldoc-idle-delay 0.2)       ; すぐに表示したい
(setq eldoc-minor-mode-string "") ; モードラインにElDocと表示しない
(setq eldoc-echo-area-use-multiline-p t)

;;; 30-mode.el ends here
