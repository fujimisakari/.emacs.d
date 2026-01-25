;;; 10-buffer.el --- Buffer設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; *Completions*バッファを，使用後に消す
(require 'lcomp)
(lcomp-install)

;; 最近閉じたバッファを復元
;; http://d.hatena.ne.jp/kitokitoki/20100608/p2
(require 'cl)
(defvar my-killed-file-name-list nil)
(defun my-push-killed-file-name-list ()
  (when (buffer-file-name)
    (push (expand-file-name (buffer-file-name)) my-killed-file-name-list)))

(defun my-pop-killed-file-name-list ()
  (interactive)
  (unless (null my-killed-file-name-list)
    (find-file (pop my-killed-file-name-list))))
(add-hook 'kill-buffer-hook 'my-push-killed-file-name-list)

;; *scratch* バッファに移動できるようにした
(defun my-switch-to-scratch/current-buffer ()
  (interactive)
  (if (string-equal (buffer-name) "*scratch*")
      (switch-to-buffer (cadr (buffer-list)))
    (switch-to-buffer (get-buffer "*scratch*"))))

;; *scratch*バッファを消さない
(defun my-make-scratch (&optional arg)
  (interactive)
  (progn
    ;; "*scratch*" を作成して buffer-list に放り込む
    (set-buffer (get-buffer-create "*scratch*"))
    (funcall initial-major-mode)
    (erase-buffer)
    (when (and initial-scratch-message (not inhibit-startup-message))
      (insert initial-scratch-message))
    (or arg (progn (setq arg 0)
                   (switch-to-buffer "*scratch*")))
    (cond ((= arg 0) (message "*scratch* is cleared up."))
          ((= arg 1) (message "another *scratch* is created")))))

(defun my/scratch-kill-buffer-query ()
  "*scratch* バッファで kill-buffer したら内容を消去するだけにする."
  (if (string= "*scratch*" (buffer-name))
      (progn (my-make-scratch 0) nil)
    t))
(add-hook 'kill-buffer-query-functions #'my/scratch-kill-buffer-query)

;;; 10-buffer.el ends here
