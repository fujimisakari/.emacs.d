;;; 46-go-mode.el --- go-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; autoload
(autoload 'go-mode "go-mode" nil t)
(autoload 'open-godoc "open-godoc" nil t)
(add-to-list 'auto-mode-alist '("\\.go$" . go-mode))

(defun my/go-mode-setup ()
  "Setup for go-mode."
  (setq indent-tabs-mode t)
  (setq go-test-verbose t)
  (setq tab-width 4)
  (setq go-tab-width 4)
  (setq-local copilot-indent-offset tab-width) ; Copilot workaround
  (my/common-mode-init)
  (company-mode)
  (flycheck-golangci-lint-setup)
  (copilot-mode))
(add-hook 'go-mode-hook #'my/go-mode-setup)

(with-eval-after-load 'go-mode
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook #'gofmt-before-save))

;; Change godoc buffer name
(defun my/godoc--get-buffer (query)
  "Get an empty buffer for a godoc QUERY."
  (let* ((buffer-name "*godoc*")
         (buffer (get-buffer buffer-name)))
    ;; Kill the existing buffer if it already exists.
    (when buffer (kill-buffer buffer))
    (get-buffer-create buffer-name)))

;; Docoument Popup
(defun my/godoc-popup ()
  (interactive)
  (unless (use-region-p)
    (error "Dose not region selection"))
  (let ((query (buffer-substring-no-properties (region-beginning) (region-end))))
    (run-at-time 0.1 nil 'deactivate-mark)
    (popup-tip
     (with-temp-buffer
       (let ((standard-output (current-buffer))
             (help-xref-following t))
         (prin1 (funcall 'shell-command-to-string (concat "go doc " query)))
         (buffer-substring-no-properties (+ (point-min) 1) (- (point-max) 3)))))))

;; toggle to test file
(defun my/go-toggle-to-test-file ()
  (interactive)
  (go-internal-toggle-to-test-file))

;; Open a go file and a test file side by side
(defun my/go-open-with-test-file ()
  (interactive)
  (my/other-window-or-split)
  (go-internal-toggle-to-test-file))

(defun my/go-internal-toggle-to-test-file ()
  (let ((current-file (buffer-file-name))
        (tmp-file (buffer-file-name)))
    (cond ((string-match "_test.go$" current-file)
           (setq tmp-file (replace-regexp-in-string "_test.go$" ".go" tmp-file)))
          ((string-match ".go$" current-file)
           (setq tmp-file (replace-regexp-in-string ".go$" "_test.go" tmp-file))))
    (unless (eq current-file tmp-file)
      (find-file tmp-file))))

;;; 46-go-mode.el ends here
