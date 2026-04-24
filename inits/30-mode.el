;;; 30-mode.el --- モードの基本設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun my/common-mode-init ()
  (rainbow-delimiters-mode)
  (eldoc-mode t))

;; --- image-mode ---
(setq image-use-external-converter t)

(defun my/image-auto-orient ()
  "EXIF の Orientation に従って画像を回転する (ImageMagick 利用)."
  (when (and buffer-file-name
             (string-match-p "\\.jpe?g\\'" (downcase buffer-file-name))
             (executable-find "magick"))
    (let* ((raw (ignore-errors
                  (string-trim
                   (shell-command-to-string
                    (format "magick identify -format '%%[EXIF:Orientation]' %s 2>/dev/null"
                            (shell-quote-argument buffer-file-name))))))
           (orient (and (stringp raw)
                        (not (string-empty-p raw))
                        (string-to-number raw))))
      (when (and orient (> orient 0))
        (pcase orient
          (6 (image-rotate 90))
          (3 (image-rotate 180))
          (8 (image-rotate 270)))))))

(add-hook 'image-mode-hook #'image-transform-fit-to-window)
(add-hook 'image-mode-hook #'my/image-auto-orient)

;; --- diff-mode ---
(setq diff-switches "-u")

;; --- shell-script-mode ---
(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))
(setq sh-basic-offset 2)
(setq sh-indentation 2)

;; --- dockerfile-mode ---
(add-to-list 'auto-mode-alist '("Dockerfile.*" . dockerfile-mode))

;; --- nginx-mode ---
(with-eval-after-load 'nginx-mode
  (add-to-list 'auto-mode-alist '("/nginx/sites-\\(?:available\\|enabled\\)/" . nginx-mode)))

;; --- graphql-mode ---
(add-to-list 'auto-mode-alist '("\\.graphqls$" . graphql-mode))

;; タブインデント単位で削除できるようにする
(defun my/indent-dedent-line-p ()
  "Check if De-indent current line."
  (interactive "*")
  (when (and (<= (point-marker) (save-excursion
                                  (back-to-indentation)
                                  (point-marker)))
             (> (current-column) 0))
    t))

(defun my/indent-dedent-line-backspace (arg)
  "De-indent current line."
  (interactive "*p")
  (if (my/indent-dedent-line-p)
      (backward-delete-char-untabify tab-width)
    (delete-backward-char arg)))
(put 'my/indent-dedent-line-backspace 'delete-selection 'supersede)

;; 関数・変数のヘルプをエコーエリアに表示する
(require 'eldoc-extension)        ; 拡張版
(setq eldoc-idle-delay 0.2)       ; すぐに表示したい
(setq eldoc-minor-mode-string "") ; モードラインにElDocと表示しない
(setq eldoc-echo-area-use-multiline-p t)

;;; 30-mode.el ends here
