;;; 18-git.el --- git設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'git-gutter)
(global-git-gutter-mode +1)

(require 'magit)

 (custom-set-variables
      '(magit-log-margin '(t "%Y-%m-%d %H:%M" magit-log-margin-width t 12)))

;; common
(set-face-attribute 'magit-section-heading nil
                    :foreground "lime green" :weight 'bold)
(set-face-background 'magit-section-highlight nil)
(set-face-foreground 'magit-filename "MediumPurple1")

;; branch
(set-face-attribute 'magit-branch-current nil
                    :foreground "turquoise1" :background nil :weight 'bold)
(set-face-attribute 'magit-branch-local nil
                    :foreground "turquoise3" :background nil :weight 'normal)
(set-face-attribute 'magit-branch-remote-head nil
                    :foreground "yellow" :background nil :weight 'bold)
(set-face-attribute 'magit-branch-remote nil
                    :foreground "yellow3" :background nil :weight 'normal)
(set-face-attribute 'magit-tag nil
                    :foreground "orchid1" :background nil :weight 'bold)

;; diff
(setq magit-diff-refine-hunk 'all)

;; diffを表示したらすぐに文字単位での強調表示も行う
(defun diff-mode-refine-automatically ()
  (diff-auto-refine-mode t))
(add-hook 'diff-mode-hook 'diff-mode-refine-automatically)

;; 範囲単位の変更箇所
(set-face-attribute 'magit-diff-added nil
                :foreground "gray75" :background "#112914")

(set-face-attribute 'magit-diff-added-highlight nil
                :foreground "gray75" :background "#112914")

(set-face-attribute 'magit-diff-removed nil
                :foreground "gray75" :background "#321618")

(set-face-attribute 'magit-diff-removed-highlight nil
                :foreground "gray75" :background "#321618")

;; 文字単位での変更箇所
(set-face-attribute 'diff-refine-added nil
                :foreground "gray3" :background "#41953E")

(set-face-attribute 'diff-refine-removed nil
                :foreground "gray3" :background "#C9635C")

(set-face-background 'magit-diff-context-highlight nil)
(set-face-foreground 'magit-diff-file-heading "white")
(set-face-background 'magit-diff-file-heading nil)
(set-face-foreground 'magit-diff-file-heading-highlight "white")
(set-face-background 'magit-diff-file-heading-highlight nil)
(set-face-foreground 'magit-diff-hunk-heading "deep sky blue")
(set-face-background 'magit-diff-hunk-heading nil)
(set-face-foreground 'magit-diff-hunk-heading-highlight "deep sky blue")
(set-face-background 'magit-diff-hunk-heading-highlight nil)

;; log
(set-face-foreground 'magit-hash "SkyBlue1")
(set-face-foreground 'magit-log-author "LightSeaGreen")
(set-face-foreground 'magit-log-date "#4f57f9")

;;; 18-git.el ends her
