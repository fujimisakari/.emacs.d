;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                              モードの基本設定                              ;;
;;;--------------------------------------------------------------------------;;;

;;; あらゆるモードで有効なキーバインドの設定(my-keyjack-mode)
(setq my-keyjack-mode-map (make-sparse-keymap))

(mapcar (lambda (x)
          (define-key my-keyjack-mode-map (car x) (cdr x))
          (global-set-key (car x) (cdr x)))
        '(("\C-\M-l" . elscreen-next)
          ("\C-\M-h" . elscreen-previous)))

(easy-mmode-define-minor-mode my-keyjack-mode "Grab keys"
                              t " Keyjack" my-keyjack-mode-map)

(defun mode-init-func()
  (hl-line-mode t)
  (skk-mode t)
  (setq indent-level 4)
  (c-toggle-hungry-state 1)
  (orgtbl-mode))

(require 'flymake)
(require 'flymake-cursor) ; minibufferにエラーメッセージを表示させる
(global-set-key (kbd "C-M-p") 'flymake-goto-prev-error)
(global-set-key (kbd "C-M-n") 'flymake-goto-next-error)
;; 文法チェックの頻度の設定
(setq flymake-no-changes-timeout 1)
;; 改行時に文法チェックを行うかどうかの設定
(setq flymake-start-syntax-check-on-newline nil)
;; 自動でリアルタイムの文法チェックを有効
;; (add-hook 'c-mode-common-hook (lambda() (flymake-mode t)))
;; syntax checkが異常終了しても無視する
(defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
  (setq flymake-check-was-interrupted t))
(ad-activate 'flymake-post-syntax-check)

;; emacs-lisp-mode
(add-hook 'emacs-lisp-mode-hook 'mode-init-func)
;; text-mode
(add-hook 'text-mode-hook 'mode-init-func)

;; ruby-mode
(add-hook 'ruby-mode-hook 'mode-init-func)

;; view-mode
(add-hook 'view-mode-hook
          '(lambda()
             (skk-mode nil)
             (hl-line-mode t)))

;; dired-mode
(add-hook 'dired-mode-hook
          '(lambda()
             (hl-line-mode t)))

;; org-mode
(add-hook 'org-mode-hook
          '(lambda()
             (skk-mode)
             (hl-line-mode)))

;; org-remember-mode
(add-hook 'org-remember-mode-hook
          '(lambda()
             (skk-mode)
             (hl-line-mode)))

;; ratpoisnrc編集を支援するメジャーモード
;; (require 'ratpoison)
