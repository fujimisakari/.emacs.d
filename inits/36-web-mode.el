;;; 36-web-mode.el --- web-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'web-mode)

;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.ejs?$"      . web-mode))
(add-to-list 'auto-mode-alist '("\\.css$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.scss$"      . web-mode))

;; 拡張子がhtmlの場合はdjangoテンプレートとみなす
(add-to-list 'web-mode-engine-file-regexps '("django" . "\\.html\\'"))

;; インデント数
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 4)   ;; html indent
  (setq web-mode-css-indent-offset    4)   ;; css indent
  (setq web-mode-code-indent-offset   4)   ;; script indent(js,php,etc..)
  (setq web-mode-enable-auto-indentation nil)
  (setq web-mode-enable-block-face t)
  (setq web-mode-enable-part-face t)
  (common-mode-init)
  (add-hook 'local-write-file-hooks
            (lambda ()
              (delete-trailing-whitespace)
               nil)))

;; カラー設定
(set-face-foreground 'web-mode-html-tag-bracket-face "lime green")
(set-face-foreground 'web-mode-html-tag-face "lime green")
(set-face-foreground 'web-mode-html-attr-name-face "magenta")
(set-face-foreground 'web-mode-variable-name-face "orange")
(set-face-foreground 'web-mode-preprocessor-face "MediumPurple1")
(set-face-background 'web-mode-block-face "gray10")

(add-hook 'web-mode-hook 'web-mode-hook)

;; FlymakeHtml
;; http://www.emacswiki.org/emacs/FlymakeHtml
;; (defun flymake-html-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name))))
;;     (list "~/.emacs.d/bin/tidylint" (list local-file))))
;;     ;; (list "tidy" (list "-utf8" "--doctype" "<!DOCTYPE html>" "--accessibility-check" "1" "--new-blocklevel-tags" "table,section,article,aside,hgroup,header,footer,nav,figure,figcaption,video,audio,canvas" "markup" "no" "tr" "--numeric-entities" "yes" "--fix-bad-comments" "no" local-file))))
;; (add-to-list 'flymake-allowed-file-name-masks
;;              '("\\.html$\\|\\.ctp" flymake-html-init))
;; (add-to-list 'flymake-err-line-patterns
;;              '("line \\([0-9]+\\) column \\([0-9]+\\) - \\(Warning\\|Error\\): \\(.*\\)"
;;                nil 1 2 4))
;; (add-hook 'html-mode-hook '(lambda () (flymake-mode t)))

;;; 36-web-mode.el ends here
