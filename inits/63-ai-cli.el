;;; 63-ai-cli.el --- AI CLI(codex/claude)連携設定 -*- lexical-binding: t; -*-

;;; Commentary:

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

(defconst my/ai-cli-codex-provider "litellm"
  "codex の model_provider 名。config.toml の [model_providers.<name>] に対応。")

(defconst my/ai-cli-codex-env-key "LITELLM_API_KEY"
  "codex がAPIキーを読む環境変数名。config.toml の env_key と一致させる。")

(defun my/ai-cli-private (key)
  "private-env-hash から KEY の値を取得する。未設定や空文字なら nil。"
  (let ((v (and (boundp 'private-env-hash) (gethash key private-env-hash))))
    (and (stringp v) (> (length v) 0) v)))

(defun my/ai-cli-codex-base-url ()
  "codex に渡す base_url を返す。未設定なら nil。
private-env の \"openai-api-base\" は /v1 を含まない形なので補う。"
  (let ((base (my/ai-cli-private "openai-api-base")))
    (when base
      (if (string-suffix-p "/v1" base)
          base
        (concat (directory-file-name base) "/v1")))))

(defun my/ai-cli-process-environment ()
  "APIキーを載せた `process-environment' を返す。未設定ならそのまま返す。"
  (let ((key (my/ai-cli-private "openai-api-key")))
    (if key
        (cons (concat my/ai-cli-codex-env-key "=" key) process-environment)
      process-environment)))

(defun my/ai-cli-command (instruction &optional backend)
  "INSTRUCTION を指示として実行するシェルコマンド文字列を返す。
BACKEND(codex / claude)を指定するとそのCLIを使う。省略時は `my/ai-cli-backend'。
リージョンは標準入力から文脈として渡される。標準エラー出力は捨てる。"
  (pcase (or backend my/ai-cli-backend)
    ('claude (format "claude -p %s"
                     (shell-quote-argument instruction)))
    (_       (let ((base (my/ai-cli-codex-base-url)))
               (format "codex exec --skip-git-repo-check --ephemeral%s %s"
                       (if base
                           (format " -c %s"
                                   (shell-quote-argument
                                    (format "model_providers.%s.base_url=%s"
                                            my/ai-cli-codex-provider base)))
                         "")
                       (shell-quote-argument instruction))))))

;; --- CLI 実行: stdout / stderr / 終了ステータスを分けて受け取る ---

(defvar my/ai-cli-error-buffer-name "*AI CLI Error*"
  "CLI が失敗したときに標準エラー出力を表示するバッファ名。")

(defun my/ai-cli-run (text cmd)
  "TEXT を標準入力として CMD を実行する。
戻り値は (STATUS STDOUT STDERR)。STATUS は終了コード。"
  (let ((err-file (make-temp-file "ai-cli-err"))
        (out-buf (generate-new-buffer " *ai-cli-out*")))
    (unwind-protect
        (let ((status (let ((process-environment (my/ai-cli-process-environment)))
                        (with-temp-buffer
                          (insert text)
                          (call-process-region
                           (point-min) (point-max) shell-file-name nil
                           (list out-buf err-file) nil
                           shell-command-switch cmd)))))
          (list status
                (with-current-buffer out-buf (buffer-string))
                (with-temp-buffer (insert-file-contents err-file) (buffer-string))))
      (kill-buffer out-buf)
      (delete-file err-file))))

(defun my/ai-cli-blank-p (s)
  "S が空または空白のみなら non-nil。"
  (string-match-p "\\`[ \t\n\r]*\\'" s))

(defun my/ai-cli-report-failure (cmd status err)
  "CLI の失敗内容を専用バッファへ表示する。バッファは書き換えない。"
  (let ((buf (get-buffer-create my/ai-cli-error-buffer-name)))
    (with-current-buffer buf
      (setq buffer-read-only nil)
      (view-mode -1)
      (erase-buffer)
      (insert (format "AI CLI の実行に失敗しました (終了コード: %s)\n\n" status))
      (insert (format "コマンド:\n  %s\n\n" cmd))
      (insert "標準エラー出力:\n")
      (insert (if (my/ai-cli-blank-p err) "  (出力なし)\n" err))
      (goto-char (point-min))
      (view-mode 1))
    (display-buffer buf)
    (message "AI CLI が失敗しました。%s を確認してください" my/ai-cli-error-buffer-name)))

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
         (cmd (my/ai-cli-command instruction backend))
         (res (my/ai-cli-run (buffer-substring-no-properties start end) cmd))
         (status (nth 0 res))
         (out (nth 1 res))
         (err (nth 2 res)))
    ;; 失敗時や出力が空のときにリージョンを消してしまわないようにする
    (if (or (not (eq status 0)) (my/ai-cli-blank-p out))
        (my/ai-cli-report-failure cmd status err)
      (save-excursion
        (delete-region start end)
        (goto-char start)
        (insert out)))))

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
         (res (my/ai-cli-run text cmd))
         (status (nth 0 res))
         (out (nth 1 res))
         (err (nth 2 res)))
    ;; 失敗時は空の結果バッファを出さず、エラー内容を表示する
    (if (or (not (eq status 0)) (my/ai-cli-blank-p out))
        (my/ai-cli-report-failure cmd status err)
      (let ((buf (get-buffer-create my/ai-translate-buffer-name)))
        (with-current-buffer buf
          (setq buffer-read-only nil)
          (view-mode -1)
          (erase-buffer)
          (insert out)
          (goto-char (point-min))
          (view-mode 1))                ; 読み取り専用・q で閉じる
        (display-buffer buf)))))

;;; 63-ai-cli.el ends here
