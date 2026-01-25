;;; 02-emacs-server.el --- Emacs Server設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(server-start)

;; emacsclientでの編集が終了したらEmacsをアイコン化する（好みに応じて）
(defun iconify-emacs-when-server-is-done ()
  (unless server-clients (iconify-frame)))
;;(add-hook 'server-done-hook 'iconify-emacs-when-server-is-done)

;; serverモードで起動時は1画面で開く
(defun my/server-switch-setup ()
  "Delete other windows on server switch."
  (delete-other-windows))
(add-hook 'server-switch-hook #'my/server-switch-setup)

;;; 02-emacs-server.el ends here
