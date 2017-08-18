;;; 21-auto-complete.el --- auto-complete設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;;; auto-complete-mode: 高機能補完+ポップアップメニュー
(ac-config-default)
;;ac-auto-startが整数値の場合、文字列の長さがac-auto-start以上になると自動補完開始
(setq ac-auto-start nil)
(setq ac-delay 0.5)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/share/ac-dict")
;; ソートファイルの保存場所を変更
(setq ac-comphist-file
      (expand-file-name (concat user-emacs-directory "/cache/ac-comphist.dat")))
;; クイックヘルプを利用する
(setq ac-use-quick-help t)
;; 補完メニューのときだけキーバインドを有効にする
(setq ac-use-menu-map t)
;; 色の設定
(set-face-foreground 'ac-candidate-face "#fff")
(set-face-background 'ac-candidate-face "#444")
(set-face-foreground 'ac-selection-face "#fff")
(set-face-background 'ac-selection-face "SlateBlue2")
(set-face-foreground 'ac-gtags-candidate-face "#fff")
(set-face-background 'ac-gtags-candidate-face "#444")
(set-face-foreground 'ac-gtags-selection-face "#fff")
(set-face-background 'ac-gtags-selection-face "SlateBlue2")

(set-face-foreground 'popup-menu-face "#fff")
(set-face-background 'popup-menu-face "#444")
(set-face-foreground 'popup-menu-selection-face "#fff")
(set-face-background 'popup-menu-selection-face "SlateBlue2")

(set-face-background 'popup-scroll-bar-foreground-face "#ccc")
(set-face-background 'popup-scroll-bar-background-face "#444")

;;; 21-auto-complete.el ends here
