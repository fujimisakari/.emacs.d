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
(defalias 'yes-or-no-p 'y-or-n-p)                    ; "yes or no" の表示を "y or n"に変える
(defalias 'exit 'save-buffers-kill-emacs)            ; M-x exit で Emacsが終了できるようにする
(defalias 'qr 'replace-regexp)                       ; 一括置換(正規表現置換)
(defalias 'qrr 'query-replace-regexp)                ; 対話型置換(正規表現置換)

;; private用prefixを追加
(global-unset-key (kbd "C-l"))
(winner-mode 1)
(global-set-key (kbd "C-l C-u") 'winner-undo)
(global-set-key (kbd "C-l C-l") 'recenter-top-bottom)
(global-set-key (kbd "C-l r") 'query-replace-regexp)
(global-set-key (kbd "C-l R") 'replace-regexp)
(global-set-key (kbd "C-l w") 'whitespace-cleanup)
(global-set-key (kbd "C-l k") 'keitai-hankaku-katakana-region)
(global-set-key (kbd "C-l C-j") 'delete-horizontal-space)
(global-set-key (kbd "C-l j") 'just-one-space)
(global-set-key (kbd "C-l C-;") 'flyspell-region)

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

;; キーボードの同時押しでコマンドを実行する
;; (install-elisp-from-emacswiki key-chord.el)
(require 'key-chord)
(setq key-chord-two-keys-delay 0.04)     ; 許容誤差は0.04秒
(key-chord-mode 1)
;; メジャーモードへの設定：emacs-lisp-mode で df を押すと describe-bindings を実行
(key-chord-define-global "qp" 'describe-bindings)
;; 別窓(フレーム)でバッファを開く
(key-chord-define-global "ru" 'find-file-other-frame)
;;; git statusを表示
(key-chord-define-global "ei" 'magit-status)

;; 行番号表示
(global-set-key (kbd "<S-f5>") 'linum-mode)

;; emacs-lisp-modeでC-cC-dを押すと注釈される
;; (require 'lispxmp)
;; (define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)

;; ウィンドウを切り替える。
;; ウィンドウを分割していないときは、左右分割して新しいウィンドウを作る
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p) (split-window-horizontally))
  (other-window 1))
(global-set-key (kbd "C-t") 'other-window-or-split)
