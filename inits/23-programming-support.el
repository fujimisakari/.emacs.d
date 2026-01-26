;;; 23-programming-support.el --- プログラミング支援設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; プログラムをインタラクティブに実行する
(autoload 'quickrun "quickrun" nil t)
(autoload 'quickrun-region "quickrun" nil t)

;; リジョン選択をgithubで開く
(require 'open-github-from-here)

;; git blameからPRを開く
(require 'vc-annotate)
(setq vc-annotate-background-mode nil)
(defun open-pr-at-line ()
  (interactive)
  (let* ((rev-at-line (vc-annotate-extract-revision-at-line))
         (rev (car rev-at-line)))
    (shell-command (concat "open-pr-from-commit " rev))))

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
  (cl-loop for (re . modes) in bm-goto-top-alist
           thereis (and (memq major-mode modes)
                        (save-excursion
                          (beginning-of-line)
                          (looking-at re)))))

(defun my/bm-goto-recenter-top (&rest _)
  "Recenter to top after bm-goto if at top pattern."
  (when (bm-goto-top-p)
    (recenter 0)))
(advice-add 'bm-goto :after #'my/bm-goto-recenter-top)

(require 'highlight-symbol)
(setq highlight-symbol-colors '("LightSeaGreen" "HotPink" "SlateBlue1" "DarkOrange" "SpringGreen1" "tan" "DodgerBlue"))

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

;; 縦のインデント表記
(require 'highlight-indent-guides)
(setq highlight-indent-guides-method 'bitmap)
(setq highlight-indent-guides-auto-enabled nil)
(setq highlight-indent-guides-responsive t)
(add-hook 'prog-mode-hook #'highlight-indent-guides-mode)
(add-hook 'yaml-mode-hook #'highlight-indent-guides-mode)

(defun my/normalize-spaces-in-region (start end)
  "Replaces a continuous space or tab in a region with a single space"
  (interactive "r") ;; get a start or end from region
  (save-excursion
    (save-restriction
      (narrow-to-region start end) ;; only region
      (goto-char (point-min))
      (while (re-search-forward "[ \t]+" nil t)
        (replace-match " ")))))

(defun my/add-bullets-to-region (start end)
  "Add ' •' to the beginning of each row in the region. Do not add to
rows that already have ' • '"
  (interactive "r")
  (let ((bullet " • "))
    (save-excursion
      (goto-char start)
      (while (< (point) end)
        (beginning-of-line)
        (unless (looking-at (regexp-quote bullet))
          (insert bullet)
          (setq end (+ end (length bullet)))) ;  ; end位置を調整
        (forward-line 1)))))

;;; 23-programming-support.el ends here
