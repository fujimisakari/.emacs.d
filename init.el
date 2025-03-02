;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                          各設定ファイルの読み込み                          ;;
;;;--------------------------------------------------------------------------;;;

;;; load-path を追加する関数を定義

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))
;; site-lispとconfディレクトリをサブディレクトリごとload-pathに追加する
(add-to-load-path "site-lisp" "elpa" "private/env")

;; 個人環境変数の読み込み
(require 'private-env)

;; init loader
(require 'init-loader)
(init-loader-load "~/.emacs.d/inits")   ; 設定ファイルがあるディレクトリを指定
(put 'set-goal-column 'disabled nil)

;; after init
(add-hook 'after-init-hook
          (lambda ()
            ;; 不要なメニューを非表示
            (define-key global-map [menu-bar Anything] 'undefined)
            (define-key global-map [menu-bar SKK] 'undefined)
            (define-key global-map [menu-bar file] 'undefined)
            (define-key global-map [menu-bar options] 'undefined)
            (define-key global-map [menu-bar tools] 'undefined)
            (define-key global-map [menu-bar javascript] 'undefined)
            (define-key global-map [menu-bar summary] 'undefined)
            (define-key global-map [menu-bar edit] 'undefined)
            (define-key global-map [menu-bar YASnippet] 'undefined)
            (define-key global-map [menu-bar w3m] 'undefined)
            ;; show init time
            (message "init time: %.3f sec"
                     (float-time (time-subtract after-init-time before-init-time)))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(anzu-deactivate-region t)
 '(anzu-mode-lighter "")
 '(anzu-replace-to-string-separator " => ")
 '(anzu-search-threshold 1000)
 '(magit-log-margin '(t "%Y-%m-%d %H:%M" magit-log-margin-width t 12))
 '(package-selected-packages
   '(ace-isearch ace-jump-mode ace-window all-ext all-the-icons-dired
                 all-the-icons-ivy amx angular-mode anzu arduino-mode
                 async auto-async-byte-compile auto-install bbdb-vcard
                 beacon bind-key bm buffer-expose c-eldoc ccc ccls cdb
                 chatgpt clang-format color-moccur column-marker
                 company-box company-go company-posframe
                 company-quickhelp company-terraform compat
                 csharp-mode csv-mode dired-git dired-imenu
                 dired-rainbow dired-subtree distel-completion-lib
                 dockerfile-mode doom-modeline dumb-jump edit-list
                 eldoc-extension elixir-mode elscreen engine-mode epc
                 erlang etags-table evil-python-movement
                 exec-path-from-shell expand-region fancy-battery
                 flycheck-elixir flycheck-golangci-lint
                 flycheck-posframe fold-dwim fuzzy ghub git-gutter
                 go-direx go-errcheck go-expr-completion go-snippets
                 golden-ratio google-translate gotest graphql
                 grep-a-lot gtags highlight-indent-guides
                 highlight-symbol htmlize id-manager ido-vertical-mode
                 igrep image+ imenu-list info+ init-loader irony
                 ivy-dired-history ivy-hydra ivy-posframe
                 ivy-yasnippet json-mode json-reformat lispxmp lsp-ui
                 lua-mode magit magit-popup memoize migemo
                 mo-git-blame mode-icons mozc-popup multi-term
                 nginx-mode nyan-mode open-junk-file openwith
                 org-autolist org-bullets org-modern ox-reveal
                 package-lint paredit pdf-tools perfect-margin
                 php-mode plantuml-mode point-undo popwin powershell
                 protobuf-mode py-autopep8 py-isort pydoc pyflakes
                 python-environment quickrun rainbow-delimiters
                 rainbow-mode recentf-ext redo+ region-bindings-mode
                 request resize-window sass-mode screen-lines
                 sequential-command shell-history shell-pop shimbun
                 shut-up slime-repl-ansi-color smartparens smeargle
                 smooth-scroll stem sticky sudo-ext swift-mode
                 symbol-overlay toml-mode typescript-mode viewer
                 vimrc-mode virtualenv vline volatile-highlights w3m
                 wanderlust web-mode which-key xcscope yahoo-weather
                 yaml-mode zlc))
 '(tab-stop-list (tab-stop-list-creator 4)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-header ((t (:foreground "yellow" :weight bold :height 1.3 :family my-global-font))))
 '(ivy-current-match ((t :background "gray20" :distant-foreground "gray75")))
 '(ivy-minibuffer-match-face-1 ((t :foreground "gray75")))
 '(ivy-minibuffer-match-face-2 ((t :foreground "#7777ff" :underline t)))
 '(ivy-minibuffer-match-face-3 ((t :foreground "lime green" :underline t)))
 '(ivy-minibuffer-match-face-4 ((t :foreground "yellow" :underline t)))
 '(ivy-posframe ((t (:foreground "gray75" :background "gray5"))))
 '(ivy-posframe-border ((t (:background "#6272a4"))))
 '(ivy-posframe-cursor ((t (:foreground "gray75")))))
