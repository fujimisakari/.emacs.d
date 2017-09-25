;;; 43-rst-mode.el --- rst-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'rst)
(set-face-foreground 'rst-level-1 "lime green")
(set-face-background 'rst-level-1 nil)
(set-face-foreground 'rst-level-2 "orchid1")
(set-face-background 'rst-level-2 nil)
(set-face-foreground 'rst-level-3 "CornflowerBlue")
(set-face-background 'rst-level-3 nil)
(set-face-foreground 'rst-level-4 "orange")
(set-face-background 'rst-level-4 nil)
(set-face-foreground 'rst-level-5 "turquoise")
(set-face-background 'rst-level-5 nil)
(set-face-foreground 'rst-level-6 nil)
(set-face-background 'rst-level-6 nil)
(set-face-attribute 'rst-level-1 nil :bold nil :height 1.8)
(set-face-attribute 'rst-level-2 nil :bold nil :height 1.2)
(set-face-attribute 'rst-level-3 nil :bold nil :height 1.1)

;;; 43-rst-mode.el ends here
