;;; 21-dumb-jump.el --- dump-jump setting -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(setq dumb-jump-default-project "~/.emacs.d")
(setq dumb-jump-force-searcher 'ag)
(setq dumb-jump-ag-search-args "-U")
(setq dumb-jump-selector 'ivy)

;; customize dumb-jump-go
(defun my/dumb-jump-go ()
  (interactive)
  (if (one-window-p)
      (dumb-jump-go-other-window)
    (dumb-jump-go-current-window)))

;;; 22-dumb-jump.el ends here
