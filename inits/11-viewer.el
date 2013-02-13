;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                 viewer設定                                 ;;
;;;--------------------------------------------------------------------------;;;

;; (require 'viewer)
;; ;; C-x C-r は view-modeでファイルを開く
;; (setq view-read-only t)

;; ;; kl でグローバルマップから view-mode を切り替え
;; (key-chord-define-global "kl" 'view-mode)

;; ;; 書き込み不能ファイルはview-modeから抜けなくする
;; (viewer-stay-in-setup)

;; ;; 特定のファイルを view-mode で開くようにする
;; (setq view-mode-by-default-regexp "\\.log$")

;; ;;; view-mode のときに mode-line に色をつける
;; ;; 書き込み不可ファイルを開く場合は濃い赤色
;; (setq viewer-modeline-color-unwritable "red")
;; ;; 書き込み可能ファイルを開く場合はオレンジ色
;; (setq viewer-modeline-color-view "orange")
;; (viewer-change-modeline-color-setup)

;; ;;; view-modeのキーバインド
;; ;; less感覚の操作
;; (define-key view-mode-map (kbd "N") 'View-search-last-regexp-backward)
;; (define-key view-mode-map (kbd "?") 'View-search-regexp-backward)
;; (define-key view-mode-map (kbd "G") 'View-goto-line-last)
;; (define-key view-mode-map (kbd "b") 'View-scroll-page-backward)
;; (define-key view-mode-map (kbd "f") 'View-scroll-page-forward)
;; ;; vi/w3w感覚の操作
;; (define-key view-mode-map (kbd "h") 'backward-char)
;; (define-key view-mode-map (kbd "j") 'next-line)
;; (define-key view-mode-map (kbd "k") 'previous-line)
;; (define-key view-mode-map (kbd "l") 'forward-char)
;; (define-key view-mode-map (kbd "J") 'View-scroll-line-forward)
;; (define-key view-mode-map (kbd "K") 'View-scroll-line-backward)
;; ;; bm.el の設定
;; (define-key view-mode-map (kbd "m") 'bm-toggle)
;; (define-key view-mode-map (kbd "[") 'bm-previous)
;; (define-key view-mode-map (kbd "]") 'bm-next)
;; ;; メジャーモードに合わせてview-modeのキーバインドを設定する
;; (define-overriding-view-mode-map c-mode ("RET" . gtags-find-tag-from-here))
;; (define-overriding-view-mode-map emacs-lisp-mode-map ("RET" . find-function-at-point))
