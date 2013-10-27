;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                  helm関連                                  ;;
;;;--------------------------------------------------------------------------;;;

(require 'helm-config)
(require 'helm-ag)

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

(setq helm-split-window-default-side 'rigth) ; 左右分割
;; ディレクトリの自動補完を切る
(setq helm-ff-auto-update-initial-value nil)
;; スマート補完
(setq helm-ff-smart-completion t)

;; キーバインド設定
;; (anything-complete-shell-history-setup-key (kbd "C-o"))                       ; シェルコマンドの履歴から補完する
;; (global-set-key (kbd "M-o") 'anything-c-moccur-occur-by-moccur)
(global-set-key (kbd "C-;") 'helm-mini)                   ; helmの起動
(global-set-key (kbd "C-M-i") 'helm-imenu)                ; helm-imenuの起動
(global-set-key (kbd "C-x C-f") 'helm-find-files)         ; ファイルリスト検索

(define-key global-map (kbd "M-y") 'helm-show-kill-ring)  ; 過去のkill-ringの内容を取り出す
(define-key global-map (kbd "M-x") 'helm-M-x)             ; helmでM-x

;; カラー設定
;; (set-face-foreground 'helm-ff-file "gray75")
(set-face-foreground 'helm-ff-directory "dodgerblue")
(set-face-background 'helm-ff-directory nil)
(set-face-foreground 'helm-ff-symlink "cyan")
(set-face-foreground 'helm-candidate-number nil)
(set-face-background 'helm-candidate-number nil)
