;;; 63-ai-cli.el --- AI CLI(codex/claude)連携設定 -*- lexical-binding: t; -*-

;;; Commentary:

;; リージョンをAI CLI(codex / claude)へ渡して以下を行う。
;;   - 清書: リージョンをその場で差し替える (my/ai-rewrite-region)
;;   - 翻訳: 英⇄日を自動判定し別バッファ(popwin)へ表示する (my/ai-translate-region)
;; API/APIキー不要で、認証済みのローカルCLIを非対話モードで呼び出すだけ。
;; codex は `codex exec`、claude は `claude -p` を使い、リージョンを標準入力へ、
;; 結果を標準出力から受け取る。進捗等の標準エラー出力は捨てる(2>/dev/null)。

;;; Code:

(defcustom my/ai-cli-backend 'codex
  "清書・翻訳に使うAI CLIバックエンド。シンボル codex または claude。"
  :type '(choice (const codex) (const claude))
  :group 'my)

(defun my/ai-cli-toggle-backend ()
  "AI CLIバックエンドを codex <-> claude で切り替える。"
  (interactive)
  (setq my/ai-cli-backend (if (eq my/ai-cli-backend 'codex) 'claude 'codex))
  (message "AI CLI backend: %s" my/ai-cli-backend))

(defun my/ai-cli-command (instruction &optional backend)
  "INSTRUCTION を指示として実行するシェルコマンド文字列を返す。
BACKEND(codex / claude)を指定するとそのCLIを使う。省略時は `my/ai-cli-backend'。
リージョンは標準入力から文脈として渡される。標準エラー出力は捨てる。"
  (pcase (or backend my/ai-cli-backend)
    ('claude (format "claude -p %s 2>/dev/null"
                     (shell-quote-argument instruction)))
    (_       (format "codex exec --skip-git-repo-check --ephemeral %s 2>/dev/null"
                     (shell-quote-argument instruction)))))

;; --- 清書: その場で差し替え ---
(defun my/ai-rewrite-region (start end &optional backend)
  "リージョン(START..END)をAI CLIで清書し、その場で差し替える。
BACKEND(codex / claude)を指定するとそのCLIを使う。省略時は `my/ai-cli-backend'。
置換前テキストは kill-ring に退避されるので取り消しできる。"
  (interactive "r")
  (let* ((instruction
          (read-string
           "清書の指示: "
           "以下の文章を、意味を変えずに丁寧で読みやすい日本語に清書して。前置きや説明は付けず、清書後の本文だけを出力して。"))
         (cmd (my/ai-cli-command instruction backend)))
    (shell-command-on-region start end cmd nil t)))

(defun my/ai-rewrite-region-codex (start end)
  "リージョン(START..END)を codex で清書し、その場で差し替える。"
  (interactive "r")
  (my/ai-rewrite-region start end 'codex))

(defun my/ai-rewrite-region-claude (start end)
  "リージョン(START..END)を claude で清書し、その場で差し替える。"
  (interactive "r")
  (my/ai-rewrite-region start end 'claude))

;; --- 翻訳: 英⇄日を自動判定して別バッファへ表示 ---
(defvar my/ai-translate-buffer-name "*AI Translate*"
  "翻訳結果を表示するバッファ名。popwin(16-popwin.el)でポップアップ表示する。")

(defun my/ai-translate-region (start end)
  "リージョン(START..END)を英⇄日で自動判定して翻訳し、別バッファへ表示する。
バッファ内容は差し替えず、翻訳文は手動でコピーできる。"
  (interactive "r")
  (let* ((text (buffer-substring-no-properties start end))
         ;; ascii(と空白)のみなら英語とみなし日本語へ、それ以外は英語へ翻訳
         (asciip (string-match-p "\\`[[:ascii:][:space:][:cntrl:]]+\\'" text))
         (instruction
          (if asciip
              "以下の英文を自然な日本語に翻訳して。前置きや説明・引用符は付けず、翻訳文だけを出力して。"
            "以下の日本語を自然な英語に翻訳して。前置きや説明・引用符は付けず、翻訳文だけを出力して。"))
         (cmd (my/ai-cli-command instruction))
         (buf (get-buffer-create my/ai-translate-buffer-name)))
    (with-current-buffer buf
      (setq buffer-read-only nil)
      (view-mode -1)
      (erase-buffer))
    (shell-command-on-region start end cmd buf)
    (with-current-buffer buf
      (goto-char (point-min))
      (view-mode 1))                    ; 読み取り専用・q で閉じる
    (display-buffer buf)))

;;; 63-ai-cli.el ends here
