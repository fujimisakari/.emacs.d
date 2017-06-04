;;; 39-slime-mode.el --- slime-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(when (require 'slime nil t)

  (add-hook 'lisp-mode-hook (lambda ()
                              (common-mode-init)
                              (slime-mode t)
                              (setq indent-tabs-mode nil)
                              (unless show-paren-mode
                                (show-paren-mode))))
  (add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))

  (slime-setup '(slime-repl slime-fancy slime-banner slime-fuzzy slime-indentation))
  (setq slime-autodoc-use-multiline-p t)
  (setq slime-net-coding-system 'utf-8-unix) ;; 日本語利用のための設定（Lisp 環境側の対応も必要）

  (require 'ac-slime)
  (add-hook 'slime-mode-hook 'set-up-slime-ac)
  (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)

  ;; 括弧の対応を取りながらS式を編集する
  ;; (add-hook 'slime-repl-mode-hook 'enable-paredit-mode)

  ;; roswell設定
  ;; (load (expand-file-name "~/.roswell/impls/ALL/ALL/quicklisp/slime-helper.el"))
  ;; (setq inferior-lisp-program "ros -L sbcl -Q run")

  ;; HyperSpecをeww見る設定
  (setq common-lisp-hyperspec-root "~/.emacs.d/share/HyperSpec/")

  (defun common-lisp-hyperspec (symbol-name)
    (interactive (list (common-lisp-hyperspec-read-symbol-name)))
    (let ((name (common-lisp-hyperspec--strip-cl-package
                 (downcase symbol-name))))
      (cl-maplist (lambda (entry)
                    (eww-open-file (concat common-lisp-hyperspec-root "Body/"
                                           (car entry)))
                    (when (cdr entry)
                      (sleep-for 1.5)))
                  (or (common-lisp-hyperspec--find name)
                      (error "The symbol `%s' is not defined in Common Lisp"
                             symbol-name)))))

  (defun common-lisp-hyperspec-lookup-reader-macro (macro)
    (interactive
     (list
      (let ((completion-ignore-case t))
        (completing-read "Look up reader-macro: "
                         common-lisp-hyperspec--reader-macros nil t
                         (common-lisp-hyperspec-reader-macro-at-point)))))
    (eww-open-file
     (concat common-lisp-hyperspec-root "Body/"
             (gethash macro common-lisp-hyperspec--reader-macros))))

  (defun common-lisp-hyperspec-format (character-name)
    (interactive (list (common-lisp-hyperspec--read-format-character)))
    (cl-maplist (lambda (entry)
                  (eww-open-file (common-lisp-hyperspec-section (car entry))))
                (or (gethash character-name
                             common-lisp-hyperspec--format-characters)
                    (error "The symbol `%s' is not defined in Common Lisp"
                           character-name))))

  (defadvice common-lisp-hyperspec (around common-lisp-hyperspec-around activate)
    (let ((buf (current-buffer)))
      ad-do-it
      (switch-to-buffer buf)
      (pop-to-buffer "*eww*")))

  (defadvice common-lisp-hyperspec-lookup-reader-macro (around common-lisp-hyperspec-lookup-reader-macro-around activate)
    (let ((buf (current-buffer)))
      ad-do-it
      (switch-to-buffer buf)
      (pop-to-buffer "*eww*")))

  (defadvice common-lisp-hyperspec-format (around common-lisp-hyperspec-format activate)
    (let ((buf (current-buffer)))
      ad-do-it
      (switch-to-buffer buf)
      (pop-to-buffer "*eww*"))))

;;; 39-slime-mode.el ends here
