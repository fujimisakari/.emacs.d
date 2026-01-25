;;; 39-slime-mode.el --- slime-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(when (require 'slime nil t)

  (defun my/slime-lisp-mode-setup ()
    "Setup for lisp-mode with slime."
    (common-mode-init)
    (slime-mode t)
    (setq indent-tabs-mode nil)
    (unless show-paren-mode
      (show-paren-mode)))
  (add-hook 'lisp-mode-hook #'my/slime-lisp-mode-setup)

  (defun my/inferior-slime-setup ()
    "Setup for inferior-lisp-mode."
    (inferior-slime-mode t))
  (add-hook 'inferior-lisp-mode-hook #'my/inferior-slime-setup)

  (slime-setup '(slime-repl slime-fancy slime-banner slime-fuzzy slime-indentation))
  (setq slime-autodoc-use-multiline-p t)
  (setq slime-net-coding-system 'utf-8-unix) ; 日本語利用のための設定（Lisp 環境側の対応も必要）

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

  (defun my/hyperspec-switch-to-eww (orig-fun &rest args)
    "Switch back to original buffer and pop to eww after hyperspec lookup."
    (let ((buf (current-buffer)))
      (apply orig-fun args)
      (switch-to-buffer buf)
      (pop-to-buffer "*eww*")))

  (advice-add 'common-lisp-hyperspec :around #'my/hyperspec-switch-to-eww)
  (advice-add 'common-lisp-hyperspec-lookup-reader-macro :around #'my/hyperspec-switch-to-eww)
  (advice-add 'common-lisp-hyperspec-format :around #'my/hyperspec-switch-to-eww))

;;; 39-slime-mode.el ends here
