;;; text-translator-pos-tip.el --- Text Translator

;; Copyright (C) 2011  khiker

;; Author: khiker <khiker.mail+elisp@gmail.com>

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

;; `pos-tip' support for text-translator.el

;;; Code:

(require 'pos-tip)
(require 'text-translator-vars)


;; Variables:

(defcustom text-translator-pos-tip-timeout 0
  "*The seconds of hiding tooltip automatically.
The default is 0. It's means not hiding."
  :type  'integer
  :group 'text-translator)

(defcustom text-translator-pos-tip-tip-color nil
  "*The tooltip color.The value is the face or a cons cell like
\(FOREGROUND-COLOR . BACKGROUND-COLOR\).
The default is nil."
  :type  '(cons (string :tag "foreground-color.")
                (string :tag "background-color."))
  :group 'text-translator)

(defcustom text-translator-pos-tip-separator-face 'font-lock-keyword-face
  "*The separator face of each engine in `text-translator-all'."
  :type  'symbol
  :group 'text-translator)

;; Functions:

(defun text-translator-pos-tip-display ()
  "Display a translation result by `pos-tip-show'.
If you want to use this function for displaying translation
result, please add a following code to your .emacs.

\(setq text-translator-display-function 'text-translator-pos-tip-display\)"
  (cond
   ((= 1 text-translator-all-site-number)
    (text-translator-pos-tip-show (cdar text-translator-all-results)))
   (t
    (text-translator-pos-tip-show
     (mapconcat
      #'(lambda (x)
          (let ((engine  (substring (car x)
                                    (length text-translator-buffer)))
                (str     (cdr x)))
            (concat (propertize (concat "----- " engine " -----")
                                'face text-translator-pos-tip-separator-face)
                    "\n\n" str "\n")))
      (sort text-translator-all-results
            #'(lambda (x y) (string< (car x) (car y))))
      "\n")))))

(defun text-translator-pos-tip-show (msg)
  "Internal function of `text-translator-pos-tip-display'."
  (pos-tip-show-no-propertize
   msg
   text-translator-pos-tip-tip-color
   nil
   nil
   text-translator-pos-tip-timeout))


(provide 'text-translator-pos-tip)

;;; text-translator-pos-tip.el ends here
