;;; 09-helm.el --- helm設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'helm-config)
(require 'helm-ag)
;; (require 'helm-migemo)
(helm-mode 1)

;; 基本設定
(setq
  ;; 候補を表示するばでの時間 デフォルトは0.3
  helm-idle-delay 0.1
  ;; タイプして再描画するまでの時間。デフォルトは0.3
  helm-input-idle-delay 0.2
  ;; 候補の最大表示数。デフォルトは100
  helm-candidate-number-limit 30
  ;; 候補が多いときに体感速度を早くする
  helm-quick-update t)

;; (setq helm-buffer-max-length 35) ; バッファ名の最大文字数
(setq helm-split-window-default-side 'right) ; 分割
;; ディレクトリの自動補完を切る
(setq helm-ff-auto-update-initial-value nil)
;; スマート補完
(setq helm-ff-smart-completion t)
;; ミニバッファ内の先頭でない特定の位置からC-kできるようにする
(setq helm-delete-minibuffer-contents-from-point t)

;; customize
(progn
  (custom-set-variables
   '(helm-truncate-lines t)
   '(helm-buffer-max-length 37)
   '(helm-delete-minibuffer-contents-from-point t)
   '(helm-ff-skip-boring-files t)
   '(helm-boring-file-regexp-list '("~$" "\\.elc$"))
   '(helm-mini-default-sources '(helm-source-buffers-list
                                 helm-source-bookmarks
                                 helm-source-recentf
                                 helm-source-buffer-not-found))))

;; gtags設定
(require 'helm-gtags)

;; find-cmd設定
(require 'helm-find-cmd)

;; helm-swoop
(setq helm-swoop-split-with-multiple-windows t)
(setq helm-swoop-split-direction 'split-window-horizontally)
(setq helm-swoop-speed-or-color t)
(setq helm-swoop-use-line-number-face nil)
(custom-set-faces
 '(helm-swoop-target-line-face ((t (:background "SlateBlue3" :foreground "white"))))
 '(helm-swoop-target-line-block-face ((t (:background "SlateBlue3" :foreground "white")))))

;; customize
(custom-set-variables
 '(helm-gtags-path-style 'relative)
 '(helm-gtags-ignore-case t)
 '(helm-gtags-auto-update t))

;; カラー設定
(custom-set-faces
 '(helm-source-header
   ((t (:foreground "white" :background "SlateBlue" :weight bold :height 1.5 :family global-ascii-font))))
 '(helm-ff-file ((t (:foreground "gray75" :background nil))))
 '(helm-ff-symlink ((t (:foreground "orange" :background nil))))
 '(helm-buffer-file ((t (:foreground "OliveDrab2" :background nil))))
 '(helm-buffer-directory ((t (:foreground "CornflowerBlue" :background nil))))
 '(helm-ff-directory ((t (:foreground "CornflowerBlue" :background nil))))
 '(helm-candidate-number ((t (:foreground nil :background nil)))))

(set-face-foreground 'helm-match "white")
(set-face-background 'helm-match "SlateBlue3")

;;; 09-helm.el ends here
