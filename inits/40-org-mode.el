;;; 40-org-mode.el --- org-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'ox-reveal)
(require 'org)

;; 基本設定
(setq org-startup-folded 'content)             ; 見出しの初期状態（見出しだけ表示）
(setq org-startup-indented t)                  ; インデントをつける
(setq org-startup-truncated nil)               ; org-mode開始時は折り返しするよう設定
(setq org-startup-with-inline-images t)        ; 画像をインライン表示
(setq org-indent-mode-turns-on-hiding-stars t) ; 見出しインデントのアスタリスクを減らす
(setq org-return-follows-link t)               ; リンクはRETで開く
(setq org-edit-src-content-indentation 0)      ; BEGIN_SRCブロック内をインデントをしない

; 拡張子がorgのファイルを開いた場合、自動的にorg-modeにする
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

; org-modeでの強調表示を有効にする
(add-hook 'org-mode-hook
          (lambda ()
            (turn-on-font-lock)
            (common-mode-init)))

;; インデントマークを拡張
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; エクスポート処理
(setq org-export-default-language "ja")     ; 言語は日本語
(setq org-export-html-coding-system 'utf-8) ; 文字コードはUTF-8
(setq org-export-with-fixed-width nil)      ; 行頭の:は使わない BEGIN_EXAMPLE 〜 END_EXAMPLE で十分
(setq org-export-with-sub-superscripts nil) ; ^と_を解釈しない
(setq org-export-with-special-strings nil)  ; --や---をそのまま出力する
(setq org-export-with-TeX-macros nil)       ; TeX・LaTeXのコードを解釈しない
(setq org-export-with-LaTeX-fragments nil)

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

;;; 40-org-mode.el ends here
