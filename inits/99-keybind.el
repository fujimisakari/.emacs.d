;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                KeyBind設定                                 ;;
;;;--------------------------------------------------------------------------;;;

(require 'bind-key)

;; key-chord
(key-chord-define-global "qp" 'describe-bindings)            ; キーバインド設定の参照
(key-chord-define-global "ui" 'skk-mode)                     ; skk-modeを有効
(key-chord-define-global "kl" 'view-mode)                    ; view-modeを有効

;; Fn
(bind-key "<f1>" 'linum-mode)                                ; 行番号表示
(bind-key "<f3>" 'mo-git-blame-current)                      ; git-blame表示
(bind-key "<f4>" 'magit-status)                              ; git statusを表示
(bind-key "<f5>" 'wl)                                        ; wanderlustの起動
(bind-key "<f6>" 'id-manager)                                ; id-managerの起動

;; C-
(bind-key* "C-'" 'helm-mini)                                 ; helmの起動
(bind-key "C-;" 'ace-jump-word-mode)                         ; 単語でace-jump
(bind-key "C-," 'er/expand-region)                           ; 拡張リジョン選択
(bind-key "C-." 'redo)                                       ; redo
(bind-key "C-k" 'kill-line)                                  ; カーソル位置より前(右)を削除
(bind-key "C-t" 'other-window-or-split)                      ; ウィンドウを切り替える
(bind-key "C-h" 'delete-backward-char)                       ; C-hをバックスペースに割り当てる（ヘルプは、<F1>にも割り当てられている）
(bind-key "C-m" 'newline-and-indent)                         ; "C-m" に newline-and-indent を割り当てる。初期値は newline
(bind-key "C-<tab>" 'tabify)                                 ; TAB生成
(bind-key "C-x C-f" 'helm-find-files)                        ; helmでファイルリスト検索
(bind-key "C-x C-c" 'server-edit)                            ; emacsclientの終了をC-x C-cに割り当てる（好みに応じて）

;; C-M-
(bind-key* "C-M-d" 'duplicate-this-line-forward)             ; 直前行をコピーする
(bind-key* "C-M-i" 'helm-imenu)                              ; helm-imenuの起動
(bind-key* "C-M-l" 'elscreen-next)                           ; タブの右移動
(bind-key* "C-M-h" 'elscreen-previous)                       ; タブの左移動
(bind-key "C-M-<right>" 'elscreen-swap-next)                 ; タブの配置位置ずらし(右)
(bind-key "C-M-<left>" 'elscreen-swap-previous)              ; タブの配置位置ずらし(左)
(bind-key "C-M-<tab>" 'untabif)                              ; TAB削除
(bind-key "C-M-o" 'occur-by-moccur)                          ; 現在開いているファイルをmoccur検索する
(bind-key "C-M-p" 'highlight-symbol-prev-in-defun)           ; 関数内のhighlight-symbolの移動(前)
(bind-key "C-M-n" 'highlight-symbol-next-in-defun)           ; 関数内のhighlight-symbolの移動(次)
(bind-key "C-M-;" 'recenter-top-bottom)                      ; 現在の行の位置調整
(bind-key "C-M-'" 'delete-other-windows)                     ; 現在のウィンドウ以外を消す
(bind-key "C-M-," 'helm-gtags-find-tag-other-window)         ; (別バッファで)関数の定義元(関数の実体)へジャンプ

;; M-
(bind-key* "M-k" 'kill-buffer-for-elscreen)                  ; カレントバッファを閉じる
(bind-key "M-x" 'helm-M-x)                                   ; helmでM-x
(bind-key "M-y" 'helm-show-kill-ring)                        ; 過去のkill-ringの内容を取り出す
(bind-key "M-/" 'hippie-expand)                              ; 略語展開・補完を行うコマンドをまとめる(M-x hippie-expand)
(bind-key "M-g" 'goto-line)                                  ; M-g で指定行へジャンプ
(bind-key "M-h" 'backward-kill-word)                         ; 直前の単語を削除
(bind-key "M-<right>" 'flymake-goto-prev-error)              ; flymakeの警告・エラーに移動(前)
(bind-key "M-<left>" 'flymake-goto-next-error)               ; flymakeの警告・エラーに移動(次)
(bind-key "M-[" 'bm-previous)                                ; bm-goto 前へ移動
(bind-key "M-]" 'bm-next)                                    ; bm-goto 次へ移動
(bind-key "M-SPC" 'bm-toggle)                                ; bm-goto 現在行に色をつけて記録
;; (bind-key "M-o" 'helm-occur)                                 ; helm-occurの起動
(bind-key "M-o" 'anything-c-moccur-occur-by-moccur)          ; anything-c-moccurの起動
(bind-key "M-P" 'highlight-symbol-prev)                      ; highlight-symbolの移動(前)
(bind-key "M-N" 'highlight-symbol-next)                      ; highlight-symbolの移動(次)

;; C-l
(unbind-key "C-l")
(bind-key "C-l q" 'quickrun)                                 ; quickrun(バッファ)
(bind-key "C-l l" 'ace-jump-line-mode)                       ; 行でace-jump
(bind-key "C-l j" 'just-one-space)                           ; 1文字空白を残して不要な空白を削除
(bind-key "C-l w" 'whitespace-cleanup)                       ; TABを空白に置換
(bind-key "C-l k" 'keitai-hankaku-katakana-region)           ; 全角カナを半角カナに置換
(bind-key "C-l b" 'open-browse-by-url)                       ; URLをブラウザで開く
(bind-key "C-l g" 'open-github-from-here)                    ; リジョン選択をgithubで開く
(bind-key "C-l u" 'revert-buffer)                            ; バッファ更新
(bind-key "C-l o" 'line-to-top-of-window)                    ; 現在行を最上部にする
(bind-key "C-l f" 'helm-ag)                                  ; helm-ag検索
(bind-key "C-l d" 'dired-open-current-directory)             ; 現在開いているバッファをdierdで開く
(bind-key "C-l r" 'anzu-query-replace-regexp)                ; インタラクティブ置換(anzu)
(bind-key "C-l R" 'anzu-query-replace)                       ; 一括置換
(bind-key "C-l s" 'my-switch-to-scratch/current-buffer)      ; *scratch*バッファに移動
(bind-key "C-l C-'" 'flyspell-region)                        ; スペルが正しいかチェック
(bind-key* "C-l C-l" 'highlight-symbol-at-point)             ; symbolをhighlight表示
(bind-key "C-l C-q" 'quickrun-region)                        ; quickrun(リジョン)
(bind-key "C-l C-;" 'google-translate-enja-or-jaen)          ; google翻訳
(bind-key "C-l C-j" 'delete-horizontal-space)                ; 行の不要な空白を削除
(bind-key "C-l C-f" 'moccur-grep-find)                       ; moccur-grep検索
(bind-key* "C-l C-M-l" 'highlight-symbol-remove-all)         ; symbolをhighlight表示を解除
(bind-key "C-l C-M-'" 'ispell-word)                          ; 現在のスペルから候補を表示
(bind-key "C-l C-M-;" 'sdic-describe-region)                 ; 英辞郎で翻訳
(bind-key "C-l C-M-h" 'hatena-keyword-start)                 ; 英辞郎で翻訳
;; (bind-key "C-l r" 'query-replace-regexp)                     ; インタラクティブ置換
;; (bind-key "C-l R" 'replace-regexp)                           ; 一括置換
(bind-key "C-l v s" 'smeargle)                               ; 更新履歴を可視化する
(bind-key "C-l v c" 'smeargle-clear)                         ; smeargleを消す

;; emacs-lisp-mode
(bind-key "C-c C-d" 'lispxmp emacs-lisp-mode-map)            ; 実行結果を注釈してくれる

;; php-mode
(bind-key "C-o" 'phpcmp-complete php-mode-map)               ; 補完

;; perl-mode
;; (define-key cperl-mode-map "\M-\t" 'perlplus-complete-symbol)            ; 補完
;; (define-key cperl-mode-map (kbd "C-c C-c") 'cperl-db)                    ; デバッガの起動

;; web-mode
(bind-key "M-;" 'web-mode-comment-or-uncomment web-mode-map)
(bind-key "C-;" nil web-mode-map)
(bind-key "C-c '" 'sp-fp-file-toggle web-mode-map)

;; markdown-mode
(bind-key "C-c C-s" 'markdown-header-list markdown-mode-map) ; markdown-headerの一覧表示

;; ELSscreen固有のキーバインド
(bind-key "c" 'create-newscreen elscreen-map)
(bind-key "C-a" 'create-maxscreen elscreen-map)
(bind-key "C-k" 'elscreen-kill-screen-and-buffers elscreen-map)
(bind-key "k" 'elscreen-kill-screen-and-buffers elscreen-map)

;; helm-read-file
(bind-key "C-h" 'delete-backward-char helm-read-file-map)             ; C-h でバックスペースと同じように文字を削除できるようにする
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
    (local-set-key (kbd "C-f") 'dired-find-file)                     ; ディレクトリ, ファイルを展開
    (local-set-key (kbd "C-M-m") 'dired-up-directory)                ; 上位ディレクトリへ
    (local-set-key (kbd "C-t") 'other-window-or-split)               ; ウィンドウを切り替える
    (local-set-key (kbd "C-c '") 'dired-sp-fp-directory-toggle)      ; spとfpのディレクトリを切り替える
    (local-set-key (kbd "C-c g") 'dired-move-gree-static-directory)  ; gree staticディレクトリへ切り替える
    (local-set-key (kbd "C-c m") 'dired-move-mbge-static-directory)  ; mbge staticディレクトリへ切り替える
    (local-set-key (kbd "C-c d") 'dired-move-dgame-static-directory) ; dgame staticディレクトリへ切り替える
    (local-set-key (kbd "C-c a") 'dired-move-application-directory)  ; アプリケーションディレクトリへ切り替える
    (local-set-key (kbd "C-c t") 'dired-move-template-directory)     ; テンプレートディレクトリへ切り替える

    (local-set-key (kbd "i") 'dired-subtree-insert)                  ; ディレクトリをサブツリーで開く
    (local-set-key (kbd "C-l i") 'dired-subtree-remove)              ; サブツリーを閉じる
    (local-set-key (kbd "C-l u") 'dired-subtree-up)                  ; サブツリーの上層に移動
    (local-set-key (kbd "C-l d") 'dired-subtree-down)                ; サブツリーの下層に移動

    (local-set-key (kbd "/") 'dired-ex-isearch)                      ; Diredのパス移動
    (local-set-key (kbd "r") 'wdired-change-to-wdired-mode)))

;; auto-complete-mode
(bind-key "<tab>" 'auto-complete ac-mode-map)
(bind-key "C-n" 'ac-next ac-menu-map)
(bind-key "C-p" 'ac-previous ac-menu-map)
(bind-key "C-j" 'ac-complete ac-menu-map)
(bind-key "C-i" 'ac-expand ac-menu-map)

;; anything-c-moccur-anything
(bind-key "C-h" 'delete-backward-char anything-c-moccur-anything-map)  ; 削除

;; mo-git-blame
(bind-key "q" 'mo-git-blame-quit mo-git-blame-mode-map)

;; eclim-mode
(bind-key "C-c C-e ;" 'eclim-run-class eclim-mode-map)
(bind-key "C-<tab>" 'help-at-pt-display eclim-mode-map)