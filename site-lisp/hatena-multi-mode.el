(require 'multi-mode)
(require 'multi-mode-util)
(eval-when-compile (require 'cl))

(defvar hatena-mm-langs nil)
(defvar hatena-mm-file-types nil)
(make-variable-buffer-local 'hatena-mm-file-types)

(defgroup hatena-multi-mode nil
  "Multi modes for Hatena super-pre syntax."
  :group 'hypermedia)

(defcustom hatena:mm:check-supported-languages t
  "Do not install mode for unsupported language."
  :type 'boolean
  :group 'hatena-multi-mode)

(defcustom hatena:mm:filetype-alist nil
  "Mapping from file type signatures to major mode names."
  :type '(alist :key-type (choice string symbol)
                :value-type (choice string symbol function))
  :group 'hatena-multi-mode)

(defcustom hatena:mm:electric-parse-lang t
  "Parse super-pre language declaration on modification of the text."
  :type 'boolean
  :group 'hatena-multi-mode)

(defface hatena:mm:invalid-language
  '((((class color) (min-colors 8) (background dark))
     :inherit error :background "#553333")
    (((class color) (min-colors 8) (background light))
     :inherit error :background "#ffdddd"))
  "Face for invalid language specification."
  :group 'hatena-multi-mode)

;;;###autoload
(define-minor-mode hatena:multi-mode
  "Multi mode for Hatena super-pre syntax."
  :group 'hatena-multi-mode
  (if hatena:multi-mode
      (progn
        (when hatena:mm:electric-parse-lang
          (add-hook 'after-change-functions
                    #'hatena:mm:electric-parse-lang nil t))
        (hatena:mm:parse-langs))
    (remove-hook 'after-change-functions #'hatena:mm:electric-parse-lang t)))

(defun hatena:mm:parse-langs ()
  (interactive)
  (multi-with-base-buffer
   (save-excursion
     (goto-char (point-min))
     (while (re-search-forward "^>|\\([a-zA-Z0-9_?]+\\)|$" nil t)
       (hatena:mm:install-this-line)))))

(defun hatena:mm:electric-parse-lang (&rest args)
  (let* ((end (line-end-position))
         (beg (max (line-beginning-position) (1- end))))
    (when (string-match-p "|$" (buffer-substring-no-properties beg end))
      (hatena:mm:install-this-line))))

(defun hatena:mm:langs ()
  (or hatena-mm-langs (setq hatena-mm-langs (hatena-mm-retrieve-langs))))

(defun hatena:mm:install (ft)
  (multi-with-base-buffer
   (let ((mode (hatena-mm-major-mode ft))
         (installed (member ft hatena-mm-file-types)))
     (cond
      ((or installed (string= ft "?") (string= ft "aa")) t)
      ((and hatena:mm:check-supported-languages
            (not (member ft (hatena:mm:langs))))
       (message (format "Unknown language or file type '%s'" ft))
       nil)
      ((not mode)
       (message (format "Cannot find major mode for file type '%s'" ft))
       nil)
      (t
       (multi-install-chunk-finder (format "^>|%s|$" ft) "^||<$" mode)
       (push ft hatena-mm-file-types))))))

(defun hatena:mm:install-this-line ()
  (multi-with-base-buffer
    (save-excursion
      (beginning-of-line)
      (when (and (looking-at "^>|\\(.*\\)|$")
                 (not (hatena:mm:install (match-string 1))))
          (hatena-mm-warn-invalid-lang)))))

;; internals

(defconst hatena-mm-langs-url
  "http://hatenadiary.g.hatena.ne.jp/keyword/%E3%82%BD%E3%83%BC%E3%82%B9%E3%82%B3%E3%83%BC%E3%83%89%E3%82%92%E8%89%B2%E4%BB%98%E3%81%91%E3%81%97%E3%81%A6%E8%A8%98%E8%BF%B0%E3%81%99%E3%82%8B%EF%BC%88%E3%82%B7%E3%83%B3%E3%82%BF%E3%83%83%E3%82%AF%E3%82%B9%E3%83%BB%E3%83%8F%E3%82%A4%E3%83%A9%E3%82%A4%E3%83%88%EF%BC%89")
(defconst hatena-mm-langs-regexps
  '("<blockquote>" "</blockquote>"
    "\\(<.*?>\\|</.*?>\\|^[ \t\r\n]*\\|[ \t\r\n]*$\\)" "[ \t\r\n]+"))

(defun hatena-mm-retrieve-langs ()
  (with-current-buffer (url-retrieve-synchronously hatena-mm-langs-url)
    (let* ((rs hatena-mm-langs-regexps)
           (beg (re-search-forward (nth 0 rs) nil t))
           (end (re-search-forward (nth 1 rs) nil t))
           (s (or (and beg end (buffer-substring-no-properties beg end)) ""))
           (s (replace-regexp-in-string (nth 2 rs) "" s))
           (s (replace-regexp-in-string (nth 3 rs) " " s)))
      (and (> (length s) 0) (split-string s " ")))))

(defsubst hatena-mm-assoc-auto-mode (ft)
  (assoc-default (format "dummy.%s" ft) auto-mode-alist #'string-match-p))

(defun hatena-mm-major-mode (ft)
  (let ((candidates (list (cdr (assoc-string ft hatena:mm:filetype-alist))
                          ft
                          (hatena-mm-assoc-auto-mode ft))))
    (loop for mode in candidates
          when (functionp mode)
          return mode
          for mode-mode = (intern (format "%s-mode" mode))
          when (functionp mode-mode)
          return mode-mode)))

(defun hatena-mm-modified-hook (overlay after &rest args)
  (when after
    (let ((inhibit-modification-hooks t))
      (delete-overlay overlay))))

(defun hatena-mm-make-warning-overlay (beg end)
  (let ((overlay (make-overlay beg end))
        (hooks '(hatena-mm-modified-hook)))
    (overlay-put overlay 'modification-hooks hooks)
    (overlay-put overlay 'insert-in-front-hooks hooks)
    (overlay-put overlay 'insert-behind-hooks hooks)
    (overlay-put overlay 'font-lock-face 'hatena:mm:invalid-language)
    overlay))

(defun hatena-mm-warn-invalid-lang ()
  (let ((beg (+ 2 (line-beginning-position)))
        (end (1- (line-end-position))))
    (when (and (< beg end) (< (point-min) beg) (< end (point-max)))
      (hatena-mm-make-warning-overlay beg end))))

(provide 'hatena-multi-mode)
;;; hatena-multi-mode.el ends here
