;;; 66-plantuml-mode.el --- plantuml-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'plantuml-mode)

(add-to-list 'auto-mode-alist '("\\.pu\\'" . plantuml-mode))
(add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))

;; 日本語を含むUMLを書く場合はUTF-8を指定
(setq plantuml-output-type "png")
(setq plantuml-default-exec-mode 'executable)
(setq plantuml-executable-path "plantuml")
(setq plantuml-executable-args (append plantuml-executable-args '("-charset" "UTF-8")))

;; Open a plantuml file and a png file side by side
(defun plantuml-open-with-png-file ()
  (interactive)
  (other-window-or-split)
  (plantuml-internal-toggle-to-png-file))

(defun plantuml-internal-toggle-to-png-file ()
  (let ((current-file (buffer-file-name))
        (tmp-file (buffer-file-name)))
    (cond ((string-match ".png$" current-file)
           (setq tmp-file (replace-regexp-in-string ".png$" ".puml" tmp-file)))
          ((string-match ".puml$" current-file)
           (setq tmp-file (replace-regexp-in-string ".puml$" ".png" tmp-file))))
    (unless (eq current-file tmp-file)
      (find-file tmp-file))))

;;; 66-plantuml-mode.el ends here
