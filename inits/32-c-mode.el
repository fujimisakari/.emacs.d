;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                 c-mode設定                                 ;;
;;;--------------------------------------------------------------------------;;;

;; c, c++の基本設定
(defun my-c-mode-common-hook()
  (c-set-style "stroustrup")      ; インデントスタイル
  (c-basic-offset 4)              ; 基本インデント量
  (tab-width 4)                   ; タブ幅
  (c-toggle-hungry-state 1)       ; スペースを一気に消す欲張り削除機能とelecetic-modeをを有功にする
  (c-set-offset 'innamespace 0)   ; namespace {}の中はインデントしない
  (c-set-offset 'arglist-close 0) ; 関数の引数リストの閉じ括弧はインデントしない
  (c-set-offset 'comment-intro 0)
  )

;; fly-make設定
(setq gcc-warning-options
      '("-Wall" "-Wextra" "-Wformat=2" "-Wstrict-aliasing=2" "-Wcast-qual"
      "-Wcast-align" "-Wwrite-strings" "-Wfloat-equal"
      "-Wpointer-arith" "-Wswitch-enum"
      ))

(setq gxx-warning-options
      `(,@gcc-warning-options "-Woverloaded-virtual" "-Weffc++")
      )

(setq gcc-cpu-options '("-msse" "-msse2" "-mmmx"))

(defun flymake-c-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name)))
       )
    (list "gcc" `(,@gcc-warning-options ,@gcc-cpu-options "-fsyntax-only" "-std=c99" ,local-file))
    ))
(push '(".+\\.c$" flymake-c-init) flymake-allowed-file-name-masks)

(defun flymake-c++-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "g++" `(,@gxx-warning-options ,@gcc-cpu-options "-fsyntax-only" "-std=c++0x" ,local-file))
    ))
(push '(".+\\.h$" flymake-c++-init) flymake-allowed-file-name-masks)
(push '(".+\\.cpp$" flymake-c++-init) flymake-allowed-file-name-masks)


(add-hook 'c-mode-hook '(lambda () (flymake-mode t) (my-c-mode-common-hook)))
(add-hook 'c++-mode-hook '(lambda () (flymake-mode t) (my-c-mode-common-hook)))

;; ファイルを保存したときに自動でコンパイルする
;; (defvar after-save-hook-command-alist
;;   '(("c" . "make")
;;     ))
;; (defun after-save-hook-command ()
;;   (let* ((filename (buffer-file-name))
;;        (extension (file-name-extension filename))
;;        (pair (assoc extension after-save-hook-command-alist))
;;        )
;;     (when pair
;;       (shell-command (format (cdr pair) filename)))
;;     ))
;; (add-hook 'after-save-hook 'after-save-hook-command)
