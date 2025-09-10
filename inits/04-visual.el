;;; 04-visual.el --- Visual設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun my/apply-theme-and-ui (frame)
  "Apply theme, font, and UI settings to new FRAME."
  (with-selected-frame frame
    ;; Apply theme (only enable if already loaded)
    (enable-theme 'my-visual)

    ;; Font setup
    (cond ((eq my-os-type 'linux)
           (setq-default line-spacing 0.25)
           (set-face-attribute 'default nil :family my-global-font :height 130))
          ((eq my-os-type 'mac)
           (set-face-attribute 'default nil :family my-global-font :height 160)))

    ;; Japanese font setup
    (set-fontset-font t 'japanese-jisx0208 (font-spec :family my-global-ja-font))
    (add-to-list 'face-font-rescale-alist `(,(concat ".*" my-global-ja-font ".*") . 1.2))

    ;; Frame decorations and transparency
    (toggle-scroll-bar -1)
    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (auto-image-file-mode 1)
    (setq ring-bell-function 'ignore) ; ビープ音、画面フラッシュどちらも起こさない
    (setq inhibit-startup-screen t)   ; 起動画面を表示させない
    (cond ((eq my-os-type 'mac)
           (set-frame-parameter nil 'alpha 73))
          ((eq my-os-type 'linux)
           (set-frame-parameter nil 'alpha 81)))))

;; Hook to apply settings to new frames
(add-hook 'after-make-frame-functions #'my/apply-theme-and-ui)

;; Apply to initial frame
(my/apply-theme-and-ui (selected-frame))

;; Font-lock configuration
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;; Cursor settings
(blink-cursor-mode t)

;; Highlight current line
(beacon-mode 1)
(setq beacon-size 70
      beacon-blink-duration 0.6
      beacon-blink-when-focused t
      beacon-color "lime")

;; Show line numbers
(global-display-line-numbers-mode 1)

;; Mark settings
(setq transient-mark-mode t)

;; Matching parentheses
(show-paren-mode 1)
(setq show-paren-delay 0
      show-paren-style 'expression)

;; Describe face at point helper
(defun describe-face-at-point ()
  "Return face used at point."
  (interactive)
  (message "%s" (get-char-property (point) 'face)))

;; Reload current theme for debug
(defun my/reload-current-theme ()
  "Reload the currently enabled theme."
  (interactive)
  (when custom-enabled-themes
    (let ((theme (car custom-enabled-themes)))
      (disable-theme theme)
      (load-theme theme t)
      (message "Reloaded theme: %s" theme))))

;; Battery status
(require 'fancy-battery)
(add-hook 'after-init-hook #'fancy-battery-mode)

;;; 04-visual.el ends here
