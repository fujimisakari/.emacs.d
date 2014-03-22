;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                js2-mode設定                                ;;
;;;--------------------------------------------------------------------------;;;

;; js2-mode
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$" . js2-mode))

;; (defun js-indent-hook ()
;;   ;; インデント幅を2にする
;;   (setq js-indent-level 2
;;         js-expr-indent-offset 2
;;         indent-tabs-mode nil)
;;   ;; switch文のcaseラベルをインデントする関数を定義する
;;   (defun my-js-indent-line ()
;;     (interactive)
;;     (let* ((parse-status (save-excursion (syntax-ppss (point-at-bol))))
;;            (offset (- (current-column) (current-indentation)))
;;            (indentation (js--proper-indentation parse-status)))
;;       (back-to-indentation)
;;       (if (looking-at "case\\s-")
;;           (indent-line-to (+ indentation 2))
;;         (js-indent-line))
;;       (when (> offset 0) (forward-char offset))))
;;   ;; caseラベルのインデント処理をセットする
;;   (set (make-local-variable 'indent-line-function) 'my-js-indent-line)
;;   ;; ここまでcaseラベルを調整する設定
;;   )

;; js-modeの起動時にhookを追加
(add-hook 'js-mode-hook'(lambda()
                          (mode-init-func)))

