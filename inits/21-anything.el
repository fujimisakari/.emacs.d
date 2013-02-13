;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                              anything設定                                  ;;
;;;--------------------------------------------------------------------------;;;

;; 基本設定
(require 'anything-config)
(when (require 'anything nil t)
  (setq
   ;; 候補を表示するまでの時間。デフォルトは0.5
   anything-idle-delay 0.3
   ;; タイプして再描写するまでの時間。デフォルトは0.1
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数。デフォルトは50
   anything-candidate-number-limit 50
   ;; 候補が多いときに体感速度を早くする
   anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    ;; root権限でアクションを実行するときのコマンド
    ;; デフォルトは"su"
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)
  (and (equal current-language-environment "Japanese")
       (executable-find "cmigemo")
       (require 'anything-migemo nil t))
  (when (require 'anything-complete nil t)
    ;; M-xによる補完をAnythingで行なう
    (anything-read-string-mode 1)
    ;; lispシンボルの補完候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnythingに置き換える
    (descbinds-anything-install)
    ;; 画面分割して表示します
    (setq descbinds-anything-window-style 'split-window))

  (require 'anything-grep nil t)
  )

;; カラー設定
(set-face-foreground 'anything-ff-file "gray75")
(set-face-foreground 'anything-ff-directory "dodgerblue")
(set-face-background 'anything-ff-directory nil)
(set-face-foreground 'anything-ff-symlink "cyan")
(set-face-foreground 'anything-candidate-number nil)
(set-face-background 'anything-candidate-number nil)

;; 個人設定
;; アルファベットで候補選択
(setq anything-enable-shortcuts 'alphabet)

;; manやinfoを調べるコマンドを作成してみる
;; anything-for-document 用のソースを定義
(setq anything-for-document-sources
      (list anything-c-source-man-pages
            anything-c-source-info-cl
            anything-c-source-info-pages
            anything-c-source-info-elisp
            anything-c-source-apropos-emacs-commands
            anything-c-source-apropos-emacs-functions
            anything-c-source-apropos-emacs-variables))
;; anything-for-document コマンドを作成
(defun anything-for-document ()
  "Preconfigured `anything' for anything-for-document."
  (interactive)
  (anything anything-for-document-sources (thing-at-point 'symbol) nil nil nil "*anything for document*"))
;; Command+d に anything-for-documentを割り当て
(global-set-key (kbd "H-d") 'anything-for-document)

;; anything-c-moccur: MoccurのAnythingインターフェイス
;;(install-elisp "http://svn.coderepos.org/share/lang/elisp/anything-c-moccur/trunk/anything-c-moccur.el")
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
(global-set-key (kbd "M-o") 'anything-c-moccur-occur-by-moccur)

(defun my-anything ()
  (interactive)
  (anything-other-buffer '(anything-c-source-buffers-list
                           anything-c-source-bookmarks
                           anything-c-source-recentf
                           anything-c-source-etags-select
                           anything-c-source-filelist)
                         "* my anything *"))

;; anything-project: プロジェクトからファイルを絞り込み
;; (install-elisp "http://github.com/imakado/anything-project/raw/master/anything-project.el")
;; (when (require 'anything-project nil t)
;;   (global-set-key (kbd "C-c C-f") 'anything-project)
;;   (setq ap:project-files-filters
;;         (list
;;          (lambda (files)
;;            (remove-if 'file-directory-p files)
;;            (remove-if '(lambda (file) (string-match-p "~$" file)) files)))))

;; session を利用するため anything-c-adaptive-save-history を作成しない
;; (remove-hook 'kill-emacs-hook 'anything-c-adaptive-save-history)
;; (ad-disable-advice 'anything-exit-minibuffer 'before 'anything-c-adaptive-exit-minibuffer)
;; (ad-disable-advice 'anything-select-action 'before 'anything-c-adaptive-select-action)
;; (setq anything-c-adaptive-history-length 0)

;; キーバインド設定
(global-set-key (kbd "C-;") 'my-anything)                                     ; anythingの起動
(global-set-key (kbd "C-M-p") 'anything-imenu)                                ; anything-imenuの起動
(define-key anything-map (kbd "M-k") 'anything-delete-minibuffer-contents)    ; カレントバッファ削除ができるようにする
(define-key anything-map (kbd "C-t") 'other-window-or-split)                  ; ウィンドウを切り替える
(define-key anything-c-moccur-anything-map (kbd "C-h") 'delete-backward-char) ; 削除
(anything-complete-shell-history-setup-key (kbd "C-o"))                       ; シェルコマンドの履歴から補完する
(global-set-key (kbd "M-y") 'anything-show-kill-ring)                         ; 過去のkill-ringの内容を取り出す

;; anythingを使ってzshの履歴検索をする
;; (save-window-excursion (shell-command (format "emacs -Q -L ~/emacs/lisp -l test-minimum -l %s %s &" buffer-file-name buffer-file-name)))
(require 'anything-complete)
(defun anything-zsh-history-from-zle ()
  (interactive)
  (azh/set-frame)
  (let ((anything-samewindow t)
        (anything-display-function 'anything-default-display-buffer))
    (azh/set-command
     (anything-other-buffer
      `(((name . "History")
         (action
          ("Paste" . identity)
          ("Edit" . azh/edit-command))
         ,@anything-c-source-complete-shell-history))
      "*anything zsh history*"))))

(defvar azh/tmp-file "/tmp/.azh-tmp-file")
(defvar azh/frame nil)

(defun azh/set-frame ()
  (unless (and azh/frame (frame-live-p azh/frame))
    (setq azh/frame (make-frame '((name . "zsh history")
                                  (title . "zsh history")))))
  (select-frame azh/frame)
  (sit-for 0))
;; (progn (azh/set-frame) (anything))
(defun azh/set-command (line)
  (write-region (or line "") nil azh/tmp-file)
  (azh/close-frame))

(defun azh/close-frame ()
  (ignore-errors (make-frame-invisible azh/frame))
  (when (fboundp 'do-applescript)
    (funcall 'do-applescript "tell application \"iTerm\"
                                activate
                             end")))

(defun azh/edit-command (line)
  (switch-to-buffer "*zsh command edit*")
  (erase-buffer)
  (setq buffer-undo-list nil)
  (azh/edit-mode)
  (insert line)
  (recursive-edit)
  (buffer-string))

(define-derived-mode azh/edit-mode fundamental-mode
  "Press C-c C-c to exit!"
  "Edit zsh command line"
  (define-key azh/edit-mode-map "\C-c\C-c" 'azh/edit-exit))

(defun azh/edit-exit ()
  (interactive)
  (exit-recursive-edit))

;; フォント一覧表示
(require 'cl)  ; loop, delete-duplicates

(defun anything-font-families ()
  "Preconfigured `anything' for font family."
  (interactive)
  (flet ((anything-mp-highlight-match () nil))
    (anything-other-buffer
     '(anything-c-source-font-families)
     "*anything font families*")))

(defun anything-font-families-create-buffer ()
  (with-current-buffer
      (get-buffer-create "*Fonts*")
    (loop for family in (sort (delete-duplicates (font-family-list)) 'string<)
          do (insert
              (propertize (concat family "\n")
                          'font-lock-face
                          (list :family family :height 2.0 :weight 'bold))))
    (font-lock-mode 1)))

(defvar anything-c-source-font-families
  '((name . "Fonts")
    (init lambda ()
          (unless (anything-candidate-buffer)
            (save-window-excursion
              (anything-font-families-create-buffer))
            (anything-candidate-buffer
             (get-buffer "*Fonts*"))))
    (candidates-in-buffer)
    (get-line . buffer-substring)
    (action
     ("Copy Name" lambda
      (candidate)
      (kill-new candidate))
     ("Insert Name" lambda
      (candidate)
      (with-current-buffer anything-current-buffer
        (insert candidate))))))
