;;; 64-microsoft-translator.el --- microsoft-translator設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'microsoft-translator)

(setq microsoft-translator-client-id (gethash "client-id" private-env-hash))
(setq microsoft-translator-client-secret (gethash "client-secret" private-env-hash))
(setq microsoft-translator-default-from "english")
(setq microsoft-translator-default-to "Japanese")
(setq microsoft-translator-use-language-by-auto-translate "Japanese")

;;; 64-microsoft-translator.el ends here
