;;; text-translator-popup.el --- Text Translator

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

;; The `popup.el' support for text-translator.el
;;
;; Todo: do customizable: keymap, option of popup-tip etc...

;;; Code:

(require 'popup)
(require 'text-translator-vars)


;; Variables:

(defvar text-translator-popup-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-p" 'popup-scroll-up)
    (define-key map "\C-n" 'popup-scroll-down)
    map)
  "*The keymap for `text-translator-popup-display'.")


;; Functions:

(defun text-translator-popup-display ()
  "Display a translation result by `popup-tip'.
If you want to use this function for displaying translation
result, please add a following code to your .emacs.

\(setq text-translator-display-function 'text-translator-popup-display\)"
  (cond
   ((= 1 text-translator-all-site-number)
    (popup-tip (cdar text-translator-all-results) :margin t))
   (t
    (let ((tip
           (popup-tip
            (mapconcat
             #'(lambda (x)
                 (let ((engine  (substring (car x)
                                           (length text-translator-buffer)))
                       (str     (cdr x)))
                   (concat "----- " engine " -----" "\n\n" str "\n")))
             (sort text-translator-all-results
                   #'(lambda (x y) (string< (car x) (car y))))
             "\n")
            :margin t
            :nowait t
            :scroll-bar t))
          (loop t)
          key binding command)
      (unwind-protect
          (progn
            (while loop
              (setq key (read-key-sequence-vector "")
                    binding (lookup-key text-translator-popup-keymap key))
              (cond
               ((eq binding 'popup-scroll-up)
                (popup-scroll-up tip))
               ((eq binding 'popup-scroll-down)
                (popup-scroll-down tip))
               ((commandp binding)
                (call-interactively binding))
               (t
                (when (setq command (key-binding key))
                  (setq loop nil))))))
        (popup-delete tip))
      (when command
        (call-interactively command))))))

(provide 'text-translator-popup)

;;; text-translator-popup.el ends here
