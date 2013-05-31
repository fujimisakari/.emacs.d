;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                 gtags設定                                  ;;
;;;--------------------------------------------------------------------------;;;

(require 'gtags)

;; キーバインド
(global-set-key (kbd "C-'") 'gtags-find-tag-other-window)  ; (別バッファで)関数の定義元(関数の実体)へジャンプ
(global-set-key (kbd "C-M-'") 'gtags-find-tag)             ; 変数等のジャンプ
;; (global-set-key (kbd "C-]") 'gtags-pop-stack)              ; ジャンプした場合にジャンプ前の場所に戻る
;; (global-set-key "\M-r" 'gtags-find-rtag)                   ; 関数の参照元(関数のプロトタイプ宣言、関数をコールしている部分)へジャンプ
;; (global-set-key (kbd "C-M-:") 'gtags-find-symbol)          ; 変数等のジャンプ
;; (global-set-key "\M-p" 'gtags-find-pattern)                ; マッチした行にジャンプ
;; (global-set-key "\M-f" 'gtags-find-file)                   ; マッチしたファイル名にジャンプ。

;; ファイル保存時にGTAGSを更新する
(setq gtags-auto-UPDATE t)

;; 相対pathで表示
;; (setq gtags-path-style 'relative)
(setq gtags-path-style 'absolute)

;; *GTAGS SELECT* のバッファは1つだけ生成する
(setq gtags-select-buffer-single t)

;; 複数のタグテーブルを切り替え
(setq my-gtags-tag-table-alist
      (list (cons (gethash "tags-name1" private-env-hash) (gethash "tags-path1" private-env-hash))
            (cons (gethash "tags-name2" private-env-hash) (gethash "tags-path2" private-env-hash))
            (cons (gethash "tags-name3" private-env-hash) (gethash "tags-path3" private-env-hash))
            (cons (gethash "tags-name4" private-env-hash) (gethash "tags-path4" private-env-hash))))

(defun my-gtags-show-tag-table-alist ()
  (split-window-vertically)
  (other-window 1)
  (switch-to-buffer "*my-gtags-show-tag-table-alist*")
  (let ((n 1) (tag-table) (tag-table-alist))
    (setq tag-table-alist my-gtags-tag-table-alist)
    (while tag-table-alist
      (setq tag-table (car tag-table-alist))
      (insert (format "%d %s\n" n (car tag-table)))
      (setq tag-table-alist (cdr tag-table-alist))
      (setq n (1+ n)))))

(defun my-gtags-hide-tag-table-alist ()
  (kill-buffer "*my-gtags-show-tag-table-alist*")
  (other-window 1)
  (delete-other-windows))

(defun my-gtags-select-tag-table ()
  (interactive)
  (gtags-mode t)
  (my-gtags-show-tag-table-alist)
  (let ((n 0) (answer) (tag-table) (tag-table-alist))
    (setq tag-table-alist my-gtags-tag-table-alist)
    (setq answer (read-from-minibuffer "which tag table do you want to use?:"))
    (setq answer (string-to-number answer))
    (while (not (= n answer))
      (setq tag-table (car tag-table-alist))
      (setq tag-table-alist (cdr tag-table-alist))
      (setq n (1+ n)))
    (setq-default gtags-rootdir (cdr tag-table)))
  (my-gtags-hide-tag-table-alist)
  (cd gtags-rootdir))

(global-set-key (kbd "<f2>") 'my-gtags-select-tag-table)
