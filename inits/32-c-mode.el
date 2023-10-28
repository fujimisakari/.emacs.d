;;; 32-c-mode.el --- c-mode -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(add-hook 'c-mode-hook
          (lambda ()
            (c-set-style "stroustrup")
            (common-mode-init)))

;; .hと.mを左右に並べて開く
(defun open-header-and-source-file ()
  (interactive)
  (other-window-or-split)
  (ff-find-other-file))

;;コード整形できるようにする
(require 'clang-format)

(defun clang-format-save-hook-for-this-buffer ()
  "Create a buffer local save hook."
  (add-hook 'before-save-hook
            (lambda ()
              (when (locate-dominating-file "." ".clang-format")
                (clang-format-buffer))
              ;; Continue to save.
              nil)
            nil
            ;; Buffer local hook.
            t))
;; Run this for each mode you want to use the hook.
(add-hook 'c-mode-hook (lambda () (clang-format-save-hook-for-this-buffer)))

;;; 32-c-mode.el ends here
