;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                 Buffer設定                                 ;;
;;;--------------------------------------------------------------------------;;;

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
(global-set-key (kbd "C-x /") 'my-pop-killed-file-name-list)

;; バッファの画面サイズの変更
(defun my-window-resizer ()
  "Control window size and position."
  (interactive)
  (let ((window-obj (selected-window))
        (current-width (window-width))
        (current-height (window-height))
        (dx (if (= (nth 0 (window-edges)) 0) 1
              -1))
        (dy (if (= (nth 1 (window-edges)) 0) 1
              -1))
        c)
    (catch 'end-flag
      (while t
        (message "size[%dx%d]"
                 (window-width) (window-height))
        (setq c (read-char))
        (cond ((= c ?l)
               (enlarge-window-horizontally dx))
              ((= c ?h)
               (shrink-window-horizontally dx))
              ((= c ?j)
               (enlarge-window dy))
              ((= c ?k)
               (shrink-window dy))
              ;; otherwise
              (t
               (message "Quit")
               (throw 'end-flag t)))))))
(global-set-key (kbd "C-c r") 'my-window-resizer)

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

(add-hook 'kill-buffer-query-functions
          ;; *scratch* バッファで kill-buffer したら内容を消去するだけにする
          (lambda ()
            (if (string= "*scratch*" (buffer-name))
                (progn (my-make-scratch 0) nil)
              t)))

;; scratch バッファを次回起動時に復元。ログも記録する。
;; (install-elisp "http://github.com/kitokitoki/scratch-log/raw/master/scratch-log.el")
;; (when (require 'scratch-log.el nil t)
;;   (setq sl-scratch-log-file "~/.emacs.d/var/scratch/.scratch-log")
;;   (setq sl-prev-scratch-string-file "~/.emacs.d/var/scratch/.scratch")
;;   ;; nil なら emacs 起動時に，最後に終了したときの スクラッチバッファの内容を復元しない。初期値は t です。
;;   (setq sl-restore-scratch-p t)
;;   ;; nil なら スクラッチバッファを削除できるままにする。初期値は t です。
;;   (setq sl-prohibit-kill-scratch-buffer-p t))

;; ミニバッファの履歴を消す
(define-key minibuffer-local-map (kbd "S-<delete>")
  '(lambda ()
      (interactive)
      (set minibuffer-history-variable (delete (buffer-substring-no-properties (minibuffer-prompt-end) (point-max)) (symbol-value minibuffer-history-variable)))
      (goto-history-element minibuffer-history-position)
))
