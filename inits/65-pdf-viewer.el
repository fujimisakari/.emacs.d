;;; 65-pdf-viewer.el --- pdf-viewer設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; PDF ファイルを開いた時に pdf-tools を読み込む
(autoload 'pdf-view-mode "pdf-tools" "View PDF files." t)
(add-to-list 'auto-mode-alist '("\\.pdf$" . pdf-view-mode))

(with-eval-after-load 'pdf-tools
  (when (eq my-os-type 'mac)
    (setenv "PKG_CONFIG_PATH" "/usr/local/opt/libffi/lib/pkgconfig"))
  (pdf-tools-install t))

(add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1)))

;;; 65-pdf-viewer.el ends here
