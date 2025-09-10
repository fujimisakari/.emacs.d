;;; my-visual-theme.el --- Unified custom theme -*- lexical-binding: t; -*-

(deftheme my-visual "A unified, personalized Emacs theme.")

(let ((class '((class color) (min-colors 89)))
      (my-global-font "Comic Code"))
  (custom-theme-set-faces
   'my-visual

   ;; Default appearance
   `(default ((,class (:family ,my-global-font :height 160 :foreground "gray75" :background "gray3"))))
   `(cursor ((,class (:background "#4f57f9"))))
   `(region ((,class (:background "#2b43e1"))))
   `(line-number ((,class (:foreground "DarkOliveGreen"))))
   `(line-number-current-line ((,class (:foreground "DarkOliveGreen2"))))

   ;; Mode line
   `(mode-line ((,class (:foreground "#757bff" :background "gray15" :box nil))))
   `(mode-line-inactive ((,class (:foreground "gray40" :background "gray15" :weight light))))
   `(doom-modeline-bar ((,class (:background "#4f57f9"))))
   `(doom-modeline-project-dir ((,class (:foreground "Yellow"))))
   `(doom-modeline-buffer-modified ((,class (:foreground "orchid1"))))
   `(anzu-mode-line ((,class (:foreground "yellow" :weight bold))))

   ;; Font-lock
   `(font-lock-comment-face ((,class (:foreground "CornflowerBlue"))))
   `(font-lock-string-face ((,class (:foreground "firebrick1"))))
   `(font-lock-keyword-face ((,class (:foreground "yellow"))))
   `(font-lock-function-name-face ((,class (:foreground "lime green"))))
   `(font-lock-variable-name-face ((,class (:foreground "orchid1"))))
   `(font-lock-negation-char-face ((,class (:foreground "coral"))))
   `(font-lock-type-face ((,class (:foreground "DeepSkyBlue"))))
   `(font-lock-builtin-face ((,class (:foreground "orange"))))
   `(font-lock-constant-face ((,class (:foreground "turquoise"))))
   `(font-lock-warning-face ((,class (:foreground "LightCyan" :weight normal))))
   `(font-lock-doc-face ((,class (:foreground "firebrick1"))))
   `(font-lock-regexp-grouping-backslash ((,class (:foreground "green4"))))
   `(font-lock-regexp-grouping-construct ((,class (:foreground "green" :inherit bold))))

   ;; Show paren
   `(show-paren-match ((,class (:underline (:color "yellow") :background nil))))

   ;; Rainbow delimiters
   `(rainbow-delimiters-depth-1-face ((,class (:foreground "SlateBlue2"))))
   `(rainbow-delimiters-depth-2-face ((,class (:foreground "DarkOliveGreen2"))))
   `(rainbow-delimiters-depth-3-face ((,class (:foreground "RoyalBlue"))))
   `(rainbow-delimiters-depth-4-face ((,class (:foreground "lime green"))))
   `(rainbow-delimiters-depth-5-face ((,class (:foreground "DeepSkyBlue1"))))
   `(rainbow-delimiters-depth-6-face ((,class (:foreground "SeaGreen"))))
   `(rainbow-delimiters-depth-7-face ((,class (:foreground "khaki2"))))
   `(rainbow-delimiters-depth-8-face ((,class (:foreground "DeepPink3"))))
   `(rainbow-delimiters-depth-9-face ((,class (:foreground "LightSalmon2"))))

   ;; Imenu-list
   `(imenu-list-entry-face-0 ((,class (:foreground "lime green"))))
   `(imenu-list-entry-face-1 ((,class (:foreground "lime green"))))
   `(imenu-list-entry-face-2 ((,class (:foreground "khaki2"))))
   `(imenu-list-entry-face-3 ((,class (:foreground "SteelBlue1"))))
   `(imenu-list-entry-subalist-face-0 ((,class (:foreground "DeepSkyBlue"))))
   `(imenu-list-entry-subalist-face-1 ((,class (:foreground "lime green"))))
   `(imenu-list-entry-subalist-face-2 ((,class (:foreground "khaki2"))))
   `(imenu-list-entry-subalist-face-3 ((,class (:foreground "SteelBlue1"))))

   ;; Popup
   `(popup-tip-face ((,class (:foreground "gray20" :background "ivory3"))))

   ;; Elscreens
   `(elscreen-tab-current-screen-face ((,class (:foreground "#6c6aff" :background "gray25" :weight bold))))
   `(elscreen-tab-control-face ((,class (:foreground "red" :background "gray25" :underline "gray50" :weight bold))))
   `(elscreen-tab-background-face ((,class (:background "gray25"))))
   `(elscreen-tab-other-screen-face ((,class (:foreground "gray50" :background "gray25"))))

   ;; Ivy and Swiper
   `(ivy-grep-info ((,class (:foreground "lime green"))))
   `(ivy-modified-buffer ((,class (:foreground "OliveDrab2"))))
   `(ivy-current-match ((,class (:background "gray20" :distant-foreground "gray75"))))
   `(ivy-minibuffer-match-face-1 ((,class (:foreground "gray75"))))
   `(ivy-minibuffer-match-face-2 ((,class (:foreground "#7777ff" :underline t))))
   `(ivy-minibuffer-match-face-3 ((,class (:foreground "lime green" :underline t))))
   `(ivy-minibuffer-match-face-4 ((,class (:foreground "yellow" :underline t))))
   `(ivy-posframe ((,class (:foreground "gray75" :background "gray5"))))
   `(ivy-posframe-border ((,class (:background "#6272a4"))))
   `(ivy-posframe-cursor ((,class (:foreground "gray75"))))
   `(swiper-line-face ((,class (:foreground "white" :background "SeaGreen"))))

   ;; Diff
   `(diff-context ((,class (:foreground nil))))
   `(diff-header ((,class (:background nil :underline t))))
   `(diff-file-header ((,class (:foreground "white" :background nil :weight bold))))
   `(diff-index ((,class (:foreground "MediumSeaGreen" :background nil))))
   `(diff-hunk-header ((,class (:foreground "turquoise" :background nil))))
   `(diff-removed ((,class (:foreground "red" :background nil))))
   `(diff-added ((,class (:foreground "lime green" :background nil))))
   `(diff-changed ((,class (:foreground "yellow"))))
   `(diff-function ((,class (:background nil))))
   `(diff-nonexistent ((,class (:background nil))))

   ;; Dired
   `(dired-directory ((,class (:foreground "CornflowerBlue"))))
   `(dired-header ((,class (:foreground "yellow" :height 1.3 :weight bold))))
   `(dired-symlink ((,class (:foreground "turquoise"))))
   `(dired-perm-write ((,class (:foreground "gray75"))))
   `(highline-face ((,class (:foreground "black" :background "yellow"))))
   `(dired-subtree-depth-1-face ((,class (:background nil))))
   `(dired-subtree-depth-2-face ((,class (:background nil))))
   `(dired-subtree-depth-3-face ((,class (:background nil))))
   `(dired-subtree-depth-4-face ((,class (:background nil))))
   `(dired-subtree-depth-5-face ((,class (:background nil))))
   `(dired-subtree-depth-6-face ((,class (:background nil))))

   ;; Others
   `(zlc-selected-completion-face ((,class (:foreground "gray7" :background "#4f57f9" :weight bold :slant normal))))
   `(vhl/default-face ((,class (:foreground "gray75" :background "#4f57f9"))))
   `(highlight-indent-guides-character-face ((,class (:foreground "#4f57f9"))))
   `(highlight-indent-guides-top-character-face ((,class (:foreground "DeepSkyBlue"))))
   `(moccur-face ((,class (:background "pale green"))))
   `(jaspace-highlight-eol-face ((,class (:foreground "gray30"))))
   `(aw-leading-char-face ((,class (:height 4.0 :foreground "#f1fa8c"))))

   ;; Magit
   `(magit-filename ((,class (:foreground "MediumPurple1" :weight normal))))
   `(magit-diff-added ((,class (:foreground "gray75" :background "#112914"))))
   `(magit-diff-added-highlight ((,class (:foreground "gray75" :background "#112914" :Extend t))))
   `(magit-diff-removed ((,class (:background nil))))
   `(magit-diff-removed-highlight ((,class (:background nil))))
   `(magit-diff-context-highlight ((,class (:background nil))))
   `(magit-diff-file-heading ((,class (:foreground "white" :background nil))))
   `(magit-diff-file-heading-highlight ((,class (:foreground "white" :background nil))))
   `(magit-diff-hunk-heading ((,class (:foreground "deep sky blue" :background nil))))
   `(magit-diff-hunk-heading-highlight ((,class (:foreground "deep sky blue" :background nil))))
   `(magit-hash ((,class (:foreground "SkyBlue1"))))
   `(magit-log-author ((,class (:foreground "LightSeaGreen"))))
   `(magit-log-date ((,class (:foreground "#4f57f9"))))

   ;; web-mode
   `(web-mode-html-tag-bracket-face ((,class (:foreground "lime green"))))
   `(web-mode-html-tag-face ((,class (:foreground "lime green"))))
   `(web-mode-html-attr-name-face ((,class (:foreground "orchid1"))))
   `(web-mode-variable-name-face ((,class (:foreground "orange"))))
   `(web-mode-preprocessor-face ((,class (:foreground "#4f57f9"))))
   `(web-mode-block-face ((,class (:background "gray7"))))

   ;; org-mode
   `(org-level-1 ((,class (:foreground "lime green" :bold t :height 1.0))))
   `(org-level-2 ((,class (:foreground "orchid1" :bold nil :height 1.0))))
   `(org-level-3 ((,class (:foreground "yellow" :bold nil :height 1.0))))
   `(org-level-4 ((,class (:foreground "CornflowerBlue" :bold nil :height 1.0))))
   `(org-level-5 ((,class (:foreground "orange"))))
   `(org-level-7 ((,class (:foreground "purple1"))))

   ;; markdown-mode
   `(markdown-header-face-1 ((,class (:foreground "lime green" :bold nil :height 1.8))))
   `(markdown-header-face-2 ((,class (:foreground "orchid1" :bold nil :height 1.4))))
   `(markdown-header-face-3 ((,class (:foreground "CornflowerBlue" :bold nil :height 1.2))))
   `(markdown-header-face-4 ((,class (:foreground "orange"))))
   `(markdown-header-face-5 ((,class (:foreground "turquoise"))))
   `(markdown-code-face ((,class (:family ,my-global-font :foreground "HotPink" :background "gray15" :bold nil))))

   ;; rst-mode
   `(rst-level-1 ((,class (:foreground "lime green" :bold nil :height 1.8 :background nil))))
   `(rst-level-2 ((,class (:foreground "orchid1" :bold nil :height 1.2 :background nil))))
   `(rst-level-3 ((,class (:foreground "CornflowerBlue" :bold nil :height 1.1 :background nil))))
   `(rst-level-4 ((,class (:foreground "orange" :background nil))))
   `(rst-level-5 ((,class (:foreground "turquoise" :background nil))))
   `(rst-level-6 ((,class (:foreground nil :background nil))))

   ;; lsp-ui
   `(lsp-ui-peek-selection ((,class (:foreground "white" :background "#4f57f9"))))
   `(lsp-ui-peek-header ((,class (:foreground "white" :background "SlateBlue2"))))
   `(lsp-ui-peek-footer ((,class (:foreground "white" :background "SlateBlue2"))))
   `(lsp-ui-peek-filename ((,class (:foreground "CornflowerBlue"))))
   `(lsp-ui-peek-line-number ((,class (:foreground "gray45"))))
   `(lsp-ui-peek-peek ((,class (:background "gray15"))))
   `(lsp-ui-peek-highlight ((,class (:background "DarkOliveGreen2" :DistantForeground white))))

   ;; doom-modeline
   `(doom-modeline-bar ((,class (:background "#4f57f9"))))
   `(doom-modeline-project-dir ((,class (:foreground "Yellow"))))
   `(doom-modeline-buffer-modified ((,class (:foreground "orchid1"))))

   ;; wanderlust
   `(wl-highlight-summary-refiled-face ((,class (:foreground "DodgerBlue"))))))

(provide-theme 'my-visual)

;;; my-visual-theme.el ends here
