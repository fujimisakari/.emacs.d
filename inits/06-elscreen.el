;;; 06-elscree.el --- ElScreen設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; ELScreen関連PKG
(require 'elscreen)
(elscreen-start)

;; EmacsでGNU screen風のインターフェイスを使う
(setq elscreen-prefix-key (kbd "C-z"))
(if window-system
    (define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
  (define-key elscreen-map (kbd "C-z") 'suspend-emacs))
(setq elscreen-display-tab 12)              ; tabの幅(6以上でないとダメ)
(setq elscreen-tab-display-kill-screen nil) ; タブの左端の×を非表示

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

;; 起動時に自動で10個スクリーンを立ち上げる
(defun elscreen-create-default-screen ()
  "create default-screen"
  (let ((counter 0))
    (while (< counter 9)
      (elscreen-create)
      (setq counter(1+ counter))))
  (elscreen-next))
(elscreen-create-default-screen)

;; elscreen用バッファ削除
(defvar elscreen-ignore-buffer-list
 '("*Backtrace*" "*Colors*" "*Faces*" "*Compile-Log*" "*Packages*" "*Echo" "*vc-" "*Minibuf-"
   "*Messages" "*WL:Message" "Folder" "*Org Agenda*" "inbox.org" "daily-projects.org"))

(defun kill-buffer-for-elscreen ()
  "バッファを削除時の次のバッファは直近で開いてたバッファを選択するようにする"
  (interactive)
  (kill-buffer)
  (let* ((next-buffer nil)
         (re (regexp-opt elscreen-ignore-buffer-list))
         (next-buffer-list (mapcar (lambda (buf)
                                     (let ((name (buffer-name buf)))
                                       (when (not (string-match re name))
                                         name)))
                                   (buffer-list))))
    (dolist (buf next-buffer-list)
      (if (equal next-buffer nil)
          (setq next-buffer buf)))
    (switch-to-buffer next-buffer)))

(defun elscreen-swap-previous()
  "Interchange screens selected currently and previous."
  (interactive)
  (cond
   ((elscreen-one-screen-p)
    (elscreen-message "There is only one screen, cannot swap"))
   (t
    (let* ((screen-list (sort (elscreen-get-screen-list) '>))
           (previous-screen
            (or (nth 1 (memq (elscreen-get-current-screen) screen-list))
               (car screen-list)))
           (current-screen (elscreen-get-current-screen))
           (current-screen-property
            (elscreen-get-screen-property current-screen))
           (previous-screen-property
            (elscreen-get-screen-property previous-screen)))
      (elscreen-set-screen-property current-screen previous-screen-property)
      (elscreen-set-screen-property previous-screen current-screen-property)
      (elscreen-goto-internal (elscreen-get-current-screen)))))
  (elscreen-previous))

(defun elscreen-swap-next()
  "Interchange screens selected currently and next."
  (interactive)
  (cond
   ((elscreen-one-screen-p)
    (elscreen-message "There is only one screen, cannot swap"))
   (t
    (let* ((screen-list (sort (elscreen-get-screen-list) '<))
           (next-screen
            (or (nth 1 (memq (elscreen-get-current-screen) screen-list))
               (car screen-list)))
           (current-screen (elscreen-get-current-screen))
           (current-screen-property
            (elscreen-get-screen-property current-screen))
           (next-screen-property
            (elscreen-get-screen-property next-screen)))
      (elscreen-set-screen-property current-screen next-screen-property)
      (elscreen-set-screen-property next-screen current-screen-property)
      (elscreen-goto-internal (elscreen-get-current-screen)))))
     (elscreen-next))

;; diredとターミナルを連動させる
(defun buffer-directory-safe (&optional buffer)
  "Return directory for BUFFER (or current buffer). Always returns a string."
  (with-current-buffer (or buffer (current-buffer))
    ;; buffer-file-name があればそのディレクトリ、無ければ default-directory
    (let ((dir (or (and (buffer-file-name)
                        (file-name-directory (buffer-file-name)))
                   default-directory)))
      ;; 念のため nil を避ける
      (file-name-as-directory (expand-file-name (or dir "~"))))))

(defun elscreen-current-directory ()
  (buffer-directory-safe
   (let* ((current-screen (car (elscreen-get-conf-list 'screen-history)))
          (property (cadr (assoc current-screen
                                 (elscreen-get-conf-list 'screen-property))))
          (marker (nth 2 property)))
     (and marker (marker-buffer marker)))))

(defun non-elscreen-current-directory ()
  (buffer-directory-safe
   (let* ((conf (current-frame-configuration))
          (params (nth 1 (nth 1 conf)))
          (buf-list (cdr (assoc 'buffer-list params))))
     (nth 0 buf-list))))

;; screenを定位置に設定する
(setq elscreen-custom-screen-alist
      '((0 . ":home")
        (1 . "inbox.org")
        (2 . "*scratch*")
        (3 . "*scratch*")
        (4 . "*scratch*")
        (5 . "*scratch*")
        (6 . "*scratch*")
        (7 . "*scratch*")
        (8 . "*scratch*")))

(setq elscreen-default-screen-alist
      '((0 . "*scratch*")
        (1 . "*scratch*")
        (2 . "*scratch*")
        (3 . "*scratch*")
        (4 . "*scratch*")
        (5 . "*scratch*")
        (6 . "*scratch*")
        (7 . "*scratch*")
        (8 . "*scratch*")))

(defun elscreen-set-custom-screen ()
  (interactive)
  (elscreen-set-screen elscreen-custom-screen-alist))

(defun elscreen-set-default-screen ()
  (interactive)
  (elscreen-set-screen elscreen-default-screen-alist))

(defun elscreen-set-screen (set-screen-alist)
  (let ((screen-list (sort (elscreen-get-screen-list) '<))
        (current-screen (elscreen-get-current-screen)))
    (mapc (lambda (alist)
            (let ((screen-num (car alist))
                  (buffer-name (cdr alist)))
              (elscreen-goto (nth screen-num screen-list))
              (switch-to-buffer buffer-name))) set-screen-alist)
    (elscreen-goto current-screen))
  (message "set coustom screen done."))

;;; 06-elscreen.el ends here
