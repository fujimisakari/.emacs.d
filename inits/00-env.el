;;; 00-env.el --- 環境設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; OSの種別を判定
(defvar my-os-type nil)
(cond ((string-match "apple-darwin" system-configuration) ; Mac
       (setq my-os-type 'mac))
      ((string-match "linux" system-configuration)        ; Linux
       (setq my-os-type 'linux))
      ((string-match "freebsd" system-configuration)      ; FreeBSD
       (setq my-os-type 'bsd))
      ((string-match "mingw" system-configuration)        ; Windows
       (setq my-os-type 'win)))

;; macのCtrl/Cmd/Optionがシステムに渡されるのを防ぐ
(when (eq my-os-type 'mac)
  (setq mac-pass-control-to-system nil)
  (setq mac-pass-command-to-system nil)
  (setq mac-pass-option-to-system nil))

;; フォント設定
(defconst my-global-font "Comic Code")
(defconst my-global-ja-font "SF Mono Square")

;; shellのコマンドパスの追加
(load-file (expand-file-name "~/.emacs.d/share/shellenv/work1_shellenv.el"))
(load-file (expand-file-name "~/.emacs.d/share/shellenv/work2_shellenv.el"))
(load-file (expand-file-name "~/.emacs.d/share/shellenv/work3_shellenv.el"))
(load-file (expand-file-name "~/.emacs.d/share/shellenv/work4_shellenv.el"))
(load-file (expand-file-name "~/.emacs.d/share/shellenv/work5_shellenv.el"))
(load-file (expand-file-name (format "~/.emacs.d/share/shellenv/%s_shellenv.el" (getenv "USER"))))
(dolist (path (reverse (split-string (getenv "PATH") ":")))
  (add-to-list 'exec-path path))

;; (require 'exec-path-from-shell)
;; (let ((envs '("PATH" "GOPATH")))
;;   (exec-path-from-shell-copy-envs envs))

;; 日本語環境設定
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-buffer-file-coding-system 'utf-8-unix)

;; C-h を help-command から BackSpace に変更
;; http://openlab.dino.co.jp/2007/09/25/23251372.html
(load "term/bobcat")
(when (fboundp 'terminal-init-bobcat)
  (terminal-init-bobcat))

;; システム関連
(setq echo-keystrokes 0.1)                                    ; キーストロークをエコーエリアに早く表示させる
(setq gc-cons-threshold (* 50 gc-cons-threshold))             ; GCを減らして軽くする（デフォルトの50倍）
(setq x-select-enable-clipboard t)                            ; X11とクリップボードを共有する
(setq use-dialog-box nil)                                     ; ダイアログボックスを使わないようにする

;; 履歴関連
(setq backup-inhibited t)                                     ; バックアップファイルを作らない
(setq delete-auto-save-files t)                               ; 終了時にオートセーブファイルを消す
(setq history-length 1000)                                    ; 履歴をたくさん保存する
(setq message-log-max 1000)                                   ; ログ記録行数を増やす
(setq enable-recursive-minibuffers t)                         ; ミニバッファを再帰的に呼び出せるようにする
(setq vc-follow-symlinks t)                                   ; シンボリックファイルを開く時にいちいち聞かない

;; シンボルのショートカット名
(defalias 'yes-or-no-p 'y-or-n-p)                             ; "yes or no" の表示を "y or n"に変える
(defalias 'exit 'save-buffers-kill-emacs)                     ; M-x exit で Emacsが終了できるようにする
(defalias 'qr 'replace-regexp)                                ; 一括置換(正規表現置換)
(defalias 'qrr 'query-replace-regexp)                         ; 対話型置換(正規表現置換)

;; 自動インデントは無効
(electric-indent-mode 0)

;; 新しいフレームで開かない
(setq ns-pop-up-frames nil)

;; 自動バックアップの保存先を変更
(setq auto-save-list-file-prefix "~/.emacs.d/cache/auto-save-list/.saves-")

;; 最近使ったファイルを履歴で残すようにする
;; (install-elisp "http://www.emacswiki.org/emacs/download/recentf-ext.el")
;; 最近のファイルを2000個を保存する
(require 'recentf-ext)
(setq recentf-max-saved-items 2000)
(setq recentf-save-file "~/.recentf")
(setq recentf-auto-cleanup 'never)  ;; 存在しないファイルは消さない
(run-with-idle-timer 30 t '(lambda () (with-suppressed-message (recentf-save-list))))

;; Delete unnecessary messages
(defmacro with-suppressed-message (&rest body)
  "Suppress new messages temporarily in the echo area and the `*Messages*' buffer while BODY is evaluated."
  (declare (indent 0))
  (let ((message-log-max nil))
    `(with-temp-message (or (current-message) "") ,@body)))

;; ネイティブコンパイルで失敗するので無効
(setq native-comp-deferred-compilation-deny-list '("transient\\.el$"))

;; 最近使ったファイルに加えないファイルを正規表現で定義する
;; (setq recentf-exclude '("/TAGS$" "/var/tmp/"))

;; バッファは左右分割で開くようにする
;; https://ayatakesi.github.io/emacs/24.5/Window-Choice.html
(setq split-height-threshold nil)
(setq split-width-threshold 0)

;; 関数の呼び出し規定回数を拡張(デフォルト:600)
(setq max-lisp-eval-depth 1500)

;; ファイル内のカーソル位置を記憶する
(require 'saveplace)
(setq-default save-place t)

;; ミニバッファで入力を取り消しても履歴を残す
(defadvice abort-recursive-edit (before minibuffer-save activate)
  (when (eq (selected-window) (active-minibuffer-window))
    (add-to-history minibuffer-history-variable (minibuffer-contents))))

;; フルスクリーン設定(24.3以降)
(setq ns-use-native-fullscreen nil)

;; Shell Command実行時にzsh_historyに履歴を残さないようにする
;; (setq revert-buffer-insert-file-contents-function nil)
(setq revert-buffer-function nil)

;; URLはOSブラウザで開く
(setq browse-url-browser-function 'browse-url-generic)
(cond ((eq my-os-type 'mac)
       (setq browse-url-generic-program
             (if (file-exists-p "/usr/bin/open")
                 "/usr/bin/open")))
      ((eq my-os-type 'linux)
       (setq browse-url-generic-program
             (if (file-exists-p "/usr/bin/google-chrome")
                 "/usr/bin/google-chrome"))))

;; native-compの警告は非表示
(setq native-comp-async-report-warnings-errors 'silent)

;;; 00-env.el ends here
