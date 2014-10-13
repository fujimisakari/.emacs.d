;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                                KeyBind設定                                 ;;
;;;--------------------------------------------------------------------------;;;

;; あらゆるモードで有効なキーバインドの設定(my-keyjack-mode)
(setq my-keyjack-mode-map (make-sparse-keymap))
(mapcar (lambda (x)
          (define-key my-keyjack-mode-map (car x) (cdr x))
          (global-set-key (car x) (cdr x)))
        '(("\C-\M-l" . elscreen-next)                       ; タブの右移動
          ("\C-\M-h" . elscreen-previous)                   ; タブの左移動
          ("\C-\M-d" . duplicate-this-line-forward)         ; 直前行をコピーする
          ("\C-\M-i" . helm-imenu)))                        ; imenu起動
(easy-mmode-define-minor-mode my-keyjack-mode "Grab keys"
                              t " Keyjack" my-keyjack-mode-map)

;; Fn
(global-set-key (kbd "<f1>") 'linum-mode)                                ; 行番号表示
(global-set-key (kbd "<f3>") 'mo-git-blame-current)                      ; git-blame表示
(global-set-key (kbd "<f4>") 'magit-status)                              ; git statusを表示
(global-set-key (kbd "<f5>") 'wl)                                        ; wanderlustの起動
(global-set-key (kbd "<f6>") 'id-manager)                                ; id-managerの起動

;; key-chord
(key-chord-define-global "qp" 'describe-bindings)                        ; キーバインド設定の参照
(key-chord-define-global "ui" 'skk-mode)                                 ; skk-modeを有効
(key-chord-define-global "kl" 'view-mode)                                ; view-modeを有効

;; C-
(global-set-key (kbd "C-;") 'helm-mini)                                  ; helmの起動
(global-set-key (kbd "C-M-i") 'helm-imenu)                               ; helm-imenuの起動
(global-set-key (kbd "C-x C-f") 'helm-find-files)                        ; helmでファイルリスト検索
(global-set-key (kbd "C-k") 'kill-line)                                  ; カーソル位置より前(右)を削除
(global-set-key (kbd "C-t") 'other-window-or-split)                      ; ウィンドウを切り替える
(global-set-key (kbd "C-.") 'redo)                                       ; redo
(global-set-key (kbd "C-h") 'delete-backward-char)                       ; C-hをバックスペースに割り当てる（ヘルプは、<F1>にも割り当てられている）
(global-set-key (kbd "C-x C-c") 'server-edit)                            ; emacsclientの終了をC-x C-cに割り当てる（好みに応じて）
(global-set-key (kbd "C-m") 'newline-and-indent)                         ; "C-m" に newline-and-indent を割り当てる。初期値は newline
(global-set-key (kbd "C-M-;") 'delete-other-windows)                     ; 現在のウィンドウ以外を消す
(global-set-key (kbd "C-M-o") 'occur-by-moccur)                          ; 現在開いているファイルをmoccur検索する
(global-set-key (kbd "C-<tab>") 'tabify)                                 ; TAB生成
(global-set-key (kbd "C-M-<tab>") 'untabif)                              ; TAB削除
(global-set-key (kbd "C-M-d") 'duplicate-this-line-forward)              ; 直前行をコピーする
;; (global-set-key (kbd "C-'") 'helm-gtags-find-tag)                        ; 関数の定義元(関数の実体)へジャンプ
(global-set-key (kbd "C-'") 'helm-gtags-find-tag-other-window)           ; (別バッファで)関数の定義元(関数の実体)へジャンプ
(global-set-key (kbd "C-M-<right>") 'elscreen-swap-next)                 ; タブの配置位置ずらし(右)
(global-set-key (kbd "C-M-<left>") 'elscreen-swap-previous)              ; タブの配置位置ずらし(左)
(global-set-key (kbd "C-M-p") 'highlight-symbol-prev-in-defun)           ; 関数内のhighlight-symbolの移動(前)
(global-set-key (kbd "C-M-n") 'highlight-symbol-next-in-defun)           ; 関数内のhighlight-symbolの移動(次)
(global-set-key (kbd "C-M-'") 'gtags-find-tag)                           ; 変数等のジャンプ
(global-set-key (kbd "C-M-r") 'recenter-top-bottom)                      ; 現在の行の位置調整
(global-set-key (kbd "C-,") 'er/expand-region)                           ; 拡張リジョン選択
(global-set-key (kbd "C-M-,") 'er/contract-region)                       ; 拡張リジョン選択(戻す)

;; M-
(global-set-key (kbd "M-x") 'helm-M-x)                                   ; helmでM-x
(global-set-key (kbd "M-y") 'helm-show-kill-ring)                        ; 過去のkill-ringの内容を取り出す
(global-set-key (kbd "M-/") 'hippie-expand)                              ; 略語展開・補完を行うコマンドをまとめる(M-x hippie-expand)
(global-set-key (kbd "M-g") 'goto-line)                                  ; M-g で指定行へジャンプ
(global-set-key (kbd "M-h") 'backward-kill-word)                         ; 直前の単語を削除
(global-set-key (kbd "M-k") 'kill-buffer-for-elscreen)                   ; カレントバッファを閉じる
(global-set-key (kbd "M-<right>") 'flymake-goto-prev-error)              ; flymakeの警告・エラーに移動(前)
(global-set-key (kbd "M-<left>") 'flymake-goto-next-error)               ; flymakeの警告・エラーに移動(次)
(global-set-key (kbd "M-[") 'bm-previous)                                ; bm-goto 前へ移動
(global-set-key (kbd "M-]") 'bm-next)                                    ; bm-goto 次へ移動
(global-set-key (kbd "M-SPC") 'bm-toggle)                                ; bm-goto 現在行に色をつけて記録
(global-set-key (kbd "M-o") 'anything-c-moccur-occur-by-moccur)          ; anything-c-moccurの起動
(global-set-key (kbd "M-P") 'highlight-symbol-prev)                      ; highlight-symbolの移動(前)
(global-set-key (kbd "M-N") 'highlight-symbol-next)                      ; highlight-symbolの移動(次)

;; C-l
(global-unset-key (kbd "C-l"))
(global-set-key (kbd "C-l C-'") 'flyspell-region)                        ; スペルが正しいかチェック
(global-set-key (kbd "C-l C-M-'") 'ispell-word)                          ; 現在のスペルから候補を表示
;; (global-set-key (kbd "C-l l") 'ace-jump-line-mode)                       ; 行のace-jump
(global-set-key (kbd "C-l C-l") 'highlight-symbol-at-point)              ; symbolをhighlight表示
(global-set-key (kbd "C-l C-M-l") 'highlight-symbol-remove-all)          ; symbolをhighlight表示を解除
(global-set-key (kbd "C-l q") 'quickrun)                                 ; quickrun(バッファ)
(global-set-key (kbd "C-l C-q") 'quickrun-region)                        ; quickrun(リジョン)
(global-set-key (kbd "C-l C-;") 'text-translator-all-by-auto-selection)  ; Webで翻訳
(global-set-key (kbd "C-l C-M-;") 'sdic-describe-region)                 ; 英辞郎で翻訳
(global-set-key (kbd "C-l C-M-h") 'hatena-keyword-start)                     ; 英辞郎で翻訳
(global-set-key (kbd "C-l C-j") 'delete-horizontal-space)                ; 行の不要な空白を削除
(global-set-key (kbd "C-l j") 'just-one-space)                           ; 1文字空白を残して不要な空白を削除
(global-set-key (kbd "C-l w") 'whitespace-cleanup)                       ; TABを空白に置換
(global-set-key (kbd "C-l k") 'keitai-hankaku-katakana-region)           ; 全角カナを半角カナに置換
(global-set-key (kbd "C-l b") 'open-browse-by-url)                       ; URLをブラウザで開く
(global-set-key (kbd "C-l g") 'open-github-from-here)                    ; リジョン選択をgithubで開く
(global-set-key (kbd "C-l u") 'revert-buffer)                            ; バッファ更新
(global-set-key (kbd "C-l o") 'line-to-top-of-window)                    ; 現在行を最上部にする
(global-set-key (kbd "C-l f") 'helm-ag)                                  ; helm-ag検索
(global-set-key (kbd "C-l d") 'dired-open-current-directory)             ; 現在開いているバッファをdierdで開く
(global-set-key (kbd "C-l C-f") 'moccur-grep-find)                       ; moccur-grep検索
;; (global-set-key (kbd "C-l r") 'query-replace-regexp)                     ; インタラクティブ置換
;; (global-set-key (kbd "C-l R") 'replace-regexp)                           ; 一括置換
(global-set-key (kbd "C-l r") 'anzu-query-replace-regexp)                ; インタラクティブ置換(anzu)
(global-set-key (kbd "C-l R") 'anzu-query-replace)                       ; 一括置換
(global-set-key (kbd "C-l s") 'my-switch-to-scratch/current-buffer)      ; *scratch*バッファに移動
(global-set-key (kbd "C-l v s") 'smeargle)                               ; 更新履歴を可視化する
(global-set-key (kbd "C-l v c") 'smeargle-clear)                         ; smeargleを消す

;; emacs-lisp-mode
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)                ; 実行結果を注釈してくれる

;; python-mode
(define-key python-mode-map (kbd "C-M-a") 'gh-sh-file-toggle)            ; ghとshのディレクトリを切り替える

;; php-mode
(define-key php-mode-map (kbd "C-o") 'phpcmp-complete)                   ; 補完

;; perl-mode
;; (define-key cperl-mode-map "\M-\t" 'perlplus-complete-symbol)            ; 補完
;; (define-key cperl-mode-map (kbd "C-c C-c") 'cperl-db)                    ; デバッガの起動

;; web-mode
(define-key web-mode-map (kbd "M-;") 'web-mode-comment-or-uncomment)
(define-key web-mode-map (kbd "C-;") nil)
(define-key web-mode-map (kbd "C-M-'") 'sp-fp-file-toggle)
(define-key web-mode-map (kbd "C-M-a") 'gh-sh-file-toggle)

;; markdown-mode
(define-key markdown-mode-map (kbd "C-c C-s") 'markdown-header-list)     ; markdown-headerの一覧表示

;; ELSscreen固有のキーバインド
(define-key elscreen-map (kbd "c") 'create-newscreen)
(define-key elscreen-map (kbd "C-a") 'create-maxscreen)
(define-key elscreen-map (kbd "C-k") 'elscreen-kill-screen-and-buffers)
(define-key elscreen-map (kbd "k") 'elscreen-kill-screen-and-buffers)

;; helm-read-file
(define-key helm-read-file-map (kbd "C-h") 'delete-backward-char)             ; C-h でバックスペースと同じように文字を削除できるようにする
(define-key helm-read-file-map (kbd "<tab>") 'helm-execute-persistent-action) ; TAB で補完する

;; org-mode
(define-key org-mode-map (kbd "C-<up>") 'outline-previous-visible-heading)
(define-key org-mode-map (kbd "C-<down>") 'outline-next-visible-heading)
(define-key org-mode-map (kbd "C-M-<up>") 'outline-backward-same-level)
(define-key org-mode-map (kbd "C-M-<down>") 'outline-forward-same-level)
(define-key org-mode-map (kbd "C-,") nil)
(define-key org-mode-map (kbd "C-]") 'org-insert-heading-dwim)

;; dired-mode
(add-hook 'dired-mode-hook
  (lambda ()
    (local-set-key (kbd "C-f") 'dired-find-file)                     ; ディレクトリ, ファイルを展開
    (local-set-key (kbd "C-M-m") 'dired-up-directory)                ; 上位ディレクトリへ
    (local-set-key (kbd "C-t") 'other-window-or-split)               ; ウィンドウを切り替える
    (local-set-key (kbd "C-M-'") 'dired-sp-fp-directory-toggle)      ; spとfpのディレクトリを切り替える
    (local-set-key (kbd "C-M-a") 'dired-gh-sh-directory-toggle)      ; ghとshのディレクトリを切り替える
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
(define-key ac-mode-map (kbd "TAB") 'auto-complete)
(define-key ac-menu-map (kbd "C-n") 'ac-next)
(define-key ac-menu-map (kbd "C-p") 'ac-previous)
(define-key ac-menu-map (kbd "C-j") 'ac-complete)
(define-key ac-menu-map (kbd "C-i") 'ac-expand)

;; anything-c-moccur-anything
(define-key anything-c-moccur-anything-map (kbd "C-h") 'delete-backward-char)  ; 削除

;; mo-git-blame
(define-key mo-git-blame-mode-map (kbd "q") 'mo-git-blame-quit)
