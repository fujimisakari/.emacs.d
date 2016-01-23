;;; 98-utility.el --- utility設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun open-browse-by-url ()
  "w3m上のリンクやURL文字列をブラウザで開く"
  (interactive)
  (setq w3m-url (w3m-print-this-url))
  (if (> (length w3m-url) 0)
      (browse-url w3m-url browse-url-new-window-flag)
    (browse-url-at-point)))


;; windowを入れ変える
;; http://emacswiki.org/emacs/TransposeWindowsより参照
(defun swap-window-positions ()
  "*Swap the positions of this window and the next one."
  (interactive)
  (let ((other-window (next-window (selected-window) 'no-minibuf)))
    (let ((other-window-buffer (window-buffer other-window))
          (other-window-hscroll (window-hscroll other-window))
          (other-window-point (window-point other-window))
          (other-window-start (window-start other-window)))
      (set-window-buffer other-window (current-buffer))
      (set-window-hscroll other-window (window-hscroll (selected-window)))
      (set-window-point other-window (point))
      (set-window-start other-window (window-start (selected-window)))
      (set-window-buffer (selected-window) other-window-buffer)
      (set-window-hscroll (selected-window) other-window-hscroll)
      (set-window-point (selected-window) other-window-point)
      (set-window-start (selected-window) other-window-start))
    (select-window other-window)))

;; 現在時間
(defun display-now-time ()
  (interactive)
  (message "%s" (format-time-string "%Y-%m-%d %H:%M (%A)")))

;;; 98-utility.el ends here
