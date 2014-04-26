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


(require 'dired)
(defun dired-maybe-insert-subdir-or-go-up (&optional arg)
  "Try to make `i' more reproducable in dired. Hitting `i' twice
will bring dired-status back. With arg, move point to next
directory."
  (interactive "p")
  (cond
   ((not (file-accessible-directory-p (dired-get-file-for-visit)))
    (error "%s is not readable directory" (dired-get-file-for-visit)))
   ((string= (file-name-nondirectory (dired-get-file-for-visit)) "..")
    (let ((dir (dired-current-directory)))
      (dired-goto-file (directory-file-name dir))
      (if arg (dired-next-line arg))))
   (t ; default `i' behavior
    (call-interactively 'dired-maybe-insert-subdir)
    (if (ignore-errors (dired-get-file-for-visit))
        (dired-prev-dirline 1)
      (funcall (if (eobp) 're-search-backward 're-search-forward) "\\.\\./?$" nil t)
      (goto-char (match-beginning 0))))))
(define-key dired-mode-map (kbd "i") 'dired-maybe-insert-subdir-or-go-up)


;; diredには元々、表示中のディレクトリを隠すことができます。

;; それをちょっとアレンジすることで、
;; org-modeと同等の操作性を獲得できます。

;; 以下の設定を加えると次のようなことができます。

;; - TAB: 現在のディレクトリを折り畳む・展開
;; - S-TAB: diredバッファ内すべてのディレクトリを折り畳む・展開


;; まあelispプログラムはいろんな人によって書かれているし、
;; 操作体系に規定がないので、人によってまちまちなのは
;; 仕方ないですね。

(defun dired-hide-subdir-and-stay (arg) ; steal from dired-aux.el
  "Hide or unhide the current subdirectory and DO NOT move to next directory.
Optional prefix arg is a repeat factor.  Use \\[dired-hide-all]
to (un)hide all directories."
  (interactive "p")
  (dired-hide-check)
  (let ((modflag (buffer-modified-p)))
    (while (>=  (setq arg (1- arg)) 0)
      (let* ((cur-dir (dired-current-directory))
         (hidden-p (dired-subdir-hidden-p cur-dir))
         (elt (assoc cur-dir dired-subdir-alist))
         (end-pos (1- (dired-get-subdir-max elt)))
         buffer-read-only)
    ;; keep header line visible, hide rest
    (goto-char (dired-get-subdir-min elt))
    (skip-chars-forward "^\n\r")
    (if hidden-p
        (subst-char-in-region (point) end-pos ?\r ?\n)
      (subst-char-in-region (point) end-pos ?\n ?\r)))
      ;; (dired-next-subdir 1 t)) ; comment out by TK January 13, 2014 (Mon)
      )
    (restore-buffer-modified-p modflag)))

(defun dired-fold-like-org (arg)
  (interactive "P")
  (if arg
      (dired-hide-all)
    (dired-hide-subdir-and-stay 1)))

(define-key dired-mode-map (kbd "<tab>") 'dired-fold-like-org)
(define-key dired-mode-map (kbd "S-<tab>") 'dired-hide-all)
(define-key dired-mode-map (kbd "<backtab>") 'dired-hide-all)

(require 'dired-subtree)
(define-key dired-mode-map (kbd "i") 'dired-subtree-insert)
(define-key dired-mode-map (kbd "<tab>") 'dired-subtree-remove)
(define-key dired-mode-map (kbd "C-x n n") 'dired-subtree-narrow)
(define-key dired-mode-map (kbd "C-x n d") 'dired-subtree-narrow)
(define-key dired-mode-map (kbd "^") 'dired-subtree-up)
(define-key dired-mode-map (kbd "C-c C-n") 'dired-subtree-next-sibling)
(define-key dired-mode-map (kbd "C-c C-p") 'dired-subtree-previous-sibling)
(define-key dired-mode-map (kbd "C-c C-a") 'dired-subtree-beginning)
(define-key dired-mode-map (kbd "C-c C-e") 'dired-subtree-end)
(define-key dired-mode-map (kbd "C-M-@") 'dired-subtree-mark-subtree)
(define-key dired-mode-map (kbd "C-c C-f") 'dired-subtree-only-this-file)
(define-key dired-mode-map (kbd "C-c C-d") 'dired-subtree-only-this-directory)

;; (require 'dired-details)
;; (dired-details-install)
;; (setq dired-details-hidden-string " ")
;; (setq dired-details-hide-link-targets nil)
;; (require 'dired-master)
;; (setq dired-at-left-width 30)
;; (global-set-key (kbd "C-x C-d") 'dired-at-left)
;; (dired-dedicated-install)
