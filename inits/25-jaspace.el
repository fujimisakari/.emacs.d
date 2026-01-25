;;; 25-jaspace.el --- jaspace設定 -*- lexical-binding: t; -*-

;;; Commentary:
;; タブ, 全角スペース、改行直前の半角スペースを表示する

;;; Code:

(when (require 'jaspace nil t)
  (when (boundp 'jaspace-modes)
    (setq jaspace-modes (append jaspace-modes
                                (list 'php-mode
                                      'yaml-mode
                                      'javascript-mode
                                      'ruby-mode
                                      'text-mode
                                      'python-mode
                                      'csharp-mode
                                      'web-mode
                                      'angular-mode
                                      'swift-mode
                                      'makefile-mode
                                      'fundamental-mode))))
  (when (boundp 'jaspace-alternate-jaspace-string)
    (setq jaspace-alternate-jaspace-string "□"))
  (setq jaspace-alternate-eol-string "↓\n") ; 改行記号を表示させる
  (when (boundp 'jaspace-highlight-tabs)
    (setq jaspace-highlight-tabs ?\xBB))
  (defun my/jaspace-mode-off-setup ()
    "Setup when jaspace-mode is off."
    (when (boundp 'show-trailing-whitespace)
      (setq show-trailing-whitespace nil)))
  (add-hook 'jaspace-mode-off-hook #'my/jaspace-mode-off-setup)

  (defun my/jaspace-mode-setup ()
    "Setup when jaspace-mode is on."
    (when (boundp 'show-trailing-whitespace)
      (setq show-trailing-whitespace t))
    (face-spec-set 'jaspace-highlight-jaspace-face
                   '((((class color) (background light))
                      (:foreground "blue"))
                     (t (:foreground "green"))))
    (face-spec-set 'jaspace-highlight-tab-face
                   '((((class color) (background light))
                      (:foreground "red"
                       :background "gray7"
                       :strike-through nil
                       :underline t))
                     (t (:foreground "purple"
                         :background "gray7"
                         :strike-through nil
                         :underline t))))
    (face-spec-set 'trailing-whitespace
                   '((((class color) (background light))
                      (:foreground "red"
                       :background "gray7"
                       :strike-through nil
                       :underline t))
                     (t (:foreground "purple"
                         :background "gray7"
                         :strike-through nil
                         :underline t)))))
  (add-hook 'jaspace-mode-hook #'my/jaspace-mode-setup))

;;; 25-jaspace.el ends here
