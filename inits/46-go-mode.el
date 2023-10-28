;;; 46-go-mode.el --- go-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'go-mode)
(require 'open-godoc)

(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)
(add-hook 'go-mode-hook
          '(lambda()
             (setq indent-tabs-mode t)
             (setq go-test-verbose t)
             (common-mode-init)
             (company-mode)
             (flycheck-golangci-lint-setup)
             (copilot-mode)))

;; Change godoc buffer name
(defun godoc--get-buffer (query)
  "Get an empty buffer for a godoc QUERY."
  (let* ((buffer-name "*godoc*")
         (buffer (get-buffer buffer-name)))
    ;; Kill the existing buffer if it already exists.
    (when buffer (kill-buffer buffer))
    (get-buffer-create buffer-name)))

;; Docoument Popup
(defun godoc-popup ()
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
(defun go-toggle-to-test-file ()
  (interactive)
  (go-internal-toggle-to-test-file))

;; Open a go file and a test file side by side
(defun go-open-with-test-file ()
  (interactive)
  (other-window-or-split)
  (go-internal-toggle-to-test-file))

(defun go-internal-toggle-to-test-file ()
  (let ((current-file (buffer-file-name))
        (tmp-file (buffer-file-name)))
    (cond ((string-match "_test.go$" current-file)
           (setq tmp-file (replace-regexp-in-string "_test.go$" ".go" tmp-file)))
          ((string-match ".go$" current-file)
           (setq tmp-file (replace-regexp-in-string ".go$" "_test.go" tmp-file))))
    (unless (eq current-file tmp-file)
      (find-file tmp-file))))

;;; 46-go-mode.el ends here
