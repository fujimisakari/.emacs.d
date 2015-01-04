;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                  helm設定                                  ;;
;;;--------------------------------------------------------------------------;;;

(require 'helm-config)
(require 'helm-ag)
(require 'helm-migemo)
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

;; customize
(custom-set-variables
 '(helm-gtags-path-style 'relative)
 '(helm-gtags-ignore-case t)
 '(helm-gtags-auto-update t))

;; ;; key bindings
;; (eval-after-load "helm-gtags"
;;   '(progn
;;      (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
;;      (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
;;      (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
;;      (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file)
;;      (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
;;      (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
;;      (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)))

;; (when (require 'helm-gtags nil t)
;;   (add-hook 'helm-gtags-mode-hook
;;             '(lambda ()
;;                (local-set-key (kbd "M-t") 'helm-gtags-find-tag)
;;                (local-set-key (kbd "M-r") 'helm-gtags-find-rtag)
;;                (local-set-key (kbd "M-s") 'helm-gtags-find-symbol)
;;                (local-set-key (kbd "C-t") 'helm-gtags-pop-stack))))

;; カラー設定
(custom-set-faces
 '(helm-source-header
   ((t (:foreground "white" :background "MediumPurple4" :weight bold :height 1.5 :family "Menlo"))))
 '(helm-ff-file ((t (:foreground "gray75" :background nil))))
 '(helm-ff-symlink ((t (:foreground "cyan" :background nil))))
 '(helm-buffer-directory ((t (:foreground "dodgerblue" :background nil))))
 '(helm-ff-directory ((t (:foreground "dodgerblue" :background nil))))
 '(helm-candidate-number ((t (:foreground nil :background nil)))))
