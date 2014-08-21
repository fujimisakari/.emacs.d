;;; web-mode.el --- major mode for editing html templates
;;; -*- coding: utf-8 -*-

;; Copyright 2011-2014 François-Xavier Bois

;; Version: 9.0.28
;; Author: François-Xavier Bois <fxbois AT Google Mail Service>
;; Maintainer: François-Xavier Bois
;; Created: July 2011
;; Keywords: html template php javascript js css web
;;           django jsp asp erb twig jinja blade dust closure
;;           freemarker mustache velocity cheetah smarty
;; URL: http://web-mode.org
;; Repository: http://github.com/fxbois/web-mode

;; =========================================================================
;; This work is sponsored by Kernix : Digital Agency (Web & Mobile) in Paris
;; =========================================================================

;; This file is not part of Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;; Code goes here

;;todo :
;;       web-mode-part|block-extra-keywords
;;       web-mode-surround : chaque ligne est entourée par un open et un close tag
;;       tester web-mode avec un fond blanc
;;       web-mode-extra-constants
;;       web-mode-extra-keywords + engines + javascript + comment
;;       phphint

;;todo : Stickiness of Text Properties
;;todo : web-mode-engine-real-name (canonical name)
;;todo : finir filling
;;todo : screenshot : http://www.cockos.com/licecap/
;;todo : passer les content-types en symboles
;;todo : tester shortcut A -> pour pomme

(defconst hatena-keyward-mode-version "1.0.00"
  "Hatena Keyword Mode version.")

(defgroup hatena-keyward-mode nil
  "Major mode for editing web templates:
   html files embedding parts (css/javascript)
   and blocks (php, erb, django/twig, smarty, jsp, asp, etc.)"
  :group 'languages
  :prefix "hatena-keyward-"
  :link '(url-link :tag "Site" "http://web-mode.org")
  :link '(url-link :tag "Repository" "https://github.com/fxbois/web-mode"))

(defgroup hatena-keyward-faces nil
  "Faces for syntax highlighting."
  :group 'hatena-keyward-mode
  :group 'faces)

(defface hatena-keyward-title
  '((((class color) (background light))
     (:foreground "blue"
      :weight bold :height 1.3))
    (((class color) (background dark))
     (:foreground "lime green"
      :weight bold :height 1.3)))
  "Face used for displaying anchors."
  :group 'hatena-keyward-faces)

(defface hatena-keyward-separator
  '((((class color) (background light))
     (:foreground "blue"
      :weight bold :height 1.3))
    (((class color) (background dark))
     (:foreground "lime green"
      :weight bold :height 1.3)))
  "Face used for displaying anchors."
  :group 'hatena-keyward-faces)

(defface hatena-keyward-h3
  '((((class color) (background light))
     (:foreground "blue"
      :weight bold :height 1.1))
    (((class color) (background dark))
     (:foreground "yellow"
      :weight bold :height 1.1)))
  "Face used for displaying anchors."
  :group 'hatena-keyward-faces)

(defface hatena-keyward-h4
  '((((class color) (background light))
     (:foreground "blue"
      :weight bold :height 1.0))
    (((class color) (background dark))
     (:foreground "DeepSkyBlue"
      :weight bold :height 1.0)))
  "Face used for displaying anchors."
  :group 'hatena-keyward-faces)

(defface hatena-keyward-h5
  '((((class color) (background light))
     (:foreground "blue"
      :weight bold :height 1.0))
    (((class color) (background dark))
     (:foreground "magenta"
      :weight bold :height 1.0)))
  "Face used for displaying anchors."
  :group 'hatena-keyward-faces)

(defvar hatena-keyword-title-separator "="
  "Keyword title.")

(defvar hatena-keyword-subtitle-separator "-"
  "Keyword title.")

(defvar hatena-keyword-title ""
  "Keyword title.")

(defvar hatena-keyword-separator ""
  "Keyword title.")

(defvar hatena-keyword-furigana ""
  "Keyword title.")

(defvar hatena-keyword-description ""
  "Keyword title.")

(defvar hatena-keyword-buffer-string ""
  "Keyword title.")

(defvar hatena-keyword-escape-html-alist
  '(("&#91;" . "\[") ("&#93;" . "\]") ("&#8217;" . "\'") ("&quot;" . "\"")
    ("mdash" . "\?") ("&#8482;" . " TM") ("&#24389;". "彅") ("&gt;". ">")
    ("&lt;". "<")))

