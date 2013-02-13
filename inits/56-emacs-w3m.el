;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               Emacs-w3m設定                                ;;
;;;--------------------------------------------------------------------------;;;

(require 'w3m-load)
(setq w3m-home-page "http://www.google.co.jp/")                             ; 起動時に開くページ
(setq w3m-search-default-engine "google-ja")                                ; 検索をGoogle(日本語サイト)でおこなう
(setq w3m-use-cookies t)                                                    ; クッキーを使う
;; (setq w3m-bookmark-file "~/.emacs.d/cache/bookmark.html")                 ; ブックマークを保存するファイル
(setq w3m-default-display-inline-images t)                                  ; 画像表示を有効にする
(global-set-key (kbd "C-c s") 'w3m-search)                                  ; C-csを押下するとどのBufferからでも検索を開始
(autoload 'w3m "w3m" "Interface for w3m on Emacs." t)                       ; M-x w3mでw3mを起動する
(autoload 'w3m-find-file "w3m" "w3m interface function for local file." t)  ; M-x w3m-find-fileとして、ページャとしてのw3mの機能を利用する。
;; (autoload 'w3m-weather "w3m-weather" "Display weather report." t)
;; (autoload 'w3m-antenna "w3m-antenna" "Report change of WEB sites." t)
;; (autoload 'w3m-namazu "w3m-namazu" "Search files with Namazu." t)
;; (autoload 'w3m-search "w3m-search" "Search QUERY using SEARCH-ENGINE." t) ;

;; browse-url w3m
;; 以下のように設定しておくと、URI に類似した文字列がある場所で C-x m と
;; 入力すれば、w3m で表示されるようになる。
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(global-set-key (kbd "C-x m") 'browse-url-at-point)

;; `dired' バッファで `C-x m' キーをタイプすることによって、
;; emacs-w3m を使って HTML ファイルを閲覧することができるようにする
(eval-after-load "dired"
  '(define-key dired-mode-map "\C-xm" 'dired-w3m-find-file))

(defun dired-w3m-find-file ()
  (interactive)
  (require 'w3m)
  (let ((file (dired-get-filename)))
    (if (y-or-n-p (format "Use emacs-w3m to browse %s? "
                          (file-name-nondirectory file)))
        (w3m-find-file file))))

;; wanderlustとの連携設定
;; w3m でhtml パートを表示する。
(require 'mime-w3m)

;; w3mのバッファーでは、デフォルトで、inline image 表示
(setq w3m-default-display-inline-images t)

;; wanderlust の、message buffer では、html メールに関しては、デフォルトでは
;; inline image off にしておく。
(setq mime-w3m-safe-url-regexp nil)
(setq mime-w3m-display-inline-images nil)

;; message buffer で、C-u M-i で、inline image 表示
;; 安全だと思われる、メールだけ、表示する。
(defun wl-summary-w3m-safe-toggle-inline-images (&optional arg)
  "Toggle displaying of all images in the message buffer.
If the prefix arg is given, all images are considered to be safe."
  (interactive "P")
  (save-excursion
    (set-buffer wl-message-buffer)
    (w3m-safe-toggle-inline-images arg)))

(eval-after-load "wl-summary"
  '(define-key wl-summary-mode-map
     "\M-i" 'wl-summary-w3m-safe-toggle-inline-images))

