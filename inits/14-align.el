;;; 14-align.el --- align設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(with-eval-after-load 'align
  ;; php-mode
  (add-to-list 'align-rules-list
               '(php-assignment
                 (regexp . "[^-=!^&*+<>/.| \t\n]\\(\\s-*[.-=!^&*+<>/|]*\\)=>?\\(\\s-*\\)\\([^= \t\n]\\|$\\)")
                 (justify .t)
                 (tab-stop . nil)
                 (modes . '(php-mode))))
  (add-to-list 'align-dq-string-modes 'php-mode)
  (add-to-list 'align-sq-string-modes 'php-mode)
  (add-to-list 'align-open-comment-modes 'php-mode)
  (setq align-region-separate (concat "\\(^\\s-*$\\)\\|"
                                      "\\([({}\\(/\*\\)]$\\)\\|"
                                      "\\(^\\s-*[)}\\(\*/\\)][,;]?$\\)\\|"
                                      "\\(^\\s-*\\(}\\|for\\|while\\|if\\|else\\|"
                                      "switch\\|case\\|break\\|continue\\|do\\)[ ;]\\)"
                                      ))

  (add-to-list 'align-rules-list
               '(comma-delimiter
                 (regexp . ",\\(\\s-*\\)[^# \t\n]")
                 (repeat . t)
                 (modes  . '(php-mode))))
  (add-to-list 'align-rules-list
               '(hash-literal1
                 (regexp . "=>\\(\\s-*\\)[^# \t\n]")
                 (repeat . t)
                 (modes  . '(php-mode))))
  (add-to-list 'align-rules-list
               '(hash-literal2
                 (regexp . "\\(\\s-*\\)=>\\s-*[^# \t\n]")
                 (repeat . t)
                 (modes  . '(php-mode))))
  (add-to-list 'align-rules-list
               '(assignment-literal1
                 (regexp . "\\(\\s-*\\)=\\s-*[^# \t\n]")
                 (repeat . t)
                 (modes  . '(php-mode))))

  ;; emacs-lisp-mode
  (add-to-list 'align-rules-list
               '(emacs-assignment
                 (regexp . ";\\(\\s-*\\)") ; 末尾に \\(\\s-*\\)
                 (modes  . '(emacs-lisp-mode))))

  ;;  lisp-interaction-mode
  (add-to-list 'align-rules-list
               '(trac-table1
                 (regexp . "||\\(\\s-*\\)[^# \t\n]")
                 (repeat . t)
                 (modes  . '(lisp-interaction-mode))))
  (add-to-list 'align-rules-list
               '(trac-table2
                 (regexp . "\\(\\s-*\\)||\\s-*[^# \t\n]")
                 (repeat . t)
                 (modes  . '(lisp-interaction-mode)))))

;;; 14-align.el ends here