(defvar hatena-keyword-all-replace-html-alist
  '(("</item>" . "") ("\n" . "") ("\\s " . "")))

(defvar hatena-keyword-replace-html-alist
  '(("</li>" . "\n") ("</p>" . "\n") ("\\]\\]>" . "") ("<!\\[CDATA\\[" . "")
    ("<br>" . "\n") ("</th>" . "  ") ("<tr>" . "\n") ("</td>" . "  ")
    ("</ul>" . "\n") ("</table>" . "\n") ("</dd>" . "\n\n") ("</dt>" . "\n  ")
    ("</dl>" . "\n") ("</blockquote>" . "\n") ("</pre>" . "\n")))
  ;; '(("</li>" . "\n") ("</p>" . "\n") ("\\]\\]>" . "") ("<!\\[CDATA\\[" . "")
  ;;   ("<br>" . "\n") ("</th>" . "  ") ("<tr>" . "\n") ("</td>" . "  ")
  ;;   ("</ul>" . "\n") ("</table>" . "\n") ("</dd>" . "\n\n") ("</dt>" . "\n  ")
  ;;   ("</dl>" . "\n") ("</blockquote>" . "\n") ("</pre>" . "\n") ("\\s " . " ")))


(defconst hatena-keyword-buffer-name "*hatena-keyword*")
(defconst hatena-keyword-proc-name "hatena-keyword-proc")

(defun hatena-keyword-title-set (html)
  (let ((title "")
        (furigana ""))
    (string-match "<title>\\(.*\\)</title>" html)
    (setq title (match-string 1 html))
    (string-match "<hatena:furigana>\\(.*\\)</hatena:furigana>" html)
    (setq furigana (match-string 1 html))
    (setq hatena-keyword-title (format "%s(%s)" title furigana))))

(defun hatena-keyword-separator-set (str)
  (setq hatena-keyword-separator "")
  (let ((i 0))
    (while (< i (string-width hatena-keyword-title))
      (setq hatena-keyword-separator (concat hatena-keyword-separator str))
      (setq i (+ i 1)))))

(defun hatena-keyword-replace-regexp (regexp-list)
  (let ((replace-regexp-func (lambda (regexp) (replace-regexp-in-string (car regexp) (cdr regexp) hatena-keyword-buffer-string))))
    (dolist (regexp regexp-list)
      (setq hatena-keyword-buffer-string (funcall replace-regexp-func regexp)))))

(defun hatena-keyword-replace-string (html replace-alist)
  (let ((replace-html-func (lambda (replace-cons html) (replace-regexp-in-string (car replace-cons) (cdr replace-cons) html))))
    (dolist (replace-cons replace-alist)
      (setq html (funcall replace-html-func replace-cons html)))
    html))

(defun hatena-keyword-html-formatter (html)
  (string-match "<content:encoded>\\(.*\\)</content:encoded>" html)
  (setq html (match-string 1 html))
  (setq html (hatena-keyword-replace-string html hatena-keyword-escape-html-alist))
  (setq html (hatena-keyword-replace-string html hatena-keyword-replace-html-alist))
  html)

