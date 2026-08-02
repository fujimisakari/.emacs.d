;;; 40-org-mode.el --- org-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; autoload
(autoload 'org-mode "org" nil t)

; 拡張子がorgのファイルを開いた場合、自動的にorg-modeにする
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

;; org-modeでの強調表示を有効にする
;; `> ' で始まる引用行用のフェイス
(defface my/org-quote-line-face
  '((t (:inherit font-lock-doc-face)))
  "Face for markdown-style quote lines (`> ...') in org-mode.
markdown-mode の `markdown-blockquote-face' と同じ見た目 (font-lock-doc-face 継承)."
  :group 'org-faces)

(defun my/org-mode-setup ()
  "Setup for org-mode."
  (turn-on-font-lock)
  (my/common-mode-init)
  ;; org-mode では < > が括弧クラス扱いのため、`> 引用' のように
  ;; 片方だけ出現すると rainbow-delimiters の色付けが崩れる。
  ;; バッファローカルに区切り文字クラスへ変更して色付け対象から外す。
  (set-syntax-table (make-syntax-table (syntax-table)))
  (modify-syntax-entry ?< ".")
  (modify-syntax-entry ?> ".")
  ;; 行頭が `> ' の行を引用として色付けする
  (font-lock-add-keywords
   nil
   '(("^[ \t]*\\(>.*\\)$" 1 'my/org-quote-line-face t))
   'append)
  ;; turn-on-font-lock 後にキーワードを追加しているため、既存表示へ再適用する
  (font-lock-flush)
  (font-lock-ensure))
(add-hook 'org-mode-hook #'my/org-mode-setup)

;; インデントマークを拡張
(autoload 'org-bullets-mode "org-bullets" nil t)
(defun my/org-bullets-setup ()
  "Enable org-bullets-mode."
  (org-bullets-mode 1))
(add-hook 'org-mode-hook #'my/org-bullets-setup)

;; org 読み込み後の設定
(with-eval-after-load 'org
  ;; 基本設定
  (setq org-startup-folded t)                    ; 見出しの初期状態（fold）
  (setq org-startup-indented t)                  ; インデントをつける
  (setq org-startup-truncated nil)               ; org-mode開始時は折り返しするよう設定
  (setq org-startup-with-inline-images t)        ; 画像をインライン表示
  (setq org-indent-mode-turns-on-hiding-stars t) ; 見出しインデントのアスタリスクを減らす
  (setq org-return-follows-link t)               ; リンクはRETで開く
  (setq org-image-actual-width 1100)             ; 画像のデフォルト幅を指定

  ;; エクスポート処理
  (setq org-export-default-language "ja")     ; 言語は日本語
  (setq org-export-html-coding-system 'utf-8) ; 文字コードはUTF-8
  (setq org-export-with-fixed-width nil)      ; 行頭の:は使わない BEGIN_EXAMPLE 〜 END_EXAMPLE で十分
  (setq org-export-with-sub-superscripts nil) ; ^と_を解釈しない
  (setq org-export-with-special-strings nil)  ; --や---をそのまま出力する
  (setq org-export-with-TeX-macros nil)       ; TeX・LaTeXのコードを解釈しない
  (setq org-export-with-LaTeX-fragments nil)

  ;; plantuml設定
  (setq org-plantuml-jar-path "~/dotfiles/bin/plantuml.jar") ; plantuml.jar のパス
  (setq org-confirm-babel-evaluate nil)                      ; 実行時の確認を無効化
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t)))                                        ; plantuml を有効化

  ;; src のハイライト設定
  (setq org-src-fontify-natively t)

  (custom-set-faces
   '(org-block-begin-line ((t (:foreground "gray30" :background "gray3" :slant italic))))
   '(org-block-end-line ((t (:foreground "gray30" :background "gray3" :slant italic))))))

(defun my/create-org-img-dir-before-plantuml ()
  (let* ((dir (expand-file-name (format-time-string "~/org/work/img/%Y/%m"))))
    (unless (file-directory-p dir)
      (make-directory dir t))))

(add-hook 'org-babel-before-execute-hook 'my/create-org-img-dir-before-plantuml)

;; org-bullets 読み込み後の設定
;; https://unicode.org/emoji/charts/full-emoji-list.html
(with-eval-after-load 'org-bullets
  (setq org-bullets-bullet-list '("🟢" "🟣" "🔵" "🟠" "🟡")))

;; 画像貼り付け
;; https://chatgpt.com/share/0ca4b7b0-ecc6-41c3-9454-9588aefba8e4
(defun my/copy-latest-file-and-insert-org-link (source-dir target-dir)
  "Copy the latest file from SOURCE-DIR to a subdirectory of TARGET-DIR based on the current date,
d insert the org-mode image link at point."
  (interactive "DSource directory: \nDTarget directory: ")
  (let* ((files (directory-files source-dir t "^[^.].*png"))
         (latest-file (car (sort files (lambda (a b) (time-less-p (nth 5 (file-attributes b))
                                                                  (nth 5 (file-attributes a)))))))
         (file-name (file-name-nondirectory latest-file))
         (current-year (format-time-string "%Y"))
         (current-month (format-time-string "%m"))
         (target-subdir (expand-file-name (concat current-year "/" current-month) target-dir))
         (target-path (expand-file-name file-name target-subdir)))
    (unless (file-directory-p target-subdir)
      (make-directory target-subdir t))
    (copy-file latest-file target-path t)
    (insert (format "[[file:%s]]" target-path))
    (message "Copied file to: %s" target-path)))

(defun my/insert-image-like-logsec ()
  (interactive)
  (my/copy-latest-file-and-insert-org-link "~/Desktop" "~/org/work/img"))

(defun my/convert-text-to-org-table (start end)
  "Converts text in a region to an org-mode table. The number of columns
is automatically determined using the first row as a header."
  (interactive "r")
  (save-excursion
    (let* ((lines (split-string (buffer-substring-no-properties start end) "\n" t))
           (split-lines (mapcar (lambda (line)
                                  (split-string line "[ \t]+" t))
                                lines))
           (max-cols (apply #'max (mapcar #'length split-lines)))
           (table-lines '()))
      ;; ヘッダー行の処理
      (let ((header (car split-lines)))
        (setq header (append header (make-list (- max-cols (length header)) "")))
        (push (concat "| " (mapconcat #'identity header " | ") " |") table-lines)
        (push (concat "|"
                      (mapconcat (lambda (_) "----") header "|")
                      "|") table-lines))
      ;; データ行の処理
      (dolist (row (cdr split-lines))
        (setq row (append row (make-list (- max-cols (length row)) "")))
        (push (concat "| " (mapconcat #'identity row " | ") " |") table-lines))
      ;; 結果を挿入
      (setq table-lines (nreverse table-lines))
      (delete-region start end)
      (dolist (line table-lines)
        (insert line "\n"))
      (org-table-align))))

;;; 40-org-mode.el ends here
