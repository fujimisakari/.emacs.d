;;; 76-w3m.el --- w3m設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'w3m)
(cond ((eq my-os-type 'linux)
       (setq w3m-command "/usr/bin/w3m"))
      ((eq my-os-type 'mac)
       (setq w3m-command "w3m")))

(setq w3m-home-page "http://www.google.co.jp/")                             ; 起動時に開くページ
(setq w3m-search-default-engine "google-ja")                                ; 検索をGoogle(日本語サイト)でおこなう
(setq w3m-use-cookies t)                                                    ; クッキーを使う
;; (setq w3m-bookmark-file "~/.emacs.d/cache/bookmark.html")                 ; ブックマークを保存するファイル
(setq w3m-default-display-inline-images t)                                  ; 画像表示を有効にする
(autoload 'w3m "w3m" "Interface for w3m on Emacs." t)                       ; M-x w3mでw3mを起動する
(autoload 'w3m-find-file "w3m" "w3m interface function for local file." t)  ; M-x w3m-find-fileとして、ページャとしてのw3mの機能を利用する。

;;; 76-w3m.el ends here
