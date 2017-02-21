;;; 23-programming-support.el --- プログラミング支援設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; プログラムをインタラクティブに実行する
(require 'quickrun)

;; 現在の関数名を画面の上に表示する
(which-func-mode 1)
;; すべてのメジャーモードにwhich-func-modeを適用する
(setq which-func-modes t)
;; 画面上部に表示する場合は下の2行が必要
;; (delete (assoc 'which-func-mode mode-line-format) mode-line-format)
;; (setq-default header-line-format '(which-func-mode ("" which-func-format)))
(set-face-foreground 'which-func "cyan")

;; リジョン選択をgithubで開く
(require 'open-github-from-here)

;; 更新履歴を可視化する
(require 'smeargle)

;; 関数定義開始などで目印をつけた場合は画面最上部にもっていく
;; 正規表現とメジャーモードを指定する
(setq bm-goto-top-alist
      '(("^\\$" eshell-mode shell-mode sxmp-mode)
        ("^\\*" org-mode)
        ("^(" emacs-lisp-mode)
        ("^ *\\(function\\|class\\)" php-mode)
        ("^ *\\(def\\|class\\|module\\)" python-mode)
        ("^ *\\(def\\|class\\|module\\)" ruby-mode)))

(defun bm-goto-top-p ()
        (loop for (re . modes) in bm-goto-top-alist
              thereis (and (memq major-mode modes)
                           (save-excursion
                             (beginning-of-line)
                             (looking-at re)))))
(defadvice bm-goto (after bm-goto-top activate)
  (when (bm-goto-top-p)
    (recenter 0)))

(require 'highlight-symbol)
(setq highlight-symbol-colors '("LightSeaGreen" "HotPink" "SlateBlue1" "DarkOrange" "SpringGreen1" "tan" "DodgerBlue1"))

;; highlight-symbol-at-point時にfont-lockが狂うので対策
;; あとphp-modeの変数が(thing-at-point 'symbol)だとハイライトできないので 'sexpに変更
(defun my-highlight-symbol-at-point ()
  (interactive)
  (defalias 'highlight-symbol-at-point 'highlight-symbol)
  (if (eq major-mode 'php-mode)
      (highlight-symbol-at-point (thing-at-point 'sexp))
    (highlight-symbol-at-point)))

(defun highlight-symbol-region-or-read-string ()
  (cond
   (mark-active
    (buffer-substring-no-properties (region-beginning) (region-end)))
   (t
    (read-string "highlight word: "))))

(defun interactive-highlight-symbol ()
  (interactive)
  (let ((symbol (highlight-symbol-region-or-read-string)))
    (if (highlight-symbol-symbol-highlighted-p symbol)
        (highlight-symbol-remove-symbol symbol)
      (highlight-symbol-add-symbol symbol)
      (when (member 'explicit highlight-symbol-occurrence-message)
        (highlight-symbol-count symbol t)))))


;; codeのskeletonをhelm経由で参照
(when (require 'helm-code-skeleton nil t)
  (require 'skeleton)
  (setq helm-code-skeleton-dir-path-alist '((python-mode . "$HOME/.emacs.d/code-skeletons/python")
                                            (php-mode . "$HOME/.emacs.d/code-skeletons/php")
                                            (c-mode . "$HOME/.emacs.d/code-skeletons/c")))
  (helm-code-skeleton-load))

;;; 23-programming-support.el ends here
