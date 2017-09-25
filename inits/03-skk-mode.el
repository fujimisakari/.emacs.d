;;; 03-skk-mode.el --- skk設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; 基本設定
(setq default-input-method "japanese-skk")

;; ddskk の読み込みを Emacs の起動時に行う
(setq skk-preload t)

;; 辞書サーバを使うための設定
(setq skk-user-directory "~/skk")
(setq skk-jisyo "~/skk/skk-jisyo.utf8")
(setq skk-backup-jisyo "~/skk/skk-jisyo.utf8.bak")
(setq skk-large-jisyo "~/skk/SKK-JISYO.L.utf8")
(setq skk-study-file "~/skk/skk-study.utf8")
(setq skk-study-backup-file "~/skk/skk-study.utf8.bak")
(setq skk-jisyo-code 'utf-8)       ; 個人辞書の文字コードを指定する
;; (setq skk-server-host "localhost") ; AquaSKK のサーバー機能を利用
;; (setq skk-server-portnum 1178)     ; ポートは標準
(setq skk-share-private-jisyo t)   ; 複数 skk 辞書を共有

;; 10 分放置すると個人辞書が自動的に保存される設定
(defvar skk-auto-save-jisyo-interval 600)
(defun skk-auto-save-jisyo ()
  (skk-save-jisyo))
(run-with-idle-timer skk-auto-save-jisyo-interval
                     skk-auto-save-jisyo-interval
                     'skk-auto-save-jisyo)

;; 基本的なユーザ・インターフェース
(setq skk-egg-like-newline t)        ; ▼モードで Enter キーを押したときは確定するのみ
(setq skk-undo-kakutei-word-only t)  ; ▽モードと▼モード時のアンドゥ情報を記録しない
;; (setq skk-auto-insert-paren t)       ; 対応する閉括弧を自動的に挿入する

;; 基本設定
(setq skk-japanese-message-and-error t)   ; メッセージを日本語で通知する
(setq skk-show-annotation nil)            ; 変換時に注釈 (annotation) を非表示(表示にすると重くなる)
;; (setq skk-verbose t)                      ; 変換前/変換中にエコーエリアに助言的メッセージを表示
(setq skk-show-icon t)                    ; モードラインに SKK アイコンを表示する。
(setq skk-use-jisx0201-input-method t)    ; 半角カナを入力

;; カーソル色を変えてみる
(setq skk-use-color-cursor t)
(setq skk-cursor-hiragana-color "DodgerBlue"
      skk-cursor-katakana-color "LimeGreen"
      skk-cursor-abbrev-color "red"
      skk-cursor-jisx0208-latin-color "red"
      skk-cursor-jisx0201-color "orchid1"
      skk-cursor-latin-color "Yellow2")

;; インジケータをマイナーモード内へ。
(setq skk-status-indicator 'minor-mode)

;; 句読点を動的に決定する
(add-hook 'skk-mode-hook
          (lambda ()
            (save-excursion
              (goto-char 0)
              (make-local-variable 'skk-kutouten-type)
              (if (re-search-forward "。" 10000 t)
                  (setq skk-kutouten-type 'en)
                (setq skk-kutouten-type 'jp)))))

;; 変換の学習
(require 'skk-study)
(setq skk-henkan-strict-okuri-precedence t)   ; 送り仮名が厳密に正しい候補を優先して表示する
(setq skk-check-okurigana-on-touroku 'auto)   ; 辞書登録のとき、余計な送り仮名を送らないようにする

;; 変換候補一覧と注釈(annotation)をGUIぽく表示する
(setq skk-show-tooltip t)
(setq skk-tooltip-parameters
      '((background-color . "black")
        (border-color . "royal blue")))

;; ;; 動的補完
;; (setq skk-dcomp-activate t)          ; 動的補完
;; (setq skk-dcomp-multiple-activate t) ; 動的補完の複数候補表示
;; (setq skk-dcomp-multiple-rows 10)    ; 動的補完の候補表示件数
;; ;; 動的補完の複数表示群のフェイス
;; (set-face-foreground 'skk-dcomp-multiple-face "Black")
;; (set-face-background 'skk-dcomp-multiple-face "LightGoldenrodYellow")
;; (set-face-bold-p 'skk-dcomp-multiple-face nil)
;; ;; 動的補完の複数表示郡の補完部分のフェイス
;; (set-face-foreground 'skk-dcomp-multiple-trailing-face "dim gray")
;; (set-face-bold-p 'skk-dcomp-multiple-trailing-face nil)
;; ;; 動的補完の複数表示郡の選択対象のフェイス
;; (set-face-foreground 'skk-dcomp-multiple-selected-face "White")
;; (set-face-background 'skk-dcomp-multiple-selected-face "LightGoldenrod4")
;; (set-face-bold-p 'skk-dcomp-multiple-selected-face nil)

;; 補完候補を賢くす
;; (setq skk-comp-use-prefix t) ; ローマ字 prefix をみて補完する
;; (setq skk-comp-circulate t)  ; 補完時にサイクルする

;; 個人辞書
(add-to-list 'skk-completion-prog-list
             '(skk-comp-from-jisyo "~/skk/skk-jisyo.utf8"))
;; server completion
(add-to-list 'skk-search-prog-list
             '(skk-server-completion-search) t)
(add-to-list 'skk-search-prog-list
             '(skk-comp-by-server-completion) t)

;; 検索に関連した設定
(setq skk-use-look t)                 ; look コマンドを使った検索を行う
(setq skk-use-numeric-conversion t)   ; 数値変換機能を使う
(setq skk-auto-okuri-process t)       ; 送りあり変換を送りなし変換と同じ操作でできるようにする

(when skk-use-look
  ;; look が見つけた語を見出し語として検索する
  (setq skk-look-recursive-search t)
  ;; ispell を look と一緒に使うのはやめる
  (setq skk-look-use-ispell nil)
  ;; look に渡すコマンドラインオプションの設定。補完時と検索時それぞれに
  ;; ついて設定できる。
  ;; look で case を見るときは、それ専用の辞書を sort コマンドで作る必要
  ;; がある (look の引数 -d, -f は sort の引数 -d, -f と一致させておく必
  ;; 要がある)。
  ;; (*) 補完時には引数 -d を指定すると dcomp との併用時に問題あることが
  ;; 報告されているため、-d を指定しないことをお勧めします。
  (setq skk-look-completion-arguments "%s /usr/share/dict/words")
  (setq skk-look-conversion-arguments "-df %s /usr/share/dict/words")
  ;; `skk-abbrev-mode' で skk-look を使った検索をしたときに確定情報を
  ;; 個人辞書に記録しないようにする
  (add-hook 'skk-search-excluding-word-pattern-function
            ;; KAKUTEI-WORD を引数にしてコールされるので、不要でも引数を取る
            ;; 必要あり
            #'(lambda (kakutei-word)
                (and skk-abbrev-mode
                     (save-match-data
                       ;; `skk-henkan-key' が "*" で終わるとき、または
                       ;; `skk-henkan-key' が数字のみのとき
                       (or (string-match "\\*$" skk-henkan-key)
                           (string-match "^[0-9]*$" skk-henkan-key)))))))

;; sticky設定
;; 大文字入力を楽にします
;; (defvar sticky-key ";")
;; (defvar sticky-list
;;   '(
;;     ("a" . "A") ("b" . "B") ("c" . "C") ("d" . "D") ("e" . "E") ("f" . "F") ("g" . "G")
;;     ("h" . "H") ("i" . "I") ("j" . "J") ("k" . "K") ("l" . "L") ("m" . "M") ("n" . "N")
;;     ("o" . "O") ("p" . "P") ("q" . "Q") ("r" . "R") ("s" . "S") ("t" . "T") ("u" . "U")
;;     ("v" . "V") ("w" . "W") ("x" . "X") ("y" . "Y") ("z" . "Z")
;;     ("1" . "!") ("2" . "\"") ("3" . "#") ("4" . "$") ("5" . "%") ("6" . "&") ("7" . "'")
;;     ("8" . "(") ("9" . ")") ("0" . "~")
;;     ("@" . "`") ("[" . "{") ("]" . "}") ("-" . "=") (":" . "*") ("," . "<") ("." . ">")
;;     ("/" . "?") (";" . "+") ("\\" . "|") ("^" . "_")
;;     ))
;; (defvar sticky-map (make-sparse-keymap))
;; (global-set-key sticky-key sticky-map)
;; (mapcar (lambda (pair)
;;           (define-key sticky-map (car pair)
;;             `(lambda() (interactive)
;;                (setq unread-command-events
;;                      (cons , (string-to-char (cdr pair)) unread-command-events)))))
;;         sticky-list)
;; (define-key sticky-map sticky-key '(lambda () (interactive) (insert sticky-key)))
;; (add-hook 'skk-mode-hook
;;           (lambda ()
;;             (progn
;;               (define-key skk-j-mode-map sticky-key sticky-map)
;;               (define-key skk-jisx0208-latin-mode-map sticky-key sticky-map)
;;               (define-key skk-abbrev-mode-map sticky-key sticky-map)
;;               )
;;             ))

;;isearch-mode に入った際に自動的に skk-isearch を起動
(add-hook 'isearch-mode-hook 'skk-isearch-mode-setup)
(add-hook 'isearch-mode-end-hook 'skk-isearch-mode-cleanup)

;; かなモードの入力で (モード変更を行なわずに) 長音(ー)を
;; ASCII 数字の直後では `-' に、全角数字の直後では `－' にしたい。
(setq skk-rom-kana-rule-list
      (cons '("-" nil skk-hyphen)
            skk-rom-kana-rule-list))
(defun skk-hyphen (arg)
  (let ((c (char-before (point))))
    (cond ((null c) "ー")
          ((and (<= ?0 c) (>= ?9 c)) "-")
          ((and (<= ?０ c) (>= ?９ c)) "－")
          (t "ー"))))

;; かなモードの入力でモード変更を行わずに、数字入力中の
;; 小数点 (.) およびカンマ (,) 入力を実現する。
;; (例) かなモードのまま 1.23 や 1,234,567 などの記述を行える。
;; period
(setq skk-rom-kana-rule-list
      (cons '("." nil skk-period)
            skk-rom-kana-rule-list))
(defun skk-period (arg)
  (let ((c (char-before (point))))
    (cond ((null c) "。")
          ((and (<= ?0 c) (>= ?9 c)) ".")
          ((and (<= ?０ c) (>= ?９ c)) "．")
          (t "。"))))

;; comma
(setq skk-rom-kana-rule-list
      (cons '("," nil skk-comma)
            skk-rom-kana-rule-list))
(defun skk-comma (arg)
  (let ((c (char-before (point))))
    (cond ((null c) "、")
          ((and (<= ?0 c) (>= ?9 c)) ",")
          ((and (<= ?０ c) (>= ?９ c)) "，")
          (t "、"))))

;; z1とかx1で丸数字入力を可能にする
(let ((s "⑩①②③④⑤⑥⑦⑧⑨"))
  (dotimes (n (length s))
    (add-to-list
     'skk-rom-kana-rule-list
     (list (concat "z" (number-to-string n))
           nil
           (cons (substring s n (1+ n)) (substring s n (1+ n)))))))
(let ((s "⑳⑪⑫⑬⑭⑮⑯⑰⑱⑲"))
  (dotimes (n (length s))
    (add-to-list
     'skk-rom-kana-rule-list
     (list (concat "x" (number-to-string n))
           nil
           (cons (substring s n (1+ n)) (substring s n (1+ n)))))))

;;; 03-skk-mode.el ends here
