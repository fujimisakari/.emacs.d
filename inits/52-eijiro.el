;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                 英辞郎設定                                 ;;
;;;--------------------------------------------------------------------------;;;

;; 辞書データの格納パス - sufary で高速化した場合
(setq sdic-eiwa-dictionary-list
      '((sdicf-client "~/.emacs.d/share/eijiro/eijirou.sdic"
                      (strategy array))))
(setq sdic-waei-dictionary-list
      '((sdicf-client "~/.emacs.d/share/eijiro/waeijirou.sdic")))

(setq sdic-default-coding-system 'utf-8-unix)

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
(global-set-key (kbd "C-M-@") 'sdic-describe-region)         ; リージョンの語句を引く
;; (global-set-key [end]     'sdic-close-window)                ; 検索結果表示ウィンドウを閉じる
;; (global-set-key [next]    'scroll-other-window)              ; 検索結果表示ウィンドウをスクロールする
;; (global-set-key [prior]   'scroll-other-window-down)         ; 検索結果表示ウィンドウをスクロールする

;; 見出し語を表示するために使うフェイスと色
(setq sdic-face-style 'bold)
(setq sdic-face-color "lime green")

;; 検索結果表示バッファで引いた単語をハイライト表示する
(defadvice sdic-search-eiwa-dictionary (after highlight-phrase (arg))
  (highlight-phrase arg "hi-yellow"))
(defadvice sdic-search-waei-dictionary (after highlight-phrase (arg))
  (highlight-phrase arg "hi-yellow"))

(ad-activate 'sdic-search-eiwa-dictionary)
(ad-activate 'sdic-search-waei-dictionary)

;; 検索結果表示ウインドウの高さ
(setq sdic-window-height 20)

;; 検索結果表示ウインドウにカーソルを移動しないようにする
(setq sdic-disable-select-window t)
