;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                 etags設定                                  ;;
;;;--------------------------------------------------------------------------;;;

;; (defun find-tag-next ()
;;   (interactive)
;;   (find-tag last-tag t))

;; ;; キーバインド設定
;; (global-set-key (kbd "C-M-]") 'find-tag)
;; (global-set-key (kbd "C-]") 'find-tag-other-window)
;; (global-set-key (kbd "C-:") 'find-tag-next)
;; (global-set-key (kbd "C-M-:") 'pop-tag-mark)

;; ;; 読み込みタグテーブル
;; (let ((path-list (list (gethash "tags-path1" private-env-hash)
;;                        (gethash "tags-path2" private-env-hash)
;;                        (gethash "tags-path3" private-env-hash))))
;;   (setq tags-table-list path-list))
