;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                 Dired設定                                  ;;
;;;--------------------------------------------------------------------------;;;

;; face設定
(set-face-foreground 'dired-directory "dodgerblue")   ; ディレクトリ
(set-face-foreground 'dired-symlink "cyan")           ; シンボリックリンク
(set-face-foreground 'dired-perm-write "gray75")      ; 書き込み権限

;; ディレクトリ内のファイル名を自由自在に編集する
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;; フォルダを開く時, 新しいバッファを作成しない
(require 'dired)   ; requireしてあげないとDiredで使われている関数やモードを認識しない
;; バッファを作成したい時にはoやC-u ^を利用する
(defvar my-dired-before-buffer nil)
(defadvice dired-advertised-find-file
  (before kill-dired-buffer activate)
  (setq my-dired-before-buffer (current-buffer)))

(defadvice dired-advertised-find-file
  (after kill-dired-buffer-after activate)
  (if (eq major-mode 'dired-mode)
      (kill-buffer my-dired-before-buffer)))

(defadvice dired-up-directory
  (before kill-up-dired-buffer activate)
  (setq my-dired-before-buffer (current-buffer)))

(defadvice dired-up-directory
  (after kill-up-dired-buffer-after activate)
  (if (eq major-mode 'dired-mode)
      (kill-buffer my-dired-before-buffer)))

; spとfpのディレクトリを切り替える
(defun dired-sp-fp-directory-toggle ()
  (interactive)
  (let ((current-directory (elscreen-current-directory))
        (tmp-directory (elscreen-current-directory)))
    (cond ((or (string-match "/smartphone/" current-directory) (string-match "/sp/" current-directory))
           (setq tmp-directory (replace-regexp-in-string "/smartphone/" "/featurephone/" tmp-directory))
           (setq tmp-directory (replace-regexp-in-string "/sp/" "/fp/" tmp-directory)))
          ((or (string-match "/featurephone/" current-directory) (string-match "/fp/" current-directory))
           (setq tmp-directory (replace-regexp-in-string "/featurephone/" "/smartphone/" tmp-directory))
           (setq tmp-directory (replace-regexp-in-string "/fp/" "/sp/" tmp-directory))))
    (unless (eq current-directory tmp-directory)
      (kill-buffer (current-buffer))
      (dired tmp-directory))))


; ghとshのディレクトリを切り替える
(defun dired-gh-sh-directory-toggle ()
  (interactive)
  (let ((current-directory (elscreen-current-directory))
        (tmp-directory (elscreen-current-directory)))
    (cond ((string-match "/genju-hime/" current-directory)
           (setq tmp-directory (replace-regexp-in-string "/genju-hime/" "/seishun-hime/" tmp-directory)))
          ((string-match "/seishun-hime/" current-directory)
           (setq tmp-directory (replace-regexp-in-string "/seishun-hime/" "/genju-hime/" tmp-directory))))
    (unless (eq current-directory tmp-directory)
      (kill-buffer (current-buffer))
      (dired tmp-directory))))

;; Dired表示設定
;; ディレクトリから先頭表示されるようにする
(load "ls-lisp")
(setq ls-lisp-dirs-first t)
(when (executable-find "gls")
  (setq insert-directory-program "gls"))
;; (setq ls-lisp-use-insert-directory-program nil) ; needed on unix
;; lsのオプション 「l」(小文字のエル)は必須
(setq dired-listing-switches "-lahFv")
;; ディレクトリを再帰的にコピー可能にする
(setq dired-recursive-copies 'always)
;; コピーしたファイルの更新時間は現在の時間にする
(setq dired-copy-preserve-time nil)

;; ファイル名のコピーはpathを含める
(defadvice dired-copy-filename-as-kill (before dired-copy-prefix activate)
  (if (eq (first (ad-get-args 0)) nil)
      (ad-set-arg 0 0)))

;; Diredのパス移動
(require 'dired-ex-isearch)

;; マッチした行を強調表示させる
(require 'highline)
(set-face-foreground 'highline-face "black")
(set-face-background 'highline-face "yellow")

;; ヘッダーを強調表示させる
(custom-set-faces
 '(dired-header
   ((t (:foreground "yellow" :weight bold :height 1.3 :family "Menlo")))))

;;; 更新日が当日のファイルは色を変える
(defface dired-todays-face '((t (:foreground "green"))) nil)
(defvar dired-todays-face 'dired-todays-face)

(defconst month-name-alist
  '(("1" . "Jan") ("2" . "Feb") ("3" . "Mar") ("4" . "Apr")
    ("5" . "May") ("6" . "Jun") ("7" . "Jul") ("8" . "Aug")
    ("9" . "Sep") ("10" . "Oct") ("11" . "Nov") ("12" . "Dec")))

(defun dired-today-search (arg)
  "Fontlock search function for dired."
  (search-forward-regexp
   (let ((month-name
(cdr (assoc (format-time-string "%b") month-name-alist))))
     (if month-name
(format
(format-time-string
"\\(%Y-%m-%d\\|%b %e\\|%%s %e\\) [0-9]....") month-name)
       (format-time-string
"\\(%Y-%m-%d\\|%b %e\\) [0-9]....")))
   arg t))

(eval-after-load "dired"
  '(font-lock-add-keywords
    'dired-mode
    (list '(dired-today-search . dired-todays-face))))
