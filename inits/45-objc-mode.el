;; -*- Emacs-lisp -*-

;;;--------------------------------------------------------------------------;;;
;;                               objc-mode設定                                ;;
;;;--------------------------------------------------------------------------;;;

;;; TODO
;; - リアルタイムsytleチェック
;; - gtags

;; 基本設定
(add-hook 'objc-mode-hook
          '(lambda()
             (skk-mode t)
             (setq c-basic-offset 4)
             (setq tab-width 4)
             (setq indent-tabs-mode nil)))

;; .hファイルをobjc-modeで開く
(add-to-list 'magic-mode-alist
             `(,(lambda ()
                  (and (string= (file-name-extension buffer-file-name) "h")
                       (re-search-forward "@\\<interface\\>"
                                          magic-mode-regexp-match-limit t)))
               . objc-mode))

;; ff-find-other-fileの検索対象にFrameworkの.hファイルを含めるようにする
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

;; コード整形できるようにする
(require 'clang-format)

;; .hと.mを左右に並べて開く
(defun open-header-and-method-file ()
  (interactive)
  (other-window-or-split)
  (ff-find-other-file))

;; quickrunにclangでの実行環境を追加
(add-to-list 'quickrun-file-alist '("\\.m$" . "objc/clang"))
(quickrun-add-command "objc/clang"
                      '((:command . "clang")
                        (:exec    . ("%c -fobjc-arc -framework Foundation %s -o %e" "%e"))
                        (:remove  . ("%e")))
                      :default "objc")

;; flymakeで文法チェック
(defvar xcode:sdkpath "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer")
(defvar xcode:sdk (concat xcode:sdkpath "/SDKs/iPhoneSimulator.sdk"))
(defvar flymake-objc-compiler (executable-find "clang"))
(defvar flymake-objc-compile-default-options (list "-D__IPHONE_OS_VERSION_MIN_REQUIRED=30200" "-fsyntax-only" "-fobjc-arc" "-fblocks" "-fno-color-diagnostics" "-Wreturn-type" "-Wparentheses" "-Wswitch" "-Wno-unused-parameter" "-Wunused-variable" "-Wunused-value" "-isysroot" xcode:sdk))
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

;; 拡張子 m と h に対して flymake を有効にする設定
(add-hook 'objc-mode-hook
          (lambda ()
            (push '("\\.m$" flymake-objc-init) flymake-allowed-file-name-masks)
            (push '("\\.h$" flymake-objc-init) flymake-allowed-file-name-masks)
            ;; 存在するファイルかつ書き込み可能ファイル時のみ flymake-mode を有効にします
            (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
                (flymake-mode t))))

;; objc で etags からの補完を可能にする
(require 'etags-table)
(add-to-list 'etags-table-alist
             '("\\.[mh]$" "~/.emacs.d/share/tags/objc.TAGS"))

;; auto-complete に etags の内容を認識させるための変数
;; 以下の例だと3文字以上打たないと補完候補にならないように設定してあります。requires の次の数字で指定します
(defvar ac-source-etags
  '((candidates . (lambda ()
                    (all-completions ac-target (tags-completion-table))))
    (candidate-face . ac-candidate-face)
    (selection-face . ac-selection-face)
    (requires . 3))
  "etags をソースにする")

;; etags-tableでTAGSのpathが取れなかったので再定義
(defun etags-table-build-table-list (filename)
  "Build tags table list based on a filename"
  (let (tables)
    ;; Go through mapping alist
    (mapc (lambda (mapping)
            (let ((key (car mapping))
                  (tag-files (cdr mapping)))
              (when (string-match key filename)
                (mapc (lambda (tag-file)
                        (add-to-list 'tables tag-file t))
                      tag-files))))
          etags-table-alist)

    ;; Return result or the original list
    (setq etags-table-last-table-list
          (or tables tags-table-list etags-table-last-table-list))))

;; ac-company で company-xcode を有効にしてXCodeを利用した補完をする
(require 'ac-company)
(ac-company-define-source ac-source-company-xcode company-xcode)
(setq ac-modes (append ac-modes '(objc-mode)))

(add-hook 'objc-mode-hook
          (lambda ()
            (push 'ac-source-company-xcode ac-sources)
            (push 'ac-source-etags ac-sources)))

(require 'helm-xcdoc)
(setq xcdoc:command-path "/Applications/Xcode.app/Contents/Developer/usr/bin/docsetutil")
(setq xcdoc:document-path "~/Library/Developer/Shared/Documentation/DocSets/com.apple.adc.documentation.AppleiOS8.1.iOSLibrary.docset")
