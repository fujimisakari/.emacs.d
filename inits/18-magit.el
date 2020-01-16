;;; 18-magit.el --- magit-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'magit)

(setq magit-diff-refine-hunk 'all)

;; 文字単位での変更箇所は色を反転して強調
(set-face-attribute 'diff-refine-added nil
                :foreground nil :background "SpringGreen4" :weight 'bold :inverse-video t)

(set-face-attribute 'diff-refine-removed nil
                :foreground nil :background "red4" :weight 'bold :inverse-video t)

;; diffを表示したらすぐに文字単位での強調表示も行う
(defun diff-mode-refine-automatically ()
  (diff-auto-refine-mode t))
(add-hook 'diff-mode-hook 'diff-mode-refine-automatically)

(set-face-foreground 'magit-diff-file-heading "gray90")
(set-face-background 'magit-diff-file-heading "SlateBlue4")
(set-face-foreground 'magit-diff-file-heading-highlight "gray90")
(set-face-background 'magit-diff-file-heading-highlight "SlateBlue4")

(set-face-foreground 'magit-branch-current "IndianRed1")
(set-face-foreground 'magit-branch-local "IndianRed1")
(set-face-foreground 'magit-branch-remote "goldenrod1")

(set-face-foreground 'magit-hash "SkyBlue1")
(set-face-foreground 'magit-log-author "LightSeaGreen")
(set-face-foreground 'magit-log-date "MediumPurple1")

(require 'git-gutter)
(global-git-gutter-mode +1)

;;; 18-magit.el ends her
