;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                 gtags設定                                  ;;
;;;--------------------------------------------------------------------------;;;

(require 'gtags)

;; ファイル保存時にGTAGSを更新する
(setq gtags-auto-UPDATE t)

;; 相対pathで表示
(setq gtags-path-style 'relative)
;; (setq gtags-path-style 'absolute)

;; *GTAGS SELECT* のバッファは1つだけ生成する
(setq gtags-select-buffer-single t)

(defun helm-gtags-find-tag-other-window ()
  "It opens gtags by other buffer"
  (interactive)
  (other-window-or-split)
  (helm-gtags-find-tag))
