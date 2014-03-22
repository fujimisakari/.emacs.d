;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                            プログラミング支援                              ;;
;;;--------------------------------------------------------------------------;;;

;; バッファのサマリを表示する
(require 'summarye)

;; プログラムを実行する
(require 'quickrun)
(global-set-key (kbd "C-l q") 'quickrun)
(global-set-key (kbd "C-l C-q") 'quickrun-region)

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
  (add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
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
