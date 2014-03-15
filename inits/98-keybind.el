;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                            キーバインド設定                                ;;
;;;--------------------------------------------------------------------------;;;

(global-set-key (kbd "C-h") 'delete-backward-char)   ; C-hをバックスペースに割り当てる（ヘルプは、<F1>にも割り当てられている）
(global-set-key (kbd "M-h") 'backward-kill-word)     ; 直前の単語を削除
(global-set-key (kbd "C-x C-c") 'server-edit)        ; emacsclientの終了をC-x C-cに割り当てる（好みに応じて）
(global-set-key (kbd "C-m") 'newline-and-indent)     ; "C-m" に newline-and-indent を割り当てる。初期値は newline
(global-set-key (kbd "M-k") 'kill-this-buffer)       ; カレントバッファを閉じる。初期値は kill-sentence
(global-set-key (kbd "C-M-;") 'delete-other-windows) ; 現在のウィンドウ以外を消す
(global-set-key (kbd "M-/") 'hippie-expand)          ; 略語展開・補完を行うコマンドをまとめる(M-x hippie-expand)
(global-set-key (kbd "M-g") 'goto-line)              ; M-g で指定行へジャンプ
(global-set-key (kbd "<C-tab>") 'tabify)             ; TAB生成
(global-set-key (kbd "<C-M-tab>") 'untabify)         ; TAB削除
(global-unset-key (kbd "C-x b"))                     ; switch bufferは使用してないので無効

;; C-lはprivate用prefixを追加
(winner-mode 1)
(global-set-key (kbd "C-l C-u") 'winner-undo)
(global-set-key (kbd "C-l C-l") 'recenter-top-bottom)
(global-set-key (kbd "C-l r") 'query-replace-regexp)
(global-set-key (kbd "C-l R") 'replace-regexp)
(global-set-key (kbd "C-l w") 'whitespace-cleanup)
(global-set-key (kbd "C-l k") 'keitai-hankaku-katakana-region)
(global-set-key (kbd "C-l C-j") 'delete-horizontal-space)
(global-set-key (kbd "C-l j") 'just-one-space)
(global-set-key (kbd "C-l C-'") 'flyspell-region)
(global-set-key (kbd "C-l C-M-'") 'ispell-word)
(global-set-key (kbd "C-l l") 'ace-jump-line-mode)
(global-set-key (kbd "C-l '") 'ace-jump-mode)
(global-set-key (kbd "C-l b") 'browse-url-at-point)
(global-set-key (kbd "C-l f") 'moccur-grep-find)
;; anzu
(global-set-key (kbd "C-l r") 'anzu-query-replace-regexp)
(global-set-key (kbd "C-l R") 'anzu-query-replace)
;; *scratch* バッファに移動できるようにした
(defun my-switch-to-scratch/current-buffer ()
  (interactive)
  (if (string-equal (buffer-name) "*scratch*")
      (switch-to-buffer (cadr (buffer-list)))
    (switch-to-buffer (get-buffer "*scratch*"))))
(global-set-key (kbd "C-l s") 'my-switch-to-scratch/current-buffer)

;; 選択拡張
(require 'expand-region)
(global-set-key (kbd "C-,") 'er/expand-region)
(global-set-key (kbd "C-M-,") 'er/contract-region)

;; カーソル拡張
;; (require 'multiple-cursors)
;; (global-unset-key (kbd "C-q"))
;; (smartrep-define-key global-map "C-q"
;;   '(("n"        . 'mc/mark-next-like-this)
;;     ("p"        . 'mc/mark-previous-like-this)
;;     ("m"        . 'mc/mark-more-like-this-extended)
;;     ("u"        . 'mc/unmark-next-like-this)
;;     ("U"        . 'mc/unmark-previous-like-this)
;;     ("s"        . 'mc/skip-to-next-like-this)
;;     ("S"        . 'mc/skip-to-previous-like-this)
;;     ("*"        . 'mc/mark-all-like-this)
;;     ("SPC"      . 'mc/mark-all-in-region)
;;     ("C-SPC"    . 'mc/edit-lines)
;;     ("i"        . 'mc/insert-numbers)))

;; キーボードの同時押しでコマンドを実行する
;; (install-elisp-from-emacswiki key-chord.el)
(require 'key-chord)
(setq key-chord-two-keys-delay 0.06)     ; 許容誤差は0.06秒
(key-chord-mode 1)
(key-chord-define-global "qp" 'describe-bindings)
(key-chord-define-global "ui" 'skk-mode)
(key-chord-define-global "kl" 'view-mode)

;; 行全体を削除
(defun kill-all-line (&optional numlines)
  (interactive)
  (setq pos(current-column))
  (beginning-of-line)
  (kill-line numlines)
  (move-to-column pos))
(global-set-key (kbd "C-c C-k") 'kill-all-line)

;; カーソル位置より前(右)を削除
(global-set-key (kbd "C-k") 'kill-line)

;; カーソル位置より前(左)を削除
(global-set-key (kbd "C-M-k")
                '(lambda ()
                   (interactive)(kill-line 0)))

;; 別窓(フレーム)でバッファを開く
;; (key-chord-define-global "ru" 'find-file-other-frame)
;;; git statusを表示
(global-set-key (kbd "<f4>") 'magit-status)

;; 行番号表示
(global-set-key (kbd "<f1>") 'linum-mode)

;; emacs-lisp-modeでC-c C-dを押すと注釈される
;; (require 'lispxmp)
;; (define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)

;; ウィンドウを切り替える。
;; ウィンドウを分割していないときは、左右分割して新しいウィンドウを作る
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p) (split-window-horizontally))
  (other-window 1))
(global-set-key (kbd "C-t") 'other-window-or-split)
