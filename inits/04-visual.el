;;; 04-visual.el --- Visual設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; フォント設定
;; (dolist (x (font-family-list)) (print x))
;; (dolist (x (x-list-fonts "*")) (print x))
(cond ((eq my-os-type 'linux)
       (setq global-ascii-font "Menlo for Powerline")
       (let* ((ascii-font global-ascii-font)
              (jp-font "Ricty")
              (ascii-fontspec (font-spec :family ascii-font))
              (jp-fontspec (font-spec :family jp-font)))
         (set-face-attribute 'default nil :family ascii-font :height 130)
         (set-fontset-font nil 'japanese-jisx0208 jp-fontspec)
         (set-fontset-font nil 'japanese-jisx0212 jp-fontspec)
         (set-fontset-font nil 'katakana-jisx0201 jp-fontspec)
         (set-fontset-font nil 'mule-unicode-0100-24ff jp-fontspec)) ; Unicode フォント
       (setq face-font-rescale-alist
             '((".*Ricty.*" . 1.2)
               (".*Menlo for Powerline.*" . 1.0))))
      ((eq my-os-type 'mac)
       (setq global-ascii-font "Menlo")
       (let* ((ascii-font global-ascii-font)
              (jp-font "Ricty")
              (ascii-fontspec (font-spec :family ascii-font))
              (jp-fontspec (font-spec :family jp-font)))
         (set-face-attribute 'default nil :family ascii-font :height 150)
         (set-fontset-font nil 'japanese-jisx0208 jp-fontspec)
         (set-fontset-font nil 'japanese-jisx0212 jp-fontspec)
         (set-fontset-font nil 'katakana-jisx0201 jp-fontspec)
         (set-fontset-font nil 'mule-unicode-0100-24ff jp-fontspec)) ; Unicode フォント
       (setq face-font-rescale-alist
             '(("^-apple-hiragino.*" . 1.2)
               (".*ricty.*" . 1.2)
               (".*osaka-bold.*" . 1.2)
               (".*osaka-medium.*" . 1.2)
               (".*courier-bold-.*-mac-roman" . 1.0)
               (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
               (".*monaco-bold-.*-mac-roman" . 0.9)
               ("-cdac$" . 1.3)))
       (setq fixed-width-use-QuickDraw-for-ascii t)
       (setq mac-allow-anti-aliasing t))
      (define-key global-map [?¥] [?\\])) ; ¥の代わりにバックスラッシュを入力する

;; font-lock設定
(global-font-lock-mode t)                                            ; 特定のモードで色を付ける(Font-Lookモード有効にする)
(setq font-lock-maximum-decoration t)                                ; 色づけは最大限に
(set-face-foreground 'font-lock-comment-face "DodgerBlue")           ; コメントの色
(set-face-foreground 'font-lock-string-face  "firebrick1")           ; 文字(string)部分の色文
(set-face-foreground 'font-lock-keyword-face "yellow")               ; キーワード(if,for等の予約語)の色
(set-face-foreground 'font-lock-function-name-face "lime green")     ; 関数名の色
(set-face-foreground 'font-lock-variable-name-face "orchid1")        ; 変数名の色
(set-face-foreground 'font-lock-negation-char-face "coral")          ; 文字(char)部分の色
(set-face-foreground 'font-lock-type-face "DeepSkyBlue")             ; ユーザ定義のデータ型の色
(set-face-foreground 'font-lock-builtin-face "orange")               ; 組込み関数の色
(set-face-foreground 'font-lock-constant-face "turquoise")           ; 定数名の色
(set-face-foreground 'font-lock-warning-face "LightCyan")            ; 独特な構文の色
(set-face-foreground 'font-lock-doc-face "firebrick1")               ; ドキュメントの色
(set-face-foreground 'font-lock-regexp-grouping-backslash "green4")  ; 正規表現
(set-face-foreground 'font-lock-regexp-grouping-construct "green")   ; 正規表現
(set-face-bold-p 'font-lock-function-name-face t)                    ; 太字設定
(set-face-bold-p 'font-lock-warning-face nil)                        ; 太字設定

;; フレーム設定
(setq default-frame-alist
      (append '((foreground-color . "gray75") ; 文字の色設定
                (background-color . "gray10") ; 背景色の設定
                (cursor-color . "SlateBlue2") ; カーソルの色設定
                (mouse-color  . "SlateBlue2") ; マウスポインタの色を設定
                ;; (width  . 160)                ; 画面の幅(何文字分)
                ;; (height . 50)                 ; 画面の高さ(何文字分)
                (alpha  . 87))                ; 画面透明度の設定
              default-frame-alist))
(toggle-scroll-bar nil)                           ; スクロールバーを消す
(menu-bar-mode nil)                               ; メニューバーを消す
(tool-bar-mode 0)                                 ; ツールバーを消す
(setq ring-bell-function 'ignore)                 ; ビープ音、画面フラッシュどちらも起こさない
(auto-image-file-mode)                            ; 画像表示を有効
(setq inhibit-startup-screen t)                   ; 起動画面を表示させない

;; タイトルバーのフォーマット設定
(setq frame-title-format `("GNU/Emacs " emacs-version " -- %b " (buffer-file-name "( %f )")))

;; カーソルを点滅させる
(blink-cursor-mode t)

;; カーソル行をハイライト表示
(hl-line-mode -1)
(set-face-background 'hl-line "gray20")

;; 選択中のリージョンの色設定
(setq transient-mark-mode t)
(set-face-background 'region "SlateBlue4")

;; paren: 対応する括弧を光らせる
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)                           ; カッコ内の色も変更
(set-face-background 'show-paren-match-face nil)              ; カッコ内のフェイス
(set-face-underline-p 'show-paren-match-face "yellow")        ; カッコ内のフェイス

;; ネストしてるカッコわかりやすくする
(require 'rainbow-delimiters)
(set-face-foreground 'rainbow-delimiters-depth-1-face "SlateBlue2")
(set-face-foreground 'rainbow-delimiters-depth-2-face "DarkOliveGreen2")
(set-face-foreground 'rainbow-delimiters-depth-3-face "RoyalBlue")
(set-face-foreground 'rainbow-delimiters-depth-4-face "lime green")
(set-face-foreground 'rainbow-delimiters-depth-5-face "DeepSkyBlue1")
(set-face-foreground 'rainbow-delimiters-depth-6-face "SeaGreen")
(set-face-foreground 'rainbow-delimiters-depth-7-face "khaki2")
(set-face-foreground 'rainbow-delimiters-depth-8-face "DeepPink3")
(set-face-foreground 'rainbow-delimiters-depth-9-face "LightSalmon2")

;; カーソル位置のフェースを調べる関数
(defun describe-face-at-point ()
  "Return face used at point."
  (interactive)
  (message "%s" (get-char-property (point) 'face)))

;;; 04-visual.el ends here
