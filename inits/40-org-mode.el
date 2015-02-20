;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                              org-mode設定                                  ;;
;;;--------------------------------------------------------------------------;;;

(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))  ; 拡張子がorgのファイルを開いた場合、自動的にorg-modeにする
(add-hook 'org-mode-hook 'turn-on-font-lock)            ; org-modeでの強調表示を有効にする
(setq browse-url-browser-function 'browse-url-firefox)  ; リンクはemacs-w3mで開く
(setq org-return-follows-link t)                        ; リンクはRETで開く
(setq org-startup-truncated nil)                        ; org-mode開始時は折り返しするよう設定
(setq org-startup-with-inline-images t)                 ; 画像をインライン表示
(setq org-edit-src-content-indentation 0)               ; BEGIN_SRCブロック内をインデントをしない

;; エクスポート処理
(setq org-export-default-language "ja")      ; 言語は日本語
(setq org-export-html-coding-system 'utf-8)  ; 文字コードはUTF-8
(setq org-export-with-fixed-width nil)       ; 行頭の:は使わない BEGIN_EXAMPLE 〜 END_EXAMPLE で十分
(setq org-export-with-sub-superscripts nil)  ; ^と_を解釈しない
(setq org-export-with-special-strings nil)   ; --や---をそのまま出力する
(setq org-export-with-TeX-macros nil)        ; TeX・LaTeXのコードを解釈しない
(setq org-export-with-LaTeX-fragments nil)

(defun org-insert-upheading (arg)
  "1レベル上の見出しを入力する"
  (interactive "P")
  (org-insert-heading arg)
  (cond ((org-on-heading-p) (org-do-promote))
        ((org-at-item-p) (org-indent-item -1))))
(defun org-insert-heading-dwim (arg)
  "現在と同じレベルの見出しを入力するC-uをつけると1レベル上、C-u C-uをつけると1レベル下の見出しを入力する"
  (interactive "p")
  (case arg
    (4  (org-insert-subheading nil))    ; C-u
    (16 (org-insert-upheading  nil))    ; C-u C-u
    (t  (org-insert-heading    nil))))

;; org-remember設定
;; テンプレートの設定
;; Select template: [n]ote [t]odo
(setq org-remember-templates
      '(("Note" ?n "** %?\n" nil "Note")
        ("Todo" ?t "** TODO %?\n" nil "Inbox-Todo")))

;; genda関連設定
;; TODOリストを作成する
(setq org-use-fast-todo-selection t)
(setq org-todo-keywords
      '((sequence "TODO(t)" "STARTED(s)" "WAITING(w)" "SOMEDAY(d)" "EVENT(e)" "|" "DONE(x)" "CANCEL(c)")))

(setq org-log-done 'tilme)                    ; DONEの時刻を記録する
(setq org-agenda-files (list org-directory))  ; 予定表に使うorgファイルのリスト

;; フォントサイズ設定
(set-face-attribute 'org-level-1 nil :bold t :height 1.0)
(set-face-attribute 'org-level-2 nil :bold nil :height 1.0)
(set-face-attribute 'org-level-3 nil :bold nil :height 1.0)
(set-face-attribute 'org-level-4 nil :bold nil :height 1.0)
;; (set-face-attribute 'org-checkbox nil :background "gray" :foreground "black"
;;                                    :box '(:line-width 1 :style released-button))

;; src のハイライト設定
(setq org-src-fontify-natively t)

(defface org-block-begin-line
  '((t (:foreground "SlateBlue1" :background "gray0")))
  "Face used for the line delimiting the begin of source blocks.")
(set-face-foreground 'org-block-begin-line "gray0")

(defface org-block-background
  '((t (:background "gray0")))
  "Face used for the source block background.")
(set-face-background 'org-block-background "gray0")

(defface org-block-end-line
  '((t (:foreground "SlateBlue1" :background "gray0")))
  "Face used for the line delimiting the end of source blocks.")
(set-face-foreground 'org-block-end-line "gray0")

(set-face-foreground 'org-level-5 "orange")             ; レベル3の色とカブってたので変更
(set-face-foreground 'org-level-7 "purple1")            ; レベル5の色とカブってたので変更

;;;; org習慣仕事術
;; 時刻の記録をagendaに表示させる
(setq org-agenda-start-with-log-mode t)

;; inbox.orgのサンプルにあわせ、今日から30日分の予定を表示させる
(setq org-agenda-span 30)

;; org-agendaで扱うorgファイルたち
(setq org-agenda-files '("~/org/inbox.org" "~/org/daily-projects.org"))

;; C-c a aでagendaを起動する
;; agendaには、習慣・スケジュール・TODOを表示させる
(setq org-agenda-custom-commands
      '(("a" "Agenda and all TODO's"
         ((tags "project-CLOCK=>\"<today>\"|repeatable") (agenda "") (alltodo)))))

;;; <f6>で直接org習慣仕事術用agendaを起動させる
(defun org-agenda-default ()
  (interactive)
  (org-agenda nil "a"))
