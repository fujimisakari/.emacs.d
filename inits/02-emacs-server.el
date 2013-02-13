;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                              Emacs Server設定                              ;;
;;;--------------------------------------------------------------------------;;;

(server-start)

;; emacsclientでの編集が終了したらEmacsをアイコン化する（好みに応じて）
(defun iconify-emacs-when-server-is-done ()
  (unless server-clients (iconify-frame)))
;;(add-hook 'server-done-hook 'iconify-emacs-when-server-is-done)

;; serverモードで起動時はSKKモードで1画面で開く
(add-hook 'server-switch-hook
          (lambda()
            (delete-other-windows)
            (skk-mode)))
