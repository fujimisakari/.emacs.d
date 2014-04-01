;;; text-translator-test.el --- Text Translator

;; Copyright (C) 2011  khiker

;; Author: khiker <khiker.mail+elisp@gmail.com>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; test code for test-translator.el.
;;
;; M-x text-translator-test or make test

;;; Code:

(require 'text-translator-vars)
(require 'text-translator)


;; Variables:

(defcustom text-translator-test-display-OK nil
  "*Non-nil means that displays also case of OK."
  :type 'symbol
  :group 'text-translator)

(defvar text-translator-test-google.com
  '("google.com" .
    (("en" "ja" "Japan" "日本の")
     ("ja" "en" "日本" "Japan")
     ("en" "es" "Japan" "Japón")
     ("es" "en" "Japón" "Japan")
     ("en" "fr" "Japan" "Le Japon")
     ("fr" "en" "Le Japon" "Japan")
     ("en" "de" "English" "Englisch")
     ("de" "en" "Englisch" "English")
     ("en" "it" "English" "Inglese")
     ("it" "en" "Inglese" "English")
     ("en" "ar" "Japan" "اليابان")
     ("ar" "en" "اللغة الإنجليزية" "English")
     ("de" "fr" "Englisch" "Anglaise")
     ("fr" "de" "En anglais" "Englisch")
     ("en" "pt" "Japan" "Japão")
     ("pt" "en" "Japão" "Japan")
     ("en" "ru" "Japan" "Япония")
     ("ru" "en" "Япония" "Japan")
     ("en" "ko" "Japan" "일본")
     ("ko" "en" "일본" "Japan")
     ("en" "ch" "Hello, World" "你好，世界")
     ("ch" "en" "你好，世界" "Hello, World")
     ("en" "tw" "China" "中國")
     ("tw" "en" "中國" "China")
     ("ch" "tw" "中国" "中國")
     ("tw" "ch" "中國" "中国")))
  "The test data of google.com.")

(defvar text-translator-test-yahoo.com
  '("yahoo.com" .
    (("en" "ja" "Japan" "日本")
     ("ja" "en" "日本" "Japan")
     ("en" "fr" "Japan" "Le Japon")
     ("fr" "en" "Le Japon" "Japan")
     ("en" "de" "English" "Englisch")
     ("de" "en" "Englisch" "English")
     ("en" "el" "English" "Αγγλικά")
     ("el" "en" "Αγγλικά" "English")
     ("en" "ko" "Japan" "일본")
     ("ko" "en" "일본" "Japan")
     ("en" "pt" "Japan" "Japão")
     ("pt" "en" "Japão" "Japan")
     ("en" "ru" "Japan" "Япония")
     ("ru" "en" "Япония" "Japan")
     ("en" "es" "Japan" "Japón")
     ("es" "en" "Japón" "Japan")
     ("en" "nl" "Emacs is a great interpreter." "Emacs is een groot tolk.")
     ("nl" "en" "Emacs is een groot tolk." "Emacs are large an interpreter.")
     ("fr" "de" "En anglais" "Auf englisch")
     ("nl" "fr" "Emacs is een groot tolk." "Emacs est grand un interprète.")
     ("fr" "el" "En anglais" "Στους Άγγλους")
     ("el" "fr" "Στους Άγγλους" "Aux Anglais")
     ("fr" "it" "Le Japon" "Il Giappone")
     ("it" "fr" "Il Giappone" "Le Japon")
     ("fr" "pt" "Le Japon" "O Japão")
     ("pt" "fr" "O Japão" "Le Japon")
     ("fr" "es" "Le Japon" "Japón")
     ("es" "fr" "Japón" "Le Japon")
     ("en" "tw" "China" "中國")
     ("tw" "en" "中國" "China")
     ("en" "ch" "Hello, World" "你好，世界")
     ("ch" "en" "你好，世界" "You are good, world")))
  "The test data of yahoo.com.")

(defvar text-translator-test-freetranslation.com
  '("freetranslation.com" .
    (("en" "es" "Japan" "Japón")
     ("es" "en" "Japón" "Japan")
     ("en" "fr" "Japan" "Le Japon")
     ("fr" "en" "Le Japon" "Japan")
     ("en" "de" "English" "Englisch")
     ("de" "en" "Englisch" "English")
     ("en" "it" "English" "Inglesi")
     ("it" "en" "Inglesi" "English")
     ("en" "nl" "English" "Engels")
     ("nl" "en" "Engels" "Angels")
     ("en" "pt" "Japan" "Japão")
     ("pt" "en" "Japão" "Japan")
     ("en" "no" "English" "Engelsk")
     ("en" "ru" "English" "Английский язык")
     ("ru" "en" "Английский язык" "English language")
     ("en" "ch" "English" "英语")
     ("en" "tw" "English" "英語")
     ("en" "ja" "English" "英語")
     ("ja" "en" "英語" "English   ")))
  "The test data of freetranslation.com.")

