;;; 34-php-mode.el --- php-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'php-mode)
(require 'php-completion)

(setq auto-mode-alist (cons '("\\.ctp$" . php-mode) auto-mode-alist))
;; mmm-mode in php
;; (require 'mmm-mode)
;; (setq mmm-global-mode 'maybe)
;; (set-face-background 'mmm-default-submode-face nil)
;; (mmm-add-mode-ext-class nil "\\.php?\\'" 'html-php)
;; (mmm-add-mode-ext-class nil "\\.ctp?\\'" 'html-php)
;; (mmm-add-classes
;;  '((html-php
;;     :submode php-mode
;;     :front "<\\?\\(php\\)?"
;;     :back "\\?>")))
;; (add-to-list 'auto-mode-alist '("\\.php?\\'" . xml-mode))
;; (add-to-list 'auto-mode-alist '("\\.ctp?\\'" . xml-mode))
;; (define-key ac-menu-map (kbd "C-k") 'ac-)

(add-hook 'php-mode-hook '(lambda()
                            (mode-init-func)
                            (setq php-mode-force-pear t)
                            (c-set-style "stroustrup")
                            (c-set-offset 'comment-intro 0)
                            (c-toggle-hungry-state 1) ; 連続する空白の一括削除
                            (setq indent-tabs-mode nil)
                            ;; コメントスタイル
                            (setq comment-start "// "
                                  comment-end ""
                                  comment-start-skip "// *")
                            (php-completion-mode t)
                            (add-to-list 'dummy 'php-mode)
                            (make-variable-buffer-local 'ac-sources)
                            (add-to-list 'ac-sources 'ac-source-php-completion)
                            (auto-complete-mode t)))

;;; 34-php-mode.el ends here
