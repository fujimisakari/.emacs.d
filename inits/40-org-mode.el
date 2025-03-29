;;; 40-org-mode.el --- org-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'org)

;; 基本設定
(setq org-startup-folded t)                    ; 見出しの初期状態（fold）
(setq org-startup-indented t)                  ; インデントをつける
(setq org-startup-truncated nil)               ; org-mode開始時は折り返しするよう設定
(setq org-startup-with-inline-images t)        ; 画像をインライン表示
(setq org-indent-mode-turns-on-hiding-stars t) ; 見出しインデントのアスタリスクを減らす
(setq org-return-follows-link t)               ; リンクはRETで開く
(setq org-image-actual-width 1100)             ; 画像のデフォルト幅を指定

; 拡張子がorgのファイルを開いた場合、自動的にorg-modeにする
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

; org-modeでの強調表示を有効にする
(add-hook 'org-mode-hook
          (lambda ()
            (turn-on-font-lock)
            (common-mode-init)))

;; インデントマークを拡張
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;; https://unicode.org/emoji/charts/full-emoji-list.html
(setq org-bullets-bullet-list '("🟢" "🟣" "🟡" "🔵" "🟠"))

;; エクスポート処理
(setq org-export-default-language "ja")     ; 言語は日本語
(setq org-export-html-coding-system 'utf-8) ; 文字コードはUTF-8
(setq org-export-with-fixed-width nil)      ; 行頭の:は使わない BEGIN_EXAMPLE 〜 END_EXAMPLE で十分
(setq org-export-with-sub-superscripts nil) ; ^と_を解釈しない
(setq org-export-with-special-strings nil)  ; --や---をそのまま出力する
(setq org-export-with-TeX-macros nil)       ; TeX・LaTeXのコードを解釈しない
(setq org-export-with-LaTeX-fragments nil)

;; フォントサイズ設定
(set-face-attribute 'org-level-1 nil :bold t :height 1.0)
(set-face-attribute 'org-level-2 nil :bold nil :height 1.0)
(set-face-attribute 'org-level-3 nil :bold nil :height 1.0)
(set-face-attribute 'org-level-4 nil :bold nil :height 1.0)
;; (set-face-attribute 'org-checkbox nil :background "gray" :foreground "black"
;;                                    :box '(:line-width 1 :style released-button))

;; src のハイライト設定
(setq org-src-fontify-natively t)

;; (defface org-block-begin-line
;;   '((t (:foreground "DimGray" :background "DarkSlateGray")))
;;   "Face used for the line delimiting the begin of source blocks.")
;; (set-face-foreground 'org-block-begin-line "DimGray")
;; ;; (set-face-background 'org-block-begin-line "gray18")

;; (defface org-block-background
;;   '((t (:background "gray18")))
;;   "Face used for the source block background.")
;; (set-face-background 'org-block-background "gray18")

;; (defface org-block-end-line
;;   '((t (:foreground "DimGray" :background "gray18")))
;;   "Face used for the line delimiting the end of source blocks.")
;; (set-face-foreground 'org-block-end-line "DimGray")
;; ;; (set-face-background 'org-block-end-line "gray18")

(set-face-foreground 'org-level-5 "orange")  ; レベル3の色とカブってたので変更
(set-face-foreground 'org-level-7 "purple1") ; レベル5の色とカブってたので変更

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