(defvar text-translator-test-livedoor.com
  '("livedoor.com" .
    (("en" "ja" "English" "英語")
     ("ja" "en" "英語" "English")
     ("ja" "ko" "英語" "영어 ")
     ("ko" "ja" "영어" "英語")
     ("ja" "ch" "英語" "英语")
     ("ch" "ja" "英语" "英語")
     ("ja" "de" "英語" "Englisch")
     ("de" "ja" "Englisch" "英語")
     ("ja" "fr" "日本" "Japon")
     ("fr" "ja" "Japon" "日本")
     ("ja" "it" "日本" "Giappone")
     ("it" "ja" "Giappone" "日本")
     ("ja" "es" "日本" "Japón")
     ("es" "ja" "Japón" "日本")
     ("ja" "pt" "日本" "Japão")
     ("pt" "ja" "Japão" "日本")
     ("en" "de" "English" "Englisch")
     ("de" "en" "Englisch" "English")
     ("en" "it" "Japan" "Giappone")
     ("it" "en" "Giappone" "Japan")
     ("en" "fr" "Japan" "Japon")
     ("fr" "en" "Japon" "Japan")
     ("en" "es" "Japan" "Japón")
     ("es" "en" "Japón" "Japan")
     ("en" "pt" "Japan" "Japão")
     ("pt" "en" "Japão" "Japan")))
  "The test data of livedoor.com.")

(defvar text-translator-test-fresheye.com
  '("fresheye.com" .
    (("en" "ja" "English" "英語")
     ("ja" "en" "英語" "English")
     ("ja" "ch" "英語" "英语")
     ("ch" "ja" "英语" "英語")
     ("ja" "tw" "ハローワールド" "哈羅世界")
     ("tw" "ja" "哈羅世界" "ハロ世界")))
  "The test data of fresheye.com.")

(defvar text-translator-test-excite.co.jp
  '("excite.co.jp" .
    (("en" "ja" "English" "英語")
     ("ja" "en" "英語" "English")
     ("ja" "ch" "英語" "英语")
     ("ch" "ja" "英语" "英語")
     ("ja" "tw" "中国" "中國")
     ("tw" "ja" "中國" "中国")
     ("ja" "ko" "英語" "영어 ")
     ("ko" "ja" "영어" "英語")
     ("ja" "fr" "日本" "Japon")
     ("fr" "ja" "Japon" "日本")
     ("en" "fr" "Japan" "Japon")
     ("fr" "en" "Japon" "Japan")
     ("ja" "de" "英語" "Englisch")
     ("de" "ja" "Englisch" "英語")
     ("en" "de" "English" "Englisch")
     ("de" "en" "Englisch" "English")
     ("ja" "it" "日本" "Giappone")
     ("it" "ja" "Giappone" "日本")
     ("en" "it" "Japan" "Giappone")
     ("it" "en" "Giappone" "Japan")
     ("ja" "es" "日本" "Japón")
     ("es" "ja" "Japón" "日本")
     ("en" "es" "Japan" "Japón")
     ("es" "en" "Japón" "Japan")
     ("ja" "pt" "日本" "Japão")
     ("pt" "ja" "Japão" "日本")
     ("en" "pt" "Japan" "Japão")
     ("pt" "en" "Japão" "Japan")))
  "The test data of excite.co.jp")

(defvar text-translator-test-yahoo.co.jp
  '("yahoo.co.jp" .
    (("en" "ja" "English" "英語")
     ("ja" "en" "英語" "English")
     ("ja" "ch" "英語" "英语")
     ("ch" "ja" "英语" "英語")
     ("ja" "ko" "英語" "영어")
     ("ko" "ja" "영어" "英語")))
  "The test data of yahoo.co.jp.")

(defvar text-translator-test-ocn.ne.jp
  '("ocn.ne.jp" .
    (("en" "ja" "English" "英語\n")
     ("ja" "en" "英語" "English")
     ("ja" "ch" "英語" "英语")
     ("ch" "ja" "英语" "英語")
     ("ja" "ko" "英語" "영어 ")
     ("ko" "ja" "영어" "英語")))
  "The test data of ocn.ne.jp.")

(defvar text-translator-test-lou5.jp
  '("lou5.jp" .
    (("*normal" "" "空が青い。" "ホールがブルー。\n\n")))
  "The test data of lou5.jp.")

(defvar text-translator-test-tatoeba.org
  '("tatoeba.org" .
    (("furigana" "" "日本語" "日本語[にほんご]")
     ("romaji"   "" "日本語" "nihongo")))
  "The test data of tatoeba.org.")

(defvar text-translator-test-traduku.net
  '("traduku.net" .
    (("en" "eo" "English" "\nLa angla\n")
     ("eo" "en" "La angla" "\nEnglish\n")))
  "The test data of toraduku.net.")


