;;; 42-markdown-mode.el --- markdown-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; autoload
(autoload 'markdown-mode "markdown-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))

(defun my/markdown-mode-setup ()
  "Setup for markdown-mode."
  (my/common-mode-init)
  (markdown-display-inline-images))
(add-hook 'markdown-mode-hook #'my/markdown-mode-setup)

(defun my/markdown-header-list ()
  "Show Markdown Formed Header list through temporary buffer."
  (interactive)
  (occur "^\\(#+\\|.*\n===+\\|.*\n\---+\\)")
  (other-window 1))

;; プレビュー
(defun my/markdown-preview-by-eww ()
  (interactive)
  (message (buffer-file-name))
  (call-process "grip" nil nil nil
                (buffer-file-name)
                "--export"
                "/tmp/grip.html")
  (let ((buf (current-buffer)))
    (eww-open-file "/tmp/grip.html")))

;; 現在のバッファ内の Markdown テーブルをすべて整形する
(defun my/markdown-align-all-tables ()
    (interactive)
  (when (eq major-mode 'markdown-mode)
    (save-excursion
      (save-restriction
        (widen)
        (goto-char (point-min))
        ;; 行頭の | を探す
        (while (re-search-forward "^[ \t]*|" nil t)
          (beginning-of-line)
          (when (markdown-table-at-point-p)
            ;; テーブルの開始位置
            (let ((beg (copy-marker (point) nil))
                  end)
              ;; テーブル末尾（行頭が | でなくなる直前）を marker で取る
              (while (and (not (eobp))
                          (save-excursion
                            (beginning-of-line)
                            (looking-at-p "^[ \t]*|")))
                (forward-line 1))
              (setq end (copy-marker (point) t)) ;; t: 末尾挿入に追従

              ;; テーブルブロックだけ narrow して整形
              (save-restriction
                (narrow-to-region beg end)
                (goto-char (point-min))
                (when (markdown-table-at-point-p)
                  (markdown-table-align)))

              ;; 次の探索開始位置を「テーブル末尾」に移動（marker なのでズレない）
              (goto-char end)

              ;; marker を解放（地味に大事）
              (set-marker beg nil)
              (set-marker end nil))))))))

(defun my/markdown-enable-auto-table-align-on-save ()
  "このバッファで保存時に Markdown テーブルを全整形する。"
  (add-hook 'before-save-hook #'my/markdown-align-all-tables nil t))

(add-hook 'markdown-mode-hook #'my/markdown-enable-auto-table-align-on-save)

;;; 42-markdown-mode.el ends here
