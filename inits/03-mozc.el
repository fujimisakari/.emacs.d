;;; 03-mozc.el --- mozc設定 -*- lexical-binding: t; -*-

(require 'mozc)
(setq default-input-method "japanese-mozc")
(setq mozc-helper-program-name "mozc_emacs_helper")

;; Changing the color of the cursor with on/off
(require 'mozc-cursor-color)
;; カーソルカラーを設定する
(setq mozc-cursor-color-alist
      '((direct . "Yellow2")
        (read-only . "LimeGreen")
        (hiragana . "DodgerBlue")
        (full-katakana . "goldenrod")
        (half-ascii . "dark orchid")
        (full-ascii . "orchid")
        (half-katakana . "dark goldenrod")))

(add-hook 'input-method-deactivate-hook
          (lambda() (key-chord-mode 1)))

;; use postframe with mozc
(require 'mozc-posframe)
(mozc-posframe-register)
(setq mozc-candidate-style 'posframe)

(defun mozc-insert-str (str)
  (mozc-handle-event 'enter)
  (insert str))

;; Mac 固有の設定
;; https://www.inabamasaki.com/archives/1898
(when (eq system-type 'darwin)
  (defun my-eisuu-key ()
    "Emulating alphanumeric keys"
    (interactive)
    (call-process "osascript" nil t nil "-e" "tell application \"System Events\" to key code 102"))
  ;; Mozc が起動されたら英数にする
  (add-hook 'mozc-mode-hook 'my-eisuu-key)
  ;; フレームがアクティブになった時英数にする
  (add-hook 'focus-in-hook 'my-eisuu-key))

;;; 03-mozc.el ends here
