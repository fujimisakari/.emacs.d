;; -*- Emacs-lisp -*-

;; 不要なメニューを非表示
(define-key global-map [menu-bar elscreen] 'undefined)
(define-key global-map [menu-bar Anything] 'undefined)
(define-key global-map [menu-bar evernote] 'undefined)
(define-key global-map [menu-bar SKK] 'undefined)
(define-key global-map [menu-bar file] 'undefined)
(define-key global-map [menu-bar options] 'undefined)
(define-key global-map [menu-bar tools] 'undefined)
(define-key global-map [menu-bar javascript] 'undefined)
(define-key global-map [menu-bar summary] 'undefined)
(define-key global-map [menu-bar edit] 'undefined)
(define-key global-map [menu-bar w3m] 'undefined)

;; macbook air 11インチでフルスクリーン
(ns-toggle-fullscreen)
;; (set-frame-size (selected-frame) 170 45)
(set-frame-size (selected-frame) 75 42)

;; ブラウザはmacを使用する
(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program
(if (file-exists-p "/usr/bin/open")
"/usr/bin/open"))
(global-set-key (kbd "C-l g") 'open-github-from-here)
