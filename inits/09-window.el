;;; 09-window.el --- Window設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; ウィンドウを分割していないときは、左右分割して新しいウィンドウを作る
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p) (split-window-horizontally))
  (other-window 1))

;;; 09-window.el ends here
