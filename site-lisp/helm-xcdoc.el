;;; helm-xcdoc.el --- GNU GLOBAL helm interface  -*- lexical-binding: t; -*-

;; Copyright (C) 2015 by Syohei YOSHIDA

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

(require 'cl-lib)
(require 'helm)
(require 'helm-utils)
(require 'thingatpt)

(defgroup helm-xcdoc nil
  "GNU GLOBAL for helm"
  :group 'helm)

(defcustom helm-xcdoc-document-path nil
  "please set docset full path like:
\"/Developer/Platforms/iPhoneOS.platform/Developer/Documentation/DocSets/com.apple.adc.documentation.AppleiPhone3_1.iPhoneLibrary.docset\""
  :group 'helm-xcdoc)

(defcustom helm-xcdoc-document-path nil
  ""
  :group 'helm-xcdoc)

(defun helm-xcdoc--docsetutil-command ()
  helm-xcdoc-command-path)

(defun* helm-xcdoc--search-command (query docset)
  (format "%s search -query %s %s"
          (helm-xcdoc--docsetutil-command)
          (shell-quote-argument query)
          docset))

(defun* helm-xcdoc--excecute-search (&key query docset (call-shell-command-fn 'shell-command-to-string))
  "call shell command like:
\"/Developer/usr/bin/docsetutil search -query  'View'  /Developer/Platforms/iPhoneOS.platform/Developer/Documentation/DocSets/com.apple.adc.documentation.AppleiPhone3_1.iPhoneLibrary.docset\""
  (funcall call-shell-command-fn
           (helm-xcdoc--search-command query docset)))

(defun helm-xcdoc--catdir (s1 s2)
  (let ((s1 (replace-regexp-in-string (rx "/" eol) "" s1))
        (s2 (replace-regexp-in-string (rx bol "/") "" s2)))
    (concat s1 "/" s2)))

(defun helm-xcdoc--build-candidates-from-command-res (res)
  (let* ((los (split-string res "\n"))
         (los (remove-if-not (lambda (s) (string-match ".*\\.html.*" s)) los)))
    (mapcar (lambda (s) (car (last (split-string s " ")))) los)))

(defun helm-xcdoc--remove-hash (s)
  (replace-regexp-in-string (rx "#//" (* not-newline)) "" s))

;; (helm-xcdoc-extract-html "1.000 documentation/UIKit/Reference/UIView_Class/index.html")
;; (helm-xcdoc-extract-html "Objective-C/cl/-/UIView   documentation/UIKit/Reference/UIView_Class/UIView/UIView.html#//apple_ref/occ/cl/UIView")
(defun helm-xcdoc--extract-html (line)
  (let ((get-html-path (lambda (docpath html-return-search)
                         (helm-xcdoc--catdir (helm-xcdoc--catdir docpath "Contents/Resources/Documents/") html-return-search))))
    (cond
     ((string-match (rx (group (+ (any alnum "/" "_")) ".html" (* (any alnum "/" "#" "_"))))
                    line)
      (helm-xcdoc--remove-hash
       (funcall get-html-path (expand-file-name helm-xcdoc-document-path) (match-string 1 line))))
     (t
      (error "cant find text like URL!!")))))

;;(w3m-browse-url (helm-xcdoc-extract-html" Objective-C/cl/-/UIView   documentation/UIKit/Reference/UIView_Class/UIView/UIView.html#//apple_ref/occ/cl/UIView"))
(defun helm-xcdoc--open-eww (url &optional new-session)
   (eww-open-file (helm-xcdoc--extract-html url)))

(defun helm-xcdoc--search-init ()
  (with-current-buffer (helm-candidate-buffer 'global)
    (dolist (row (helm-xcdoc--build-candidates-from-command-res
                  (helm-xcdoc--excecute-search
                   :query "UITableView"
                   :docset helm-xcdoc-document-path)))
      (insert row)
      (insert "\n"))))

(defvar helm-source-xcdoc-search
  (helm-build-in-buffer-source "Jump to definitions"
    :init 'helm-xcdoc--search-init
    :candidate-number-limit 50
    ;; :real-to-display 'helm-gtags--candidate-transformer
    ;; :persistent-action 'helm-gtags--persistent-action
    ;; :fuzzy-match helm-gtags-fuzzy-match
    :action 'helm-xcdoc--open-eww))

(defun helm-xcdoc-search ()
  "Jump to definition"
  (interactive)
  (helm :sources '(helm-source-xcdoc-search) :buffer "*helm-xcdoc*"))

(provide 'helm-xcdoc)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:

;;; helm-xcdoc.el ends here
