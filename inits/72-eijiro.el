;;; 72-eijiro.el --- 英辞郎設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; 辞書データの格納パス - sufary で高速化した場合
(with-eval-after-load "sdic"
  (setq sdicf-array-command "/usr/bin/grep")
  (setq sdic-eiwa-dictionary-list
        '((sdicf-client "~/.emacs.d/share/eijiro/eijirou.sdic"))
        sdic-waei-dictionary-list
        '((sdicf-client "~/.emacs.d/share/eijiro/waeijirou.sdic")))

  ;; saryを直接使用できるように sdicf.el 内に定義されているarrayコマンド用関数を強制的に置換
  (fset 'sdicf-array-init 'sdicf-common-init)
  (fset 'sdicf-array-quit 'sdicf-common-quit)

  (defun my/sdicf-array-search (sdic pattern &optional case regexp)
    "Custom sdicf-array-search using grep."
    (sdicf-array-init sdic)
    (if regexp
        (signal 'sdicf-invalid-method '(regexp))
      (save-excursion
        (set-buffer (sdicf-get-buffer sdic))
        (delete-region (point-min) (point-max))
        ;; grepコマンド用の引数に変更
        (apply 'sdicf-call-process
               sdicf-array-command
               (sdicf-get-coding-system sdic)
               nil t nil
               (append (if case (list "-i"))
                       (list pattern (sdicf-get-filename sdic))))
        (goto-char (point-min))
        (let (entries)
          (while (not (eobp)) (sdicf-search-internal))
          (nreverse entries)))))
  (fset 'sdicf-array-search #'my/sdicf-array-search)

  (defun my/sdic-item-recenter (&rest _)
    "Recenter to top after sdic item navigation."
    (recenter 0))
  (advice-add 'sdic-forward-item :after #'my/sdic-item-recenter)
  (advice-add 'sdic-backward-item :after #'my/sdic-item-recenter))

(setq sdic-default-coding-system 'utf-8-unix)

;; eval-buffer: Symbol’s value as variable is void: default-fill-column の対応
;; emacs26以降ではdefault-* の変数が廃止される
;; http://suzuki.tdiary.net/20161226.html
(if (not (boundp 'default-fill-column))
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
(defun my/sdic-highlight-search-word (orig-fun arg)
  "Highlight searched word after sdic search."
  (funcall orig-fun arg)
  (highlight-phrase arg "yellow"))
(advice-add 'sdic-search-eiwa-dictionary :around #'my/sdic-highlight-search-word)
(advice-add 'sdic-search-waei-dictionary :around #'my/sdic-highlight-search-word)

;; 検索結果表示ウインドウの高さ
(setq sdic-window-height 20)

;; 検索結果表示ウインドウにカーソルを移動しないようにする
(setq sdic-disable-select-window t)

;;; 72-eijiro.el ends here
