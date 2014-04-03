;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                css-mode設定                                ;;
;;;--------------------------------------------------------------------------;;;

;; css-mode
(defun css-mode-hooks ()
  "css-mode hooks"
  ;; インデントをCスタイルにする
  (setq cssm-indent-function #'cssm-c-style-indenter)
  ;; インデント幅を4にする
  (setq cssm-indent-level 4)
  ;; インデントにタブ文字を使わない
  (setq-default indent-tabs-mode nil))
(add-hook 'css-mode-hook '(lambda()
                            (css-mode-hooks)
                            (mode-init-func)))
