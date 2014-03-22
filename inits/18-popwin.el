;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                 popwin設定                                 ;;
;;;--------------------------------------------------------------------------;;;

(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(setq popwin:popup-window-position 'right)
(setq popwin:popup-window-width 75)

(setq anything-samewindow nil)
(push '("*Messages*") popwin:special-display-config)
(push '("*Warnings*") popwin:special-display-config)
(push '("*Backtrace*") popwin:special-display-config)
(push '("*Moccur*") popwin:special-display-config)
(push '("*Buffer List*") popwin:special-display-config)
(push '("*helm mini*") popwin:special-display-config)
(push '("*helm M-x*") popwin:special-display-config)
(push '("*anything*") popwin:special-display-config)
(push '("*my anything*") popwin:special-display-config)
(push '("*anything gtags*") popwin:special-display-config)
(push '("*anything moccur*") popwin:special-display-config)
(push '("*anything kill-ring*") popwin:special-display-config)
(push '("*GTAGS SELECT*") popwin:special-display-config)
(push '("*Kill Ring*") popwin:special-display-config)
(push '("*sdic*") popwin:special-display-config)
(push '("*Completions*") popwin:special-display-config)
(push '("*quickrun*") popwin:special-display-config)
(push '("*help*") popwin:special-display-config)
;; M-!
(push "*Shell Command Output*" popwin:special-display-config)
;; M-x compile
(push '(compilation-mode :noselect t) popwin:special-display-config)
;; slime
(push "*slime-apropos*" popwin:special-display-config)
(push "*slime-macroexpansion*" popwin:special-display-config)
(push "*slime-description*" popwin:special-display-config)
(push '("*slime-compilation*" :noselect t) popwin:special-display-config)
(push "*slime-xref*" popwin:special-display-config)
(push '(sldb-mode :stick t) popwin:special-display-config)
(push 'slime-repl-mode popwin:special-display-config)
(push 'slime-connection-list-mode popwin:special-display-config)

;; sdic-display-buffer 書き換え 
(defadvice sdic-display-buffer (around sdic-display-buffer-normalize activate)
  "sdic のバッファ表示を普通にする。"
  (setq ad-return-value (buffer-size))
  (let ((p (or (ad-get-arg 0)
               (point))))
    (and sdic-warning-hidden-entry
         (> p (point-min))
         (message "この前にもエントリがあります。"))
    (goto-char p)
    (display-buffer (get-buffer sdic-buffer-name))
    (set-window-start (get-buffer-window sdic-buffer-name) p)))

(defadvice sdic-other-window (around sdic-other-normalize activate)
  "sdic のバッファ移動を普通にする。"
  (other-window 1))

(defadvice sdic-close-window (around sdic-close-normalize activate)
  "sdic のバッファクローズを普通にする。"
  (bury-buffer sdic-buffer-name))
