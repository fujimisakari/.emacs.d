;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                              ElScreen設定                                  ;;
;;;--------------------------------------------------------------------------;;;

;; ELScreen関連PKG
(require 'elscreen)
(require 'elscreen-color-theme)
(require 'elscreen-wl)
(require 'elscreen-dired)
(require 'elscreen-dnd)
(require 'elscreen-gf)
(require 'elscreen-server)
(require 'elscreen-speedbar)
(require 'elscreen-w3m)
(require 'elscreen-howm)
(require 'elscreen-goby)

;; EmacsでGNU screen風のインターフェイスを使う
(setq elscreen-prefix-key (kbd "C-z"))
(if window-system
    (define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
  (define-key elscreen-map (kbd "C-z") 'suspend-emacs))
(setq elscreen-display-tab 15)                ; tabの幅(6以上でないとダメ)
(setq elscreen-tab-display-kill-screen nil)   ; タブの左端の×を非表示

;; 起動時に自動でスクリーンを生成する
(defmacro elscreen-create-automatically (ad-do-it)
  `(if (not (elscreen-one-screen-p))
       ,ad-do-it
     (elscreen-create)
     (elscreen-notify-screen-modification 'force-immediately)
     (elscreen-message "New screen is automatically created")))
(defadvice elscreen-next (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))
(defadvice elscreen-previous (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))
(defadvice elscreen-toggle (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

;; ELSscreen固有のキーバインド
(global-set-key (kbd "C-M-l") 'elscreen-next)
(global-set-key (kbd "C-M-h") 'elscreen-previous)
(define-key elscreen-map (kbd "c") 'create-newscreen)
(define-key elscreen-map (kbd "C-a") 'create-maxscreen)
(define-key elscreen-map (kbd "C-k") 'elscreen-kill-screen-and-buffers)
(define-key elscreen-map (kbd "k") 'elscreen-kill-screen-and-buffers)

;; スクリーン追加時はanything画面を開く
(defun create-newscreen ()
  "`elscreen-create' and `anything-for-files'"
  (interactive)
  (elscreen-create)
  (my-anything))

;; 起動時に自動で10個スクリーンを立ち上げる
(defun create-maxscreen ()
  "`8-elscreen-create'"
  (let (( counter 0))
    (while (< counter 8)
      (elscreen-create)(setq counter(1+ counter)))))
(create-maxscreen)
(elscreen-next)

;; カラー設定
(set-face-foreground 'elscreen-tab-current-screen-face "MediumPurple1")
(set-face-background 'elscreen-tab-current-screen-face "gray25")
(set-face-bold-p 'elscreen-tab-current-screen-face t)

(set-face-foreground 'elscreen-tab-control-face "red")
(set-face-background 'elscreen-tab-control-face "gray25")
(set-face-bold-p 'elscreen-tab-control-face t)

(set-face-background 'elscreen-tab-background-face "gray25")
(set-face-background 'elscreen-tab-other-screen-face "gray25")

;; diredとターミナルを連動させる
(defun elscreen-current-directory ()
  (let* (current-dir
         (active-file-name
          (with-current-buffer
              (let* ((current-screen (car (elscreen-get-conf-list 'screen-history)))
                     (property (cadr (assoc current-screen
                                            (elscreen-get-conf-list 'screen-property)))))
                (marker-buffer (nth 2 property)))
            (progn
              (setq current-dir (expand-file-name (cadr (split-string (pwd)))))
              (buffer-file-name)))))
    (if active-file-name
        (file-name-directory active-file-name)
      current-dir)))

(defun non-elscreen-current-directory ()
  (let* (current-dir
         (current-buffer
          (nth 1 (assoc 'buffer-list
                        (nth 1 (nth 1 (current-frame-configuration))))))
         (active-file-name
          (with-current-buffer current-buffer
            (progn
              (setq current-dir (expand-file-name (cadr (split-string (pwd)))))
              (buffer-file-name)))))
    (if active-file-name
        (file-name-directory active-file-name)
      current-dir)))
