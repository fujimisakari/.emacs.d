;;; 54-vue-ts-mode.el --- vue-ts-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:
;; Vue.js Single File Component (.vue) 用のメジャーモード設定
;; tree-sitter ベースの vue-ts-mode を利用する
;; Emacs 29+ 必須 (treesit 組み込み)

;;; Code:

;; tree-sitter grammar のソースを登録
;; vue-ts-mode は内部で typescript / tsx / css / javascript grammar も参照する
(require 'treesit)
;; Emacs 30.2 の tree-sitter は ABI 14 まで対応
;; master ブランチの grammar は ABI 15 でビルドされているため、ABI 14 互換のタグに固定する
(dolist (src '((vue        "https://github.com/ikatyang/tree-sitter-vue")
               (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "typescript/src")
               (tsx        "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "tsx/src")
               (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "v0.23.1" "src")
               (css        "https://github.com/tree-sitter/tree-sitter-css"        "v0.23.2" "src")))
  (add-to-list 'treesit-language-source-alist src))

;; 未インストールの grammar を自動ビルド
(when (and (fboundp 'treesit-available-p) (treesit-available-p))
  (dolist (lang '(vue typescript tsx javascript css))
    (unless (treesit-language-available-p lang)
      (ignore-errors (treesit-install-language-grammar lang)))))

;; vue-ts-mode 本体を package-vc で取得 (MELPA 未登録のため GitHub から)
(unless (package-installed-p 'vue-ts-mode)
  (when (fboundp 'package-vc-install)
    (ignore-errors
      (package-vc-install
       '(vue-ts-mode
         :url "https://github.com/8uff3r/vue-ts-mode"
         :branch "main")))))

;; autoload と拡張子関連付け
(autoload 'vue-ts-mode "vue-ts-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-ts-mode))

;;; 54-vue-ts-mode.el ends here
