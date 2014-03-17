;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                 tabbar関連                                 ;;
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
 :family "Comic Sans MS"
 :background "black"
 :foreground "white"
 :height 1.1)
(set-face-attribute
 'tabbar-unselected nil
 :background "black"
 :foreground "white"
 :box nil)
(set-face-attribute
 'tabbar-selected nil
 :background "black"
 :foreground "MediumPurple1"
 :box nil)
(set-face-attribute
 'tabbar-button nil
 :box nil)
(set-face-attribute
 'tabbar-separator nil
 :height 1.0)

;; タブに表示させるバッファの設定
(defvar my-tabbar-displayed-buffers
 '("scratch*" "*Backtrace*" "*Colors*" "*Faces*" "*vc-")
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

;; タブ移動キーバインド
(global-set-key (kbd "C-M-l") 'tabbar-forward-tab)
(global-set-key (kbd "C-M-h") 'tabbar-backward-tab)

;; タブモードのオン/オフをトグル
;; (global-set-key (kbd "M-4") 'tabbar-mode)
