;;; 12-file.el --- File設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; 使い捨てファイルを設定
;; autoload
(autoload 'open-junk-file "open-junk-file" nil t)
(with-eval-after-load 'open-junk-file
  (setq open-junk-file-format "~/junk/%Y-%m-%d-%H%M%S."))

;; ファイル名がかぶった時、バッファ名をわかりやすくする
;; filename<dir> 形式のバッファ名にする
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;; * で囲まれたバッファ名は対象外とする
(setq uniquify-ignore-bufers-re "*[^*]+*")

;; 現在位置(カーソル)のファイル・URLを開く（アイドル時に設定）
(defun my/ffap-setup ()
  "Setup ffap bindings after idle."
  (ffap-bindings))
(run-with-idle-timer 1 nil #'my/ffap-setup)

;; bookmack設定
;; ブックマークの保存先を指定
(setq bookmark-default-file "~/.emacs.d/private/emacs.bmk")

;; ファイル内の特定の位置をブックマークする
;; ブックマークを変更したら即保存する
(setq bookmark-save-flag 1)
;; 超整理法(好みに応じて)
(progn
  (setq bookmark-sort-flag nil)
  (defun bookmark-arrange-latest-top ()
    (let ((latest (bookmark-get-bookmark bookmark)))
      (setq bookmark-alist (cons latest (delq latest bookmark-alist))))
    (bookmark-save))
  (add-hook 'bookmark-after-jump-hook 'bookmark-arrange-latest-top))

;; バイナリファイルを開く（アイドル時に有効化）
(autoload 'openwith-mode "openwith" nil t)
(defun my/openwith-setup ()
  "Setup openwith-mode after idle."
  (setq openwith-associations
        '(("\\.\\(?:mpe?g\\|avi\\|wmv\\|mp[34]\\|flv\\|wav\\|ogg\\|swf\\|xls\\|xlsx\\)\\'" "open" (file))))
  (openwith-mode 1))
(run-with-idle-timer 1 nil #'my/openwith-setup)
(setq large-file-warning-threshold nil)

;;; 12-file.el ends here
