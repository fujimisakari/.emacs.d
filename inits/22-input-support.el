;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               入力支援関連                                 ;;
;;;--------------------------------------------------------------------------;;;

;; 未来へやり直しできるようにる(redo)
;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
(require 'redo+)
(global-set-key (kbd "C-.") 'redo)

;; 過去のundoがredoされないようにする
(setq undo-no-redo t)

;; 大量のundoに 耐えられるようにする
(setq undo-limit 600000)
(setq undo-strong-limit 900000)

;; M-iで字下げは4の倍数にする
(custom-set-variables
 '(tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))))

;; auto-complete-mode: 高機能補完+ポップアップメニュー
(require 'auto-complete-config)
(require 'auto-complete-etags)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/share/ac-dict")
;; ソートファイルの保存場所を変更
(setq ac-comphist-file
      (expand-file-name (concat user-emacs-directory "/cache/ac-comphist.dat")))
;; クイックヘルプを利用しない
(setq ac-use-quick-help nil)
;; キーバインド設定
(setq ac-use-menu-map t)  ; 補完メニューのときだけキーバインドを有効にする
(define-key ac-menu-map (kbd "C-n") 'ac-next)
(define-key ac-menu-map (kbd "C-p") 'ac-previous)
(define-key ac-menu-map (kbd "C-j") 'ac-complete)
(define-key ac-menu-map (kbd "C-i") 'ac-expand)
;; 色の設定
(set-face-foreground 'ac-candidate-face "#ccc")
(set-face-background 'ac-candidate-face "#444")
(set-face-foreground 'ac-selection-face "#fff")
(set-face-background 'ac-selection-face "SlateBlue2")

(set-face-foreground 'popup-menu-face "#ccc")
(set-face-background 'popup-menu-face "#444")
(set-face-foreground 'popup-menu-selection-face "#fff")
(set-face-background 'popup-menu-selection-face "SlateBlue2")

(set-face-background 'popup-scroll-bar-background-face "#444")
(set-face-background 'popup-scroll-bar-foreground-face "#444")

;; 略語展開・補完を行うコマンドをまとめる
;; (setq hippie-expand-try-functions-list
;;   '(try-complete-file-name-partially                       ; ファイル名の一部
;;     try-complete-file-name                                 ; ファイル名全体
;;     try-expand-all-abbrevs                                 ; 動的略語展開
;;     try-expand-abbrev                                      ; 動的略語展開(カレントバファ)
;;     try-expand-abbrev-all-buffers                          ; 動的略語展開(全バッファ)
;;     try-expand-abbrev-from-kill                            ; 動的略語展開(キルリング：M-w/C-wの履歴)
;;     try-complete-lisp-symbol-partially                     ; Lispシンボル名の一部
;;     try-complete-lisp-symbol                               ; Lispシンボル名の全体
;;    ))

;; one-keyの設定
;; (require 'one-key-default)                                 ; one-key.el も一緒に読み込んでくれる
;; (require 'one-key-config)                                  ; one-key.el をより便利にする
;; (one-key-default-setup-keys)                               ; one-key- で始まるメニュー使える様になる
;; (define-key global-map (kbd "C-x") 'one-key-menu-C-x)      ; C-x にコマンドを定義

;; 矩形をより簡単にする
(cua-mode t)
(setq cua-enable-cua-keys nil) ;; 変なキーバインドを禁止

;; Tabの代わりにスペースでインデント
(setq-default tab-width 4 indent-tabs-mode nil)

;; 物理行でカーソル移動する
;; (install-elisp http://homepage1.nifty.com/bmonkey/emacs/elisp/screen-lines.el)
(require 'screen-lines)
;; text-modeかそれを継承したメジャーモードで自動的に有効にする
(add-hook 'text-mode-hook 'turn-on-screen-lines-mode)

;; 最後の変更箇所へジャンプする
;; (require 'goto-chg)
;; (global-set-key (kbd "<f8>") 'goto-last-change)
;; (global-set-key (kbd "S-<f8>") 'goto-last-change-reverse)

;; \C-aでインデントを飛ばした行頭に移動
(defun beginning-of-indented-line (current-point)
  "インデント文字を飛ばした行頭に戻る。ただし、ポイントから行頭までの間にインデント文字しかない場合は、行頭に戻る。"
  (interactive "d")
  (if (string-match
       "^[ ¥t]+$"
       (save-excursion
         (buffer-substring-no-properties
          (progn (beginning-of-line) (point))
          current-point)))
      (beginning-of-line)
    (back-to-indentation)))
(global-set-key (kbd "C-a") 'beginning-of-indented-line)

;; 同じコマンドを連続実行したときの振舞いを変更する
;; C-a，C-eを2回押ししたとき，バッファの先頭・末尾へ行く
(require 'sequential-command-config)
(sequential-command-setup-keys)

;(setq-default show-trailing-whitespace t)              ; 行の末尾に入った空白文字を強調表示
;(setq-default indicate-empty-lines t)                  ; ファイルの最後の空行表示
(setq kill-whole-line t)                                ; C-kは行末改行を削除しないが、改行までまとめて行カットする
(setq next-screen-context-lines 1)                      ; C-v/M-vで前のページの１行を残す

;; ファイルの末尾に[EOF]を表示
(defun my-mark-eob ()
  (let ((existing-overlays (overlays-in (point-max) (point-max)))
        (eob-mark (make-overlay (point-max) (point-max) nil t t))
        (eob-text "[EOF]"))
    ;; 急EOFマークを削除
    (dolist (next-overlay existing-overlays)
      (if (overlay-get next-overlay 'eob-overlay)
          (delete-overlay next-overlay)))
    ;; 新規EOF マークの表示
    (put-text-property 0 (length eob-text)
                       'face '(foreground-color . "gray30") eob-text)
    (overlay-put eob-mark 'eob-overlay t)
    (overlay-put eob-mark 'after-string eob-text)))
(add-hook 'find-file-hooks 'my-mark-eob)
