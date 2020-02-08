;;; 72-eijiro.el --- 英辞郎設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; 辞書データの格納パス - sufary で高速化した場合
(eval-after-load "sdic"
  '(progn
     (setq sdicf-array-command "/usr/local/bin/sary") ; コマンドパス
     (setq sdic-eiwa-dictionary-list
           '((sdicf-client "~/.emacs.d/share/eijiro/eijirou.sdic" (strategy array)))
           sdic-waei-dictionary-list
           '((sdicf-client "~/.emacs.d/share/eijiro/waeijirou.sdic" (strategy array))))

     ;; saryを直接使用できるように sdicf.el 内に定義されているarrayコマンド用関数を強制的に置換
     (fset 'sdicf-array-init 'sdicf-common-init)
     (fset 'sdicf-array-quit 'sdicf-common-quit)
     (fset 'sdicf-array-search
           '(lambda (sdic pattern &optional case regexp)
             (sdicf-array-init sdic)
             (if regexp
                 (signal 'sdicf-invalid-method '(regexp))
               (save-excursion
                 (set-buffer (sdicf-get-buffer sdic))
                 (delete-region (point-min) (point-max))
                 (apply 'sdicf-call-process
                        sdicf-array-command
                        (sdicf-get-coding-system sdic)
                        nil t nil
                        (if case
                            (list "-i" pattern (sdicf-get-filename sdic))
                          (list pattern (sdicf-get-filename sdic))))
                 (goto-char (point-min))
                 (let (entries)
                   (while (not (eobp)) (sdicf-search-internal))
                   (nreverse entries))))))

     (defadvice sdic-forward-item (after sdic-forward-item-always-top activate)
       (recenter 0))
     (defadvice sdic-backward-item (after sdic-backward-item-always-top activate)
       (recenter 0))))

(setq sdic-default-coding-system 'utf-8-unix)

;; eval-buffer: Symbol’s value as variable is void: default-fill-column の対応
;; emacs26以降ではdefault-* の変数が廃止される
;; http://suzuki.tdiary.net/20161226.html
(if (string-match "26" emacs-version)
    (setq default-fill-column (default-value 'fill-column)))

;; sdicのロード
(autoload 'sdic-describe-word "sdic" "sdic 英和・和英辞書検索" t nil)
;;(autoload 'sdic-describe-word-at-point "sdic" "カーソルの位置の英和・和英辞書検索" t nil)
(autoload 'sdic-describe-region "sdic" "リージョン選択した英和・和英辞書検索" t nil)

;; キーバインド設定
;; 問い合わせて語句を引く例
;; 'word' (シングルクォートで囲む)：word に完全一致する単語を検索
;; word* (末尾に * )：word に前方一致する単語を検索 ex: word-blind
;; *word (先頭に * )：word に後方一致する単語を検索 ex: bear a sword
;; /word (先頭に / )：word 全文検索 ex: fixed-word-length computer
;; (global-set-key (kbd "M-") 'sdic-describe-word-at-point)     ; カーソル上の語句を引く
;; (global-set-key (kbd "C-M-;") 'sdic-describe-word)           ; ミニバッファに問い合わせて語句を引く
;; (global-set-key (kbd "C-l C-M-;") 'sdic-describe-region)        ; リージョンの語句を引く
;; (global-set-key [end]     'sdic-close-window)                ; 検索結果表示ウィンドウを閉じる
;; (global-set-key [next]    'scroll-other-window)              ; 検索結果表示ウィンドウをスクロールする
;; (global-set-key [prior]   'scroll-other-window-down)         ; 検索結果表示ウィンドウをスクロールする

;; 見出し語を表示するために使うフェイスと色
(setq sdic-face-style 'bold)
(setq sdic-face-color "lime green")

;; 検索結果表示バッファで引いた単語をハイライト表示する
(defadvice sdic-search-eiwa-dictionary (after highlight-phrase (arg))
  (highlight-phrase arg "yellow"))
(defadvice sdic-search-waei-dictionary (after highlight-phrase (arg))
  (highlight-phrase arg "yellow"))

(ad-activate 'sdic-search-eiwa-dictionary)
(ad-activate 'sdic-search-waei-dictionary)

;; 検索結果表示ウインドウの高さ
(setq sdic-window-height 20)

;; 検索結果表示ウインドウにカーソルを移動しないようにする
(setq sdic-disable-select-window t)

;;; 72-eijiro.el ends here
