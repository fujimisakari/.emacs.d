;;; 99-keybind.el --- KeyBind設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'bind-key)

(define-key global-map [?¥] [?\\]) ; ¥の代わりにバックスラッシュを入力する

;; key-chord
(key-chord-define-global "qp" 'helm-descbinds)                ; キーバインド設定の参照
(key-chord-define-global "ui" 'skk-mode)                      ; skk-modeを有効
(key-chord-define-global "kl" 'view-mode)                     ; view-modeを有効
;; (key-chord-define-global "ti" 'display-now-time)              ; 現在時間の表示
(key-chord-define-global "dk" 'helm-ghq)                      ; ghpを起動
(key-chord-define-global "jk" 'custom-cua-set-rectangle-mark) ; cuaを起動

;; region-bindings-mode
(require 'region-bindings-mode)
(region-bindings-mode-enable)
(bind-key "M-'" 'region-to-single-quote region-bindings-mode-map)   ; 選択リージョンを''で囲む
(bind-key "M-\"" 'region-to-double-quote region-bindings-mode-map)  ; 選択リージョンを""で囲む
(bind-key "M-9" 'region-to-bracket region-bindings-mode-map)        ; 選択リージョンを()で囲む
(bind-key "M-[" 'region-to-square-bracket region-bindings-mode-map) ; 選択リージョンを[]で囲む
(bind-key "M-l" 'region-to-clear region-bindings-mode-map)          ; 選択リージョンを囲みをクリア

;; Fn
(bind-key "<f1>" 'linum-mode)                                ; 行番号表示
(bind-key "<f2>" 'twit)                                      ; twiterlingを起動
(bind-key "<f3>" 'id-manager)                                ; id-managerの起動
(bind-key "<f4>" 'wl)                                        ; wanderlustの起動

;; C-
(bind-key* "C-'" 'helm-mini)                                 ; helmの起動
(bind-key "C-;" 'ace-jump-word-mode)                         ; 単語でace-jump
(bind-key* "C-," 'er/expand-region)                          ; 拡張リジョン選択
(bind-key "C-." 'redo)                                       ; redo
(bind-key "C-k" 'kill-line)                                  ; カーソル位置より前(右)を削除
(bind-key "C-t" 'other-window-or-split)                      ; ウィンドウを切り替える
(bind-key "C-h" 'delete-backward-char)                       ; C-hをバックスペースに割り当てる（ヘルプは、<F1>にも割り当てられている）
(bind-key "C-m" 'newline-and-indent)                         ; "C-m" に newline-and-indent を割り当てる。初期値は newline
(bind-key* "C-]" 'goto-matching-paren)                       ; 対応する括弧に飛ぶ
(bind-key "C-x C-f" 'helm-find-files)                        ; helmでファイルリスト検索
(bind-key "C-x C-c" 'server-edit)                            ; emacsclientの終了をC-x C-cに割り当てる（好みに応じて）

;; C-M-
(bind-key* "C-M-d" 'duplicate-this-line-forward)             ; 直前行をコピーする
(bind-key* "C-M-i" 'helm-imenu)                              ; helm-imenuの起動
(bind-key* "C-M-l" 'elscreen-next)                           ; タブの右移動
(bind-key* "C-M-h" 'elscreen-previous)                       ; タブの左移動
(bind-key* "C-M-f" 'elscreen-swap-next)                      ; タブの配置位置ずらし(右)
(bind-key* "C-M-b" 'elscreen-swap-previous)                  ; タブの配置位置ずらし(左)
(bind-key "C-M-o" 'occur-by-moccur)                          ; 現在開いているファイルをmoccur検索する
;; (bind-key "C-M-p" 'highlight-symbol-prev-in-defun)           ; 関数内のhighlight-symbolの移動(前)
;; (bind-key "C-M-n" 'highlight-symbol-next-in-defun)           ; 関数内のhighlight-symbolの移動(次)
(bind-key "C-M-;" 'ace-window)                               ; 現在の行の位置調整
(bind-key "C-M-'" 'delete-other-windows)                     ; 現在のウィンドウ以外を消す
(bind-key "C-M-n" 'helm-gtags-pop-stack)                     ; 関数のジャンプから一つ手前に戻る
(bind-key "C-M-m" 'helm-gtags-find-tag)                      ; (同じバッファで)関数の定義元(関数の実体)へジャンプ
(bind-key "C-M-," 'helm-gtags-find-tag-other-window)         ; 関数の定義元(関数の実体)へジャンプ
(bind-key "C-M-." 'helm-gtags-find-rtag-other-window)        ; 関数の参照先を参照
(bind-key "C-M-/" 'helm-gtags-find-symbol-other-window)      ; シンボルの定義先を参照

;; M-
(bind-key* "M-k" 'kill-buffer-for-elscreen)                  ; カレントバッファを閉じる
(bind-key "M-x" 'helm-M-x)                                   ; helmでM-x
(bind-key "M-y" 'helm-show-kill-ring)                        ; 過去のkill-ringの内容を取り出す
(bind-key "M-/" 'hippie-expand)                              ; 略語展開・補完を行うコマンドをまとめる(M-X Hippie-Expand)
(bind-key "M-g" 'goto-line)                                  ; M-g で指定行へジャンプ
(bind-key "M-h" 'backward-kill-word)                         ; 直前の単語を削除
(bind-key "M-<right>" 'flymake-goto-prev-error)              ; flymakeの警告・エラーに移動(前)
(bind-key "M-<left>" 'flymake-goto-next-error)               ; flymakeの警告・エラーに移動(次)
(bind-key "M-p" 'bm-previous)                                ; bm-goto 前へ移動
(bind-key "M-n" 'bm-next)                                    ; bm-goto 次へ移動
(bind-key "M-SPC" 'bm-toggle)                                ; bm-goto 現在行に色をつけて記録
;; (bind-key "M-o" 'helm-occur)                                 ; helm-occurの起動
;; (bind-key "M-o" 'anything-c-moccur-occur-by-moccur)          ; anything-c-moccurの起動
(bind-key "M-o" 'helm-swoop)                                 ; helm-swoopの起動
(bind-key "M-P" 'highlight-symbol-prev)                      ; highlight-symbolの移動(前)
(bind-key "M-N" 'highlight-symbol-next)                      ; highlight-symbolの移動(次)

;; C-l
(unbind-key "C-l")
(bind-key "C-l 0" 'copy-current-path)                        ; 現在のfile-pathを表示&コピー
(bind-key "C-l q" 'quickrun)                                 ; quickrun(バッファ)
(bind-key "C-l l" 'ace-jump-line-mode)                       ; 行でace-jump
(bind-key "C-l j" 'just-one-space)                           ; 1文字空白を残して不要な空白を削除
(bind-key "C-l w" 'whitespace-cleanup)                       ; TABを空白に置換
(bind-key "C-l k" 'keitai-hankaku-katakana-region)           ; 全角カナを半角カナに置換
(bind-key "C-l b" 'open-browse-by-url)                       ; URLをブラウザで開く
(bind-key "C-l g" 'helm-ghq-list)                            ; ghq経由でGoパッケージディレクトリを開く
(bind-key "C-l u" 'revert-buffer)                            ; バッファ更新
(bind-key "C-l o" 'line-to-top-of-window)                    ; 現在行を最上部にする
(bind-key "C-l a" 'helm-ag)                                  ; helm-ag検索
(bind-key "C-l f" 'helm-find-cmd-type-file)                  ; helm-find-cmd ファイル検索
(bind-key "C-l d" 'helm-find-cmd-type-directory)             ; helm-find-cmd ディレクトリ検索
;; (bind-key "C-l d" 'dired-open-current-directory)             ; 現在開いているバッファをdierdで開く
(bind-key "C-l r" 'anzu-query-replace-regexp)                ; インタラクティブ置換(anzu)
(bind-key "C-l R" 'replace-regexp)                           ; 一括置換
(bind-key "C-l s" 'my-switch-to-scratch/current-buffer)      ; *scratch*バッファに移動
(bind-key "C-l S" 'swap-window-positions)                    ; ウィンドウを入れ替える
(bind-key "C-l z" 'elscreen-set-custom-screen)               ; screenを固定の位置に設定する(custom)
(bind-key "C-l Z" 'elscreen-set-default-screen)              ; screenを固定の位置に設定する(default)
(bind-key "C-l ." 'insert-arrow)
(bind-key "C-l SPC" 'helm-code-skeleton-search)              ; code-skeletonの一覧表示
(bind-key "C-l C-'" 'flyspell-region)                        ; スペルが正しいかチェック
(bind-key* "C-l C-l" 'my-highlight-symbol-at-point)          ; symbolをhighlight表示
(bind-key "C-l C-q" 'quickrun-region)                        ; quickrun(リジョン)
(bind-key "C-l C-;" 'google-translate-enja-or-jaen)          ; google翻訳
(bind-key "C-l C-'" 'sdic-describe-region)                   ; 英辞郎で翻訳
(bind-key "C-l C-j" 'delete-horizontal-space)                ; 行の不要な空白を削除
(bind-key "C-l C-f" 'moccur-grep-find)                       ; moccur-grep検索
(bind-key* "C-l C-M-l" 'highlight-symbol-remove-all)         ; symbolをhighlight表示を解除
(bind-key* "C-l C-M-i" 'imenu-list-smart-toggle)             ; imenu-listの起動
(bind-key "C-l C-M-'" 'ispell-word)                          ; 現在のスペルから候補を表示
(bind-key "C-l C-M-;" 'microsoft-translator-auto-translate)  ; microsoft翻訳
;; (bind-key "C-l r" 'query-replace-regexp)                     ; インタラクティブ置換
;; (bind-key "C-l R" 'replace-regexp)                           ; 一括置換
(bind-key* "C-l M-l" 'interactive-highlight-symbol)          ; symbolをhighlight表示
(bind-key "C-l v s" 'smeargle)                               ; 更新履歴を可視化する
(bind-key "C-l v c" 'smeargle-clear)                         ; smeargleを消す
(bind-key "C-l v a" 'vc-annotate)                            ; git blameを見る
(bind-key "C-l <tab>" 'tabify)                               ; TAB生成
(bind-key "C-l C-<tab>" 'untabify)                           ; TAB削除

;; magit
(bind-key "C-l m s" 'magit-status)                           ; git status
(bind-key "C-l m l" 'magit-log-current)                      ; git log
(bind-key "C-l m d" 'magit-diff-unstaged)                    ; git diff unstaged
(bind-key "C-l m D" 'magit-diff-staged)                      ; git diff staged

;; vc-annotate-mode
(bind-key "P" 'open-pr-at-line vc-annotate-mode-map)         ; PRを開く

;; emacs-lisp-mode
(bind-key "C-c C-d" 'lispxmp emacs-lisp-mode-map)            ; 実行結果を注釈してくれる

;; python-mode(jedi-mode)
(bind-key "C-c f" 'py-autopep8-region python-mode-map)       ; コード整形
(bind-key "C-c i" 'py-isort-buffer python-mode-map)          ; import整形
(bind-key "C-c d" 'python-docstring-comment python-mode-map) ; docstring comment生成
(bind-key "<tab>" 'jedi:complete jedi-mode-map)
(bind-key "C-c ," 'jedi:goto-definition jedi-mode-map)
(bind-key "C-c m" 'jedi:goto-definition-pop-marker jedi-mode-map)
(bind-key "C-l ." 'insert-python-arrow jedi-mode-map)

;; objc-mode
(bind-key "C-c f" 'clang-format-region objc-mode-map)
(bind-key "C-c ;" 'open-header-and-method-file objc-mode-map)
(bind-key "C-c d" 'helm-xcdoc-search-other-window objc-mode-map)
(bind-key "C-c <tab>" 'ac-complete-clang objc-mode-map)

;; swift-mode
(bind-key "C-c <tab>" 'ac-complete-swift swift-mode-map)
(bind-key "C-c C-M-," 'helm-etags-select-other-window swift-mode-map)
(bind-key "C-c d" 'helm-xcdoc-search-other-window swift-mode-map)

;; slime-mode
;; (bind-key "M-l" 'paredit-forward-slurp-sexp slime-mode-map)
;; (bind-key "M-h" 'paredit-forward-barf-sexp slime-mode-map)
;; (bind-key "M-9" 'paredit-wrap-round slime-mode-map)
(bind-key "C-M-," 'helm-gtags-find-tag-other-window slime-mode-map)
(bind-key "C-M-m" 'helm-gtags-pop-stack slime-mode-map)
(bind-key "C-M-." 'helm-gtags-find-rtag slime-mode-map)
(bind-key "C-M-/" 'helm-gtags-find-symbol slime-mode-map)
(bind-key "C-c 1" 'common-lisp-hyperspec slime-mode-map)
(bind-key "C-c 2" 'common-lisp-hyperspec-lookup-reader-macro slime-mode-map)
(bind-key "C-c 3" 'common-lisp-hyperspec-format slime-mode-map)

;; cc-mode
(bind-key "\177" 'indent-dedent-line-backspace c-mode-base-map)
(bind-key "C-c '" 'ff-find-other-file c-mode-base-map)

;; go-mode
(bind-key "C-c e" 'go-errcheck go-mode-map)
(bind-key "C-c t" 'go-toggle-to-test-file go-mode-map)
(bind-key "C-c d" 'open-godoc go-mode-map)
(bind-key "C-c C-t" 'go-open-with-test-file go-mode-map)
(bind-key "C-c C-f" 'gofmt go-mode-map)
(bind-key "C-c C-p" 'helm-go-packages go-mode-map)
(bind-key "C-c C-d" 'godoc-popup go-mode-map)
(bind-key "C-c C-r" 'go-remove-unused-imports go-mode-map)

;; php-mode
(bind-key "\177" 'indent-dedent-line-backspace php-mode-map)
(bind-key "C-." 'redo php-mode-map)
(bind-key "C-c d" 'php-search-documentation php-mode-map)
(bind-key "C-c '" 'web-php-mode-toggle php-mode-map)
(bind-key "C-c p s" 'insert-php-script-tag php-mode-map)
(bind-key "C-c p v" 'insert-php-short-tag php-mode-map)
(bind-key "C-c i n" 'gamewith-insert-namespace php-mode-map)
(bind-key "C-c SPC" 'helm-gamewith-class-search php-mode-map)
(bind-key "C-c C-SPC" 'helm-gamewith-cache-clear php-mode-map)
(bind-key "C-c t" 'gamewith-open-view-file php-mode-map)
(bind-key "C-l ." 'insert-php-arrow-for-instance php-mode-map)
(bind-key "C-l C-." 'insert-php-arrow-for-array php-mode-map)

;; erlang-mode
(bind-key "\177" 'indent-dedent-line-backspace erlang-mode-map)
(bind-key "C-i" 'erlang-indent-command erlang-mode-map)
(bind-key "C-l ." 'insert-erlang-arrow erlang-mode-map)

;; elixir-mode
(bind-key "\177" 'indent-dedent-line-backspace elixir-mode-map)
(bind-key "C-l ." 'insert-elixir-patern-match-arrow elixir-mode-map)
(bind-key "C-l C-." 'insert-elixir-map-arrow elixir-mode-map)
(bind-key "C-l |" 'insert-elixir-chain-arrow elixir-mode-map)

;; js2-mode
(bind-key "\177" 'indent-dedent-line-backspace js2-mode-map)

;; perl-mode
;; (define-key cperl-mode-map "\M-\t" 'perlplus-complete-symbol) ; 補完
;; (define-key cperl-mode-map (kbd "C-c C-c") 'cperl-db)         ; デバッガの起動

;; omnisharp-mode
;; (bind-key "<tab>" 'omnisharp-auto-complete omnisharp-mode-map)
;; (bind-key "C-c ," 'omnisharp-go-to-definition-other-window omnisharp-mode-map)
;; (bind-key "C-c f" 'omnisharp-helm-find-usages omnisharp-mode-map)
;; (bind-key "C-c '" 'work-menu-scene-file-toggle omnisharp-mode-map)
;; (bind-key "C-c m" 'work-open-menu-file omnisharp-mode-map)
;; (bind-key "C-c s" 'work-open-scene-file omnisharp-mode-map)

;; web-mode
(bind-key "M-;" 'web-mode-comment-or-uncomment web-mode-map)
(bind-key "C-;" nil web-mode-map)
;; (bind-key "C-c '" 'sp-fp-file-toggle web-mode-map)
(bind-key "C-c '" 'web-php-mode-toggle web-mode-map)
(bind-key "\177" 'indent-dedent-line-backspace web-mode-map)

;; markdown-mode
(bind-key "C-c C-s" 'markdown-header-list markdown-mode-map)    ; markdown-headerの一覧表示
(bind-key "C-c C-c" 'markdown-preview-by-eww markdown-mode-map) ; プレビュー表示
(unbind-key "RET" markdown-mode-map)

;; ELScreen固有のキーバインド
(bind-key "c" 'elscreen-create elscreen-map)
(bind-key "k" 'elscreen-kill-screen-and-buffers elscreen-map)

;; helm-read-file
;; (bind-key "C-h" 'delete-backward-char helm-read-file-map)             ; C-h でバックスペースと同じように文字を削除できるようにする
(bind-key "<tab>" 'helm-execute-persistent-action helm-read-file-map) ; TAB で補完する

;; org-mode
(bind-key "C-," nil org-mode-map)
(bind-key "C-]" 'org-insert-heading-dwim org-mode-map)
(bind-key "C-<up>" 'outline-previous-visible-heading org-mode-map)
(bind-key "C-<down>" 'outline-next-visible-heading org-mode-map)
(bind-key "C-M-<up>" 'outline-backward-same-level org-mode-map)
(bind-key "C-M-<down>" 'outline-forward-same-level org-mode-map)

;; dired-mode
(add-hook 'dired-mode-hook
  (lambda ()
    (local-set-key (kbd "C-f") 'dired-open-in-accordance-with-situation) ; ディレクトリ, ファイルを展開
    (local-set-key (kbd "C-M-m") 'dired-up-directory)                    ; 上位ディレクトリへ
    (local-set-key (kbd "C-M-r") 'dired-remove-by-shell)                 ; Shell経由で削除処理を行う
    (local-set-key (kbd "C-t") 'other-window-or-split)                   ; ウィンドウを切り替える
    ;; (local-set-key (kbd "i") 'dired-subtree-insert)                      ; ディレクトリをサブツリーで開く
    ;; (local-set-key (kbd "C-l i") 'dired-subtree-remove)                  ; サブツリーを閉じる
    ;; (local-set-key (kbd "C-l u") 'dired-subtree-up)                      ; サブツリーの上層に移動
    ;; (local-set-key (kbd "C-l d") 'dired-subtree-down)                    ; サブツリーの下層に移動
    (local-set-key (kbd "/") 'dired-ex-isearch)                          ; Diredのパス移動
    (local-set-key (kbd "r") 'wdired-change-to-wdired-mode)))

;; lsp-mode-hook
(add-hook 'lsp-mode-hook
          (lambda ()
            ;; (local-set-key (kbd "C-c C-r") 'lsp-ui-peek-find-references)
            ;; (local-set-key (kbd "C-c C-j") 'lsp-ui-peek-find-definitions)
            (local-set-key (kbd "C-c C-r") 'lsp-find-references)
            (local-set-key (kbd "C-c C-j") 'lsp-find-definition-other-window)
            (local-set-key (kbd "C-c C-M-j") 'pop-tag-mark)
            (local-set-key (kbd "C-c i") 'lsp-ui-peek-find-implementation)
            (local-set-key (kbd "C-c m") 'lsp-ui-imenu)
            (local-set-key (kbd "C-c s") 'lsp-ui-sideline-mode)
            (local-set-key (kbd "C-c d") 'ladicle/toggle-lsp-ui-doc)))

;; auto-complete-mode
(bind-key "<tab>" 'auto-complete ac-mode-map)
(bind-key "C-n" 'ac-next ac-menu-map)
(bind-key "C-p" 'ac-previous ac-menu-map)
(bind-key "C-j" 'ac-complete ac-menu-map)
(bind-key "C-i" 'ac-expand ac-menu-map)

;; company-mode
(bind-key "<tab>" 'company-complete)
(bind-key "C-n" 'company-select-next company-active-map)
(bind-key "C-p" 'company-select-previous company-active-map)
(bind-key "C-n" 'company-select-next company-search-map)
(bind-key "C-p" 'company-select-previous company-search-map)
(bind-key "C-s" 'company-filter-candidates company-search-map)

;; anything-c-moccur-anything
(bind-key "C-h" 'delete-backward-char anything-c-moccur-anything-map) ; 削除

;; eclim-mode
(bind-key "C-c C-e ;" 'eclim-run-class eclim-mode-map)
(bind-key "C-<tab>" 'help-at-pt-display eclim-mode-map)

;; puml-mode
(bind-key "C-c C-t" 'plantuml-open-with-png-file plantuml-mode-map)

;; view-mode
(bind-keys :map view-mode-map
           ("h" . backward-char)
           ("l" . forward-char)
           ("j" . next-line)
           ("k" . previous-line)
           ("p" . scroll-down)
           ("n" . scroll-up)
           ("w" . forward-word)
           ("e" . backward-word))

;;; 99-keybind.el ends here
