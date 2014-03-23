;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                  Diff設定                                  ;;
;;;--------------------------------------------------------------------------;;;

(setq diff-switches "-u")

(defun set-diff-color()
  (set-face-foreground 'diff-context nil)
  (set-face-background 'diff-header nil)
  (set-face-underline-p 'diff-header t)
  (set-face-foreground 'diff-file-header "white")
  (set-face-background 'diff-file-header nil)
  (set-face-foreground 'diff-index "MediumSeaGreen")
  (set-face-background 'diff-index nil)
  (set-face-foreground 'diff-hunk-header "Cyan")
  (set-face-background 'diff-hunk-header nil)
  (set-face-foreground 'diff-removed "red")
  (set-face-background 'diff-removed nil)
  (set-face-foreground 'diff-added "lime green")
  (set-face-background 'diff-added nil)
  (set-face-foreground 'diff-changed "yellow")
  (set-face-background 'diff-function nil)
  (set-face-background 'diff-nonexistent nil)
  (set-face-background 'diff-refine-change nil))
(add-hook 'diff-mode-hook 'set-diff-color)
(add-hook 'magit-mode-hook 'set-diff-color)

;; diffを表示したらすぐに文字単位での強調表示も行う
(defun diff-mode-refine-automatically ()
  (diff-auto-refine-mode t))
(add-hook 'diff-mode-hook 'diff-mode-refine-automatically)

;; diff関連の設定
(defun magit-setup-diff ()
  ;; diffを表示しているときに文字単位での変更箇所も強調表示する
  ;; 'allではなくtにすると現在選択中のhunkのみ強調表示する
  (setq magit-diff-refine-hunk 'all)
  ;; diffの表示設定が上書きされてしまうのでハイライトを無効にする
  (set-face-attribute 'magit-item-highlight nil :inherit nil))
(add-hook 'magit-mode-hook 'magit-setup-diff)
