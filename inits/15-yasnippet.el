;;; 15-yasnippet.el --- yasnippet設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; This directory is shared by different Emacs versions.  Expand the mode
;; macros with the running Emacs instead of using incompatible .elc/.eln files.
(load "yasnippet.el" nil t)
(setq yas-snippet-dirs
      '("~/.emacs.d/share/snippets"))
(yas-global-mode 1)

;;; 15-yasnippet.el ends here
