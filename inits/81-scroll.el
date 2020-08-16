;;; 81-scroll.el --- scroll設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; スクロールは一行にする
(setq scroll-conservatively 35 scroll-margin 0 scroll-step 1)

;; ページスクロール時に画面上におけるカーソルの位置をなるべく変えないようにする
(setq scroll-preserve-screen-position t)

;; カーソル維持したままスクロール
(defun scroll-up-in-place (n)
  (interactive "p")
  (scroll-down n))

(defun scroll-down-in-place (n)
  (interactive "p")
  (scroll-up n))

;;; 81-scroll.el ends here
