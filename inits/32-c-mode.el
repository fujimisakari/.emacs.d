;;; 32-c-mode.el --- c-mode -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun my/c-mode-setup ()
  "Setup for c-mode."
  (c-set-style "stroustrup")
  (my/common-mode-init))
(add-hook 'c-mode-hook #'my/c-mode-setup)

;; .hと.mを左右に並べて開く
(defun my/open-header-and-source-file ()
  (interactive)
  (my/other-window-or-split)
  (ff-find-other-file))

;;コード整形できるようにする
(autoload 'clang-format-buffer "clang-format" nil t)

(defun my/clang-format-before-save ()
  "Run clang-format if .clang-format exists."
  (when (locate-dominating-file "." ".clang-format")
    (clang-format-buffer))
  nil)

(defun my/clang-format-save-hook-for-this-buffer ()
  "Create a buffer local save hook."
  (add-hook 'before-save-hook #'my/clang-format-before-save nil t))
;; Run this for each mode you want to use the hook.
(add-hook 'c-mode-hook #'my/clang-format-save-hook-for-this-buffer)

;;; 32-c-mode.el ends here
