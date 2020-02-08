;;; 97-gamewith.el --- gamewith設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defvar gamewith--path-to-app "/dev/gamewith/gamewith/fuel/app/classes")

(defun gamewith--format-to-app-path (path)
  (let ((remove-path (concat (getenv "HOME") gamewith--path-to-app "/")))
    (replace-regexp-in-string remove-path "" path)))

;;;
;;; helm search gamewith class
;;;
(defvar helm-gamewith--candidates-cache '())

(defun helm-gamewith--construct-command-for-class ()
  (let* ((cmd "grep")
         (opt1 "-r class")
         (path (concat (getenv "HOME") gamewith--path-to-app))
         (opt2 "| grep -v 'php#' | sed -e 's/.php:.*//' | grep -v controller | uniq")
         (cmds (list cmd opt1 path opt2)))
    (mapconcat 'identity cmds " ")))

(defun helm-gamewith--construct-command-for-trait ()
  (let* ((cmd "grep")
         (opt1 "-r trait")
         (path (concat (getenv "HOME") gamewith--path-to-app))
         (opt2 "| grep -v 'php#' | sed -e 's/.php:.*//' | grep -v controller | uniq")
         (cmds (list cmd opt1 path opt2)))
    (mapconcat 'identity cmds " ")))

(defun helm-gamewith--excecute-command (cmd-str)
  (let ((call-shell-command-fn 'shell-command-to-string))
    (funcall call-shell-command-fn cmd-str)))

(defun helm-gamewith--string-format (app-path)
  (let ((path-element '())
        (full-path nil))
    (dolist (path (split-string (gamewith--format-to-app-path app-path) "/"))
      (setq path-element (append path-element (list path))))
    (setq full-path (s-join "\\" (mapcar `s-upper-camel-case path-element)))
    (setq full-path (replace-regexp-in-string "Db" "DB" full-path))
    (replace-regexp-in-string "Gamewith" "GameWith" full-path)))

(defun helm-gamewith--get-candidates ()
  (if (null helm-gamewith--candidates-cache)
      (let* ((class-result (helm-gamewith--excecute-command (helm-gamewith--construct-command-for-class)))
             (trait-result (helm-gamewith--excecute-command (helm-gamewith--construct-command-for-trait)))
             (candidates (split-string class-result "\n"))
             (candidates (append candidates (split-string trait-result "\n")))
             (candidates (mapcar 'helm-gamewith--string-format candidates))
             (candidates (sort candidates 'string<)))
        (setq helm-gamewith--candidates-cache candidates)
        candidates)
    helm-gamewith--candidates-cache))

(defun helm-gamewith--funcall (name)
  (insert (format "\\%s" name)))

(defun helm-gamewith--search-init ()
  (let ((buf-coding buffer-file-coding-system))
    (with-current-buffer (helm-candidate-buffer 'global)
      (let ((coding-system-for-read buf-coding)
            (coding-system-for-write buf-coding))
        (mapc (lambda (row) (insert (concat row "\n"))) (helm-gamewith--get-candidates))))))

(defvar helm-source-gamewith-class-search
  (helm-build-in-buffer-source "Search Gamewith Class"
    :init 'helm-gamewith--search-init
    :candidate-number-limit 300
    :action 'helm-gamewith--funcall))

(defun helm-gamewith-class-search ()
  "Gamewith Class Search"
  (interactive)
  (helm :sources '(helm-source-gamewith-class-search) :buffer "*helm gamewith class search*"))

(defun helm-gamewith-cache-clear ()
  (interactive)
  (setq helm-gamewith--candidates-cache '()))

;;;
;;; Namespace
;;;
(defun gamewith-insert-namespace ()
  (interactive)
  (let ((app-path (gamewith--format-to-app-path (buffer-file-name)))
        (path-element '())
        (namespace nil))
    (dolist (path (split-string app-path "/"))
      (unless (string-match ".*\.php" path)
        (setq path-element (append path-element (list path)))))
    (setq namespace (s-join "\\" (mapcar `s-upper-camel-case path-element)))
    (setq namespace (replace-regexp-in-string "Db" "DB" namespace))
    (setq namespace (replace-regexp-in-string "Gamewith" "GameWith" namespace))
    (insert (format "<?php namespace %s;" namespace))))

;;;
;;; gamewith-open-view-file
;;;
(defun gamewith-open-view-file ()
  (interactive)
  (let* ((file-path (buffer-substring-no-properties (region-beginning) (region-end)))
         (file-path (format "~/dev/gamewith/gamewith/fuel/app/views/%s.php" file-path)))
    (other-window-or-split)
    (find-file file-path)))

;;; 97-gamewith.el ends here
