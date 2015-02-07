;;; helm-xcdoc.el --- GNU GLOBAL helm interface  -*- lexical-binding: t; -*-

;; Copyright (C) 2015 by Ryo Fujimoto

;; Author: Ryo Fujimoto <fujimisakri@gmail.com>
;; URL: https://github.com/fujimisakari/emacs-helm-xcdoc
;; Version: 20150127.802
;; X-Original-Version: 1.4.6
;; Package-Requires: ((helm "1.5.6") (cl-lib "0.5"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; `helm-xcdoc.el' is a `helm' interface of GNU Global.
;; `helm-gtags.el' is not compatible `anything-gtags.el', but `helm-gtags.el'
;; is designed for fast search.

;;
;; To use this package, add these lines to your init.el or .emacs file:
;;
;;     (require 'helm-xcdoc)
;;     (setq xcdoc:document-path "/Developer/Platforms/iPhoneOS.platform/Developer/Documentation/DocSets/com.apple.adc.documentation.AppleiPhone3_1.iPhoneLibrary.docset")
;;     (setq xcdoc:open-w3m-other-buffer t) ;if you like
;;
;;     to change docset-path
;;     M-x xcdoc:set-document-path
;;
;;     to search document
;;     M-x xcdoc:search
;;
;;     to search document symbol at point
;;     M-x xcdoc:search-at-point
;;
;;     to select query then search
;;     M-x xcdoc:ask-search
;;

;;; Code:

(require 'helm)
(require 'helm-utils)

(defgroup helm-xcdoc nil
  "GNU GLOBAL for helm"
  :group 'helm)

(defcustom helm-xcdoc-command-path nil
  ""
  :group 'helm-xcdoc)

(defcustom helm-xcdoc-command-option nil
  "Command line option of `ag'. This is appended after `helm-ag-base-command'"
  :type 'string
  :group 'helm-xcdoc)

(defcustom helm-xcdoc-document-path nil
  "please set docset full path like:
\"/Developer/Platforms/iPhoneOS.platform/Developer/Documentation/DocSets/com.apple.adc.documentation.AppleiPhone3_1.iPhoneLibrary.docset\""
  :group 'helm-xcdoc)

(defcustom helm-xcdoc-maximum-candidates 100
  "Maximum number of helm candidates"
  :type 'integer
  :group 'helm-xcdoc)

(defcustom helm-xcdoc-log-level 3
  "Logging level, only messages with level lower or equal will be logged.
-1 = NONE, 0 = ERROR, 1 = WARNING, 2 = INFO, 3 = DEBUG"
  :type 'integer
  :group 'helm-xcdoc)

(defvar helm-xcdoc--query nil)

(defconst helm-xcdoc--buffer "*helm xcdoc*")

(defun helm-xcdoc-log (level text &rest args)
  "Log a message at level LEVEL.
If LEVEL is higher than `helm-xcdoc-log', the message is
ignored.  Otherwise, it is printed using `message'.
TEXT is a format control string, and the remaining arguments ARGS
are the string substitutions (see `format')."
  (if (<= level helm-xcdoc-log-level)
      (let* ((msg (apply 'format text args)))
        (message "%s" msg))))

(defun helm-xcdoc--construct-command (query docset)
  (unless (executable-find helm-xcdoc-command-path)
    (error "'docsetutil' is not installed."))
  (unless (file-directory-p helm-xcdoc-document-path)
    (error "Document Directory not found"))
  (let ((cmds (list helm-xcdoc-command-path)))
    (setq cmds (append cmds (list "search -query" query)))
    (when helm-xcdoc-command-option
      (setq cmds (append cmds (list helm-xcdoc-command-option))))
    (setq cmds (append cmds (list helm-xcdoc-document-path)))
    (mapconcat 'identity cmds " ")))

(defun helm-xcdoc--excecute-search (query docset)
  (let ((cmd (helm-xcdoc--construct-command query docset))
        (call-shell-command-fn 'shell-command-to-string))
    (helm-xcdoc-log 3 "shell command: %s" cmd)
    (funcall call-shell-command-fn cmd)))

(defun helm-xcdoc--remove-hash (s)
  (replace-regexp-in-string (rx "#//" (* not-newline)) "" s))

(defun helm-xcdoc--construct-candidates-from-command-res (res)
  (let ((los (split-string res "\n")))
    (setq los (remove-if-not (lambda (s) (string-match ".*\\.html.*" s)) los))
    (setq los (mapcar (lambda (s) (car (last (split-string s " "))))
                      (mapcar 'helm-xcdoc--remove-hash los)))
    (sort (delete-dups los) 'string<)))

(defun helm-xcdoc--catdir (s1 s2)
  (let ((s1 (replace-regexp-in-string (rx "/" eol) "" s1))
        (s2 (replace-regexp-in-string (rx bol "/") "" s2)))
    (concat s1 "/" s2)))

(defun helm-xcdoc--extract-html (file-path)
  (let ((get-html-path (lambda (docpath html-return-search)
                         (helm-xcdoc--catdir (helm-xcdoc--catdir docpath "Contents/Resources/Documents/") html-return-search))))
    (funcall get-html-path (expand-file-name helm-xcdoc-document-path) file-path)))

(defun helm-xcdoc--open-eww (file-path &optional new-session)
  (let (buf current-buffer)
    (eww-open-file (helm-xcdoc--extract-html file-path))
    (switch-to-buffer buf)
    (pop-to-buffer "*eww*")))

(defun helm-xcdoc--search-init ()
  (let ((buf-coding buffer-file-coding-system))
    (with-current-buffer (helm-candidate-buffer 'global)
      (let ((coding-system-for-read buf-coding)
            (coding-system-for-write buf-coding))
        (mapcar (lambda (row)
                  (insert (concat row "\n")))
                (helm-xcdoc--construct-candidates-from-command-res
                 (helm-xcdoc--excecute-search helm-xcdoc--query helm-xcdoc-document-path)))
        (if (zerop (length (buffer-string)))
            (error "No output: '%s'" helm-xcdoc--query))))))

(defvar helm-source-xcdoc-search
  (helm-build-in-buffer-source "Xcode Document List"
    :init 'helm-xcdoc--search-init
    :candidate-number-limit helm-xcdoc-maximum-candidates
    ;; :real-to-display 'helm-gtags--candidate-transformer
    ;; :persistent-action 'helm-gtags--persistent-action
    ;; :fuzzy-match helm-gtags-fuzzy-match
    :action 'helm-xcdoc--open-eww))

(defun helm-xcdoc--search-prepare (srcs query)
  (let ((symbol-name-at-cursor (thing-at-point 'symbol)))
    (if (and (string= query "") (not symbol-name-at-cursor))
        (error "Input is empty!!"))
    (if (string= query "")
        (setq helm-xcdoc--query symbol-name-at-cursor)
      (setq helm-xcdoc--query query))
    (helm-xcdoc-log 3 "helm-xcdoc--query %s" helm-xcdoc--query)
    (helm :sources srcs :buffer helm-xcdoc--buffer)))

(defun helm-xcdoc--prompt ()
  (let ((symbol-name-at-cursor (thing-at-point 'symbol)))
    (if symbol-name-at-cursor
        (read-string (format "Search word(default \"%s\"): " symbol-name-at-cursor))
      (read-string "Search word: "))))

;;;###autoload
(defun helm-xcdoc-search (query)
  "search document"
  (interactive (list (helm-xcdoc--prompt)))
  (helm-xcdoc--search-prepare '(helm-source-xcdoc-search) query))

(provide 'helm-xcdoc)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:

;;; helm-xcdoc.el ends here
