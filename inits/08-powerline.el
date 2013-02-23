;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               powerline設定                                ;;
;;;--------------------------------------------------------------------------;;;

(require 'powerline)

(defun arrow-right-xpm (color1 color2)
  "Return an XPM right arrow string representing."
  (format "/* XPM */
static char * arrow_right[] = {
\"12 18 2 1\",
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
\".........   \",
\"........    \",
\".......     \",
\"......      \",
\".....       \",
\"....        \",
\"...         \",
\"..          \",
\".           \"};"  color1 color2))

(defun arrow-left-xpm (color1 color2)
  "Return an XPM right arrow string representing."
  (format "/* XPM */
static char * arrow_right[] = {
\"12 18 2 1\",
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
\"   .........\",
\"    ........\",
\"     .......\",
\"      ......\",
\"       .....\",
\"        ....\",
\"         ...\",
\"          ..\",
\"           .\"};"  color2 color1))

(defconst color1 "SlateBlue3")
(defconst color2 "gray23")
(defconst active-back-color "gray45")

(defvar arrow-right-1 (create-image (arrow-right-xpm color1 color2) 'xpm t :ascent 'center))
(defvar arrow-right-2 (create-image (arrow-right-xpm color2 "None") 'xpm t :ascent 'center))
(defvar arrow-left-1  (create-image (arrow-left-xpm color2 color1) 'xpm t :ascent 'center))
(defvar arrow-left-2  (create-image (arrow-left-xpm "None" color2) 'xpm t :ascent 'center))
(defvar arrow-left-3  (create-image (arrow-left-xpm color2 active-back-color) 'xpm t :ascent 'center))

(make-face 'mode-line-color-1)
(set-face-attribute 'mode-line-color-1 nil
                    :foreground "white"
                    :background color1)

(make-face 'mode-line-color-2)
(set-face-attribute 'mode-line-color-2 nil
                    :foreground "white"
                    :background color2)

(make-face 'mode-line-color-3)
(set-face-attribute 'mode-line-color-3 nil
                    :foreground "white"
                    :background active-back-color)

;; アクティブ時
(set-face-attribute 'mode-line nil
                    :foreground "gray5"
                    :background "gray40"
                    :box nil)

;; 非アクティブ時
(set-face-attribute 'mode-line-inactive nil
                    :foreground "gray75"
                    :background "gray15")

(setq-default mode-line-format
 (list  '(:eval (concat (propertize (concat " %Z:%* " (abbreviate-file-name default-directory) "%b ") 'face 'mode-line-color-1)
                        (propertize " " 'display arrow-right-1)))
        '(:eval (concat (powerline-major-mode 'left color2)
                        (powerline-minor-modes 'left color2)
                        (propertize " " 'face 'mode-line-color-2)
                        (propertize " " 'display arrow-right-2)))

        ;; Justify right by filling with spaces to right fringe - 16
        ;; (16 should be computed rahter than hardcoded)
        '(:eval (propertize " " 'display '((space :align-to (- right-fringe 20)))))

        '(:eval (concat (propertize " " 'display arrow-left-2)
                        (propertize "%4l:%2c " 'face 'mode-line-color-2)))
        '(:eval (concat (propertize " " 'display arrow-left-1)
                        (propertize " %p                         " 'face 'mode-line-color-1)))
))
