;;; 65-pdf-viewer.el --- pdf-viewer設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'pdf-tools)

(if (eq my-os-type 'mac)
    (setenv "PKG_CONFIG_PATH" "/usr/local/opt/libffi/lib/pkgconfig"))
(pdf-tools-install t)

;;; 65-pdf-viewer.el ends here
