;;; 18-magit.el --- magit-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'magit)
(set-face-foreground 'magit-diffstat-added "lime green")
(set-face-foreground 'magit-diffstat-removed "red")

(set-face-foreground 'magit-diff-added "lime green")
(set-face-background 'magit-diff-added nil)
(set-face-foreground 'magit-diff-added-highlight "lime green")
(set-face-background 'magit-diff-added-highlight "grey20")

(set-face-foreground 'magit-diff-removed "red")
(set-face-background 'magit-diff-removed nil)
(set-face-foreground 'magit-diff-removed-highlight "red")
(set-face-background 'magit-diff-removed-highlight "grey20")

(set-face-foreground 'magit-branch-current "IndianRed1")
(set-face-foreground 'magit-branch-local "IndianRed1")
(set-face-foreground 'magit-branch-remote "goldenrod1")

(set-face-foreground 'magit-hash "SkyBlue1")
(set-face-foreground 'magit-log-author "LightSeaGreen")
(set-face-foreground 'magit-log-date "MediumPurple1")

;;; 18-magit.el ends her
