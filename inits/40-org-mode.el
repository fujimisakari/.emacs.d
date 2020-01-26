;;; 40-org-mode.el --- org-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'ox-reveal)
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode)) ; 拡張子がorgのファイルを開いた場合、自動的にorg-modeにする
(setq org-return-follows-link t)                       ; リンクはRETで開く
(setq org-startup-truncated nil)                       ; org-mode開始時は折り返しするよう設定
(setq org-startup-with-inline-images t)                ; 画像をインライン表示
(setq org-edit-src-content-indentation 0)              ; BEGIN_SRCブロック内をインデントをしない

(add-hook 'org-mode-hook
          (lambda ()
            (turn-on-font-lock)     ; org-modeでの強調表示を有効にする
            (common-mode-init)))

;; エクスポート処理
(setq org-export-default-language "ja")     ; 言語は日本語
(setq org-export-html-coding-system 'utf-8) ; 文字コードはUTF-8
(setq org-export-with-fixed-width nil)      ; 行頭の:は使わない BEGIN_EXAMPLE 〜 END_EXAMPLE で十分
(setq org-export-with-sub-superscripts nil) ; ^と_を解釈しない
(setq org-export-with-special-strings nil)  ; --や---をそのまま出力する
(setq org-export-with-TeX-macros nil)       ; TeX・LaTeXのコードを解釈しない
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
    (4  (org-insert-subheading nil)) ; C-u
    (16 (org-insert-upheading  nil)) ; C-u C-u
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
      '((sequence "TODO(t)" "SCHEDULE(s)" "WAITING(w)" "SOMEDAY(d)" "EVENT(e)" "|" "DONE(x)" "CANCEL(c)")))

(setq org-log-done 'tilme)                   ; DONEの時刻を記録する
(setq org-agenda-files (list org-directory)) ; 予定表に使うorgファイルのリスト

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
  '((t (:foreground "DimGray" :background "DarkSlateGray")))
  "Face used for the line delimiting the begin of source blocks.")
(set-face-foreground 'org-block-begin-line "DimGray")
;; (set-face-background 'org-block-begin-line "gray18")

(defface org-block-background
  '((t (:background "gray18")))
  "Face used for the source block background.")
(set-face-background 'org-block-background "gray18")

(defface org-block-end-line
  '((t (:foreground "DimGray" :background "gray18")))
  "Face used for the line delimiting the end of source blocks.")
(set-face-foreground 'org-block-end-line "DimGray")
;; (set-face-background 'org-block-end-line "gray18")

(set-face-foreground 'org-level-5 "orange")  ; レベル3の色とカブってたので変更
(set-face-foreground 'org-level-7 "purple1") ; レベル5の色とカブってたので変更

;;;; org習慣仕事術
;; ;; 時刻の記録をagendaに表示させる
;; (setq org-agenda-start-with-log-mode t)

;; ;; inbox.orgのサンプルにあわせ、今日から30日分の予定を表示させる
;; (setq org-agenda-span 30)

;; ;; org-agendaで扱うorgファイルたち
;; (setq org-agenda-files '("~/org/inbox.org" "~/org/daily-projects.org"))

;; ;; C-c a aでagendaを起動する
;; ;; agendaには、習慣・スケジュール・TODOを表示させる
;; (setq org-agenda-custom-commands
;;       '(("a" "Agenda and all TODO's"
;;          ((tags "project-CLOCK=>\"<today>\"|repeatable") (agenda "") (alltodo)))))

;; ;;; <f6>で直接org習慣仕事術用agendaを起動させる
;; (defun org-agenda-default ()
;;   (interactive)
;;   (org-agenda nil "a"))

;; ;;;; org自動日記
;; (add-to-list 'org-agenda-custom-commands
;;              '("D" agenda ""
;;                ( ;; 1日分だけ表示する
;;                 (org-agenda-span 1)
;;                 ;; agenda各行の行頭のスペースをなくす
;;                 (org-agenda-prefix-format '((agenda . "%?-12t% s")))
;;                 ;; グリッドを表示しない
;;                 (org-agenda-use-time-grid nil)
;;                 ;; clockを表示する
;;                 (org-agenda-start-with-log-mode t)
;;                 (org-agenda-show-log 'clockcheck)
;;                 ;; clockの総計を表でまとめる
;;                 (org-agenda-start-with-clockreport-mode t)
;;                 (org-agenda-clockreport-mode t))))

;; (defvar org-review-diary-file "~/org/review-diary.org")
;; (defvar org-review-diary-use-follow-mode nil)
;; (defun org-review-diary ()
;;   (interactive)
;;   (find-file org-review-diary-file)            ; ファイルを開き
;;   (goto-char (point-max))                      ; 末尾に移動し
;;   (recenter 0)                                 ; 画面最上部に持っていき
;;   (insert "* ")                                ; 新しい見出し作成
;;   (save-excursion
;;     (org-insert-time-stamp (current-time) t t) ; 現在時刻
;;     (insert "\n#+BEGIN_QUOTE\n")               ; QUOTEブロックで
;;     (let (org-agenda-sticky)                   ; agendaを囲む
;;       (insert (save-window-excursion           ; 裏でagenda (D)を
;;                 (org-agenda nil "D")           ; 起動して
;;                 (unwind-protect
;;                     (buffer-string)            ; *Org Agenda*バッファの内容を
;;                   (kill-this-buffer)))))       ; 挿入してからバッファを削除
;;     (insert "#+END_QUOTE\n\n")))


;; ;; 新しいorg-modeでCLOCKキーワードが特殊プロパティから
;; ;; 外されてしまったことでCLOCKと比較できなくなってしまった修正対応
;; (unless (member "CLOCK" org-special-properties)
;;   (defun org-get-CLOCK-property (&optional pom)
;;   (org-with-wide-buffer
;;    (org-with-point-at pom
;;      (when (and (derived-mode-p 'org-mode)
;;                 (ignore-errors (org-back-to-heading t))
;;                 (search-forward org-clock-string
;;                                 (save-excursion (outline-next-heading) (point))
;;                                 t))
;;        (skip-chars-forward " ")
;;        (cons "CLOCK"  (buffer-substring-no-properties (point) (point-at-eol)))))))
;;   (defadvice org-entry-properties (after with-CLOCK activate)
;;     "special-propertyにCLOCKを復活させorg習慣仕事術を最新版orgで動かす"
;;     (let ((it (org-get-CLOCK-property (ad-get-arg 0))))
;;       (setq ad-return-value
;;             (if it
;;                 (cons it ad-return-value)
;;               ad-return-value)))))

;;; 40-org-mode.el ends here
