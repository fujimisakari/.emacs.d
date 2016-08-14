;;; 46-go-mode.el --- go-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'go-mode)
(require 'go-autocomplete)
(require 'go-flymake)

(add-hook 'go-mode-hook
          '(lambda()
             ;; (add-hook 'before-save-hook 'gofmt-before-save)
             (mode-init-func)
             (setq indent-tabs-mode t)
             (go-eldoc-setup)))

(defvar helm-go-packages-source
  '((name . "Helm Go Packages")
    (candidates . (lambda ()
                    (cons "builtin" (go-packages))))
    (action . (("Show document" . godoc)
               ("Import package" . helm-go-package-import-add)))))

(defun helm-go-package-import-add (candidate)
  (dolist (package (helm-marked-candidates))
    (go-import-add current-prefix-arg package)))

(defun helm-go-packages ()
  (interactive)
  (helm :sources '(helm-go-packages-source) :buffer "*helm go packages*"))

;;; 46-go-mode.el ends here
