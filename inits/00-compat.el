;;; 00-compat.el --- compatibility helpers for Emacs 30 -*- lexical-binding: t; -*-

;;; Code:

;; ELPA packages built for Emacs 31 still use the legacy `incf' alias.
(require 'cl)

(unless (fboundp 'set-local)
  (defun set-local (variable value)
    (set (make-local-variable variable) value)))

(unless (fboundp 'any)
  (defun any (pred list)
    (cl-member-if pred list)))

(unless (fboundp 'all)
  (defun all (pred list)
    (cl-every pred list)))

;; Emacs 31's compile-time conditional macros, used by current Magit/Transient.
(unless (macrop 'static-when)
  (defmacro static-when (condition &rest body)
    (declare (indent 1))
    (when (eval condition t)
      `(progn ,@body))))
(unless (macrop 'static-unless)
  (defmacro static-unless (condition &rest body)
    (declare (indent 1))
    (unless (eval condition t)
      `(progn ,@body))))

;;; 00-compat.el ends here
