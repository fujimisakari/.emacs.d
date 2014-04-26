;;; -*- coding: utf-8 -*-
;;; original http://www.bookshelf.jp/elc/dired-master.el
;;; Time-stamp: <2014-04-21 08:57:58 rubikitch>
;;; Modified by rubikitch
;;;  - cl-libを使ってリファクタリング
;;;  - 不要なadviceを除去
;;;  - diredを左端のdedicated-windowに表示するようにした
;;;    →diredの隣以外すべてdedicated-windowにした
;;;  - split-root.elがあれば使うようにした
;;;    (install-elisp "http://nschum.de/src/emacs/split-root/split-root.el")
;;; Config:
;;;   (require 'dired-details)
;;;   (dired-details-install)
;;;   (setq dired-details-hidden-string " ")
;;;   (setq dired-details-hide-link-targets nil)
;;;   (require 'dired-master)
;;;   (global-set-key (kbd "C-x C-d") 'dired-at-left)
;;;   (dired-dedicated-install)
;;;
(require 'dired)
(require 'master)
(require 'cl-lib)
(require 'split-root nil t)


;;; [2014-02-06 Thu]
(defvar dired-at-left-width 30
  "diredウィンドウの幅")

(defun dired-master-window ()
  (window-left-child (frame-root-window)))
(defun dired-master-running-p ()
  (and (eq t (window-dedicated-p (dired-master-window)))
       (with-current-buffer (window-buffer (dired-master-window))
         (eq major-mode 'dired-mode))))
;; (dired-master-running-p)

(defun dired-at-left (&rest args)
  "dired-masterで使いやすいようにするために左側にdiredを開く"
  (interactive (dired-read-dir-and-switches ""))
  (cond ((eq 'dired-mode
             (buffer-local-value 'major-mode
              (window-buffer (window-left-child (frame-root-window)))))
         (shrink-window (- (window-width) dired-at-left-width) t))
        ((fboundp 'split-root-window)
         (split-root-window dired-at-left-width t t)
         (other-window -1))
        (t
         (delete-other-windows)
         (split-window-horizontally dired-at-left-width)))
  (let ((bfn buffer-file-name))
    (apply 'dired args)
    (and bfn (dired-goto-file bfn))))

;;; [2014-02-13 Thu]
(defun dired-master-test-dedicated-flags ()
  (interactive)
  (message
   "%S"
   (loop for w in (window-list)
         collect (list w (window-dedicated-p w)))))
;; (global-set-key (kbd "C-x C-z") 'dired-master-test-dedicated-flags)

(defun dired-dedicated-install ()
  (defadvice dired-at-left (after dedicated activate)
    "C-x C-d経由のdiredはdedicatedに"
    (dired-master-dedicate-windows))
  ;; (progn (ad-disable-advice 'dired-at-left 'after 'dedicated) (ad-update 'dired-at-left))
  (defadvice switch-to-buffer (around dedicated activate)
    "dedicated dired bufferに別なdired bufferをswitchさせるためのアドバイス"
    (if (not (and (window-dedicated-p)
                  (eq 'dired-mode major-mode)
                  (with-current-buffer (ad-get-arg 0)
                    (eq 'dired-mode major-mode))))
        ad-do-it
      (set-window-dedicated-p (selected-window) nil)
      ad-do-it
      (set-window-dedicated-p (selected-window) t)))
  ;; (progn (ad-disable-advice 'switch-to-buffer 'around 'dedicated) (ad-update 'switch-to-buffer))
  (defadvice other-window (after dedicated activate)
    "dired-masterが有効になってるときにdedicated flagをセットする"
    (when (dired-master-running-p)
      (if (eq (selected-window) (dired-master-window))
          (dired-master-dedicate-windows)
        (dired-master-undedicate-windows))))
  ;; (progn (ad-disable-advice 'other-window 'after 'ad-return-value-test) (ad-update 'other-window))
  )

(defun dired-master-dedicate-windows ()
  (when (dired-master-running-p)
    (with-selected-window (dired-master-window)
      (cl-loop for w in (window-list)
               unless (eq w (next-window))
               do (set-window-dedicated-p w t)))))
(defun dired-master-undedicate-windows ()
  (when (dired-master-running-p)
    (with-selected-window (dired-master-window)
      (cl-loop for w in (window-list)
               unless (eq w (selected-window))
               do (set-window-dedicated-p w nil)))))

(defadvice dired-display-file (after master-mode activate)
  ;; (master-mode 1)
  (master-set-slave (find-file-noselect (dired-get-file-for-visit))))

(defun dired-get-file-or-dired-buffer (&optional file)
  "`get-file-buffer' extension for dired."
  (setq file (or file (dired-get-file-for-visit)))
  (or (get-file-buffer file)
      (get-file-buffer (file-truename file))
      ;; . と .. 対策で `expand-file-name'
      (assoc-default (concat (file-truename (expand-file-name file)) "/") dired-buffers)))
(defvar dired-view-buffer-list nil)
(defun dired-view-file-scroll (&optional back)
  (interactive)
  (dired-view-file-prepare)
  (cond
   ;; エラー(ファイルの行ではない or 存在しないsymlink)
   ;; または表示されたファイルが最下行のときは
   ;; 次のファイルを開く
   ((or (null (ignore-errors (dired-get-file-for-visit)))
        (with-selected-window (next-window)
          (and (not back)
               (= (point-max) (window-end))
               (eq last-command 'dired-view-file-scroll))))
    (dired-next-line 1)
    (push (window-buffer (dired-display-file)) dired-view-buffer-list))
   (t
    ;; ファイルが開かれてなかったら裏で開く
    (unless (dired-get-file-or-dired-buffer)
      (push (find-file-noselect (dired-get-file-for-visit)) dired-view-buffer-list))
    (master-set-slave (dired-get-file-or-dired-buffer))
    ;; ファイルを表示中ならばスクロール。さもなければ表示。
    (if (get-buffer-window (dired-get-file-or-dired-buffer))
        (if back (master-says-scroll-down) (master-says-scroll-up))
      (dired-display-file)))))
(defun dired-view-file-prepare ()
  "diredは左側に表示させる"
  (when (and (not (eq (selected-window) (frame-first-window)))
             (not (eq 'dired-mode (buffer-local-value 'major-mode (window-buffer (frame-first-window))))))
     (set-window-buffer (frame-first-window) (current-buffer))))

(defun dired-view-file-scroll-down ()
  (interactive)
  (dired-view-file-scroll t))

(defun dired-view-file-kill-buffer ()
  "diredから開かれたバッファで未セーブのものを残して削除。"
  (interactive)
  (cl-loop for buf in dired-view-buffer-list
           if (and (buffer-name buf) (not (buffer-modified-p buf)))
           do (kill-buffer buf)
           else if (buffer-live-p buf) collect buf into buf2
           finally do (setq dired-view-buffer-list buf2)))

(defadvice dired-advertised-find-file
  (after kill-buffers activate)
  (if (eq major-mode 'dired-mode)
      (dired-view-file-kill-buffer)))


(defun dired-master-kill-buffer ()
  (interactive)
  (dired-master-undedicate-windows)
  (dired-view-file-kill-buffer)
  (kill-this-buffer)
  (balance-windows))
(defun dired-master-quit-window ()
  (interactive)
  (dired-master-undedicate-windows)
  (dired-view-file-kill-buffer)
  (quit-window))
(defun dired-master-delete-window ()
  (interactive)
  (dired-master-undedicate-windows)
  (dired-view-file-kill-buffer)
  (delete-window)
  (balance-windows))

(define-key dired-mode-map " " 'dired-view-file-scroll)
(define-key dired-mode-map "b" 'dired-view-file-scroll-down)
(define-key dired-mode-map "q" 'dired-master-delete-window)
(define-key dired-mode-map (kbd "C-x k") 'dired-master-kill-buffer)

(provide 'dired-master)
