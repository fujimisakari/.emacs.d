;;; 08-consult.el --- consult Setting -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'consult)

;; ジャンプ後に再センタリングする
(add-hook 'consult-after-jump-hook #'recenter)

;; 現在行から検索を始める
(setq consult-line-start-from-top nil)

;; プレビューは即時反映させる
(setq consult-preview-key 'any)

(defun my/consult-line-thing-at-point ()
  "`consult-line' with the region or the symbol at point as initial input."
  (interactive)
  (let ((thing (if (use-region-p)
                   (prog1 (buffer-substring-no-properties
                           (region-beginning) (region-end))
                     (deactivate-mark))
                 (thing-at-point 'symbol t))))
    (consult-line thing)))

;;; 08-consult.el ends here