;; Functions:

(defun text-translator-test-internal (site data &optional wait)
  (let (engine before after translated status errors successes)
    (dolist (i data)
      (setq text-translator-all-site-number   1
            text-translator-all-results       nil
            text-translator-processes-alist   nil
            text-translator-all-before-string nil
            engine (concat site "_" (nth 0 i) (nth 1 i))
            before (nth 2 i)
            after  (nth 3 i))
      (when (and before after)
        (cond
         ((not (string=
                (setq translated
                      (prog2
                          (text-translator-timeout-start)
                          (text-translator-client engine before nil t)
                        (text-translator-timeout-stop)))
                after))
          (princ (format "NG: %s: '%s' != '%s'\n"
                         engine after translated))
          (setq errors (cons (cons (nth 0 i) (nth 1 i)) errors)))
         (t
          (when text-translator-test-display-OK
            (princ (format "OK: %s: %s == %s\n"
                           engine after translated)))
          (setq successes (cons (cons (nth 0 i) (nth 1 i)) successes))
          (setq status t))))
      (when (and wait (numberp wait))
        (sit-for wait)))
    (when errors
      (princ (format ";; > FAILED: %s\n" site))
      (dolist (i errors)
        (princ (format ";;     %s%s\n" (car i) (cdr i))))
      (princ "\n"))
    (when successes
      (princ (format ";; > PASSED: %s\n" site))
      (dolist (i successes)
        (princ (format ";;     %s%s\n" (car i) (cdr i))))
      (princ "\n"))
    status))

(defun text-translator-test-google.com ()
  (let ((site-val text-translator-test-google.com))
    (princ (format ";; %s\n" (car site-val)))
    (text-translator-test-internal (car site-val) (cdr site-val))))

(defun text-translator-test-yahoo.com ()
  (let ((site-val text-translator-test-yahoo.com)
        (text-translator-timeout-interval 5)
        (sleep-wait 3))
    (princ (format ";; %s\n" (car site-val)))
    (text-translator-test-internal (car site-val) (cdr site-val))))

(defun text-translator-test-freetranslation.com ()
  (let ((site-val text-translator-test-freetranslation.com)
        (text-translator-timeout-interval 3)
        (sleep-wait 2))
    (princ (format ";; %s\n" (car site-val)))
    (text-translator-test-internal (car site-val) (cdr site-val) sleep-wait)))

(defun text-translator-test-livedoor.com ()
  (let ((site-val text-translator-test-livedoor.com))
    (princ (format ";; %s\n" (car site-val)))
    (text-translator-test-internal (car site-val) (cdr site-val))))

(defun text-translator-test-fresheye.com ()
  (let ((site-val text-translator-test-fresheye.com))
    (princ (format ";; %s\n" (car site-val)))
    (text-translator-test-internal (car site-val) (cdr site-val))))

(defun text-translator-test-excite.co.jp ()
  (let ((site-val text-translator-test-excite.co.jp))
    (princ (format ";; %s\n" (car site-val)))
    (text-translator-test-internal (car site-val) (cdr site-val))))

(defun text-translator-test-yahoo.co.jp ()
  (let ((site-val text-translator-test-yahoo.co.jp))
    (princ (format ";; %s\n" (car site-val)))
    (text-translator-test-internal (car site-val) (cdr site-val))))

(defun text-translator-test-ocn.ne.jp ()
  (let ((site-val text-translator-test-ocn.ne.jp))
    (princ (format ";; %s\n" (car site-val)))
    (text-translator-test-internal (car site-val) (cdr site-val))))

(defun text-translator-test-lou5.jp ()
  (let ((site-val text-translator-test-lou5.jp))
    (princ (format ";; %s\n" (car site-val)))
    (text-translator-test-internal (car site-val) (cdr site-val))))

(defun text-translator-test-tatoeba.org ()
  (let ((site-val text-translator-test-tatoeba.org))
    (princ (format ";; %s\n" (car site-val)))
    (text-translator-test-internal (car site-val) (cdr site-val))))

(defun text-translator-test-traduku.net ()
  (let ((site-val text-translator-test-traduku.net))
    (princ (format ";; %s\n" (car site-val)))
    (text-translator-test-internal (car site-val) (cdr site-val))))

(defun text-translator-test ()
  "Test all site data."
  (interactive)
  (progn
    (text-translator-test-google.com)
    (text-translator-test-yahoo.com)
    (text-translator-test-freetranslation.com)
    (text-translator-test-livedoor.com)
    (text-translator-test-fresheye.com)
    (text-translator-test-excite.co.jp)
;;    (text-translator-test-yahoo.co.jp)
    (text-translator-test-ocn.ne.jp)
    (text-translator-test-lou5.jp)
    (text-translator-test-tatoeba.org)
    (text-translator-test-traduku.net)
    ))


(provide 'text-translator-test)

;;; text-translator-test.el ends here
