;;; 04-visual.el --- Visual設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; フォント設定
(cond ((eq my-os-type 'linux)
       (set-face-attribute 'default nil :family my-global-font :height 160))
      ((eq my-os-type 'mac)
       (add-to-list 'default-frame-alist '(font . "SF Mono Square-20"))
       (set-face-attribute 'default t :font "SF Mono Square")))

;; font-lock設定
(global-font-lock-mode t)                                           ; 特定のモードで色を付ける(Font-Lookモード有効にする)
(setq font-lock-maximum-decoration t)                               ; 色づけは最大限に
(set-face-foreground 'font-lock-comment-face "CornflowerBlue")      ; コメンの色
(set-face-foreground 'font-lock-string-face  "firebrick1")          ; 文字(string)部分の色文
(set-face-foreground 'font-lock-keyword-face "yellow")              ; キーワード(if,for等の予約語)の色
(set-face-foreground 'font-lock-function-name-face "lime green")    ; 関数名の色
(set-face-foreground 'font-lock-variable-name-face "orchid1")       ; 変数名の色
(set-face-foreground 'font-lock-negation-char-face "coral")         ; 文字(char)部分の色
(set-face-foreground 'font-lock-type-face "DeepSkyBlue")            ; ユーザ定義のデータ型の色
(set-face-foreground 'font-lock-builtin-face "orange")              ; 組込み関数の色
(set-face-foreground 'font-lock-constant-face "turquoise")          ; 定数名の色
(set-face-foreground 'font-lock-warning-face "LightCyan")           ; 独特な構文の色
(set-face-foreground 'font-lock-doc-face "firebrick1")              ; ドキュメントの色
(set-face-foreground 'font-lock-regexp-grouping-backslash "green4") ; 正規表現
(set-face-foreground 'font-lock-regexp-grouping-construct "green")  ; 正規表現
(set-face-bold-p 'font-lock-warning-face nil)

;; フレーム設定
(set-foreground-color "gray75")     ; 文字の色設定
(set-background-color "gray5")      ; 背景色の設定
(set-cursor-color "#4f57f9")        ; カーソルの色設定
(set-mouse-color "#4f57f9")         ; マウスポインタの色を設定
(set-frame-parameter nil 'alpha 80) ; 画面透明度の設定
(toggle-scroll-bar nil)             ; スクロールバーを消す
(menu-bar-mode 0)                   ; メニューバーを消す
(tool-bar-mode 0)                   ; ツールバーを消す
(auto-image-file-mode)              ; 画像表示を有効
(setq ring-bell-function 'ignore)   ; ビープ音、画面フラッシュどちらも起こさない
(setq inhibit-startup-screen t)     ; 起動画面を表示させない

;; タイトルバーのフォーマット設定
(setq frame-title-format `("GNU/Emacs " emacs-version " -- %b " (buffer-file-name "( %f )")))

;; カーソルを点滅させる
(blink-cursor-mode t)

;; カーソル行をハイライト表示(beacon)
(beacon-mode)
(setq beacon-size 70)
(setq beacon-blink-duration 0.6)
(setq beacon-blink-when-focused t)
(setq beacon-color "lime")

;; 選択中のリージョンの色設定
(setq transient-mark-mode t)
(set-face-background 'region "#2b43e1")

;; paren: 対応する括弧を光らせる
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)               ; カッコ内の色も変更
(set-face-background 'show-paren-match nil)       ; カッコ内のフェイス
(set-face-underline-p 'show-paren-match "yellow") ; カッコ内のフェイス

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

;; imenu-listのface設定
(require 'imenu-list)
(set-face-foreground 'imenu-list-entry-face-0 "lime green")
(set-face-foreground 'imenu-list-entry-face-1 "lime green")
(set-face-foreground 'imenu-list-entry-face-2 "khaki2")
(set-face-foreground 'imenu-list-entry-face-3 "SteelBlue1")
(set-face-foreground 'imenu-list-entry-subalist-face-0 "DeepSkyBlue")
(set-face-foreground 'imenu-list-entry-subalist-face-1 "lime green")
(set-face-foreground 'imenu-list-entry-subalist-face-2 "khaki2")
(set-face-foreground 'imenu-list-entry-subalist-face-3 "SteelBlue1")

;; popup-tipのface設定
(require 'popup)
(set-face-foreground 'popup-tip-face "gray20")
(set-face-background 'popup-tip-face "ivory3")

;; カーソル位置のフェースを調べる関数
(defun describe-face-at-point ()
  "Return face used at point."
  (interactive)
  (message "%s" (get-char-property (point) 'face)))

;; バッテリー表示
(require 'fancy-battery)
(add-hook 'after-init-hook #'fancy-battery-mode)

;;; 04-visual.el ends here
