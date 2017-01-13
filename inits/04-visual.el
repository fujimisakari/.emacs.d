;;; 04-visual.el --- Visual設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; フォント設定
(cond ((eq my-os-type 'linux)
       (when window-system
         ;; 標準のフォントを設定
         (set-default-font "M+2VM+IPAG circle-10.5")
         ;; 日本語全部
         (set-fontset-font (frame-parameter nil 'font)
                           'japanese-jisx0208
                           (font-spec :family "M+1M+IPAG")))
       )
      ((eq my-os-type 'mac)
       (when (>= emacs-major-version 23)
         (setq fixed-width-use-QuickDraw-for-ascii t)
         (setq mac-allow-anti-aliasing t)
         (set-face-attribute 'default nil
                             :family "Menlo"
                             :height 150)
         (set-fontset-font (frame-parameter nil 'font)
          'japanese-jisx0208
          '("Ricty" . "iso10646-1"))
         (set-fontset-font (frame-parameter nil 'font)
          'japanese-jisx0212
          '("Ricty" . "iso10646-1"))
         (set-fontset-font (frame-parameter nil 'font)
          'katakana-jisx0201
          '("Ricty" . "iso10646-1"))
         ;; Unicode フォント
         (set-fontset-font (frame-parameter nil 'font)
          'mule-unicode-0100-24ff
          '("Ricty" . "iso10646-1"))
         (setq face-font-rescale-alist
               '(("^-apple-hiragino.*" . 1.2)
                 (".*ricty.*" . 1.2)
                 (".*osaka-bold.*" . 1.2)
                 (".*osaka-medium.*" . 1.2)
                 (".*courier-bold-.*-mac-roman" . 1.0)
                 (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
                 (".*monaco-bold-.*-mac-roman" . 0.9)
                 ("-cdac$" . 1.3))))
         (define-key global-map [?¥] [?\\]))) ;; ¥の代わりにバックスラッシュを入力する

;; font-lock設定
(global-font-lock-mode t)                                            ; 特定のモードで色を付ける(Font-Lookモード有効にする)
(setq font-lock-maximum-decoration t)                                ; 色づけは最大限に
(set-face-foreground 'font-lock-comment-face "dodgerblue")           ; コメントの色
(set-face-foreground 'font-lock-string-face  "red")                  ; 文字(string)部分の色文
(set-face-foreground 'font-lock-keyword-face "yellow")               ; キーワード(if,for等の予約語)の色
(set-face-foreground 'font-lock-function-name-face "lime green")     ; 関数名の色
(set-face-foreground 'font-lock-variable-name-face "magenta")        ; 変数名の色
(set-face-foreground 'font-lock-negation-char-face "coral")          ; 文字(char)部分の色
(set-face-foreground 'font-lock-type-face "DeepSkyBlue")             ; ユーザ定義のデータ型の色
(set-face-foreground 'font-lock-builtin-face "orange")               ; 組込み関数の色
(set-face-foreground 'font-lock-constant-face "cyan")                ; 定数名の色
(set-face-foreground 'font-lock-warning-face "lightcyan")            ; 独特な構文の色
(set-face-foreground 'font-lock-doc-face "dodgerblue")               ; ドキュメントの色
(set-face-foreground 'font-lock-regexp-grouping-backslash "green4")  ; 正規表現
(set-face-foreground 'font-lock-regexp-grouping-construct "green")   ; 正規表現
(set-face-bold-p 'font-lock-function-name-face t)                    ; 太字設定
(set-face-bold-p 'font-lock-warning-face nil)                        ; 太字設定

;; フレーム設定
(setq default-frame-alist
  (append '((foreground-color . "gray75")         ; 文字の色設定
            (background-color . "gray10")         ; 背景色の設定
            (cursor-color . "SlateBlue2")         ; カーソルの色設定
            (mouse-color  . "SlateBlue2")         ; マウスポインタの色を設定
            ;; (width  . 160)                        ; 画面の幅(何文字分)
            ;; (height . 50)                         ; 画面の高さ(何文字分)
            (alpha  . 97)                         ; 画面透明度の設定
           ) default-frame-alist))
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
(when (require 'rainbow-delimiters nil 'noerror)
  (add-hook 'lisp-interaction-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'js2-mode 'rainbow-delimiters-mode)
  (add-hook 'php-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'go-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'python-mode-hook 'rainbow-delimiters-mode))
(set-face-foreground 'rainbow-delimiters-depth-1-face "SlateBlue2")
(set-face-foreground 'rainbow-delimiters-depth-2-face "DarkOliveGreen2")
(set-face-foreground 'rainbow-delimiters-depth-3-face "CornflowerBlue")
(set-face-foreground 'rainbow-delimiters-depth-4-face "PaleGreen2")
(set-face-foreground 'rainbow-delimiters-depth-5-face "magenta2")
(set-face-foreground 'rainbow-delimiters-depth-6-face "DarkSlateGray2")
(set-face-foreground 'rainbow-delimiters-depth-7-face "khaki2")
(set-face-foreground 'rainbow-delimiters-depth-8-face "DeepPink3")
(set-face-foreground 'rainbow-delimiters-depth-9-face "LightSalmon2")

;; カーソル位置のフェースを調べる関数
(defun describe-face-at-point ()
  "Return face used at point."
  (interactive)
  (message "%s" (get-char-property (point) 'face)))

;;; 04-visual.el ends here
