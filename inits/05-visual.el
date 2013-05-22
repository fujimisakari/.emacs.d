;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                外観設定                                    ;;
;;;--------------------------------------------------------------------------;;;

;; カラーテーマを利用する
;; color-theme
;; (when window-system
;;   (require 'color-theme nil t)
;;   (color-theme-initialize)
;;   (color-theme-charcoal-black))

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
                             :family "monaco"
                             :height 125)
         (set-fontset-font
          (frame-parameter nil 'font)
          'japanese-jisx0208
          '("Hiragino Maru Gothic Pro" . "iso10646-1"))
         (set-fontset-font
          (frame-parameter nil 'font)
          'katakana-jisx0201
          '("Hiragino Maru Gothic Pro" . "iso10646-1"))
         ;; Unicode フォント
         (set-fontset-font
          (frame-parameter nil 'font)
          'mule-unicode-0100-24ff
          '("monaco" . "iso10646-1"))
         (setq face-font-rescale-alist
               '(("^-apple-hiragino.*" . 1.2)
                 (".*osaka-bold.*" . 1.2)
                 (".*osaka-medium.*" . 1.2)
                 (".*courier-bold-.*-mac-roman" . 1.0)
                 (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
                 (".*monaco-bold-.*-mac-roman" . 0.9)
                 ("-cdac$" . 1.3))))

       (define-key global-map [?¥] [?\\]))) ;; ¥の代わりにバックスラッシュを入力する

;; フォントのサイズ等を一覧表示確認できるようにする
(require 'my-sample-ascii)

;; カラー関連
(global-font-lock-mode t)                                            ; 特定のモードで色を付ける(Font-Lookモード有効にする)
(setq font-lock-maximum-decoration t)                                ; 色づけは最大限に
(set-face-foreground 'font-lock-comment-face "dodgerblue")           ; コメントの色
(set-face-foreground 'font-lock-string-face  "red")                  ; 文字(string)部分の色文
(set-face-foreground 'font-lock-keyword-face "yellow")               ; キーワード(if,for等の予約語)の色
(set-face-foreground 'font-lock-function-name-face "lime green")     ; 関数名の色
(set-face-foreground 'font-lock-variable-name-face "magenta")        ; 変数名の色
(set-face-foreground 'font-lock-negation-char-face "coral")          ; 文字(char)部分の色
(set-face-foreground 'font-lock-type-face "yellow")                  ; ユーザ定義のデータ型の色
(set-face-foreground 'font-lock-builtin-face "orange")               ; 組込み関数の色
(set-face-foreground 'font-lock-constant-face "cyan")                ; 定数名の色
(set-face-foreground 'font-lock-warning-face "lightcyan")            ; 独特な構文の色
(set-face-foreground 'font-lock-doc-face "dodgerblue")               ; ドキュメントの色
(set-face-foreground 'font-lock-regexp-grouping-backslash "green4")  ; 正規表現
(set-face-foreground 'font-lock-regexp-grouping-construct "green")   ; 正規表現
(set-face-bold-p 'font-lock-function-name-face t)                    ; 太字設定
(set-face-bold-p 'font-lock-warning-face nil)                        ; 太字設定

;; モードライン設定
(set-face-foreground 'modeline "MediumPurple1")                      ; アクティブなモードラインの文字の色設定
(set-face-background 'modeline "gray15")                             ; アクディブなモードラインの背景色設定
(set-face-background 'mode-line-inactive "gray15")                   ; インアクティブなモードラインの背景色設定
(column-number-mode t)                                               ; モードラインにカーソル列の位置表示
(line-number-mode t)                                                 ; モードラインにカーソル行の位置表示

;; 日付・時刻の表示設定
(setq display-time-string-forms
      '((format "%s/%s/%s(%s) %s:%s" year month day dayname 24-hours minutes)))
(display-time)                                                       ; 時間を表示
(setq display-time-kawakami-form t)                                  ; 時刻表示の左隣に日付を追加
(setq display-time-24hr-format t)                                    ; 24 時間制

;; モードラインにカレントディレクトリを表示する
(let ((ls (member 'mode-line-buffer-identification mode-line-format)))
  (setcdr ls
          (cons
           '(:eval (concat " (" (abbreviate-file-name default-directory) ")"))
           (cdr ls))))

;; sml-modeline
;; (load "sml-modeline.el")
;; (sml-mode t)
;; ;; フェイスの設定
;; (set-face-background 'sml-end-face "SlateGray3")                     ; 背景色
;; (set-face-background 'sml-vis-face "RoyalBlue2")                     ; 表示領域の背景色

;; モードラインに改行コードを表示
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

;; モードラインのスクロールバーをnyancatにする
(require 'nyan-mode)
;; 自動起動したいとき
;; アニメーションを使いたいとき
(nyan-mode)
(nyan-start-animation)

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
;; (global-linum-mode)                               ; 行番号表示
(setq ring-bell-function 'ignore)                 ; ビープ音、画面フラッシュどちらも起こさない
(auto-image-file-mode)                            ; 画像表示を有効
(setq inhibit-startup-screen t)                   ; 起動画面を表示させない

;; タイトルバーのフォーマット設定
(setq frame-title-format `("GNU/Emacs " emacs-version " -- %b " (buffer-file-name "( %f )")))

;; カーソルを点滅させる
(blink-cursor-mode t)

;; カーソル行をハイライト表示
(hl-line-mode)
(set-face-background 'hl-line "gray20")

;; 選択中のリージョンの色設定
(setq transient-mark-mode t)
(set-face-background 'region "SlateBlue4")

;; カーソル桁をハイライト表示
;(require 'col-highlight)
;(column-highlight-mode 1)
;(custom-set-faces
; '(col-highlight ((t (:background "gray20")))))

(require 'highlight-indentation)
(setq highlight-indentation-offset 4)  ;; default: 4
(set-face-background 'highlight-indent-face "MediumPurple4")
;; (set-face-background 'highlight-indentation-current-column-face "#e3e3d3")
;; (add-hook 'python-mode-hook 'highlight-indentation-current-column-mode)
;; (add-hook 'html-mode-hook 'highlight-indentation-current-column-mode)

;; paren: 対応する括弧を光らせる
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)                           ; カッコ内の色も変更
(set-face-background 'show-paren-match-face nil)              ; カッコ内のフェイス
(set-face-underline-p 'show-paren-match-face "yellow")        ; カッコ内のフェイス

;; カーソル位置のフェースを調べる関数
(defun describe-face-at-point ()
  "Return face used at point."
  (interactive)
  (message "%s" (get-char-property (point) 'face)))

;; rainbow設定
(setq rainbow-html-colors t)
(setq rainbow-x-colors t)
(setq rainbow-latex-colors t)
(setq rainbow-ansi-colors t)

