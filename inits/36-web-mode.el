;;; 36-web-mode.el --- web-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; autoload
(autoload 'web-mode "web-mode" nil t)

;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.ejs?$"    . web-mode))
(add-to-list 'auto-mode-alist '("\\.css$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.scss$"    . web-mode))
(add-to-list 'auto-mode-alist '("\\.vue$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.js[x]?$"  . web-mode))

;; インデント数
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 4) ; html indent
  (setq web-mode-css-indent-offset    4) ; css indent
  (setq web-mode-code-indent-offset   4) ; script indent(js,php,etc..)
  (setq web-mode-enable-auto-indentation nil)
  (setq web-mode-enable-block-face t)
  (setq web-mode-enable-part-face t)
  ;; require-final-newlineとNo newline at end of file対策 - by shigemk2
  ;; https://www.shigemk2.com/entry/emacs_no_newline_final
  (setq require-final-newline nil)
  (common-mode-init))
(add-hook 'web-mode-hook 'web-mode-hook)

;;; 36-web-mode.el ends here
