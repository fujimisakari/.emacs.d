;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                  info設定                                  ;;
;;;--------------------------------------------------------------------------;;;

;; 日本語マニュアルの導入
(setq Info-default-directory-list
      (append Info-default-directory-list (list (expand-file-name "~/.emacs.d/share/info"))))
(auto-compression-mode t)    ; 日本語infoを読めるようになる

;; キーバインド設定
(add-hook 'Info-mode-hook
          (lambda ()
            ;; 上下カーソル移動
            (local-set-key "j" 'next-line)
            (local-set-key "k" 'previous-line)
            (local-set-key "f" 'Info-scroll-up)
            (local-set-key "b" 'Info-scroll-down)
            (local-set-key "g" 'beginning-of-buffer)
            (local-set-key "G" 'end-of-buffer)
            ;; 上下スクロール (カーソル固定)
            (local-set-key "J" (lambda () (interactive) (scroll-up 1)))
            (local-set-key "K" (lambda () (interactive) (scroll-down 1)))
            ;; 左右カーソル移動
            (local-set-key "l" 'forward-word)
            (local-set-key "h" 'backward-word)
            ;; 戻る・進む
            (local-set-key "B" 'Info-history-back)
            (local-set-key "F" 'Info-history-forward)
            ;; リンクを開く
            (local-set-key "o" 'Info-follow-nearest-node)
            ;; 次・前のリンクへカーソル移動
            (local-set-key "n" 'Info-next-reference)
            (local-set-key "p" 'Info-prev-reference)
            ))
