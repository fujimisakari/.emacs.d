;;; 13-dired.el --- Dired設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; フォルダを開く時, 新しいバッファを作成しない
(require 'dired) ; requireしてあげないとDiredで使われている関数やモードを認識しない
(require 'dired-imenu)

;; dired-mode
(add-hook 'dired-mode-hook '(lambda() (hl-line-mode -1)))
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; バッファを作成したい時にはoやC-u ^を利用する
(defvar my-dired-before-buffer nil)
(defadvice dired-advertised-find-file (before kill-dired-buffer activate)
  (setq my-dired-before-buffer (current-buffer)))

(defadvice dired-advertised-find-file (after kill-dired-buffer-after activate)
  (if (eq major-mode 'dired-mode)
      (kill-buffer my-dired-before-buffer)))

(defadvice dired-up-directory (before kill-up-dired-buffer activate)
  (setq my-dired-before-buffer (current-buffer)))

(defadvice dired-up-directory (after kill-up-dired-buffer-after activate)
  (if (eq major-mode 'dired-mode)
      (kill-buffer my-dired-before-buffer)))

;; Dired表示設定
;; ディレクトリから先頭表示されるようにする
(load "ls-lisp")
(require 'ls-lisp)
(setq ls-lisp-dirs-first nil)
(setq ls-lisp-use-insert-directory-program nil) ; ls-lispを使用
(setq ls-lisp-verbosity nil) ; パーミッションを含まない
(setq dired-listing-switches "-a --time-style=long-iso")
(when (executable-find "gls")
  (setq insert-directory-program "gls"))
;; 日付フォーマットを %Y-%m-%d %H:%M に固定
(setq ls-lisp-format-time-list '("%Y-%m-%d %H:%M" "%Y-%m-%d %H:%M"))
(setq ls-lisp-use-localized-time-format t)

;; ディレクトリを再帰的にコピー可能にする
(setq dired-recursive-copies 'always)
;; コピーしたファイルの更新時間は現在の時間にする
(setq dired-copy-preserve-time nil)

;; ファイル名のコピーはpathを含める
(defadvice dired-copy-filename-as-kill (before dired-copy-prefix activate)
  (if (eq (first (ad-get-args 0)) nil)
      (ad-set-arg 0 0)))

;; ディレクトリ内のファイル名を自由自在に編集する
(require 'wdired)

;; Diredのパス移動
(require 'dired-ex-isearch)

;; マッチした行を強調表示させる
(require 'highline)

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

;; 現在開いているバッファをdierdで開く
(defun dired-open-current-directory ()
  (interactive)
  (let ((path nil))
    (if (equal major-mode 'dired-mode)
        (setq path default-directory)
      (if (eq (buffer-file-name) nil)
          (setq path "~/")
        (setq path (file-name-directory (buffer-file-name)))))
    (when path
      (other-window-or-split)
      (dired path))))

;; ファイルなら別バッファで、ディレクトリなら同じバッファで開く
(defun dired-open-in-accordance-with-situation ()
  (interactive)
  (let ((file (dired-get-filename)))
    (if (file-directory-p file)
        (dired-find-alternate-file)
      (dired-find-file))))
;; dired-find-alternate-file の有効化
(put 'dired-find-alternate-file 'disabled nil)

;; subtreeの背景は無色にする
(require 'dired-subtree)
(set-face-background 'dired-subtree-depth-1-face nil)
(set-face-background 'dired-subtree-depth-2-face nil)
(set-face-background 'dired-subtree-depth-3-face nil)
(set-face-background 'dired-subtree-depth-4-face nil)
(set-face-background 'dired-subtree-depth-5-face nil)
(set-face-background 'dired-subtree-depth-6-face nil)

;; diredからファイル or ディレクトリ削除をやろうとすると遅いのでshell経由で削除させる
(defun dired-remove-by-shell ()
  (interactive)
  (let ((files (dired-get-marked-files t current-prefix-arg)))
    (dired-do-shell-command "rm -rf" nil files)))

;;; 13-dired.el ends here
