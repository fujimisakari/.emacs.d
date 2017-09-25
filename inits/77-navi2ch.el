;;; 77-navi2ch.el --- navi2ch設定 -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'navi2ch)
;; レスを全て表示する
(setq navi2ch-article-exist-message-range '(1 . 1000))   ; 既存スレ
(setq navi2ch-article-new-message-range '(1000 . 1))     ; 新スレ
;; iconディレクトリを指定
(setq navi2ch-icon-directory "../site-lisp/navi2ch/icons")
;; Boardモードのレス数欄にレスの増加数を表示すう
(setq navi2ch-board-insert-subject-with-diff t)
;; Boardモードのレス数欄にレスの未読数を表示する
(setq navi2ch-board-insert-subject-with-unread t)
;; 板一覧のカテゴリをデフォルトですべて開いて表示する
(setq navi2ch-list-init-open-category nil)
;; スレをexpire(削除)しない
(setq navi2ch-board-expire-date nil)
;; 履歴の行数を制限しない
(setq navi2ch-history-max-line nil)
;; 外観設定
(set-face-foreground 'navi2ch-article-header-contents-face "lime green")
(set-face-foreground 'navi2ch-article-header-fusianasan-face "lime green")
(set-face-foreground 'navi2ch-article-message-separator-face "orchid1")

;;; 77-navi2ch.el ends here
