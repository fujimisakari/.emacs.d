;;; 26-shell.el --- Shell設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; shell設定
;; zshを使う
(cond ((eq my-os-type 'linux)
       (setq shell-file-name "/usr/bin/zsh"))
      ((eq my-os-type 'mac)
       (setq shell-file-name "/bin/zsh")))
;; エスケープシーケンスによる色が付くようにする
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;; M-!, M-l, M-&, M-x grepなどでsudoコマンドが使えるようにする
(require 'sudo-ext)
;; Emacs内のシェルコマンドを実行履歴に保存する
(require 'shell-history)
;; パスワードのプロンプトを認識し，入力時はミニバッファで伏せ字にする
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

;; tramp設定
(require 'tramp)
(setq tramp-default-method "ssh")
(add-to-list 'tramp-default-proxies-alist '("\\." "\\`root\\'" "/ssh:%h:"))
(setq tramp-shell-prompt-pattern "^.*[#$%>] *")


(defun current-directory-to-terminal ()
  (let* (current-dir
         (current-buffer
          (nth 1 (assoc 'buffer-list
                        (nth 1 (nth 1 (current-frame-configuration))))))
         (active-file-name
          (with-current-buffer current-buffer
            (progn
              (setq current-dir (expand-file-name (cadr (split-string (pwd)))))
              (buffer-file-name)))))
    (if active-file-name
        (file-name-directory active-file-name)
      current-dir)))


;; shell-pop設定
;; 独自ansi-term関数の呼び出し
;; (defvar my-shell-pop-key (kbd "<f3>"))
;; (defvar my-ansi-term-toggle-mode-key (kbd "<C-M-return>"))

;; (require 'shell-pop)
;; ;(shell-pop-set-window-height 94)
;; (shell-pop-set-internal-mode "ansi-term")
;; (cond ((eq my-os-type 'linux)
;;        (shell-pop-set-internal-mode-shell "/usr/bin/zsh")
;;        )
;;       ((eq my-os-type 'mac)
;;        (shell-pop-set-internal-mode-shell "/bin/zsh")
;;        ))
;; (global-set-key my-shell-pop-key 'shell-pop)

;; ;; ansi-term設定
;; (defadvice ansi-term (after ansi-term-after-advice (arg))
;;   "run hook as after advice"
;;   (run-hooks 'ansi-term-after-hook))
;; (ad-activate 'ansi-term)

;; (defun my-term-switch-line-char ()
;;   "Switch `term-in-line-mode' and `term-in-char-mode' in `ansi-term'"
;;   (interactive)
;;   (cond
;;    ((term-in-line-mode)
;;     (term-char-mode)
;;     (hl-line-mode -1))
;;    ((term-in-char-mode)
;;     (term-line-mode)
;;     (hl-line-mode 1))))

;; (defvar ansi-term-after-hook nil)
;; (add-hook 'ansi-term-after-hook
;;           (lambda ()
;;             ;; shell-pop
;;             (define-key term-raw-map my-shell-pop-key 'shell-pop)
;;             ;; これがないと M-x できなかったり
;;             (define-key term-raw-map (kbd "M-x") 'nil)
;;             ;; コピー, 貼り付け
;;             (define-key term-raw-map (kbd "C-k")
;;               (lambda (&optional arg) (interactive "P") (funcall 'kill-line arg) (term-send-raw)))
;;             (define-key term-raw-map (kbd "C-y") 'term-paste)
;;             ;; C-t で line-mode と char-mode を切り替える
;;             (define-key term-raw-map  my-ansi-term-toggle-mode-key 'my-term-switch-line-char)
;;             (define-key term-mode-map my-ansi-term-toggle-mode-key 'my-term-switch-line-char)
;;             ;; 可変でshell-pop画面サイズを調整する
;;             (setq real-w-size (frame-height))
;;             (shell-pop-set-window-height (+ real-w-size 26))
;;             ;; Tango!
;;             (setq ansi-term-color-vector
;;                   [unspecified
;;                    "#000000"            ; black
;;                    "#ff0000"            ; red
;;                    "#00ff00"            ; green
;;                    "#ffff00"            ; yellow
;;                    "#1e90ff"            ; blue
;;                    "#ff00ff"            ; magenta
;;                    "#00ffff"            ; cyan
;;                    "#ffffff"]           ; white
;;                   )
;;             ))

;; multi-term設定
;;(require 'multi-term)
;(when (require 'multi-term))
;;; 快適に使うためには、以下の2変数を調整する必要がある。
  ;; C-x C-c ESCは端末に渡さないでEmacsが使うようにする。
;  (setq term-unbind-key-list '("C-x" "C-c" "<ESC>"))
;    ;; 以下のコマンドを使えるようにする。
;    (setq  term-bind-key-alist
;      '(("C-c C-c" . term-interrupt-subjob)
;        ("C-m"     . term-send-raw)
;        ("M-f"     . term-send-forward-word)
;        ("M-b"     . term-send-backward-word)
;        ("M-o"     . term-send-backspace)
;        ("M-p"     . term-send-up)
;        ("M-n"     . term-send-down)
;        ("M-M"     . term-send-forward-kill-word)
;        ("M-N"     . term-send-backward-kill-word)
;        ("M-r"     . term-send-reverse-search-history)
;        ("M-,"     . term-send-input)
;        ("M-."     . comint-dynamic-complete))))

;;; 26-shell.el ends here
