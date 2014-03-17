((anzu status "installed" recipe
       (:name anzu :website "https://github.com/syohex/emacs-anzu" :description "A minor mode which displays current match and total matches." :type "github" :branch "master" :pkgname "syohex/emacs-anzu"))
 (auto-async-byte-compile status "installed" recipe
                          (:name auto-async-byte-compile :description "Automatically byte-compile when saved" :website "http://www.emacswiki.org/emacs/AutoAsyncByteCompile" :type emacswiki :post-init
                                 (add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
                                 :features "auto-async-byte-compile"))
 (auto-complete status "installed" recipe
                (:name auto-complete :website "https://github.com/auto-complete/auto-complete" :description "The most intelligent auto-completion extension." :type github :pkgname "auto-complete/auto-complete" :depends
                       (popup fuzzy)))
 (auto-install status "installed" recipe
               (:name auto-install :description "Auto install elisp file" :type emacswiki))
 (color-moccur status "installed" recipe
               (:name color-moccur :type http :url "http://www.bookshelf.jp/elc/color-moccur.el" :description "multi-buffer occur (grep) mode" :website "http://www.bookshelf.jp/soft/meadow_50.html"))
 (column-marker status "installed" recipe
                (:name column-marker :description "Highlight certain character columns" :type emacswiki :features column-marker))
 (emacs-w3m status "installed" recipe
            (:name emacs-w3m :description "A simple Emacs interface to w3m" :type cvs :website "http://emacs-w3m.namazu.org/" :module "emacs-w3m" :url ":pserver:anonymous@cvs.namazu.org:/storage/cvsroot" :build
                   `("autoconf"
                     ("./configure" ,(concat "--with-emacs=" el-get-emacs))
                     "make")
                   :build/windows-nt
                   ("sh /usr/bin/autoconf" "sh ./configure" "make")
                   :info "doc"))
 (expand-region status "installed" recipe
                (:name expand-region :type github :pkgname "magnars/expand-region.el" :description "Expand region increases the selected region by semantic units. Just keep pressing the key until it selects what you want." :website "https://github.com/magnars/expand-region.el#readme" :features expand-region))
 (flymake-cursor status "installed" recipe
                 (:name flymake-cursor :type github :pkgname "illusori/emacs-flymake-cursor" :description "displays flymake error msg in minibuffer after delay (illusori/github)" :website "http://github.com/illusori/emacs-flymake-cursor"))
 (fuzzy status "installed" recipe
        (:name fuzzy :website "https://github.com/auto-complete/fuzzy-el" :description "Fuzzy matching utilities for GNU Emacs" :type github :pkgname "auto-complete/fuzzy-el"))
 (goto-chg status "installed" recipe
           (:name goto-chg :description "Goto the point of the most recent edit in the buffer." :type emacswiki :features goto-chg))
 (highlight-indentation status "installed" recipe
                        (:name highlight-indentation :description "Function for highlighting indentation" :type git :url "https://github.com/antonj/Highlight-Indentation-for-Emacs"))
 (js2-mode status "installed" recipe
           (:name js2-mode :website "https://github.com/mooz/js2-mode#readme" :description "An improved JavaScript editing mode" :type github :pkgname "mooz/js2-mode" :prepare
                  (autoload 'js2-mode "js2-mode" nil t)))
 (json status "installed" recipe
       (:name json :description "JavaScript Object Notation parser / generator" :type http :builtin "23" :url "http://edward.oconnor.cx/elisp/json.el" :features json))
 (key-chord status "installed" recipe
            (:name key-chord :description "Map pairs of simultaneously pressed keys to commands." :type emacswiki :features "key-chord"))
 (lispxmp status "installed" recipe
          (:name lispxmp :description "Automagic emacs lisp code annotation" :type emacswiki :features "lispxmp"))
 (mo-git-blame status "installed" recipe
               (:name mo-git-blame :description "An interactive, iterative 'git blame' mode for Emacs" :type github :pkgname "mbunkus/mo-git-blame" :features "mo-git-blame"))
 (multi-mode status "installed" recipe
             (:name multi-mode :website "http://www.loveshack.ukfsn.org/emacs/" :description "support for multiple major modes" :type http :url "http://www.loveshack.ukfsn.org/emacs/multi-mode.el"))
 (multi-term status "installed" recipe
             (:name multi-term :description "A mode based on term.el, for managing multiple terminal buffers in Emacs." :type emacswiki :features multi-term))
 (navi2ch status "installed" recipe
          (:name navi2ch :website "http://navi2ch.sourceforge.net/" :description "Navigator for 2ch for Emacsen" :type github :pkgname "naota/navi2ch"))
 (nyan-mode status "installed" recipe
            (:name nyan-mode :description "Nyan Cat for Emacs! Nyanyanyanyanyanyanyanyanyan!" :type github :pkgname "TeMPOraL/nyan-mode" :features nyan-mode))
 (open-junk-file status "installed" recipe
                 (:name open-junk-file :description "Open a junk (memo) file to try-and-error" :type emacswiki :features "open-junk-file"))
 (paredit status "installed" recipe
          (:name paredit :description "Minor mode for editing parentheses" :type http :prepare
                 (progn
                   (autoload 'enable-paredit-mode "paredit")
                   (autoload 'disable-paredit-mode "paredit"))
                 :url "http://mumble.net/~campbell/emacs/paredit.el"))
 (php-mode status "installed" recipe
           (:name php-mode :description "A PHP mode for GNU Emacs " :type github :pkgname "ejmr/php-mode" :website "https://github.com/ejmr/php-mode"))
 (popup status "installed" recipe
        (:name popup :website "https://github.com/auto-complete/popup-el" :description "Visual Popup Interface Library for Emacs" :type github :submodule nil :pkgname "auto-complete/popup-el"))
 (quickrun status "installed" recipe
           (:name quickrun :description "Run commands quickly" :website "https://github.com/syohex/emacs-quickrun" :type github :pkgname "syohex/emacs-quickrun" :features "quickrun"))
 (rainbow-delimiters status "installed" recipe
                     (:name rainbow-delimiters :website "https://github.com/jlr/rainbow-delimiters#readme" :description "Color nested parentheses, brackets, and braces according to their depth." :type github :pkgname "jlr/rainbow-delimiters"))
 (recentf-ext status "installed" recipe
              (:name recentf-ext :description "Recentf extensions" :type emacswiki :features "recentf-ext"))
 (shell-pop status "installed" recipe
            (:name shell-pop :description "Helps you pop up and pop out shell buffer easily." :website "http://www.emacswiki.org/emacs/ShellPop" :type emacswiki :features "shell-pop"))
 (sml-modeline status "installed" recipe
               (:name sml-modeline :description "Show position in a scrollbar like way in mode-line" :type http :url "http://bazaar.launchpad.net/~nxhtml/nxhtml/main/download/head%3A/smlmodeline.el-20100318165023-n7kkswg6dlq8l6b3-1/sml-modeline.el" :features "sml-modeline"))
 (stem status "installed" recipe
       (:name stem :description "routines for stemming" :type github :pkgname "yuutayamada/stem"))
 (tabbar status "installed" recipe
         (:name tabbar :type emacswiki :description "Display a tab bar in the header line" :lazy t :load-path "."))
 (twittering-mode status "installed" recipe
                  (:name twittering-mode :description "Major mode for Twitter" :type github :pkgname "hayamiz/twittering-mode" :features twittering-mode :compile "twittering-mode.el"))
 (vline status "installed" recipe
        (:name vline :description "show vertical line (column highlighting) mode." :type emacswiki :features vline))
 (web-mode status "installed" recipe
           (:name web-mode :description "emacs major mode for editing PHP/JSP/ASP HTML templates (with embedded CSS and JS blocks)" :type github :pkgname "fxbois/web-mode")))
