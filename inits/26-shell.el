;;; 26-shell.el --- Shell設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; shell設定
(cond ((eq my-os-type 'linux)
       (setq shell-file-name "/usr/bin/zsh"))
      ((eq my-os-type 'mac)
       (setq shell-file-name "/bin/zsh")))
;; エスケープシーケンスによる色が付くようにする
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;; M-!, M-l, M-&, M-x grepなどでsudoコマンドが使えるようにする
(autoload 'sudo "sudo-ext" nil t)
(autoload 'sudo-find-file "sudo-ext" nil t)
;; ;; Emacs内のシェルコマンドを実行履歴に保存する
;; (require 'shell-history)  ← これを読み込むとscratchでundoが使えなくなるので注意
;; パスワードのプロンプトを認識し，入力時はミニバッファで伏せ字にする
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

;; tramp設定（リモートファイルを開いた時に遅延読み込み）
(with-eval-after-load 'tramp
  (setq tramp-default-method "ssh")
  (add-to-list 'tramp-default-proxies-alist '("\\." "\\`root\\'" "/ssh:%h:"))
  (setq tramp-shell-prompt-pattern "^.*[#$%>] *"))

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

;;; 26-shell.el ends here
