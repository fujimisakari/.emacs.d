;;; 06-elscree.el --- twittering-mode設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'twittering-mode)
(setq twittering-username (gethash "twitter-user" private-env-hash))
(setq twittering-status-format "%i @%s / %S %p\n %C{%Y/%m/%d %H:%M:%S}\n %T\n from %f%L%r %R\n")
(setq twittering-retweet-format " RT @%s: %t")
(setq twittering-icon-mode t)
(setq twittering-convert-fix-size 48)
(setq twittering-timer-interval 300) ; 5分毎に更新

;; (自動ログインのため)OAuth認証情報を設定
(setq twittering-account-authorization 'authorized)
(setq twittering-oauth-access-token-alist
      (list (cons "oauth_token" (gethash "twitter-oauth-token" private-env-hash))
            (cons "oauth_token_secret" (gethash "twitter-oauth-token-secret" private-env-hash))
            (cons "user_id" (gethash "twitter-id" private-env-hash))
            (cons "screen_name" (gethash "twitter-screen-name" private-env-hash))))

;; 短縮URLにbit.lyを使用する
(add-to-list 'twittering-tinyurl-services-map
             (list (cons 'bitly (gethash "bitly-url" private-env-hash))))
(setq twittering-tinyurl-service 'bitly)

;;; 06-elscree.el ends here
