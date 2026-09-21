;;; 59-lsp-mode.el --- lsp-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; autoload
(autoload 'lsp "lsp-mode" nil t)
(autoload 'lsp-deferred "lsp-mode" nil t)
(autoload 'lsp-rename "lsp-mode" nil t)

;; mode
(defun my/lsp-mode-setup ()
  "Setup LSP mode."
  ;; `lsp-deferred' はバッファが可視になった時点で `lsp' を呼ぶので、
  ;; `lsp' を直接併用すると workspace が二重に張られる。
  ;; 補完も lsp-mode 側 (lsp-completion-enable) が自動で有効化するため呼ばない。
  (lsp-deferred))
(dolist (v '(go-mode-hook
             c-mode-hook
             typescript-mode-hook
             typescript-ts-mode-hook
             tsx-ts-mode-hook
             vue-mode-hook
             vue-ts-mode-hook))
  (add-hook v #'my/lsp-mode-setup))

;; lsp-mode 読み込み後の設定
(with-eval-after-load 'lsp-mode
  (require 'lsp-ui)
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)

  ;; general
  (setq lsp-session-file (expand-file-name (locate-user-emacs-file "../.lsp-session-v1")))
  (setq lsp-print-io nil)
  (setq lsp-trace nil)
  (setq lsp-auto-guess-root t)
  ;; (setq lsp-document-sync-method 'incremental) ;; always send incremental document
  ;; 巨大 monorepo (GOMODCACHE 83GB) だと gopls の応答に数秒かかるため長めに取る
  (setq lsp-response-timeout 20)
  ;; `lsp-enable-completion-at-point' は `lsp-completion-enable' の廃止済みエイリアス。
  ;; nil にすると completion-at-point への統合ごと切れて company-capf が
  ;; LSP の候補を取れなくなる (定義ジャンプや診断だけ動く状態になる)。
  (setq lsp-completion-enable t)
  ;; `lsp-prefer-capf' も `lsp-completion-provider' の廃止済みエイリアス。
  ;; capf は既定なので指定不要。
  (setq lsp-enable-file-watchers nil)
  (setq lsp-ui-flycheck-enable t)

  ;; 入力中に走るリクエストを抑える
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-idle-delay 1.0)

  ;; gopls は daemon モード (-remote=auto) をやめて 1 Emacs = 1 gopls (stdio) にする。
  ;; 共有デーモンは -listen.timeout 1m0s で自死し、その度に workspace が
  ;; SIGKILL されて "Process gopls not running: killed: 9" を起こす。
  (setq lsp-go-gopls-server-args nil)

  ;; lsp-ui-doc
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-use-webkit t)

  ;; lsp-ui-sideline
  (setq lsp-ui-sideline-enable nil)
  (setq lsp-ui-sideline-ignore-duplicate t)
  (setq lsp-ui-sideline-show-symbol t)
  (setq lsp-ui-sideline-show-hover t)
  (setq lsp-ui-sideline-show-diagnostics nil)
  (setq lsp-ui-sideline-show-code-actions nil)

  ;; Vue.js (Volar) 連携
  ;; lsp-mode は lsp-volar を同梱しており、vue-mode / vue-ts-mode を自動検出する
  ;; 事前に以下をインストールしておくこと:
  ;;   npm install -g @vue/language-server typescript-language-server typescript
  (require 'lsp-volar nil t))

;; customize
(defun my/lsp-find-definition-other-window ()
  (interactive)
  (when (one-window-p)
    (progn
      (split-window-horizontally)
      (other-window 1)))
  (lsp-find-definition))

(defun my/lsp-ui-peek--goto-xref-custom-other-window ()
  (interactive)
  (if (one-window-p)
      (lsp-ui-peek--goto-xref nil t))
  (lsp-ui-peek--goto-xref))

;; treemacs
;; lsp-treemacs-errors-list を q で閉じたあとに Treemacs のウィンドウが裏で残らず、完全に削除させる
(defun my/lsp-treemacs--open-error-list (orig-fn &rest args)
  "Open the LSP error list in a normal window, not a side window."
  (let ((display-buffer-alist
         '(("\\*LSP Error List\\*"
            (display-buffer-reuse-window display-buffer-pop-up-window)))))
    (apply orig-fn args)))

(with-eval-after-load 'lsp-treemacs
  (advice-add 'lsp-treemacs--open-error-list :around #'my/lsp-treemacs--open-error-list))

(defun my/fully-remove-lsp-error-list ()
  "Forcefully remove all windows showing *LSP Error List*, clearing window state."
  (interactive)
  (let ((buf (get-buffer "*LSP Error List*")))
    (when buf
      (dolist (win (get-buffer-window-list buf nil t))
        ;; 念のため quit-restore info をクリア
        (set-window-parameter win 'quit-restore nil)
        (set-window-dedicated-p win nil)
        (delete-window win))
      (kill-buffer buf)
      (setq lsp-treemacs-error-list-current nil))))

(with-eval-after-load 'lsp-treemacs
  (define-key lsp-treemacs-error-list-mode-map (kbd "q") #'my/fully-remove-lsp-error-list))

(setq display-buffer-base-action
      '((display-buffer-reuse-window display-buffer-pop-up-window)))

;;; 59-lsp-mode.el ends here
