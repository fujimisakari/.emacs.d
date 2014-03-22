;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                              hatena-mode設定                               ;;
;;;--------------------------------------------------------------------------;;;

(require 'hatena-diary)

;; hatena-markup-modeを編集時に使いたい場合
(require 'hatena-markup-mode)
(setq hatena:d:major-mode 'hatena:markup-mode)

;;スーパーpre記法の内部で別のメジャーモードを自動的に有効にする場合
(require 'hatena-multi-mode)
(add-hook 'hatena:markup-mode-hook #'hatena:multi-mode)

(setq hatena:username (gethash "hatena-user" private-env-hash)
      hatena:password (gethash "hatena-password" private-env-hash))

;;; キーバインド
(global-set-key (kbd "<f12>") 'hatena:d:list)
(global-set-key (kbd "C-<f12>") 'hatena:d:list-draft)
