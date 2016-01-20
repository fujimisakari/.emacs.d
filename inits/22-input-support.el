;;; 22-input-support.el --- 入力支援設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

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

;; 同じコマンドを連続実行したときの振舞いを変更する
;; C-a，C-eを2回押ししたとき，バッファの先頭・末尾へ行く
(require 'sequential-command-config)
(sequential-command-setup-keys)
(define-sequential-command seq-home
  beginning-of-line beginning-of-buffer seq-return)
(define-sequential-command seq-end
  end-of-line end-of-buffer seq-return)
(define-sequential-command org-seq-home
  org-beginning-of-line beginning-of-buffer seq-return)
(define-sequential-command org-seq-end
  org-end-of-line end-of-buffer seq-return)

;; 現在行を最上部にする
(defun line-to-top-of-window ()
  (interactive)
  (recenter 0))

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

;; undoやyank, kill-regionなどで挿入されたテキストを強調表示する
(require 'volatile-highlights)
(volatile-highlights-mode t)
(set-face-foreground 'vhl/default-face "gray75")
(set-face-background 'vhl/default-face "SlateBlue4")

;; スクロールをスムーズにしてくれる
(require 'smooth-scroll)
(smooth-scroll-mode t)

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

;; 対応する括弧に飛ぶ
(defun close-paren-at-point-p ()
  "Check closed paren at point."
  (let ((s (char-to-string (char-after (point)))))
    (s-contains? s ")]}")))

(defun not-paren-matching-at-point-p ()
  "Check not matching paren at point."
  (let ((s (char-to-string (char-after (point)))))
    (not (s-contains? s "{}[]()"))))

(defun goto-matching-paren ()
  "Jump to matching paren."
  (interactive)
  (cond ((close-paren-at-point-p)
         (forward-char)
         (-if-let (p (show-paren--default))
             (goto-char (nth 2 p))
           (backward-char)))
        ((not-paren-matching-at-point-p)
         (when (search-forward-regexp "[(\\[\[{)}]" (point-at-eol) t 1)
           (backward-char)))
        (t
         (-if-let (p (show-paren--default))
             (goto-char (nth 2 p))))))

;; 選択リージョンをクォートする
(defun region-to-single-quote ()
  (interactive)
  (quote-formater "'%s'" "^\\(\"\\).*" ".*\\(\"\\)$"))

(defun region-to-double-quote ()
  (interactive)
  (quote-formater "\"%s\"" "^\\('\\).*" ".*\\('\\)$"))

(defun quote-formater (quote-format re-prefix re-suffix)
  (if mark-active
      (let* ((region-text (buffer-substring-no-properties (region-beginning) (region-end)))
             (replace-func (lambda (re target-text)(replace-regexp-in-string re "" target-text nil nil 1)))
             (text (funcall replace-func re-suffix (funcall replace-func re-prefix region-text))))
        (delete-region (region-beginning) (region-end))
        (insert (format quote-format text)))
    (error "Not Region selection")))

;;; 22-input-support.el ends here
