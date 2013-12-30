;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                              org-mode関連                                  ;;
;;;--------------------------------------------------------------------------;;;

(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))  ; 拡張子がorgのファイルを開いた場合、自動的にorg-modeにする
(add-hook 'org-mode-hook 'turn-on-font-lock)            ; org-modeでの強調表示を有効にする
(setq browse-url-browser-function 'browse-url-firefox)  ; リンクはemacs-w3mで開く
(setq org-return-follows-link t)                        ; リンクはRETで開く
(setq org-startup-truncated nil)                        ; org-mode開始時は折り返しするよう設定
(setq org-startup-with-inline-images t)                 ; 画像をインライン表示
(set-face-foreground 'org-level-5 "orange")             ; レベル3の色とカブってたので変更
(set-face-foreground 'org-level-7 "purple1")            ; レベル5の色とカブってたので変更

;; キーバインド設定
(global-set-key (kbd "C-c l") 'org-store-link)          ; ハイパーリンク作成
(global-set-key (kbd "C-c a") 'org-agenda)              ; 予定表の表示
(define-key org-mode-map (kbd "C-<up>") 'outline-previous-visible-heading)
(define-key org-mode-map (kbd "C-<down>") 'outline-next-visible-heading)
(define-key org-mode-map (kbd "C-M-<up>") 'outline-backward-same-level)
(define-key org-mode-map (kbd "C-M-<down>") 'outline-forward-same-level)

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
(define-key org-mode-map (kbd "C-]") 'org-insert-heading-dwim)

;; org-remember設定
;; テンプレートの設定
;; Select template: [n]ote [t]odo
(setq org-remember-templates
      '(("Note" ?n "** %?\n" nil "Note")
        ("Todo" ?t "** TODO %?\n" nil "Inbox-Todo")))

;; 瞬時にメモを取る
(org-remember-insinuate)  ; org-rememberの初期化
;; (key-chord-define global-map "fj" 'org-remember)

;; メモを格納するorgファイルの設定
;; (setq org-directory "~/.emacs.d/org/todo-memo/")
;; (setq org-default-notes-file (expand-file-name "memo.org" org-directory))

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
  '((t (:foreground "SlateBlue1" :background "gray17")))
  "Face used for the line delimiting the begin of source blocks.")
(set-face-foreground 'org-block-begin-line "SlateBlue1")

(defface org-block-background
  '((t (:background "gray17")))
  "Face used for the source block background.")
(set-face-background 'org-block-background "gray17")

(defface org-block-end-line
  '((t (:foreground "SlateBlue1" :background "gray17")))
  "Face used for the line delimiting the end of source blocks.")
(set-face-foreground 'org-block-end-line "SlateBlue1")
