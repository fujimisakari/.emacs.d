;;; 35-perl-mode.el --- perl-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; perl-modeではなくcperl-modeを読み込むようにする
(defalias 'perl-mode 'cperl-mode)
;; perl設定の拡張子はcperl-modeで開く
(setq auto-mode-alist (cons '("\\.cgi$" . cperl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.pm$" . cperl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.pl$" . cperl-mode) auto-mode-alist))
;; スクリプトファイルの#!を解釈したモードで開く
(setq interpreter-mode-alist
      (cons '("perl" . cperl-mode)
            interpreter-mode-alist))
(add-hook 'cperl-mode-hook
          '(lambda()
             (common-mode-init)
             (hs-minor-mode)
             (cperl-set-style "PerlStyle") ;
             (perlplus-setup)))

;;; 35-perl-mode.el ends here
