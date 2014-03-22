;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                  File設定                                  ;;
;;;--------------------------------------------------------------------------;;;

;; 使い捨てファイルを設定
(when (require 'open-junk-file)
;; ファイル名入力時に ~/junk/年-月-日-時分秒. が出てくる
(setq  open-junk-file-format "~/junk/%Y-%m-%d-%H%M%S."))

;; ファイル名がかぶった時、バッファ名をわかりやすくする
(require 'uniquify)
;; filename<dir> 形式のバッファ名にする
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;; * で囲まれたバッファ名は対象外とする
(setq uniquify-ignore-bufers-re "*[^*]+*")

;; 現在位置(カーソル)のファイル・URLを開く
(ffap-bindings)

;; zlc.el でEmacsのミニバッファ候補をzshライクに
;; http://github.com/mooz/emacs-zlc/raw/master/zlc.el
(require 'zlc)
;; TABを押して補完候補一覧を表示する際、即時に一つ目の補完候補を選択する
(setq zlc-select-immediately t)
;; 補完候補一覧にて矢印で移動できるようにする
(let ((map minibuffer-local-map))
  ;; like menu select
  (define-key map (kbd "<down>")  'zlc-select-next-vertical)
  (define-key map (kbd "<up>")    'zlc-select-previous-vertical)
  (define-key map (kbd "<right>") 'zlc-select-next)
  (define-key map (kbd "<left>")  'zlc-select-previous)
  ;; reset selection
  (define-key map (kbd "C-c") 'zlc-reset)
  )
;; 補完候補一覧での候補の色
(set-face-foreground 'zlc-selected-completion-face "gray10")
(set-face-background 'zlc-selected-completion-face "MediumPurple1")

;; bookmack設定
;; ブックマークの保存先を指定
(setq bookmark-default-file "~/.emacs.bmk")

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

;; バイナリファイルを開く
(openwith-mode 1)
(setq openwith-associations
      '(("\\.\\(?:mpe?g\\|avi\\|wmv\\|mp[34]\\|flv\\|wav\\|ogg\\|swf\\|xls\\|xlsx\\)\\'" "open" (file))))
(setq large-file-warning-threshold nil)

