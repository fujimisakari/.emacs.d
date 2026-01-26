;;; 35-perl-mode.el --- perl-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; perl-modeではなくcperl-modeを読み込むようにする
(defalias 'perl-mode 'cperl-mode)
;; perl設定の拡張子はcperl-modeで開く
(add-to-list 'auto-mode-alist '("\\.cgi\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.pm\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.pl\\'" . cperl-mode))
;; スクリプトファイルの#!を解釈したモードで開く
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(defun my/cperl-mode-setup ()
  "Setup for cperl-mode."
  (common-mode-init)
  (hs-minor-mode)
  (cperl-set-style "PerlStyle")
  (perlplus-setup))
(add-hook 'cperl-mode-hook #'my/cperl-mode-setup)

;;; 35-perl-mode.el ends here
