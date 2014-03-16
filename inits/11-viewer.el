;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                 viewer設定                                 ;;
;;;--------------------------------------------------------------------------;;;

;; (require 'viewer)

;; C-x C-r は view-modeでファイルを開く
(setq view-read-only t)

;; 書き込み不能ファイルはview-modeから抜けなくする
;; (viewer-stay-in-setup)

;; 特定のファイルを view-mode で開くようにする
(setq view-mode-by-default-regexp "\\.log$")

;;; view-mode のときに mode-line に色をつける
;; 書き込み不可ファイルを開く場合は濃い赤色
(setq viewer-modeline-color-unwritable "red")
;; 書き込み可能ファイルを開く場合はオレンジ色
(setq viewer-modeline-color-view "orange")
;; view-modeの切り替え時のデフォルト色
(setq viewer-modeline-color-default "SlateBlue3")
;; (viewer-change-modeline-color-setup)

;;; view-modeのキーバインド
(defvar pager-keybind
      `(;; vi/w3w感覚の操作
        ("h" . backward-word)
        ("j" . next-line)
        ("k" . previous-line)
        ("l" . forward-word)
        ("J" . View-scroll-line-forward)
        ("K" . View-scroll-line-backward)
        ;; less感覚の操作
        ("/" . anything-c-moccur-occur-by-moccur)
        ("G" . View-goto-line-last)
        ("b" . View-scroll-page-backward)
        ("f" . View-scroll-page-forward)
        ;; bm.el の設定
        ("m" . bm-toggle)
        ("[" . bm-previous)
        ("]" . bm-next)
        ))
(defun define-many-keys (keymap key-table &optional includes)
  (let (key cmd)
    (dolist (key-cmd key-table)
      (setq key (car key-cmd)
            cmd (cdr key-cmd))
      (if (or (not includes) (member key includes))
        (define-key keymap key cmd))))
  keymap)

(defun view-mode-hook0 ()
  (define-many-keys view-mode-map pager-keybind)
  (skk-mode 0)
  (hl-line-mode 1))
(add-hook 'view-mode-hook 'view-mode-hook0)

(defun View-goto-line-last (&optional line)
  "goto last line"
  (interactive "P")
  (goto-line (line-number-at-pos (point-max))))

;; 書き込み不能なファイルはview-modeで開くように
(defadvice find-file
  (around find-file-switch-to-view-file (file &optional wild) activate)
  (if (and (not (file-writable-p file))
           (not (file-directory-p file)))
      (view-file file)
    ad-do-it))

;; 書き込み不能な場合はview-modeを抜けないように
(defvar view-mode-force-exit nil)
(defmacro do-not-exit-view-mode-unless-writable-advice (f)
  `(defadvice ,f (around do-not-exit-view-mode-unless-writable activate)
     (if (and (buffer-file-name)
              (not view-mode-force-exit)
              (not (file-writable-p (buffer-file-name))))
         (message "File is unwritable, so stay in view-mode.")
       ad-do-it)))

(do-not-exit-view-mode-unless-writable-advice view-mode-exit)
(do-not-exit-view-mode-unless-writable-advice view-mode-disable)
