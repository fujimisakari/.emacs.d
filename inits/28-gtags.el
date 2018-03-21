;;; 28-gtags.el --- gtags設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'gtags)

;; ファイル保存時にGTAGSを更新する
(setq gtags-auto-UPDATE t)

;; 相対pathで表示
(setq gtags-path-style 'relative)
;; (setq gtags-path-style 'absolute)

;; *GTAGS SELECT* のバッファは1つだけ生成する
(setq gtags-select-buffer-single t)

(defun helm-gtags-find-rtag-other-window (tag)
  "Jump to referenced point"
  (interactive
   (list (helm-gtags--read-tagname 'rtag (which-function))))
  (setq helm-gtags--use-otherwin t)
  (helm-gtags--common '(helm-source-gtags-rtags) tag))

(defun helm-gtags-find-symbol-other-window (tag)
  "Jump to the symbol location"
  (interactive
   (list (helm-gtags--read-tagname 'symbol)))
  (setq helm-gtags--use-otherwin t)
  (helm-gtags--common '(helm-source-gtags-gsyms) tag))

;;; 28-gtags.el ends here
