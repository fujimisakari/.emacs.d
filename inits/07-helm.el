;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                  helm関連                                  ;;
;;;--------------------------------------------------------------------------;;;

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
(setq helm-split-window-default-side 'rigth) ; 左右分割
;; ディレクトリの自動補完を切る
(setq helm-ff-auto-update-initial-value nil)
;; スマート補完
(setq helm-ff-smart-completion t)

;; (when (require 'helm-gtags nil t)
;;   (add-hook 'helm-gtags-mode-hook
;;             '(lambda ()
;;                (local-set-key (kbd "M-t") 'helm-gtags-find-tag)
;;                (local-set-key (kbd "M-r") 'helm-gtags-find-rtag)
;;                (local-set-key (kbd "M-s") 'helm-gtags-find-symbol)
;;                (local-set-key (kbd "C-t") 'helm-gtags-pop-stack))))

;; キーバインド設定
(global-set-key (kbd "C-;") 'helm-mini)                   ; helmの起動
(global-set-key (kbd "C-M-i") 'helm-imenu)                ; helm-imenuの起動
(global-set-key (kbd "C-x C-f") 'helm-find-files)         ; ファイルリスト検索
;; (global-set-key (kbd "M-o") 'helm-occur)
(global-set-key (kbd "C-M-.") 'helm-resume)
(define-key global-map (kbd "M-y") 'helm-show-kill-ring)  ; 過去のkill-ringの内容を取り出す
(define-key global-map (kbd "M-x") 'helm-M-x)             ; helmでM-x

;; カラー設定
(custom-set-faces
 '(helm-source-header
   ((t (:foreground "white" :background "MediumPurple4" :weight bold :height 1.5 :family "Menlo"))))
 '(helm-ff-file ((t (:foreground "gray75" :background nil))))
 '(helm-ff-symlink ((t (:foreground "cyan" :background nil))))
 '(helm-ff-directory ((t (:foreground "dodgerblue" :background nil))))
 '(helm-candidate-number ((t (:foreground nil :background nil)))))