(defun hatena-keyword-line-formatter ()
  (goto-char (point-min))
  (while (re-search-forward "\n+" nil t)
    (replace-match "\n"))
  (goto-char (point-min))
  (forward-line 1)
  (while (< (point) (point-max))
    (let ((text-property (get-text-property (point) 'face)))
      (cond
       ((equal text-property 'hatena-keyward-title)
        (insert "\n\n"))
       ((or (eq text-property 'hatena-keyward-h3) (eq text-property 'hatena-keyward-h4) (eq text-property 'hatena-keyward-h5))
        (insert "\n"))))
    (forward-line 1)))

(defun hatena-keyword-decorate-subtitle ()
  (goto-char (point-min))
  (while (re-search-forward "<h3.*?>.*?</h3>" nil t)
    (insert " -")
    (goto-char (point-at-bol))
    (insert "\n- ")
    (put-text-property (point-at-bol) (point-at-eol) 'face 'hatena-keyward-h3)
    (goto-char (point-at-eol)))
  (goto-char (point-min))
  (while (re-search-forward "<h4.*?>.*?</h4>" nil t)
    (let ((begin-point (point-at-bol))
          (end-point (point)))
      (goto-char (point-at-bol))
      (insert "\n-- ")
      (goto-char (- end-point 1))
      (insert " --\n")
      (put-text-property begin-point (+ end-point 3) 'face 'hatena-keyward-h4)))
  (goto-char (point-min))
  (while (re-search-forward "<h5.*?>.*?</h5>" nil t)
    (let ((end-point (point)))
      (goto-char (point-at-bol))
      (insert "\n■ ")
      (put-text-property (point-at-bol) end-point 'face 'hatena-keyward-h5)
      (goto-char (- end-point 2))
      (insert "\n"))))

(defun hatena-keyword-fetch-databytes (url)
  (with-temp-buffer
    (set-buffer-multibyte nil)
    (call-process
     shell-file-name nil t nil shell-command-switch
     (format "wget -q -O - %s" url))
    (buffer-string)))

(defun hatena-keyword-create-image (url)
  (create-image
   (hatena-keyword-fetch-databytes url)
   nil t))

(defun hatena-keyword-image-formatter ()
  (goto-char (point-max))
  (while (re-search-backward "<img.*?>" nil t)
    (let ((img-tag (buffer-substring-no-properties (point) (point-at-eol))))
      (when (string-match "<img.*?src=\"\\(.*?\\)\".*?>" img-tag)
        (insert-image (hatena-keyword-create-image (match-string 1 img-tag)))
        (insert "  ")))))

(defun hatena-keyword-initialize ()
  (if (get-buffer hatena-keyword-buffer-name)
      (kill-buffer hatena-keyword-buffer-name))
  (setq hatena-keyword-title "")
  (setq hatena-keyword-separator "")
  (setq hatena-keyword-furigana "")
  (setq hatena-keyword-description "")
  (setq hatena-keyword-buffer-string ""))

(defun hatena-keyword-http-client (search-word)
  "Fetch FILENAME from the Emacs Wiki's elisp area."
  (let* ((proc (open-network-stream hatena-keyword-proc-name
                                    hatena-keyword-buffer-name
                                    ;; These should perhaps not be hardcoded.
                                    "d.hatena.ne.jp"
                                    80))
         (buf (process-buffer proc))
         (retval nil))

    (process-send-string proc
     (format(concat
             (format "GET /keyword?word=%s&mode=rss&ie=utf8 HTTP/1.0\r\n" search-word)
             "HOST: d.hatena.ne.jp\r\n"
             "\r\n")))

    ;; Watch us spin and stop Emacs from doing anything else!
    (while (equal (process-status proc) 'open)
      (when (not (accept-process-output proc 180))
        (delete-process proc)
        (error "Network timeout!")))

    (with-current-buffer buf
      (goto-char (point-min))
      (if (looking-at "^HTTP/1.1 200 OK")
          (setq retval t)
        (error "Unable to fetch from the Emacs Wiki.")))
    retval))

(defun hatena-keyword-controller (search-word)
  (hatena-keyword-initialize)
  (if (hatena-keyword-http-client search-word)
      (with-current-buffer (get-buffer-create hatena-keyword-buffer-name)
        (setq hatena-keyword-buffer-string (buffer-string))
        (erase-buffer)
        (hatena-keyword-replace-regexp hatena-keyword-all-replace-html-alist)
        (dolist (html (cdr (split-string hatena-keyword-buffer-string "<item[^s].*?>")))
          (progn
            ;; create title
            (hatena-keyword-title-set html)
            (insert hatena-keyword-title)
            (put-text-property (point-at-bol) (point-at-eol) 'face 'hatena-keyward-title)
            (insert "\n")
            ;; create separator
            (hatena-keyword-separator-set hatena-keyword-title-separator)
            (insert hatena-keyword-separator)
            (put-text-property (point-at-bol) (point-at-eol) 'face 'hatena-keyward-separator)
            (insert "\n")
            ;; create description
            (setq html (hatena-keyword-html-formatter html))
            (insert html)
            ;; decorate subtitle
            (hatena-keyword-decorate-subtitle)
            ;; A new-line is arranged.
            (hatena-keyword-line-formatter)
            ;; create image
            (hatena-keyword-image-formatter)
            ;; remove html tag
            (goto-char (point-min))
            (while (re-search-forward "<.*?>" nil t)
              (replace-match ""))
            (insert "\n")))
        (setq buffer-read-only t)
        (pop-to-buffer (current-buffer))
        (goto-char (point-min)))))

;; マイケル・ジャクソン
;; tokio
;; v6
;; 本能寺の変
;; ジョジョの奇妙な冒険
;; 進撃の巨人
;; FIFAワールドカップ
;; はてな
;; サザンオールスターズ
;; iphone
;; http://d.hatena.ne.jp/keyword?word=%E3%81%AF%E3%81%A6%E3%81%AA&mode=rss&ie=utf8
;; http://d.hatena.ne.jp/keyword/%E3%81%AF%E3%81%A6%E3%81%AA

(defun hatena-keyword-region-or-read-string ()
  (cond
   (mark-active
    (buffer-substring-no-properties (region-beginning) (region-end)))
   (t
    (read-string "Enter search word: "))))

(defun hatena-keyword-start ()
  (interactive)
  (let ((search-word (hatena-keyword-region-or-read-string)))
    (hatena-keyword-controller search-word)))

(provide 'hatena-keyword-mode)

;;; hatena-keyword-mode.el ends here
