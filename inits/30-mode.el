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

;; c-modeのインデント設定
(defun my-c-mode-hook()
  (c-set-style "stroustrup")
  (c-set-offset 'comment-intro 0)
  (setq tab-width 4)
  (setq c-hanging-comment-ender-p nil)
  (setq indent-tabs-mode nil)
  (c-toggle-hungry-state 1))

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
