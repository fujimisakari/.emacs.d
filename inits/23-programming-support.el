;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                            プログラミング支援                              ;;
;;;--------------------------------------------------------------------------;;;

(defun alcs-describe-function (name)
  (describe-function (anything-c-symbolify name)))

(defun alcs-describe-variable (name)
  (describe-variable (anything-c-symbolify name)))

;; ;; 括弧の対応を取りながらS式を編集する
;; (require 'paredit)
;; (add-hook 'emacs-lis-mode-hook 'enable-paredit-mode)
;; (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
;; (add-hook 'lisp-mode-hook 'enable-paredit-mode)
;; (add-hook 'ielm-mode-hook 'enable-paredit-mode)

;; 式の評価結果を注釈する
(require 'lispxmp)
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)

;; Emacs-lisp関数・変数のヘルプをエコーエリアに表示する
(require 'eldoc-extension)                ; 拡張版
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(setq eldoc-idle-delay 0.2)               ; すぐに表示したい
(setq eldoc-minor-mode-string "")         ; モードラインにElDocと表示しない

;; リスト変数の内容を編集する(M-x edit-list)
(require 'edit-list)

;; バッファのサマリを表示する
(require 'summarye)

;; プログラムを実行する
(require 'quickrun)
(global-set-key (kbd "C-l q") 'quickrun)
(global-set-key (kbd "C-l C-q") 'quickrun-region)

;; HTML XML の要素を隠して見栄えをよくする
;; (require 'html-fold)
;; ;; 隠すインラインの要素
;; (setq html-fold-inline-list
;;       '(("[a:" ("a"))
;;         ("[c:" ("code"))
;;         ("[k:" ("kbd"))
;;         ("[v:" ("var"))
;;         ("[s:" ("samp"))
;;         ("[ab:" ("abbr" "acronym"))
;;         ("[lab:" ("label"))
;;         ("[opt:" ("option"))
;;         ;; RSSの設定
;;         ("[rss:" ("rss"))
;;         ("[link:" ("link"))
;;         ))
;; ;; 隠すブロック要素
;; (setq html-fold-block-list
;;       '("script" "style" "table"
;;         ;; RSSの設定
;;         "description" "content" ))
;; ;; 閉じタグを開いた時の背景
;; (set-face-background 'html-fold-unfolded-face "gray20")

;; ;; ブロックを折畳む
;; (require 'hideshow)
;; (require 'fold-dwim)
;; ;;;; fold-dwim 3つ覚えるだけで伸縮自在に
;; (define-key global-map (kbd "C-c C-M-t") 'fold-dwim-toggle)

;; 現在の関数名を画面の上に表示する
(which-func-mode 1)
;; すべてのメジャーモードにwhich-func-modeを適用する
(setq which-func-modes t)
;; 画面上部に表示する場合は下の2行が必要
(delete (assoc 'which-func-mode mode-line-format) mode-line-format)
(setq-default header-line-format '(which-func-mode ("" which-func-format)))
(set-face-foreground 'which-func "pink")

;; ネストしてるカッコわかりやすくする
(when (require 'rainbow-delimiters nil 'noerror)
  (add-hook 'lisp-interaction-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'js2-mode 'rainbow-delimiters-mode)
  (add-hook 'python-mode-hook 'rainbow-delimiters-mode))

(set-face-foreground 'rainbow-delimiters-depth-1-face "SlateBlue2")
(set-face-foreground 'rainbow-delimiters-depth-2-face "DarkOliveGreen2")
(set-face-foreground 'rainbow-delimiters-depth-3-face "CornflowerBlue")
(set-face-foreground 'rainbow-delimiters-depth-4-face "khaki2")
(set-face-foreground 'rainbow-delimiters-depth-4-face "PaleGreen2")
(set-face-foreground 'rainbow-delimiters-depth-5-face "DarkSlateGray2")
(set-face-foreground 'rainbow-delimiters-depth-6-face "LightSalmon2")
(set-face-foreground 'rainbow-delimiters-depth-7-face "magenta2")
(set-face-foreground 'rainbow-delimiters-depth-8-face "IndianRed4")
(set-face-foreground 'rainbow-delimiters-depth-9-face "DeepPink3")

;; 現在行に色をつけて記録し、移動が可能となる
(global-set-key (kbd "M-[") 'bm-previous)
(global-set-key (kbd "M-]") 'bm-next)
(global-set-key (kbd "M-SPC") 'bm-toggle)

;; 関数定義開始などで目印をつけた場合は画面最上部にもっていく
;; 正規表現とメジャーモードを指定する
(setq bm-goto-top-alist
      '(("^\\$" eshell-mode shell-mode sxmp-mode)
        ("^\\*" org-mode)
        ("^(" emacs-lisp-mode)
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
