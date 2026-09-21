;;; 02-gcmh.el --- gcmh設定 -*- lexical-binding: t; -*-

;;; Commentary:

;; lsp-mode と巨大 monorepo の gopls は大量のゴミを出すため、
;; 固定の gc-cons-threshold では打鍵中に GC が走り、その都度 Emacs が停止する。
;; 実測 (2MB 閾値 / copilot 併用時): 15 秒間に GC 20 回 / 合計 3.77 秒
;; = 1 回あたり約 189ms の停止。
;; gcmh は「入力中は閾値を上げて GC させず、アイドルになってから回収する」ことで、
;; GC の停止を打鍵経路の外へ追い出す。

;;; Code:

(require 'gcmh)

;; 入力中の閾値。ゴミの生成速度は実測で約 2.7MB/s なので、128MB あれば
;; 打鍵中に GC が走ることはほぼ無い。スワップを誘発しない範囲に収める
;; (既定値の 1GB はこのマシンの搭載メモリに対して大きすぎる)。
(setq gcmh-high-cons-threshold (* 128 1024 1024))

;; 入力が止まってから GC するまでの秒数。既定の 15 秒は長すぎてゴミが溜まるため
;; 短くするが、打鍵の合間に走らない程度には空ける。
(setq gcmh-idle-delay 5)

(gcmh-mode 1)

;;; 02-gcmh.el ends here
