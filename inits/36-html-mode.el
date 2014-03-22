;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               html-mode設定                                ;;
;;;--------------------------------------------------------------------------;;;

;; htmlはweb-modeを使う
(require 'web-mode)

;; emacs 23以下の互換
(when (< emacs-major-version 24)
  (defalias 'prog-mode 'fundamental-mode))

;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

;; インデント数
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   4)
  (setq web-mode-css-offset    4)
  (setq web-mode-script-offset 4)
  (setq web-mode-php-offset    4)
  (setq web-mode-java-offset   4)
  (setq web-mode-asp-offset    4)
  (skk-mode t)
  (add-hook 'local-write-file-hooks
            (lambda ()
              (delete-trailing-whitespace)
               nil)))

; spとfpのファイルを切り替える
(defun sp-fp-file-toggle ()
  (interactive)
  (let ((current-file (buffer-file-name))
        (tmp-file (buffer-file-name)))
    (cond ((string-match "/smartphone/" current-file)
           (setq tmp-file (replace-regexp-in-string "/smartphone/" "/featurephone/" tmp-file)))
          ((string-match "/featurephone/" current-file)
           (setq tmp-file (replace-regexp-in-string "/featurephone/" "/smartphone/" tmp-file))))
    (unless (eq current-file tmp-file)
      (find-file tmp-file))))

;; カラー設定
(set-face-foreground 'web-mode-html-tag-face "lime green")
(set-face-foreground 'web-mode-html-attr-name-face "magenta")
(set-face-foreground 'web-mode-variable-name-face "orange")
(set-face-foreground 'web-mode-preprocessor-face "MediumPurple1")

(add-hook 'web-mode-hook 'web-mode-hook)

;; FlymakeHtml
;; http://www.emacswiki.org/emacs/FlymakeHtml
;; (defun flymake-html-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name))))
;;     (list "~/.emacs.d/bin/tidylint" (list local-file))))
;;     ;; (list "tidy" (list "-utf8" "--doctype" "<!DOCTYPE html>" "--accessibility-check" "1" "--new-blocklevel-tags" "table,section,article,aside,hgroup,header,footer,nav,figure,figcaption,video,audio,canvas" "markup" "no" "tr" "--numeric-entities" "yes" "--fix-bad-comments" "no" local-file))))
;; (add-to-list 'flymake-allowed-file-name-masks
;;              '("\\.html$\\|\\.ctp" flymake-html-init))
;; (add-to-list 'flymake-err-line-patterns
;;              '("line \\([0-9]+\\) column \\([0-9]+\\) - \\(Warning\\|Error\\): \\(.*\\)"
;;                nil 1 2 4))
;; (add-hook 'html-mode-hook '(lambda () (flymake-mode t)))

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
