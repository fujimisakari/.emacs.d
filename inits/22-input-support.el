;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               入力支援設定                                 ;;
;;;--------------------------------------------------------------------------;;;

(setq kill-whole-line t)            ; C-kは行末改行を削除しないが、改行までまとめて行カットする
(setq next-screen-context-lines 1)  ; C-v/M-vで前のページの１行を残す

;; キーボードの同時押しでコマンドを実行する
(require 'key-chord)
(setq key-chord-two-keys-delay 0.06)     ; 許容誤差は0.06秒
(key-chord-mode 1)

;; リジョン選択拡張
(require 'expand-region)

;; 未来へやり直しできるようにる(redo)
;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
(require 'redo+)
;; 過去のundoがredoされないようにする
(setq undo-no-redo t)
;; 大量のundoに 耐えられるようにする
(setq undo-limit 600000)
(setq undo-strong-limit 900000)

;; スペルチェッカは aspell を使う
(when (executable-find "aspell")
  (setq-default ispell-program-name "aspell"))

;; Tabの代わりにスペースでインデント
(setq-default tab-width 4 indent-tabs-mode nil)
;; M-iで字下げは4の倍数にする
(custom-set-variables
 '(tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))))

;; 矩形をより簡単にする
(cua-mode t)
(setq cua-enable-cua-keys nil) ;; 変なキーバインドを禁止

;; 物理行でカーソル移動する
;; (install-elisp http://homepage1.nifty.com/bmonkey/emacs/elisp/screen-lines.el)
(require 'screen-lines)
;; text-modeかそれを継承したメジャーモードで自動的に有効にする
(add-hook 'text-mode-hook 'turn-on-screen-lines-mode)

;; インデントを飛ばした行頭に移動
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

;; 同じコマンドを連続実行したときの振舞いを変更する
;; C-a，C-eを2回押ししたとき，バッファの先頭・末尾へ行く
(require 'sequential-command-config)
(sequential-command-setup-keys)

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

;; auto-complete-mode: 高機能補完+ポップアップメニュー
(require 'auto-complete-config)
(ac-config-default)
(setq ac-auto-start nil)
(setq ac-delay 0.8)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/share/ac-dict")
;; ソートファイルの保存場所を変更
(setq ac-comphist-file
      (expand-file-name (concat user-emacs-directory "/cache/ac-comphist.dat")))
;; クイックヘルプを利用しない
(setq ac-use-quick-help nil)
;; 補完メニューのときだけキーバインドを有効にする
(setq ac-use-menu-map t)
;; 色の設定
(set-face-foreground 'ac-candidate-face "#fff")
(set-face-background 'ac-candidate-face "#444")
(set-face-foreground 'ac-selection-face "#fff")
(set-face-background 'ac-selection-face "SlateBlue2")
(set-face-foreground 'ac-gtags-candidate-face "#fff")
(set-face-background 'ac-gtags-candidate-face "#444")
(set-face-foreground 'ac-gtags-selection-face "#fff")
(set-face-background 'ac-gtags-selection-face "SlateBlue2")

(set-face-foreground 'popup-menu-face "#fff")
(set-face-background 'popup-menu-face "#444")
(set-face-foreground 'popup-menu-selection-face "#fff")
(set-face-background 'popup-menu-selection-face "SlateBlue2")

(set-face-background 'popup-scroll-bar-foreground-face "#ccc")
(set-face-background 'popup-scroll-bar-background-face "#444")

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
