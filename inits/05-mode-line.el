;;; 05-mode-line.el --- mode-line設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; モードライン設定
(column-number-mode t)                             ; モードラインにカーソル列の位置表示
(line-number-mode t)                               ; モードラインにカーソル行の位置表示

;; 日付・時刻の表示設定
(setq display-time-string-forms
      '((format "%s/%s(%s) %s:%s" month day dayname 24-hours minutes)))
(display-time)                      ; 時間を表示
(setq display-time-kawakami-form t) ; 時刻表示の左隣に日付を追加
(setq display-time-24hr-format t)   ; 24 時間制

;; モードラインにカレントディレクトリを表示する
(let ((ls (member 'mode-line-buffer-identification mode-line-format)))
  (setcdr ls
          (cons
           '(:eval (concat " (" (abbreviate-file-name default-directory) ")"))
           (cdr ls))))

;; モードラインに改行コードを表示
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")
(setq eol-mnemonic-undecided "(?)")

;; 文字エンコーディングの文字列表現
(defun my/coding-system-name-mnemonic (coding-system)
  (let* ((base (coding-system-base coding-system))
         (name (symbol-name base)))
    (cond ((string-prefix-p "utf-8" name) "U8")
          ((string-prefix-p "utf-16" name) "U16")
          ((string-prefix-p "utf-7" name) "U7")
          ((string-prefix-p "japanese-shift-jis" name) "SJIS")
          ((string-match "cp\\([0-9]+\\)" name) (match-string 1 name))
          ((string-match "japanese-iso-8bit" name) "EUC")
          (t "???")
          )))

(defun my/coding-system-bom-mnemonic (coding-system)
  (let ((name (symbol-name coding-system)))
    (cond ((string-match "be-with-signature" name) "[BE]")
          ((string-match "le-with-signature" name) "[LE]")
          ((string-match "-with-signature" name) "[BOM]")
          (t ""))))

(defun my/buffer-coding-system-mnemonic ()
  "Return a mnemonic for `buffer-file-coding-system'."
  (let* ((code buffer-file-coding-system)
         (name (my-coding-system-name-mnemonic code))
         (bom (my-coding-system-bom-mnemonic code)))
    (format "%s%s" name bom)))

;; `mode-line-mule-info' の文字エンコーディングの文字列表現を差し替える
(setq-default mode-line-mule-info
              (cl-substitute '(:eval (my/buffer-coding-system-mnemonic))
                             "%z" mode-line-mule-info :test 'equal))

;;; 05-mode-line.el ends here
