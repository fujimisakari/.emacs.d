;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                環境設定                                    ;;
;;;--------------------------------------------------------------------------;;;

;; OSの種別を判定
(defvar my-os-type nil)
(cond ((string-match "apple-darwin" system-configuration) ;; Mac
       (setq my-os-type 'mac))
      ((string-match "linux" system-configuration)        ;; Linux
       (setq my-os-type 'linux))
      ((string-match "freebsd" system-configuration)      ;; FreeBSD
       (setq my-os-type 'bsd))
      ((string-match "mingw" system-configuration)        ;; Windows
       (setq my-os-type 'win)))

;; macのCtrl/Cmd/Optionがシステムに渡されるのを防ぐ
(when (eq my-os-type 'mac)
  (setq mac-pass-control-to-system nil)
  (setq mac-pass-command-to-system nil)
  (setq mac-pass-option-to-system nil))

;; コマンドパスの追加
(dolist (dir (list "/usr/local/bin"))
  (when (and (file-exists-p dir) (not (member dir exec-path)))
    (setenv "PATH" (concat dir ":" (getenv "PATH")))
    (setq exec-path (append (list dir) exec-path))))
(cond ((eq my-os-type 'linux)
       (add-to-list 'exec-path "~/.emacs.d/bin")
       (setenv "PATH"
               (concat '"~/.emacs.d/bin:" (getenv "PATH")))
       )
      ((eq my-os-type 'mac)
       (add-to-list 'exec-path "/usr/local/bin")
       (setenv "PATH"
               (concat '"/usr/local/bin:" (getenv "PATH")))
       ))

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

;; ;; システム関連
(setq echo-keystrokes 0.1)                                       ; キーストロークをエコーエリアに早く表示させる
(setq gc-cons-threshold (* 50 gc-cons-threshold))                ; GCを減らして軽くする（デフォルトの50倍）
(setq x-select-enable-clipboard t)                               ; X11とクリップボードを共有する
(setq use-dialog-box nil)                                        ; ダイアログボックスを使わないようにする
(setq scroll-conservatively 35 scroll-margin 0 scroll-step 1)    ; スクロールは一行にする

;; 履歴関連
(setq backup-inhibited t)                                        ; バックアップファイルを作らない
(setq delete-auto-save-files t)                                  ; 終了時にオートセーブファイルを消す
(setq history-length 5000)                                       ; 履歴をたくさん保存する
(setq message-log-max 2000)                                      ; ログ記録行数を増やす
(setq enable-recursive-minibuffers t)                            ; ミニバッファを再帰的に呼び出せるようにする
(setq vc-follow-symlinks t)                                      ; シンボリックファイルを開く時にいちいち聞かない

;;自動バックアップの保存先を変更
(setq auto-save-list-file-prefix "~/.emacs.d/cache/auto-save-list/.saves-")

;; 最近使ったファイルを履歴で残すようにする
;; (install-elisp "http://www.emacswiki.org/emacs/download/recentf-ext.el")
;; 最近のファイルを5000個を保存する
(require 'recentf-ext)
(setq recentf-max-saved-items 5000)

;; 最近使ったファイルに加えないファイルを正規表現で定義する
;; (setq recentf-exclude '("/TAGS$" "/var/tmp/"))

;; ファイル内のカーソル位置を記憶する
(require 'saveplace)
(setq-default save-place t)

;; ミニバッファで入力を取り消しても履歴を残す
(defadvice abort-recursive-edit (before minibuffer-save activate)
  (when (eq (selected-window) (active-minibuffer-window))
    (add-to-history minibuffer-history-variable (minibuffer-contents))))

;; 会社と自宅の読み込みを切り分け 
;; 元ネタ(http://e-arrows.sakura.ne.jp/2010/12/emacs-anywhere.html)
;; (defvar *network-interface-names* '("eth0" "eth1")
;;   "Candidates for the network devices.")
;; 使い方：(if (officep) (require 'init-jabber)) ; jabber設定
(defun machine-ip-address ()
  "Return IP address of a network device."
  (let ((mia-info (network-interface-info "eth0")))
    (if mia-info
        (format-network-address (car mia-info) t))))

(defun officep ()
  "Am I in the office? If I am in the office, my IP address must start with '172.16.0.'."
  (let ((ip (machine-ip-address)))
    (and ip
         (eq 0 (string-match "^10\\.0\\.8\\." ip)))))
