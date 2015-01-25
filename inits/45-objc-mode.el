;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               objc-mode設定                                ;;
;;;--------------------------------------------------------------------------;;;

;; 基本設定
(add-hook 'objc-mode-hook
          '(lambda()
             (skk-mode t)
             (setq c-basic-offset 4)
             (setq tab-width 4)
             (setq indent-tabs-mode nil)
             (push 'ac-source-company-xcode ac-sources)
             ;; 存在するファイルかつ書き込み可能ファイル時のみ flymake-mode を有効にします
             (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
                 (flymake-mode t))
             ))

;; .hファイルをobjc-modeで開く
(add-to-list 'magic-mode-alist
             `(,(lambda ()
                  (and (string= (file-name-extension buffer-file-name) "h")
                       (re-search-forward "@\\<interface\\>" 
                                          magic-mode-regexp-match-limit t)))
               . objc-mode))

;; Frameworkの.hファイルへジャンプ設定
(setq cc-search-directories '("." "../include" "/usr/include" "/usr/local/include/*"
                              "/System/Library/Frameworks" "/Library/Frameworks"))
(defadvice ff-get-file-name (around ff-get-file-name-framework
                                    (search-dirs 
                                     fname-stub 
                                     &optional suffix-list))
  "Search for Mac framework headers as well as POSIX headers."
  (or
   (if (string-match "\\(.*?\\)/\\(.*\\)" fname-stub)
       (let* ((framework (match-string 1 fname-stub))
              (header (match-string 2 fname-stub))
              (fname-stub (concat framework ".framework/Headers/" header)))
         ad-do-it))
   ad-do-it))
(ad-enable-advice 'ff-get-file-name 'around 'ff-get-file-name-framework)
(ad-activate 'ff-get-file-name)

;; ff-find-other-fileで.hファイルと.mファイルをトグルできるようにする
(require 'find-file) ;; for the "cc-other-file-alist" variable
(nconc (cadr (assoc "\\.h\\'" cc-other-file-alist)) '(".m" ".mm"))

;; ac-company で company-xcode を有効にしてXCodeを利用した補完をする
(require 'ac-company)
(ac-company-define-source ac-source-company-xcode company-xcode)
(setq ac-modes (append ac-modes '(objc-mode)))
(add-hook 'objc-mode-hook
          (lambda ()
            (push 'ac-source-company-xcode ac-sources)))

;; 文法チェック
(defvar xcode:sdkpath "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer")
(defvar xcode:sdk (concat xcode:sdkpath "/SDKs/iPhoneSimulator.sdk"))
(defvar flymake-objc-compiler (executable-find "clang"))
(defvar flymake-objc-compile-default-options (list "-D__IPHONE_OS_VERSION_MIN_REQUIRED=30200" "-fsyntax-only" "-fno-color-diagnostics" "-fobjc-arc" "-fblocks" "-Wreturn-type" "-Wparentheses" "-Wswitch" "-Wno-unused-parameter" "-Wunused-variable" "-Wunused-value" "-isysroot" xcode:sdk))
(defvar flymake-last-position nil)
(defcustom flymake-objc-compile-options '("-I.")
  "Compile option for objc check."
  :group 'flymake
  :type '(repeat (string)))

(defun flymake-objc-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list flymake-objc-compiler (append flymake-objc-compile-default-options flymake-objc-compile-options (list local-file)))))

(defun flymake-display-err-minibuffer ()
  (interactive)
  (let* ((line-no (flymake-current-line-no))
         (line-err-info-list
          (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list
        (let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
               (full-file (flymake-ler-full-file
                           (nth (1- count) line-err-info-list)))
               (text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)))
      (setq count (1- count)))))

(defun flymake-display-err-minibuffer-safe ()
  (ignore-errors flymake-display-err-minibuffer))

;; もともとのパターンにマッチしなかったので追加
(setq flymake-err-line-patterns
      (cons
       '("\\(.+\\):\\([0-9]+\\):\\([0-9]+\\): \\(.+\\)" 1 2 3 4)
       flymake-err-line-patterns))

;; ;; (add-hook 'objc-mode-hook
;; ;;          (lambda ()
;; ;;            (push '("\\.m$" flymake-simple-make-init) flymake-allowed-file-name-masks)
;; ;;            (push '("\\.h$" flymake-simple-make-init) flymake-allowed-file-name-masks)
;; ;;            ;; (define-key objc-mode-map "\C-cd" 'flymake-display-err-minibuf)))
;; ;;            (flymake-mode t)

(add-hook 'objc-mode-hook
         (lambda ()
           (ad-activate 'flymake-post-syntax-check)
           ;; 拡張子 m と h に対して flymake を有効にする設定 flymake-mode t の前に書く必要があります
           (push '("\\.m$" flymake-objc-init) flymake-allowed-file-name-masks)
           (push '("\\.h$" flymake-objc-init) flymake-allowed-file-name-masks)
           (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
               (flymake-mode t))))

;; (defadvice flymake-mode (before post-command-stuff activate compile)
;;   "エラー行にカーソルが当ったら自動的にエラーが minibuffer に表示されるように
;; post command hook に機能追加"
;;   (set (make-local-variable 'post-command-hook)
;;        (add-hook 'post-command-hook 'flymake-display-err-minibuffer)))

;; ;; 自動的な表示に不都合がある場合は以下を設定してください
;; ;; post-command-hook は anything.el の動作に影響する場合があります
;; (define-key global-map (kbd "C-c d") 'flymake-display-err-minibuffer)
