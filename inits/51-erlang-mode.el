;;; 51-erlang-mode.el --- erlang-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; 基本設定

(require 'erlang-start)
(require 'erlang)

(add-hook 'erlang-mode-hook
          '(lambda()
             (common-mode-init)
             (flycheck-mode)))

(defun insert-erlang-arrow ()
  (interactive)
  (insert "->")
  (cond
   ;; Did we just write a bit-syntax close (`>>')?
   ((erlang-after-bitsyntax-close)
    (save-excursion
      ;; Then mark the two chars...
      (backward-char 2)
      (put-text-property (point) (1+ (point))
                         'category 'bitsyntax-close-inner)
      (forward-char)
      (put-text-property (point) (1+ (point))
                         'category 'bitsyntax-close-outer)
      ;;...and unmark any subsequent greater-than chars.
      (forward-char)
      (while (eq (char-after (point)) ?>)
        (remove-text-properties (point) (1+ (point))
                                '(category nil))
        (forward-char))))

   ;; Did we just write a function arrow (`->')?
   ((erlang-after-arrow)
    (let ((erlang-electric-newline-inhibit t))
      (undo-boundary)
      (end-of-line)
      (newline)
      (condition-case nil
          (erlang-indent-line)
        (error (if (bolp) (delete-char -1))))))

   ;; Then it's just a plain greater-than.
   (t
    nil)))

;;; 51-erlang-mode.el ends here
