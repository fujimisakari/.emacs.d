;;; 99-keybind.el --- KeyBind設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'bind-key)

(define-key global-map [?¥] [?\\]) ; ¥の代わりにバックスラッシュを入力する

;; key-chord
(key-chord-define-global "qp" 'counsel-descbinds)             ; キーバインド設定の参照
(key-chord-define-global "kl" 'view-mode)                     ; view-modeを有効
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
(bind-key "<f3>" 'id-manager)                                ; id-managerの起動
(bind-key "<f4>" 'wl)                                        ; wanderlustの起動
(bind-key "<f12>" 'toggle-input-method)                      ; IMの切り替え

;; C-
(bind-key* "C-'" 'my-ivy-switch-buffer)                      ; ivyの起動
(bind-key* "C-," 'er/expand-region)                          ; 拡張リジョン選択
(bind-key* "C-]" 'goto-matching-paren)                       ; 対応する括弧に飛ぶ
(bind-key* "C-s" 'swiper-isearch)
(bind-key* "C-<tab>" 'company-complete)                      ; 補完
(bind-key "C-;" 'ace-jump-word-mode)                         ; 単語でace-jump
(bind-key "C-." 'redo)                                       ; redo
(bind-key "C-k" 'kill-line)                                  ; カーソル位置より前(右)を削除
(bind-key "C-t" 'other-window-or-split)                      ; ウィンドウを切り替える
(bind-key "C-h" 'delete-backward-char)                       ; C-hをバックスペースに割り当てる（ヘルプは、<F1>にも割り当てられている）
(bind-key "C-m" 'newline-and-indent)                         ; "C-m" に newline-and-indent を割り当てる。初期値は newline

;; C-x
(bind-key "C-x C-f" 'counsel-find-file)                      ; counselでファイルリスト検索

;; C-M-
(bind-key* "C-M-l" 'elscreen-next)                           ; タブの右移動
(bind-key* "C-M-h" 'elscreen-previous)                       ; タブの左移動
(bind-key* "C-M-/" 'duplicate-this-line-forward)             ; 直前行をコピーする
(bind-key "C-M-;" 'ace-window)                               ; 現在の行の位置調整
(bind-key "C-M-'" 'delete-other-windows)                     ; 現在のウィンドウ以外を消す
(bind-key "C-M-i" 'counsel-imenu)                            ; counsel-imenuの起動
(bind-key "C-M-." 'my-counsel-recentf)                       ; ファイル/ディレクトリ履歴
(bind-key "C-M-," 'my-counsel-bookmark)                      ; ファイル/ディレクトリ履歴
(bind-key "C-M-o" 'occur-by-moccur)                          ; 現在開いているファイルをmoccur検索する

;; M-
(bind-key* "M-k" 'kill-buffer-for-elscreen)                  ; カレントバッファを閉じる
(bind-key* "M-p" 'scroll-up-in-place)                        ; カーソル維持したままスクロール(上)
(bind-key* "M-n" 'scroll-down-in-place)                      ; カーソル維持したままスクロール(下)
(bind-key* "M-o" 'swiper-thing-at-region)                    ; swiperの起動
(bind-key* "M-O" 'swiper-all-thing-at-region)                ; swiper-allの起動
(bind-key "M-x" 'counsel-M-x)                                ; counselでM-x
(bind-key "M-y" 'counsel-yank-pop)                           ; 過去のyank, kill-ringの内容を取り出す
(bind-key "M-/" 'hippie-expand)                              ; 略語展開・補完を行うコマンドをまとめる(M-X Hippie-Expand)
(bind-key "M-g" 'goto-line)                                  ; M-g で指定行へジャンプ
(bind-key "M-h" 'backward-kill-word)                         ; 直前の単語を削除
(bind-key "M-P" 'bm-previous)                                ; bm-goto 前へ移動
(bind-key "M-N" 'bm-next)                                    ; bm-goto 次へ移動
(bind-key "M-SPC" 'bm-toggle)                                ; bm-goto 現在行に色をつけて記録

;; C-l
(unbind-key "C-l")
(bind-key "C-l 0" 'copy-current-path)                        ; 現在のfile-pathを表示&コピー
(bind-key "C-l q" 'quickrun)                                 ; quickrun(バッファ)
(bind-key "C-l l" 'ace-jump-line-mode)                       ; 行でace-jump
(bind-key "C-l w" 'whitespace-cleanup)                       ; TABを空白に置換
(bind-key "C-l k" 'keitai-hankaku-katakana-region)           ; 全角カナを半角カナに置換
(bind-key "C-l b" 'open-browse-by-url)                       ; URLをブラウザで開く
(bind-key "C-l u" 'revert-buffer)                            ; バッファ更新
(bind-key "C-l o" 'line-to-top-of-window)                    ; 現在行を最上部にする
(bind-key "C-l m" 'magit-status)                             ; magit起動
(bind-key "C-l a" 'counsel-ag)                               ; counsel-ag検索
(bind-key "C-l d" 'dired-open-current-directory)             ; 現在開いているバッファをdierdで開く
(bind-key "C-l r" 'anzu-query-replace-regexp)                ; インタラクティブ置換(anzu)
(bind-key "C-l R" 'replace-regexp)                           ; 一括置換
(bind-key "C-l s" 'my-switch-to-scratch/current-buffer)      ; *scratch*バッファに移動
(bind-key "C-l S" 'swap-window-positions)                    ; ウィンドウを入れ替える
(bind-key "C-l t" 'www-page-title)                           ; pageタイトル取得
(bind-key "C-l z" 'elscreen-set-custom-screen)               ; screenを固定の位置に設定する(custom)
(bind-key "C-l Z" 'elscreen-set-default-screen)              ; screenを固定の位置に設定する(default)
(bind-key "C-l ." 'insert-arrow)
(bind-key "C-l <f12>" 'delete-horizontal-space)              ; 行の不要な空白を削除
(bind-key "C-l SPC" 'ivy-yasnippet)                          ; yasnippetの一覧表示
(bind-key* "C-l C-l" 'my-highlight-symbol-at-point)          ; symbolをhighlight表示
(bind-key "C-l C-q" 'quickrun-region)                        ; quickrun(リジョン)
(bind-key "C-l C-f" 'moccur-grep-find)                       ; moccur-grep検索
(bind-key "C-l C-'" 'ispell-word)                            ; 現在のスペルから候補を表示
(bind-key "C-l C-;" 'google-translate-enja-or-jaen)          ; google翻訳
(bind-key* "C-l C-M-l" 'highlight-symbol-remove-all)         ; symbolをhighlight表示を解除
(bind-key* "C-l C-M-i" 'imenu-list-smart-toggle)             ; imenu-listの起動
(bind-key "C-l C-M-;" 'sdic-describe-region)                 ; 英辞郎で翻訳
(bind-key "C-l C-M-'" 'flyspell-region)                      ; スペルが正しいかチェック
(bind-key* "C-l M-l" 'interactive-highlight-symbol)          ; symbolをhighlight表示
(bind-key "C-l v s" 'smeargle)                               ; 更新履歴を可視化する
(bind-key "C-l v c" 'smeargle-clear)                         ; smeargleを消す
(bind-key "C-l v a" 'vc-annotate)                            ; git blameを見る
(bind-key "C-l <tab>" 'tabify)                               ; TAB生成
(bind-key "C-l C-<tab>" 'untabify)                           ; TAB削除

;; vc-annotate-mode
(bind-key "P" 'open-pr-at-line vc-annotate-mode-map)         ; PRを開く

;; emacs-lisp-mode
(bind-key "C-c <f12>" 'my-dumb-jump-go emacs-lisp-mode-map)    ; jump to reference
(bind-key "C-c C-M-j" 'dumb-jump-back emacs-lisp-mode-map)     ; back to caller
(bind-key "C-c C-q" 'dumb-jump-quick-look emacs-lisp-mode-map) ;
(bind-key "C-c C-d" 'lispxmp emacs-lisp-mode-map)              ; 実行結果を注釈してくれる

;; python-mode
(bind-key "C-c f" 'py-autopep8-region python-mode-map)       ; コード整形
(bind-key "C-c i" 'py-isort-buffer python-mode-map)          ; import整形
(bind-key "C-c d" 'python-docstring-comment python-mode-map) ; docstring comment生成

;; objc-mode
(bind-key "C-c f" 'clang-format-region objc-mode-map)
(bind-key "C-c ;" 'open-header-and-method-file objc-mode-map)

;; slime-mode
;; (bind-key "M-l" 'paredit-forward-slurp-sexp slime-mode-map)
;; (bind-key "M-h" 'paredit-forward-barf-sexp slime-mode-map)
;; (bind-key "M-9" 'paredit-wrap-round slime-mode-map)
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
(bind-key "C-c x" 'go-test-current-file go-mode-map)
(bind-key "C-c C-x" 'go-test-current-test go-mode-map)
(bind-key "C-c C-c" 'go-expr-completion go-mode-map)
(bind-key "C-c C-t" 'go-open-with-test-file go-mode-map)
(bind-key "C-c C-f" 'gofmt go-mode-map)
(bind-key "C-c C-d" 'godoc-popup go-mode-map)
(bind-key "C-c C-r" 'go-remove-unused-imports go-mode-map)

;; php-mode
(bind-key "\177" 'indent-dedent-line-backspace php-mode-map)
(bind-key "C-." 'redo php-mode-map)
(bind-key "C-c d" 'php-search-documentation php-mode-map)
(bind-key "C-c '" 'web-php-mode-toggle php-mode-map)
(bind-key "C-c p s" 'insert-php-script-tag php-mode-map)
(bind-key "C-c p v" 'insert-php-short-tag php-mode-map)
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
            (local-set-key (kbd "C-c <f12>") 'lsp-find-definition-other-window)
            (local-set-key (kbd "C-c C-r") 'lsp-ui-peek-find-references)
            (local-set-key (kbd "C-c C-i") 'lsp-ui-peek-find-implementation)
            (local-set-key (kbd "C-c C-M-j") 'pop-tag-mark)
            (local-set-key (kbd "C-c m") 'lsp-ui-imenu)
            (local-set-key (kbd "C-c s") 'lsp-ui-sideline-mode)
            (local-set-key (kbd "C-c d") 'ladicle/toggle-lsp-ui-doc)))

;; lsp-ui-peek-mode
(bind-key "RET" 'lsp-ui-peek--goto-xref-custom-other-window lsp-ui-peek-mode-map)

;; company-mode
(bind-key "C-n" 'company-select-next company-active-map)
(bind-key "C-p" 'company-select-previous company-active-map)
(bind-key "C-s" 'company-filter-candidates company-active-map)
(bind-key "C-n" 'company-select-next company-search-map)
(bind-key "C-p" 'company-select-previous company-search-map)

;; mozc-mode
(bind-key "," '(lambda () (interactive) (mozc-insert-str "、")) mozc-mode-map)
(bind-key "." '(lambda () (interactive) (mozc-insert-str "。")) mozc-mode-map)
(bind-key "?" '(lambda () (interactive) (mozc-insert-str "？")) mozc-mode-map)
(bind-key "!" '(lambda () (interactive) (mozc-insert-str "！")) mozc-mode-map)
(bind-key "C-h" 'delete-backward-char mozc-mode-map)

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
