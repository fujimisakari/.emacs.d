;;; 97-work.el --- Work設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; 会社と自宅の読み込みを切り分け 
;; 元ネタ(http://e-arrows.sakura.ne.jp/2010/12/emacs-anywhere.html)
;; (defvar *network-interface-names* '("eth0" "eth1")
;;   "Candidates for the network devices.")
;; 使い方：(if (officep) (require 'init-jabber)) ; jabber設定
(defun machine-ip-address ()
  "Return IP address of a network device."
  (let ((mia-info (network-interface-info "eth0")))
    (if mia-info
        (format-network-address (car mia-info) t))))

(defun officep ()
  "Am I in the office? If I am in the office, my IP address must start with '172.16.0.'."
  (let ((ip (machine-ip-address)))
    (and ip
         (eq 0 (string-match "^10\\.0\\.8\\." ip)))))

;; ghとshのファイルを切り替える
(defun gh-sh-file-toggle ()
  (interactive)
  (let ((current-file (buffer-file-name))
        (tmp-file (buffer-file-name)))
    (cond ((string-match "/genju-hime/" current-file)
           (setq tmp-file (replace-regexp-in-string "/genju-hime/" "/seishun-hime/" tmp-file)))
          ((string-match "/seishun-hime/" current-file)
           (setq tmp-file (replace-regexp-in-string "/seishun-hime/" "/genju-hime/" tmp-file))))
    (unless (eq current-file tmp-file)
      (find-file tmp-file))))

;; ghとshのディレクトリを切り替える
(defun dired-gh-sh-directory-toggle ()
  (interactive)
  (let ((current-directory default-directory)
        (tmp-directory default-directory))
    (cond ((string-match "/genju-hime/" current-directory)
           (setq tmp-directory (replace-regexp-in-string "/genju-hime/" "/seishun-hime/" tmp-directory)))
          ((string-match "/seishun-hime/" current-directory)
           (setq tmp-directory (replace-regexp-in-string "/seishun-hime/" "/genju-hime/" tmp-directory))))
    (unless (eq current-directory tmp-directory)
      (kill-buffer (current-buffer))
      (dired tmp-directory))))

;; spとfpのファイルを切り替える
(defun sp-fp-file-toggle ()
  (interactive)
  (let ((current-file (buffer-file-name))
        (tmp-file (buffer-file-name)))
    (cond ((string-match "/smartphone/" current-file)
           (setq tmp-file (replace-regexp-in-string "/smartphone/" "/featurephone/" tmp-file)))
          ((string-match "/featurephone/" current-file)
           (setq tmp-file (replace-regexp-in-string "/featurephone/" "/smartphone/" tmp-file))))
    (unless (eq current-file tmp-file)
      (find-file tmp-file))))

;; spとfpのディレクトリを切り替える
(defun dired-sp-fp-directory-toggle ()
  (interactive)
  (let ((current-directory default-directory)
        (tmp-directory default-directory))
    (cond ((or (string-match "/smartphone/" current-directory) (string-match "/sp/" current-directory))
           (setq tmp-directory (replace-regexp-in-string "/smartphone/" "/featurephone/" tmp-directory))
           (setq tmp-directory (replace-regexp-in-string "/sp/" "/fp/" tmp-directory)))
          ((or (string-match "/featurephone/" current-directory) (string-match "/fp/" current-directory))
           (setq tmp-directory (replace-regexp-in-string "/featurephone/" "/smartphone/" tmp-directory))
           (setq tmp-directory (replace-regexp-in-string "/fp/" "/sp/" tmp-directory))))
    (unless (eq current-directory tmp-directory)
      (kill-buffer (current-buffer))
      (dired tmp-directory))))

;; gree staticディレクトリへ切り替える
(defun dired-move-gree-static-directory ()
  (interactive)
  (let ((current-directory default-directory)
        (tmp-directory default-directory))
    (cond ((or (string-match "/static_m/" current-directory) (string-match "/static_d/" current-directory))
           (setq tmp-directory (replace-regexp-in-string "/static_m/" "/static/" tmp-directory))
           (setq tmp-directory (replace-regexp-in-string "/static_d/" "/static/" tmp-directory))))
    (unless (eq current-directory tmp-directory)
      (kill-buffer (current-buffer))
      (dired tmp-directory))))

;; mbge staticディレクトリへ切り替える
(defun dired-move-mbge-static-directory ()
  (interactive)
  (let ((current-directory default-directory)
        (tmp-directory default-directory))
    (cond ((or (string-match "/static/" current-directory) (string-match "/static_d/" current-directory))
           (setq tmp-directory (replace-regexp-in-string "/static/" "/static_m/" tmp-directory))
           (setq tmp-directory (replace-regexp-in-string "/static_d/" "/static_m/" tmp-directory))))
    (unless (eq current-directory tmp-directory)
      (kill-buffer (current-buffer))
      (dired tmp-directory))))

;; dgame staticディレクトリへ切り替える
(defun dired-move-dgame-static-directory ()
  (interactive)
  (let ((current-directory default-directory)
        (tmp-directory default-directory))
    (cond ((or (string-match "/static_m/" current-directory) (string-match "/static/" current-directory))
           (setq tmp-directory (replace-regexp-in-string "/static_m/" "/static_d/" tmp-directory))
           (setq tmp-directory (replace-regexp-in-string "/static/" "/static_d/" tmp-directory))))
    (unless (eq current-directory tmp-directory)
      (kill-buffer (current-buffer))
      (dired tmp-directory))))

;; genju-himeアプリケーションディレクトリを開く
(defun dired-move-application-directory ()
  (interactive)
  (dired "~/projects/genju-hime/application"))

;; genju-himeテンプレートディレクトリを開く
(defun dired-move-template-directory ()
  (interactive)
  (dired "~/projects/genju-hime/application/website/templates/smartphone"))

;; Projectディレクトリを開く
(defun dired-open-project-directory ()
  (interactive)
  (dired "~/dev/php/fuel-php-docker/fuel_project/fuel"))

;; MenuとSceneのファイルを切り替える
(defun work-menu-scene-file-toggle ()
  (interactive)
  (let ((current-file (buffer-file-name))
        (tmp-file (buffer-file-name)))
    (cond ((string-match "Menu.cs" current-file)
           (setq tmp-file (replace-regexp-in-string "Menu.cs" "Scene.cs" tmp-file)))
          ((string-match "Scene.cs" current-file)
           (setq tmp-file (replace-regexp-in-string "Scene.cs" "Menu.cs" tmp-file))))
    (unless (eq current-file tmp-file)
      (find-file tmp-file))))

;; Sceneファイルを開く
(defun work-open-scene-file ()
  (interactive)
  (let ((current-file (buffer-file-name))
        (tmp-file (buffer-file-name)))
    (cond ((string-match "Menu.cs" current-file)
           (setq tmp-file (replace-regexp-in-string "Menu.cs" "Scene.cs" tmp-file))))
    (unless (eq current-file tmp-file)
      (other-window-or-split)
      (find-file tmp-file))))

;; Menuファイルを開く
(defun work-open-menu-file ()
  (interactive)
  (let ((current-file (buffer-file-name))
        (tmp-file (buffer-file-name)))
    (cond ((string-match "Scene.cs" current-file)
           (setq tmp-file (replace-regexp-in-string "Scene.cs" "Menu.cs" tmp-file))))
    (unless (eq current-file tmp-file)
      (other-window-or-split)
      (find-file tmp-file))))

(defun web-php-mode-toggle ()
  (interactive)
  (if (eq major-mode 'php-mode)
      (web-mode)
    (php-mode)))

(defun open-view-file-with-php-mode ()
  (interactive)
  (let* ((file-path (buffer-substring-no-properties (region-beginning) (region-end)))
         (file-path (format "~/dev/gamewith/gamewith/fuel/app/views/%s.php" file-path)))
    (other-window-or-split)
    (find-file file-path)))

;;; 97-work.el ends here
