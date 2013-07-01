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

;; wanderlust の、message buffer では、html メールに関しては、デフォルトで画像表示
(setq mime-w3m-safe-url-regexp nil)
(setq mime-w3m-display-inline-images t)

;; message buffer で、C-u M-i で、inline image 表示
;; 安全だと思われる、メールだけ、表示する。
;; (defun wl-summary-w3m-safe-toggle-inline-images (&optional arg)
;;   "Toggle displaying of all images in the message buffer.
;; If the prefix arg is given, all images are considered to be safe."
;;   (interactive "P")
;;   (save-excursion
;;     (set-buffer wl-message-buffer)
;;     (w3m-safe-toggle-inline-images arg)))

;; (eval-after-load "wl-summary"
;;   '(define-key wl-summary-mode-map
;;      "\M-i" 'wl-summary-w3m-safe-toggle-inline-images))

;; SEMI override

;; (eval-after-load "mime-image"
;;   '(progn
;;      (let ((rule '(image jpg jpeg)))
;;        (ctree-set-calist-strictly
;;         'mime-preview-condition
;;         (list (cons 'type (car rule))(cons 'subtype (nth 1 rule))
;;               '(body . visible)
;;               (cons 'body-presentation-method #'mime-display-image)
;;               (cons 'image-format (nth 2 rule)))))

;;      (require 'concurrent)

;;      (defvar mime-display-image-semaphore (cc:semaphore-create 1))
;;      (defvar mime-display-image-orgfile "/tmp/_mime_org.")
;;      (defvar mime-display-image-tmpfile "/tmp/_mime_image.jpg")
;;      (defvar mime-display-image-size '(600 . 400))

;;      (defun mime-display-image-winsize ()
;;        (let* ((win (selected-window))
;;               (ww (* (window-width win) (frame-char-width)))
;;               (wh (* (- (window-height win) 2) (frame-char-height))))
;;          (cons ww wh)))

;;      (defun mime-display-image-save-rawdata (d rawdata filename)
;;        (lexical-let ((rawdata rawdata) (filename filename))
;;          (deferred:nextc d
;;            (lambda (x) 
;;              (with-temp-buffer
;;                (let ((save-buffer-coding-system 'raw-text)
;;                      (buffer-file-coding-system 'raw-text)
;;                      (coding-system-for-read 'raw-text))
;;                  (insert rawdata)
;;                  (write-region nil nil filename)))))))

;;      (defun mime-display-image-convert (d filename dim)
;;        (lexical-let ((filename filename)
;;                      (dim mime-display-image-size))
;;          (deferred:$
;;            (deferred:nextc d
;;              (lambda (x) 
;;                (when (file-exists-p mime-display-image-tmpfile)
;;                  (delete-file mime-display-image-tmpfile))))
;;            (deferred:processc it "convert" "-resize" 
;;              (format "%sx%s" (car dim) (cdr dim))
;;              filename mime-display-image-tmpfile)
;;            (deferred:nextc it
;;              (lambda (x) 
;;                (unless (file-exists-p mime-display-image-tmpfile)
;;                  (error "Could not convert image : %s" filename)))))))

;;      (defun mime-display-image-load (filename)
;;        (let ((buf (find-file-noselect filename t t)))
;;          (prog1 (with-current-buffer buf (buffer-string))
;;            (kill-buffer buf))))

;;      (defun mime-display-image-show (d img-buf img-pos)
;;        (lexical-let ((img-buf img-buf) (img-pos img-pos))
;;          (deferred:nextc d
;;            (lambda (x) 
;;              (clear-image-cache)
;;              (let* ((raw (mime-display-image-load mime-display-image-tmpfile))
;;                     (image (mime-image-create raw 'jpeg 'data)))
;;                (with-current-buffer img-buf
;;                  (let ((flg buffer-read-only))
;;                    (setq buffer-read-only nil)
;;                    (put-text-property img-pos (1+ img-pos) 'display image)
;;                    (setq buffer-read-only flg)))
;;                (message "IMAGE : [%s]" (cons img-buf img-pos)))))))

;;      (defun mime-display-image-clean (d filename)
;;        (lexical-let ((filename filename))
;;          (deferred:nextc d
;;            (lambda (x) 
;;              (when (file-exists-p mime-display-image-tmpfile)
;;                (delete-file mime-display-image-tmpfile))
;;              (when (file-exists-p filename)
;;                (delete-file filename))))))

;;      (defun mime-display-image (entity situation)
;;        (message "Decoding image...")
;;        (lexical-let* ((format (cdr (assq 'image-format situation))) 
;;                       (rawdata (mime-entity-content entity))
;;                       (org-filename (or (cdr (assq 'filename situation))
;;                                         (cdr (assoc "name" situation))))
;;                       (filename (concat 
;;                                  mime-display-image-orgfile
;;                                  (file-name-extension org-filename)))
;;                       (img-buf (current-buffer))
;;                       (img-pos (point))
;;                       (dim (mime-display-image-winsize)))
;;          (insert (substring-no-properties " \n"))
;;          (deferred:$
;;            (cc:semaphore-acquire mime-display-image-semaphore)
;;            (mime-display-image-save-rawdata it rawdata filename)
;;            (mime-display-image-convert it filename dim)
;;            (mime-display-image-show it img-buf img-pos)
;;            (mime-display-image-clean it filename)
;;            (deferred:error it
;;              (lambda (err) (message "Image Error : %s" err)))
;;            (deferred:nextc it
;;              (lambda (x)
;;                (cc:semaphore-release mime-display-image-semaphore)
;;                (message "Image Done : %s" org-filename))))))

;;      ;; (cc:semaphore-release-all mime-display-image-semaphore)

;;      ))
