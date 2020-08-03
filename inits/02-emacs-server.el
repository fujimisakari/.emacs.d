;;; 02-emacs-server.el --- Emacs Server設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(server-start)

;; emacsclientでの編集が終了したらEmacsをアイコン化する（好みに応じて）
(defun iconify-emacs-when-server-is-done ()
  (unless server-clients (iconify-frame)))
;;(add-hook 'server-done-hook 'iconify-emacs-when-server-is-done)

;; serverモードで起動時はSKKモードで1画面で開く
(add-hook 'server-switch-hook
          (lambda()
            (delete-other-windows)))

;;; 02-emacs-server.el ends here
