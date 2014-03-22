;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                              anything設定                                  ;;
;;;--------------------------------------------------------------------------;;;

;; 基本設定
(require 'anything-startup)

(setq
  ;; 候補を表示するばでの時間 デフォルトは0.5
  anything-idle-delay 0.1
  ;; タイプして再描画するまでの時間。デフォルトは0.1
  anything-input-idle-delay 0.2
  ;; 候補の最大表示数。デフォルトは50
  anything-candidate-number-limit 30
  ;; 候補が多いときに体感速度を早くする
  anything-quick-update t
  ;; アルファベットで候補選択
  anything-enable-digit-shortcuts nil
  ;; カスタムファイルリスト検索
  anything-c-filelist-file-name "/tmp/all_filelist"
  anything-grep-candidates-fast-directory-regexp "^/tmp")

(defun my-anything ()
  (interactive)
  (anything-other-buffer '(anything-c-source-buffers-list
                           anything-c-source-bookmarks
                           anything-c-source-recentf)
                           ;; anything-c-source-filelist)
                         "*my anything*"))

;; imenu, gtagsのgtagsから読み込み
(require 'anything-gtags)
(defun anything-gtags-select-all ()
  (interactive)
  (anything-other-buffer
   '(anything-c-source-imenu
     anything-c-source-gtags-select)
   "*anything gtags*"))

;; anytingバッファは左右分割にする
;; (defadvice anything-default-display-buffer (around my-anything-default-display-buffer activate)
;;   (delete-other-windows)
;;   (split-window (selected-window) nil t)
;;   (pop-to-buffer buf))

;; anything-c-moccur: MoccurのAnythingインターフェイス
(require 'anything-c-moccur nil t)
(setq
 ;; anything-c-moccur用 `anything-idle-delay'
 anything-c-moccur-anything-idle-delay 0.1
 ;; バッファの情報をハイライトする
 anything-c-moccur-higligt-info-line-flag t
 ;; 現在選択中の候補の位置を他のwindowに表示する
 anything-c-moccur-enable-auto-look-flag t
 ;; 起動時にポイントの位置の単語を初期パターンにする
 anything-c-moccur-enable-initial-pattern t)

;; キーバインド設定
;; (global-set-key (kbd "C-;") 'my-anything)                                     ; anythingの起動
;; (global-set-key (kbd "C-M-i") 'anything-imenu)                                ; anything-imenuの起動
;; (global-set-key (kbd "M-y") 'anything-show-kill-ring)                         ; 過去のkill-ringの内容を取り出す
;; (define-key anything-map (kbd "M-k") 'anything-delete-minibuffer-contents)    ; カレントバッファ削除ができるようにする
;; (define-key anything-map (kbd "C-t") 'other-window-or-split)                  ; ウィンドウを切り替える
;; (anything-complete-shell-history-setup-key (kbd "C-o"))                       ; シェルコマンドの履歴から補完する

;; カラー設定
(set-face-foreground 'anything-ff-file "gray75")
(set-face-foreground 'anything-ff-directory "dodgerblue")
(set-face-background 'anything-ff-directory nil)
(set-face-foreground 'anything-ff-symlink "cyan")
(set-face-foreground 'anything-candidate-number nil)
(set-face-background 'anything-candidate-number nil)

(custom-set-faces
 '(anything-header
   ((t (:foreground "white" :background "MediumPurple4" :weight bold :height 1.5 :family "Menlo")))))
