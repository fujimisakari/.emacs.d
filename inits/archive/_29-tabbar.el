;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                 tabbar設定                                 ;;
;;;--------------------------------------------------------------------------;;;

(require 'tabbar)
(tabbar-mode)

;; タブ上でマウスホイール操作無効
(tabbar-mwheel-mode nil)

;; グループ化しない
(setq tabbar-buffer-groups-function nil)

;; 左に表示されるボタンを無効化
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))

;; ウインドウからはみ出たタブを省略して表示
(setq tabbar-auto-scroll-flag nil)

;; タブとタブの間の長さ
(setq tabbar-separator '(1.5))

;; 外観変更
(set-face-attribute
 'tabbar-default nil
 :family my-global-font
 :background "gray23"
 :foreground "white"
 :height 1.1)
(set-face-attribute
 'tabbar-unselected nil
 :background "gray23"
 :foreground "white"
 :box nil)
(set-face-attribute
 'tabbar-selected nil
 :background "gray23"
 :foreground "#4f57f9"
 :box nil)
(set-face-attribute
 'tabbar-button nil
 :box nil)
(set-face-attribute
 'tabbar-separator nil
 :height 1.0)
(set-face-attribute
 'tabbar-modified nil
 :foreground "white"
 :box nil)

;; タブに表示させるバッファの設定
(defvar my-tabbar-displayed-buffers
 '("*scratch*" "*Backtrace*" "*Colors*" "*Faces*" "*Packages*" "*vc-")
  "*Regexps matches buffer names always included tabs.")
(defun my-tabbar-buffer-list ()
  "Return the list of buffers to show in tabs.
Exclude buffers whose name starts with a space or an asterisk.
The current buffer and buffers matches `my-tabbar-displayed-buffers'
are always included."
  (let* ((hides (list ?\  ?\*))
         (re (regexp-opt my-tabbar-displayed-buffers))
         (cur-buf (current-buffer))
         (tabs (delq nil
                     (mapcar (lambda (buf)
                               (let ((name (buffer-name buf)))
                                 (when (or (string-match re name)
                                           (not (memq (aref name 0) hides)))
                                   buf)))
                             (buffer-list)))))
    ;; Always include the current buffer.
    (if (memq cur-buf tabs)
        tabs
      (cons cur-buf tabs))))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)

;;
;; Buffer Modification
;;
;; Add a buffer modification state indicator in the tab label, and place a
;; space around the label to make it looks less crowd.
 (defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
   (setq ad-return-value
         (if (and (buffer-modified-p (tabbar-tab-value tab))
                  (buffer-file-name (tabbar-tab-value tab)))
             (concat " + " (concat ad-return-value " "))
           (concat " " (concat ad-return-value " ")))))
;; Called each time the modification state of the buffer changed.
(defun ztl-modification-state-change ()
  (tabbar-set-template tabbar-current-tabset nil)
  (tabbar-display-update))
;; First-change-hook is called BEFORE the change is made.
(defun ztl-on-buffer-modification ()
  (set-buffer-modified-p t)
  (ztl-modification-state-change))
(add-hook 'after-save-hook 'ztl-modification-state-change)
;; This doesn't work for revert, I don't know.
;;(add-hook 'after-revert-hook 'ztl-modification-state-change)
(add-hook 'first-change-hook 'ztl-on-buffer-modification)

;;
;; Tab Position
;;
;; http://82rensa.blogspot.jp/2012/12/tabbarel.html
(require 'dash)
(defun tabbar+get-current-buffer-index ()
  (let* ((ctabset (tabbar-current-tabset 't))
         (ctabs (tabbar-tabs ctabset))
         (ctab (tabbar-selected-tab ctabset)))
    (length (--take-while (not (eq it ctab)) ctabs))))

(defun insert- (list-object index element)
  (append (-take index list-object) (list element) (-drop index list-object)))

(defun tabbar+move (direction)
  "Move current tab to (+ index DIRECTION)"
  (interactive)
  (let* ((ctabset (tabbar-current-tabset 't))
         (ctabs (tabbar-tabs ctabset))
         (ctab (tabbar-selected-tab ctabset))
         (index (tabbar+get-current-buffer-index))
         (others (--remove (eq it ctab) ctabs))
         (ins (mod (+ index direction (+ 1 (length others))) (+ 1 (length others)))))
    (set ctabset (insert- others ins ctab))
    (put ctabset 'template nil)
    (tabbar-display-update)))

(defun tabbar+move-right ()
  "Move current tab to right"
  (interactive)
  (tabbar+move +1))

(defun tabbar+move-left ()
  "Move current tab to left"
  (interactive)
  (tabbar+move -1))
