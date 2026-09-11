;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-

;;; Commentary:
;; Emacs 27+ loads this file before init.el and before the GUI frame is created.
;; This is the ideal place to disable UI elements for consistent startup.

;;; Code:

;; Disable UI elements before frame creation to prevent flicker
(setq default-frame-alist
      `((menu-bar-lines . 0)
        (tool-bar-lines . 0)
        (vertical-scroll-bars . nil)
        (horizontal-scroll-bars . nil)
        (undecorated . ,(not (eq system-type 'gnu/linux)))
        (internal-border-width . 0)))

;; Disable fringe (left/right margin indicators)
(fringe-mode 0)

;; Also disable via modes
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Startup settings
(setq inhibit-startup-screen t)   ; 起動画面を表示させない
(setq ring-bell-function 'ignore) ; ビープ音、画面フラッシュどちらも起こさない

;; 既定では .elc が古くても .el より優先されるため、コンパイル漏れの .elc が
;; 残っていると .el の変更が反映されない。常に新しい方を読む。
;; init.el 自体の読み込みにも効かせるため early-init.el に置く。
(setq load-prefer-newer t)

;;; early-init.el ends here
