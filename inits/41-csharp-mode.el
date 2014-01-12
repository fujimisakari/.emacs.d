;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                              csharp-mode関連                               ;;
;;;--------------------------------------------------------------------------;;;

(require 'csharp-mode)
(setq auto-mode-alist
   (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))

;; C#モードフック
(add-hook 'csharp-mode-hook
          '(lambda()
             (setq comment-column 40)
             (setq c-basic-offset 4)
             (setq tab-width 4)
             (setq indent-tabs-mode t)
             ;; (font-lock-add-magic-number)
             ;; オフセットの調整
             (c-set-offset 'substatement-open 0)
             (c-set-offset 'case-label '+)
             (c-set-offset 'arglist-intro '+)
             (c-set-offset 'arglist-close 0)
             (hl-line-mode)
             (skk-mode)
             (omnisharp-mode)
             ;; (auto-complete-mode)
             (flymake-mode)
             )
          )

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-omnisharp))

;; csharp-modeの不要機能をoff
(setq csharp-want-flymake-fixup nil)

;; Flymake
(defun flymake-csharp-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "~/.emacs.d/bin/csharp-checker" (list local-file))))
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.cs$" flymake-csharp-init))
(add-to-list 'flymake-err-line-patterns
             '("cs\(\\([0-9]+\\),\\([0-9]+\\)\)\: \\(error\\|warning\\) \\(.+\\)$" nil 1 2 4))
(add-to-list 'flymake-err-line-patterns
             '("LineNumber=\\([0-9]+\\) .* RuleId=\\(.+\\)</Violation" nil 1 1 2))

;; csharpの実行環境
(add-to-list 'quickrun-file-alist '("\\.cs$" . "c#/mono"))
(quickrun-add-command "c#/mono"
                      '((:command . "mono")
                        (:exec    . ("mcs %s" "%c %n.exe"))
                        (:remove  . ("%n.exe")))
                      :mode 'csharp-mode)
