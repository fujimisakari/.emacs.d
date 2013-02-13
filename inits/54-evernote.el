;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                evernote設定                                ;;
;;;--------------------------------------------------------------------------;;;

(require 'evernote-mode)

(setq evernote-enml-formatter-command '("w3m" "-dump" "-I" "UTF8" "-O" "UTF8"))
;; ユーザ名とパスワードの保存
(setq evernote-username (gethash "evernote-user" private-env-hash))
(setq evernote-password-cache t)

(global-set-key "\C-cec" 'evernote-create-note)
(global-set-key "\C-ceo" 'evernote-open-note)
(global-set-key "\C-ces" 'evernote-search-notes)
(global-set-key "\C-ceS" 'evernote-do-saved-search)
(global-set-key "\C-cew" 'evernote-write-note)
(global-set-key "\C-cep" 'evernote-post-region)
(global-set-key "\C-ceb" 'evernote-browser)
