;;; 80-eww.el --- eww設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; default の検索エンジンを Google に変更
(setq eww-search-prefix "http://www.google.co.jp/search?q=")

;; 背景色の設定
(defvar eww-disable-colorize t)
(defun my/shr-colorize-region--disable (orig start end fg &optional bg &rest _)
  (unless eww-disable-colorize
    (funcall orig start end fg)))
(advice-add 'shr-colorize-region :around 'my/shr-colorize-region--disable)
(advice-add 'eww-colorize-region :around 'my/shr-colorize-region--disable)
(defun my/eww-disable-color ()
  "eww で文字色を反映させない"
  (interactive)
  (setq-local eww-disable-colorize t)
  (eww-reload))
(defun my/eww-enable-color ()
  "eww で文字色を反映させる"
  (interactive)
  (setq-local eww-disable-colorize nil)
  (eww-reload))

;;; 80-eww.el ends here
