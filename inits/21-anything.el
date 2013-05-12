;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                              anything設定                                  ;;
;;;--------------------------------------------------------------------------;;;

;; 基本設定
(require 'anything-startup)

(defun my-anything ()
  (interactive)
  (anything-other-buffer '(anything-c-source-buffers-list
                           anything-c-source-bookmarks
                           anything-c-source-recentf
                           anything-c-source-filelist)
                         "* my anything *"))

;; imenu, gtagsのgtagsから読み込み
(require 'anything-gtags)
(defun anything-gtags-select-all ()
  (interactive)
  (anything-other-buffer
   '(anything-c-source-imenu
     anything-c-source-gtags-select)
   "*anything gtags*"))

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

;; アルファベットで候補選択
(setq anything-enable-digit-shortcuts nil)

;; キーバインド設定
(global-set-key (kbd "C-;") 'my-anything)                                     ; anythingの起動
(global-set-key (kbd "C-M-i") 'anything-imenu)                                ; anything-imenuの起動
(define-key anything-map (kbd "M-k") 'anything-delete-minibuffer-contents)    ; カレントバッファ削除ができるようにする
(define-key anything-map (kbd "C-t") 'other-window-or-split)                  ; ウィンドウを切り替える
(define-key anything-c-moccur-anything-map (kbd "C-h") 'delete-backward-char) ; 削除
(anything-complete-shell-history-setup-key (kbd "C-o"))                       ; シェルコマンドの履歴から補完する
(global-set-key (kbd "M-y") 'anything-show-kill-ring)                         ; 過去のkill-ringの内容を取り出す
(global-set-key (kbd "M-o") 'anything-c-moccur-occur-by-moccur)

;; カラー設定
(set-face-foreground 'anything-ff-file "gray75")
(set-face-foreground 'anything-ff-directory "dodgerblue")
(set-face-background 'anything-ff-directory nil)
(set-face-foreground 'anything-ff-symlink "cyan")
(set-face-foreground 'anything-candidate-number nil)
(set-face-background 'anything-candidate-number nil)
