;;; 07-ivy.el --- ivy Setting -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'ivy)
(require 'ivy-posframe)
(require 'counsel)
(require 'swiper)

;; ivy config
(ivy-mode 1)
(all-the-icons-ivy-setup)
(setq ivy-use-virtual-buffers nil)
(setq ivy-count-format "(%d/%d) ")
(when (setq enable-recursive-minibuffers t)
  (minibuffer-depth-indicate-mode 1)) ;; dispaly how many layers to prompt
(setq ivy-height 30) ;; Increase the size of the minibuffer
(setq ivy-extra-directories nil)
(setq ivy-read-action-function #'ivy-hydra-read-action)
(setq ivy-initial-inputs-alist '())
(setq swiper-action-recenter t)
(setq ivy-re-builders-alist '((t . ivy--regex-plus)))

;; counsel config
(setq counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))
(setq counsel-yank-pop-separator "\n--------------------\n")
(setq counsel-ag-base-command (list "ag" "-U" "--vimgrep" "%s"))

;; ivy-posframe config
(ivy-posframe-mode 1)
(setq ivy-posframe-display-functions-alist
      '((swiper . ivy-display-function-fallback)
        (t      . ivy-posframe-display-at-frame-center)))
(setq ivy-posframe-height-alist '((swiper . 20) (t . 40)))
(setq ivy-posframe-parameters '((left-fringe . 5) (right-fringe . 5)))

;; visual

; Search header
(with-eval-after-load "ivy"
  (defun my-pre-prompt-function ()
    (if window-system
        (format "%s\n%s "
                (make-string (frame-width) ?\x5F) ;; "__"
                (all-the-icons-faicon "sort-amount-asc")) ;; ""
      (format "%s\n" (make-string (1- (frame-width)) ?\x2D))))
  (setq ivy-pre-prompt-function #'my-pre-prompt-function))

; Selector icon
(defun ivy-format-function-pretty (cands)
  "Transform CANDS into a string for minibuffer."
  (ivy--format-function-generic
   (lambda (str)
     (concat
      (all-the-icons-faicon "hand-o-right" :height .85 :v-adjust .05 :face 'font-lock-constant-face)
      " "
      (ivy--add-face str 'ivy-current-match)))
   (lambda (str)
     (concat "   " str))
   cands
   "\n"))
(setq ivy-format-functions-alist '((t . ivy-format-function-pretty)))

; ivy-posframe
(setq ivy-posframe-parameters '((alpha . 70)))

;; customize

; sort candidates
(defun ivy--sort-by-len (name candidates)
  "Sort CANDIDATES based on similarity of their length with NAME."
  (let ((name-len (length name))
        (candidates-count (length candidates)))
    (if (< 500 candidates-count)
        candidates
      (seq-sort-by (lambda (candidate-string)
                     (cons candidate-string
                           (abs (- name-len (length candidate-string)))))
                   (lambda (a b)
                     (if (not (= (cdr a) (cdr b)))
                         (< (cdr a) (cdr b))
                       (string< (car a) (car b))))
                   candidates))))
(dolist (i '(counsel-M-x
             counsel-apropos
             counsel-describe-function
             counsel-describe-variable
             counsel-describe-face))
  (setf (alist-get i ivy-sort-matches-functions-alist) 'ivy--sort-by-len))

; switch-buffer
(defun my-ivy-switch-buffer ()
  (interactive)
  (if (one-window-p)
      (ivy-switch-buffer-other-window)
    (ivy-switch-buffer)))

; ad:counsel-ag
(defun ad:counsel-ag (f &optional initial-input initial-directory extra-ag-args ag-prompt caller)
  (apply f (or initial-input (if mark-active (buffer-substring-no-properties (region-beginning) (region-end))))
         (unless current-prefix-arg
           (or initial-directory default-directory))
         extra-ag-args ag-prompt caller))
(advice-add 'counsel-ag :around #'ad:counsel-ag)

(defun my-counsel-ag-with-ignore ()
  (interactive)
  (let ((initial-input (if mark-active (buffer-substring-no-properties (region-beginning) (region-end))))
        (initial-directory default-directory)
        (extra-ag-args "--ignore *_test.go --ignore *.txt --ignore *.html"))
    (counsel-ag initial-input initial-directory extra-ag-args)))

; counsel-recentf
(defun my-counsel-recentf ()
  (interactive)
  (if (one-window-p)
      (counsel-recentf-other-window)
    (counsel-recentf)))

(defun counsel-recentf-other-window ()
  "Find a file on `recentf-list'."
  (interactive)
  (require 'recentf)
  (recentf-mode)
  (ivy-read "Recentf: " (counsel-recentf-candidates)
            :action (lambda (f)
                      (find-file-other-window f))
            :require-match t
            :caller 'counsel-recentf))

; counsel-bookmark
(defun my-counsel-bookmark ()
  (interactive)
  (if (one-window-p)
      (counsel-bookmark-other-window)
    (counsel-bookmark)))

(defun counsel-bookmark-other-window ()
  "Forward to `bookmark-jump' or `bookmark-set' if bookmark doesn't exist."
  (interactive)
  (require 'bookmark)
  (ivy-read "Create or jump to bookmark: "
            (bookmark-all-names)
            :history 'bookmark-history
            :action (lambda (x)
                      (bookmark-jump-other-window x))
            :caller 'counsel-bookmark))

; ivy-dired-history
(require 'savehist)
(add-to-list 'savehist-additional-variables 'ivy-dired-history-variable)
(savehist-mode 1)
(with-eval-after-load 'dired
  (require 'ivy-dired-history))

;; swiper for region
(defun swiper-thing-at-region ()
  "`swiper' with `ivy-thing-at-region'."
  (interactive)
  (let ((thing ""))
    (when (use-region-p)
      (setq thing (buffer-substring (region-beginning) (region-end)))
      (deactivate-mark))
    (swiper (regexp-quote thing))))

(defun swiper-all-thing-at-region ()
  "`swiper-all' with `ivy-thing-at-region'."
  (interactive)
  (let ((thing ""))
    (when (use-region-p)
      (setq thing (buffer-substring (region-beginning) (region-end)))
      (deactivate-mark))
    (swiper-all (regexp-quote thing))))

(defun my-copilot-chat-action-picker ()
  "Select and run a Copilot Chat command using counsel."
  (interactive)
  (let ((actions '(("Display chat" . copilot-chat)
                   ("Buffer list" . copilot-chat-list)
                   ("Select AI model" . copilot-chat-default-model)
                   ("Explain selection" . copilot-chat-explain)
                   ("Explain defun" . copilot-chat-explain-defun)
                   ("Explain symbol" . copilot-chat-explain-symbol-at-line)
                   ("Review selection" . copilot-chat-review)
                   ("Fix selection" . copilot-chat-fix)
                   ("Optimize selection" . copilot-chat-optimize)
                   ("Generate test for selection" . copilot-chat-test)
                   ("Generate doc for selection" . copilot-chat-doc))))
    (ivy-read "Copilot Chat Action: "
              (mapcar #'car actions)
              :action (lambda (choice)
                        (let ((fn (cdr (assoc choice actions))))
                          (when fn (call-interactively fn)))))))

;;; 07-ivy.el ends here
