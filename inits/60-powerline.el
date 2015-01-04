;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               powerline設定                                ;;
;;;--------------------------------------------------------------------------;;;

(require 'powerline)

(defun arrow-right-xpm (color1 color2)
  "Return an XPM right arrow string representing."
  (format "/* XPM */
static char * arrow_right[] = {
\"12 24 2 1\",
\". c %s\",
\"  c %s\",
\".           \",
\"..          \",
\"...         \",
\"....        \",
\".....       \",
\"......      \",
\".......     \",
\"........    \",
\".........   \",
\"..........  \",
\"........... \",
\"............\",
\"........... \",
\"..........  \",
\".........   \",
\"........    \",
\".......     \",
\"......      \",
\".....       \",
\"....        \",
\"...         \",
\"..          \",
\".           \",
\"            \"};"  color1 color2))



(defun arrow-left-xpm (color1 color2)
  "Return an XPM right arrow string representing."
  (format "/* XPM */
static char * arrow_right[] = {
\"12 24 2 1\",
\". c %s\",
\"  c %s\",
\"           .\",
\"          ..\",
\"         ...\",
\"        ....\",
\"       .....\",
\"      ......\",
\"     .......\",
\"    ........\",
\"   .........\",
\"  ..........\",
\" ...........\",
\"............\",
\" ...........\",
\"  ..........\",
\"   .........\",
\"    ........\",
\"     .......\",
\"      ......\",
\"       .....\",
\"        ....\",
\"         ...\",
\"          ..\",
\"           .\",
\"            \"};"  color2 color1))

(defun shorten-directory (dir max-length)
  "Show up to `max-length' characters of a directory name `dir'."
  (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
        (output ""))
    (when (and path (equal "" (car path)))
      (setq path (cdr path)))
    (while (and path (< (length output) (- max-length 4)))
      (setq output (concat (car path) "/" output))
      (setq path (cdr path)))
    (when path
      (setq output (concat ".../" output)))
    output))
(buffer-name)

(defun buffer-name-for-mode-line ()
  (if (eq major-mode 'dired-mode)
    ""
    (buffer-name)))

(defconst color1 "OliveDrab2")
(defconst color2 "#1d1d1d")
(defconst color3 "gray40")
(defconst color4 "gray15")

(defvar arrow-right-1 (create-image (arrow-right-xpm color1 color2) 'xpm t :ascent 'center))
(defvar arrow-right-2 (create-image (arrow-right-xpm color2 "None") 'xpm t :ascent 'center))
(defvar arrow-left-1  (create-image (arrow-left-xpm color2 color1) 'xpm t :ascent 'center))
(defvar arrow-left-2  (create-image (arrow-left-xpm "None" color2) 'xpm t :ascent 'center))

(setq-default mode-line-format
              (list '(:eval (concat (propertize "-%Z%1*%1+ " 'face 'mode-line-color-1)
                                    (propertize (shorten-directory default-directory 15) 'face 'mode-line-color-1)
                                    (propertize (buffer-name-for-mode-line) 'face 'mode-line-color-1)
                                    (propertize " " 'face 'mode-line-color-1)
                                    (propertize " " 'display arrow-right-1)))
                    '(:eval (concat (propertize " %m" 'face 'mode-line-color-2)
                                    ;; (propertize (format-mode-line minor-mode-alist) 'face 'mode-line-color-2)
                                    (propertize " " 'face 'mode-line-color-2)
                                    (propertize " " 'display arrow-right-2)))
                    (when (and (boundp 'which-func-mode) which-func-mode)
                                       '(which-func-mode ("" which-func-format)))

                    ;; Justify right by filling with spaces to right fringe - 16
                    ;; (16 should be computed rahter than hardcoded)
                    '(:eval (propertize " " 'display '((space :align-to (- right-fringe 34)))))

                    '(:eval (concat (propertize " " 'display arrow-left-2)
                                    (propertize "[" 'face 'mode-line-color-2)
                                    (propertize (nyan-create) 'face 'mode-line-color-2)
                                    (propertize "]" 'face 'mode-line-color-2)))
                    '(:eval (concat (propertize " " 'display arrow-left-1)
                                    (propertize "%4l:%2c  " 'face 'mode-line-color-1)))))

(make-face 'mode-line-color-1)
(set-face-attribute 'mode-line-color-1 nil
                    :foreground "gray10"
                    :background color1)

(make-face 'mode-line-color-2)
(set-face-attribute 'mode-line-color-2 nil
                    :foreground "gray75"
                    :background color2)

(set-face-attribute 'mode-line nil
                    :foreground "gray75"
                    :background color3
                    :box nil)
(set-face-attribute 'mode-line-inactive nil
                    :foreground "gray75"
                    :background color4)
