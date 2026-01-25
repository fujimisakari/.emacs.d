;;; 13-dired.el --- Dired設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; フォルダを開く時, 新しいバッファを作成しない
(require 'dired) ; requireしてあげないとDiredで使われている関数やモードを認識しない
(require 'dired-imenu)

;; dired-mode
(defun my/dired-disable-hl-line ()
  "Disable hl-line-mode in dired."
  (hl-line-mode -1))
(add-hook 'dired-mode-hook #'my/dired-disable-hl-line)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; バッファを作成したい時にはoやC-u ^を利用する
(defvar my-dired-before-buffer nil)

(defun my/dired-save-buffer-before (&rest _)
  "Save current buffer before dired navigation."
  (setq my-dired-before-buffer (current-buffer)))

(defun my/dired-kill-buffer-after (&rest _)
  "Kill previous dired buffer after navigation."
  (when (eq major-mode 'dired-mode)
    (kill-buffer my-dired-before-buffer)))

(advice-add 'dired-advertised-find-file :before #'my/dired-save-buffer-before)
(advice-add 'dired-advertised-find-file :after #'my/dired-kill-buffer-after)
(advice-add 'dired-up-directory :before #'my/dired-save-buffer-before)
(advice-add 'dired-up-directory :after #'my/dired-kill-buffer-after)

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
(setq dired-use-ls-dired nil)
(setq dired-listing-switches "-alh")
;; 日付フォーマットを %Y-%m-%d %H:%M に固定
(setq ls-lisp-format-time-list '("%Y-%m-%d %H:%M" "%Y-%m-%d %H:%M"))
(setq ls-lisp-use-localized-time-format t)

;; ディレクトリを再帰的にコピー可能にする
(setq dired-recursive-copies 'always)
;; コピーしたファイルの更新時間は現在の時間にする
(setq dired-copy-preserve-time nil)

;; ファイル名のコピーはpathを含める
(defun my/dired-copy-filename-with-path (orig-fun &optional arg)
  "Copy filename with path by default."
  (funcall orig-fun (or arg 0)))
(advice-add 'dired-copy-filename-as-kill :around #'my/dired-copy-filename-with-path)

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
(defun dired-open-current-directory (&optional split-window)
  "現在のバッファのディレクトリを Dired で開く。
SPLIT-WINDOW が non-nil の場合、ウィンドウを分割して開く。
通常は prefix argument（C-u）で分割指定できる。"
  (interactive "P")
  (let ((path nil))
    (if (equal major-mode 'dired-mode)
        (setq path default-directory)
      (if (eq (buffer-file-name) nil)
          (setq path "~/")
        (setq path (file-name-directory (buffer-file-name)))))
    (when path
      (when split-window
        (other-window-or-split))
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

;; ディレクトリを新しいバッファで開く
(defun dired-open-directory-in-new-buffer ()
  "Open the directory at point in a new buffer using dired."
  (interactive)
  (let ((file (dired-get-file-for-visit)))
    (when (file-directory-p file)
      (dired-other-window file))))

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
