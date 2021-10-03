;;; 09-window.el --- Window設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; ウィンドウを分割していないときは、左右分割して新しいウィンドウを作る
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p) (split-window-horizontally))
  (other-window 1))

;; 画面分割時にいい感じの比率にしてくれる
(golden-ratio-mode 1)
(setq golden-ratio-adjust-factor 3.
      golden-ratio-wide-adjust-factor 3.)
(setq golden-ratio-exclude-modes '("calendar-mode" "wl-folder-mode" "wl-summary-mode"))
(setq golden-ratio-exclude-buffer-names '(" *Org tags*" " *Org todo*" "Foldor" "Summmary"))

(require 'ace-window)
(setq aw-keys '(?j ?k ?l ?i ?o ?h ?y ?u ?p))
(set-face-attribute 'aw-leading-char-face t :height 4.0 :foreground "#f1fa8c")

;;; 09-window.el ends here
