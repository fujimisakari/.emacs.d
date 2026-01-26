;;; 69-mermaid-mode.el --- mermaid-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; autoload
(autoload 'mermaid-mode "mermaid-mode" nil t)
(autoload 'mermaid-compile "mermaid-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.mmd\\'" . mermaid-mode))

(with-eval-after-load 'mermaid-mode
  (setq mermaid-mmdc-location "mmdc")
  (setq mermaid-output-format ".png")
  (setq mermaid-flags "-w 2000")
  (setq mermaid-tmp-dir "/tmp/mermaid"))

;;; 69-mermaid-mode.el ends here
