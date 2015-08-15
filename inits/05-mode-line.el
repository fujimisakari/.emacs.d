;;; 05-mode-line.el --- mode-line設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; モードライン設定
(set-face-foreground 'mode-line "MediumPurple1")                     ; アクティブなモードラインの文字の色設定
(set-face-background 'mode-line "gray15")                            ; アクディブなモードラインの背景色設定
(set-face-background 'mode-line-inactive "gray15")                   ; インアクティブなモードラインの背景色設定
(column-number-mode t)                                               ; モードラインにカーソル列の位置表示
(line-number-mode t)                                                 ; モードラインにカーソル行の位置表示

;; 日付・時刻の表示設定
(setq display-time-string-forms
      '((format "%s/%s(%s) %s:%s" month day dayname 24-hours minutes)))
(display-time)                                                       ; 時間を表示
(setq display-time-kawakami-form t)                                  ; 時刻表示の左隣に日付を追加
(setq display-time-24hr-format t)                                    ; 24 時間制

;; モードラインにカレントディレクトリを表示する
(let ((ls (member 'mode-line-buffer-identification mode-line-format)))
  (setcdr ls
          (cons
           '(:eval (concat " (" (abbreviate-file-name default-directory) ")"))
           (cdr ls))))

;; モードラインに改行コードを表示
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

;; nyan-catのラインバーにする
(require 'nyan-mode)
(nyan-mode 1)
(nyan-start-animation)
(setq nyan-bar-length 24)

;;; 05-mode-line.el ends here
