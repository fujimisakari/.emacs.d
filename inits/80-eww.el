;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                  eww設定                                   ;;
;;;--------------------------------------------------------------------------;;;

;; (defun eww-mode-hook--rename-buffer ()
;;   "Rename eww browser's buffer so sites open in new page."
;;   (rename-buffer "ewwl" t))
;; (add-hook 'eww-mode-hook 'eww-mode-hook--rename-buffer)

;; default の検索エンジンを Google に変更
(setq eww-search-prefix "http://www.google.co.jp/search?q=")

;; 背景色の設定
(defvar eww-disable-colorize t)
(defun shr-colorize-region--disable (orig start end fg &optional bg &rest _)
  (unless eww-disable-colorize
    (funcall orig start end fg)))
(advice-add 'shr-colorize-region :around 'shr-colorize-region--disable)
(advice-add 'eww-colorize-region :around 'shr-colorize-region--disable)
(defun eww-disable-color ()
  "eww で文字色を反映させない"
  (interactive)
  (setq-local eww-disable-colorize t)
  (eww-reload))
(defun eww-enable-color ()
  "eww で文字色を反映させる"
  (interactive)
  (setq-local eww-disable-colorize nil)
  (eww-reload))
