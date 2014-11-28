;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               eclim-mode設定                               ;;
;;;--------------------------------------------------------------------------;;;

(require 'eclim)
(require 'eclimd)

;; java-mode で有効
(add-hook 'java-mode-hook 'eclim-mode)

(custom-set-variables
  '(eclim-eclipse-dirs '("/opt/homebrew-cask/Caskroom/eclipse-java/4.4.0/eclipse"))
  '(eclim-executable "/opt/homebrew-cask/Caskroom/eclipse-java/4.4.0/eclipse/eclim")
  '(eclimd-default-workspace "~/projects/workspace"))

;; コード補完(auto-complete)
(require 'ac-emacs-eclim-source)
(ac-emacs-eclim-config)
(set-face-foreground 'ac-emacs-eclim-candidate-face "#fff")
(set-face-background 'ac-emacs-eclim-candidate-face "#444")
(set-face-foreground 'ac-emacs-eclim-selection-face "#fff")
(set-face-background 'ac-emacs-eclim-selection-face "SlateBlue2")

;; エラー箇所にカーソルを当てるとエコーエリアに詳細を表示する
(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
;; (help-at-pt-set-timer)

(define-key eclim-mode-map (kbd "C-c C-e ;") 'eclim-run-class)
