;;; 18-git.el --- git設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'git-gutter)
(global-git-gutter-mode +1)

;; Magit bytecode still calls the legacy `incf' macro.
(require 'cl)

;; Magit 2026 uses `set-local', introduced in Emacs 31.
;; Emacs 30 has the same operation under `make-local-variable' and `set'.
(unless (fboundp 'set-local)
  (defun set-local (variable value)
    (set (make-local-variable variable) value)))

;; Magit 2026 also uses the Emacs 31 `any' and `all' helpers.
(unless (fboundp 'any)
  (defun any (pred list)
    (cl-member-if pred list)))
(unless (fboundp 'all)
  (defun all (pred list)
    (cl-every pred list)))

;; The current ELPA Magit package contains an Emacs 31 compatibility
;; form compiled as a function. Emacs 30 does not provide that form;
;; skip the optional Emacs 31-only backport so Magit can load normally.
(when (and (< emacs-major-version 31)
           (not (fboundp 'static-when)))
  (defun static-when (&rest _args)
    nil))

;; magit autoload
(autoload 'magit-status "magit" nil t)
(autoload 'magit-log-current "magit" nil t)
(autoload 'magit-branch-checkout "magit" nil t)
(autoload 'magit-pull-from-pushremote "magit" nil t)
(autoload 'magit-fetch-all-prune "magit" nil t)
(autoload 'magit-rebase-branch "magit" nil t)

;; magit 読み込み後の設定
(with-eval-after-load 'magit
  (custom-set-variables
   '(magit-log-margin '(t "%Y-%m-%d %H:%M" magit-log-margin-width t 12)))

  ;; git実行結果バッファーは必ず表示する
  (setq magit-process-popup-time 0)

  ;; common
  (set-face-attribute 'magit-section-heading nil
                      :foreground "lime green" :weight 'bold)
  (set-face-background 'magit-section-highlight nil)
  (set-face-foreground 'magit-filename "MediumPurple1")

  ;; branch
  (set-face-attribute 'magit-branch-current nil
                      :foreground "turquoise1" :background 'unspecified :weight 'bold)
  (set-face-attribute 'magit-branch-local nil
                      :foreground "turquoise3" :background 'unspecified :weight 'normal)
  (set-face-attribute 'magit-branch-remote-head nil
                      :foreground "yellow" :background 'unspecified :weight 'bold)
  (set-face-attribute 'magit-branch-remote nil
                      :foreground "yellow3" :background 'unspecified :weight 'normal)
  (set-face-attribute 'magit-tag nil
                      :foreground "orchid1" :background 'unspecified :weight 'bold)

  ;; diff
  (setq magit-diff-refine-hunk 'all)

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
                      :foreground "gray3" :background "#C9635C"))

;; diffを表示したらすぐに文字単位での強調表示も行う
(defun my/diff-mode-refine-automatically ()
  (diff-auto-refine-mode t))
(add-hook 'diff-mode-hook 'my/diff-mode-refine-automatically)

;; custom command
(defun my/magit-show-previous-commit ()
  "Show the previous commit (parent) of the current commit in
magit-revision buffer."
  (interactive)
  (let* ((current magit-buffer-revision)
         (parent (and current
                      (car (process-lines "git" "rev-list" "--parents"
"-n" "1" current)))))
    (if parent
        (let ((parts (split-string parent)))
          (if (> (length parts) 1)
              (magit-show-commit (nth 1 parts))
            (message "No parent commit found.")))
      (message "Could not get commit info."))))

(defun my/magit-show-next-commit ()
  "Show the next commit of the current commit in magit-revision buffer."
  (interactive)
  (let* ((current magit-buffer-revision)
         (children (and current
                        (process-lines
                         "git" "rev-list" "--reverse" "--ancestry-path"
                         (format "%s..HEAD" current)))))
    (if (and children (> (length children) 0))
        (let ((next (car children)))
          (magit-show-commit next))
      (message "No next commit found."))))

;;; 18-git.el ends here
