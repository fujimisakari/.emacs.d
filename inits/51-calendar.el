;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               カレンダー設定                               ;;
;;;--------------------------------------------------------------------------;;;

;; カレンダーコンポーネント読み込み
(require 'calfw)

;; カレンダーの外観設定
(face-spec-reset-face 'cfw:face-default-content)
(custom-set-faces
 '(cfw:face-title ((t (:foreground "khaki" :weight bold :height 2.0 :inherit variable-pitch))))
 '(cfw:face-header ((t (:foreground "gray75" :background "gray40" :weight bold))))
 '(cfw:face-sunday ((t :foreground "red" :background "light pink" :weight bold)))
 '(cfw:face-saturday ((t :foreground "blue" :background "SteelBlue1" :weight bold)))
 '(cfw:face-holiday ((t :foreground "red" :background "light pink" :weight bold)))
 '(cfw:face-default-day ((t (:foreground "gray75" :background "grey20" :weight bold))))
 '(cfw:face-day-title ((t :background "grey20")))
 ;; '(cfw:face-default-content ((t :foreground "lime green")))
 '(cfw:face-regions ((t :foreground "cyan")))
 '(cfw:face-periods ((t :foreground "gray75")))
 '(cfw:face-today-title ((t :background "Magenta" :weight bold)))
 '(cfw:face-today ((t :background: "Magenta")))
 '(cfw:face-toolbar ((t :background: nil)))
 '(cfw:face-toolbar-button-on ((t :foreground "gray75")))
 '(cfw:face-toolbar-button-off ((t :foreground "gray40")))
 '(cfw:face-select ((t :background "BlueViolet"))))

;; カレンダーに日本の祝日を設定する
(require 'japanese-holidays)
(setq calendar-holidays
      (append japanese-holidays local-holidays other-holidays))

;; デフォルトカレンダー(calendar.el)設定
;; 月
(setq calendar-month-name-array
      ["1"  "2"  "3"  "4"   "5"   "6"
       "7"  "8"  "9"  "10"  "11"  "12"])
;; 曜日
(setq calendar-day-name-array
      ["日" "月" "火" "水" "木" "金" "土"])
;; 週の先頭の曜日
(setq calendar-week-start-day 0) ; 日曜日は0, 月曜日は1

(setq calendar-weekend-marker 'diary)
(add-hook 'today-visible-calendar-hook 'calendar-mark-weekend)
(add-hook 'today-invisible-calendar-hook 'calendar-mark-weekend)

;; Google Calendar と連携させる
(require 'calfw-ical)
(setq google-calendar-url (gethash "google-calendar-url" private-env-hash))
(defun open-my-ical ()
  (interactive)
  (cfw:open-ical-calendar google-calendar-url "lime green"))

(require 'google-calendar)
(setq google-calendar-user (gethash "google-calendar-user" private-env-hash))  ; GOOGLE USER
(setq google-calendar-password (gethash "google-calendar-password" private-env-hash))
(setq google-calendar-code-directory "~/.emacs.d/site-lisp/emacs-google-calendar/code")
(setq google-calendar-directory "/tmp")

;; calfwから予定を追加できるようにする設定
(defadvice calendar-cursor-to-date (around calfw activate)
  (if (eq major-mode 'cfw:calendar-mode)
      (setq ad-return-value (cfw:cp-get-selected-date (cfw:cp-get-component)))
    ad-do-it))
(define-key cfw:calendar-mode-map "+" 'google-calendar-quick-add-event)
(define-key cfw:calendar-mode-map "-" 'google-calendar-delete-event)

(global-set-key (kbd "<f7>") 'open-my-ical)
