;;; 61-hankaku-replace.el --- 半角カナ変換 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun my/keitai-hankaku-katakana-region (start end)
  (interactive "r")
  (while (string-match
          "[０-９Ａ-Ｚａ-ｚァ-ンー：；＄]+\\|[！？][！？]+"
          (buffer-substring start end))
    (save-excursion
      (japanese-hankaku-region
       (+ start (match-beginning 0))
       (+ start (match-end 0))
       ))))

(defun my/keitai-hankaku-katakana-buffer ()
  (interactive)
  (keitai-hankaku-katakana-region (point-min) (point-max)))

;; dired を使って、一気にファイル内を半角カナに変換する
(require 'dired-aux)
(defun my/dired-setup-hankaku-katakana-key ()
  "Setup T key for hankaku-katakana conversion in dired."
  (define-key (current-local-map) "T" #'my/dired-do-convert-hankaku-katakana))
(add-hook 'dired-mode-hook #'my/dired-setup-hankaku-katakana-key)

(defun my/dired-convert-hankaku-katakana ()
  (let ((file (dired-get-filename)) failure)
    (condition-case err
        (with-temp-buffer
          (insert-file file)
          (keitai-hankaku-katakana-region (point-min) (point-max))
          (write-region (point-min) (point-max) file))
      (error (setq failure err)))
    (if (not failure)
        nil
      (dired-log "convert hankaku-katakana error for %s:\n%s\n" file failure)
      (dired-make-relative file))))

(defun my/dired-do-convert-hankaku-katakana (&optional arg)
  "Convert file (s) in hankaku-katakana."
  (interactive)
  (dired-map-over-marks-check
   (function dired-convert-hankaku-katakana) arg 'hankaku-katakana-convert t))

;;; 61-hankaku-replace.el ends here
