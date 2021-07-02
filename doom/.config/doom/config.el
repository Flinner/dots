(add-hook 'markdown-mode-hook 'mixed-pitch-mode)
(add-hook 'org-mode-hook 'mixed-pitch-mode)

(setq leuven-scale-org-agenda-structure nil)
(setq leuven-scale-outline-headlines nil)
(setq doom-theme 'doom-gruvbox)

(setq doom-font (font-spec :family "FiraCode" :size 9.0 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "sans" :size 9.0))
(after! doom-themes
  (set-fontset-font t 'arabic "Noto Sans Arabic UI")
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t
        ))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic)
  )
;;(setq doom-font (font-spec :family "Open Sans" :size 12 :weight 'regular)
;;doom-variable-pitch-font (font-spec :family "sans" :size 12))

(setq display-line-numbers-type 't)

(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

(map!
 :n "<f5>" 'rustic-cargo-test
 :n "C-<f5>" 'compile-on-save-mode
 :n "<f6>" 'elfeed
 ;; :n "<f7>" email TODO: Add email
 :n "<f8>" (cmd! (org-agenda nil "c"))
 :n "<f12>" 'delve-open-or-select
 )

(setq doom-leader-alt-key "C-SPC")
(setq doom-localleader-alt-key "C-SPC m")

(map! "C-h" 'backward-delete-char-untabify)

(defun doom/ediff-init-and-example ()
  "ediff the current `init.el' with the example in doom-emacs-dir"
  (interactive)
  (ediff-files (concat doom-private-dir "init.el")
               (concat doom-emacs-dir "init.example.el")))

(define-key! help-map
  "di"   #'doom/ediff-init-and-example
  )

(setq-default fill-column 80)

(setq scroll-conservatively 10)
(setq scroll-margin 3)

;;(add-hook 'text-mode-hook 'mixed-pitch-mode)
(add-hook 'text-mode-hook 'blink-cursor-mode)

(use-package org-roam-server
  :after org-roam
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8888
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20)

  (defun org-roam-server-open ()
    "Ensure the server is active, then open the roam graph."
    (interactive)
    (unless (server-running-p)
      (org-roam-server-mode 1))
    (browse-url-xdg-open (format "http://localhost:%d" org-roam-server-port))))

;; Moved to Org Directory

(setq deft-directory "~/org/roam")
(setq deft-extensions '("md" "tex" "org"))
(setq deft-recursive t)
(setq deft-strip-title-regexp "\\(?:^%+\\|^#\\+TITLE: *\\|^[#* ]+\\|-\\*-[[:alpha:]]+-\\*-\\|^Title:[	 ]*\\|#+$\\)")

(setq org-roam-dailies-capture-templates
      (let ((head "\
:PROPERTIES:
:ID:       %<%Y%m%d>-daily
:TITLE: %<%Y-%m-%d (%A)>
:STARTUP: showall
:ROAM_TAGS: dailies
:END:\
\n#+STARTUP: showall\
\* MetaData\
\n- type: [[id:8bedd21f][Dailies]]\
 \n* Journal :journal: \
 \n Feelings throught the day\
 \n* Gratitude \n1. Past\n2. Present\n3. Future\
 \n* Goals for today [/][%]\
 \n- [ ] \
 \n* The Good and Bad \
 \n** YES \
 \n** NO \
  "))
        `(("j" "journal" entry
           #'org-roam-capture--get-point
           "* %<%H:%M> %?"
           :file-name "daily/%<%Y-%m-%d>"
           :head ,head
           :olp ("Journal"))
          ("t" "do today" item
           #'org-roam-capture--get-point
           "[ ] %(princ as/agenda-captured-link)"
           :file-name "daily/%<%Y-%m-%d>"
           :head ,head
           :olp ("Do Today")
           :immediate-finish t)
          ("m" "maybe do today" item
           #'org-roam-capture--get-point
           "[ ] %(princ as/agenda-captured-link)"
           :file-name "daily/%<%Y-%m-%d>"
           :head ,head
           :olp ("Maybe Do Today")
           :immediate-finish t))))

;(add-hook 'org-mode-hook #'delve-minor-mode-maybe-activate)
(setq delve-use-icons-in-completions t)
(set-evil-initial-state! 'delve-mode 'insert)
(map! :map delve-mode-map
      :n "gr"      #'delve-refresh-buffer
      :n "<right>" #'delve-expand-insert-tolinks
      :n "<left>"  #'devle-expand-insert-backlinks
      :n "TAB"  #'delve-expand-toggle-sublist)
"RET"  #'lister-key-action
:localleader
"RET"  #'lister-key-action
"TAB"  #'delve-expand-toggle-sublist

(defun org-roam-server-open ()
  "Ensure the server is active, then open the roam graph."
  (interactive)
  (smartparens-global-mode -1)
  (org-roam-server-mode 1)
  (browse-url-xdg-open (format "http://localhost:%d" org-roam-server-port))
  (smartparens-global-mode 1))
;; automatically enable server-mode
;; (after! org-roam
;;   (smartparens-global-mode -1)
;;   (org-roam-server-mode)
;;   (smartparens-global-mode 1))

(setq org-roam-prefer-id-links t)

(setq org-directory "~/org/org/")
(setq org-college-file(concat org-directory "college.org"))
;; roam
(setq org-roam-directory "~/org/roam/")
(setq org-roam-dailies-directory "daily/")
(setq org-roam-intersting-file (concat org-roam-directory "internet/intersting.org"))
(setq org-roam-goals-file (concat org-roam-directory "goals.org"))

(use-package! org-super-agenda
  :after org-agenda
  ;;:custom-face
  ;;(org-super-agenda-header ((default (:inherit propositum-agenda-heading))))

  :init
  (setq
   org-agenda-skip-scheduled-if-done t
   org-agenda-skip-deadline-if-done t
   org-agenda-include-deadlines t
   org-agenda-block-separator nil
   org-agenda-compact-blocks t
   org-agenda-start-day nil ;; i.e. today
   org-agenda-span 1
   org-agenda-start-on-weekday nil
   )

  (setq org-agenda-custom-commands
        '(("c" "Super view"
           (
            (agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:name "Today"
                            :time-grid t
                            :date today
                            :order 1)
                           (:discard (:anything t))
                           ))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '(;;(:log t)
                            (:name "Important"
                             :priority "A"
                             :order 1
                             )
                            ;; College
                            (:name "Events"
                             :tag "event"
                             :order 2
                             )
                            (:name "College"
                             :tag "college"
                             :order 3
                             )
                            ;; (:name "Next"
                            ;;  :todo "STRT"
                            ;;  :order 2)
                            ;; ====schedules====== ;;
                            ;; (:name "habits"
                            ;;  :and (:habit t :scheduled today )
                            ;;  :order 13
                            ;;  )
                            (:name "Scheduled Soon"
                             :and (:scheduled future :not (:habit t))
                             :order 6)
                            (:name "Due Soon"
                             :deadline future
                             :order 6)
                            (:name "Missed"
                             :scheduled past
                             :deadline past
                             :order 7)
                            ;;==============================;;
                            (:name "FOSS"
                             :tag "foss"
                             :order 9
                             )
                            (:name "Media to Consoom"
                             :tag "media"
                             :order 14
                             )
                            (:name "code"
                             :tag "code"
                             :order 15
                             )
                            (:name "Linux"
                             :tag "rice"
                             :order 16
                             )

                            (:discard (:habit t))
                            ))))))))
  :config
  (org-super-agenda-mode))

(add-hook 'org-agenda-mode-hook 'elegant-agenda-mode)

(with-eval-after-load 'org-agenda
  (define-key org-super-agenda-header-map "j" nil)
  (define-key org-super-agenda-header-map "k" nil))

(advice-add 'org-agenda-quit :before 'org-save-all-org-buffers)

(add-hook 'org-mode-hook 'turn-on-auto-fill)
(defun update-org-latex-fragments ()
  (org-latex-preview '(64))
  (plist-put org-format-latex-options :scale text-scale-mode-amount)
  (org-latex-preview '(16)))
(add-hook 'text-scale-mode-hook 'update-org-latex-fragments)

(eval-after-load "preview"
  '(add-to-list 'preview-default-preamble "\\PreviewEnvironment{tikzpicture}" t))

(after! org (add-hook 'org-mode-hook 'turn-on-org-cdlatex))

(cl-defmacro lsp-org-babel-enable (lang)
  "Support LANG in org source code block."
  (setq centaur-lsp 'lsp-mode)
  (cl-check-type lang stringp)
  (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
         (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
    `(progn
       (defun ,intern-pre (info)
         (let ((file-name (->> info caddr (alist-get :file))))
           (unless file-name
             (setq file-name (make-temp-file "babel-lsp-")))
           (setq buffer-file-name file-name)
           (lsp-deferred)))
       (put ',intern-pre 'function-documentation
            (format "Enable lsp-mode in the buffer of org source block (%s)."
                    (upcase ,lang)))
       (if (fboundp ',edit-pre)
           (advice-add ',edit-pre :after ',intern-pre)
         (progn
           (defun ,edit-pre (info)
             (,intern-pre info))
           (put ',edit-pre 'function-documentation
                (format "Prepare local buffer environment for org source block (%s)."
                        (upcase ,lang))))))))
(defvar org-babel-lang-list
  '("go" "python" "ipython" "bash" "sh"))
(dolist (lang org-babel-lang-list)
  (eval `(lsp-org-babel-enable ,lang)))

(after! org
  (setq org-capture-templates
        '(

          ("t" "General Todo")
          ("tt" "General" entry
           (file+headline +org-capture-todo-file  "Inbox")
           "* TODO %?\n%i")
          ("tT" "Today" entry
           (file+headline +org-capture-todo-file  "Inbox")
           "* TODO %?\n%iSCHEDULED: %T\n")

          ;; College
          ("c" "College")
          ("ch" "Homework" entry
           (file+headline org-college-file  "Homework :college:hw:")
           "* TODO %?\n%i:PROPERTIES:\n:Created: %U\n:END:")
          ("cq" "Quiz/Exam/Test" entry
           (file+headline org-college-file "Quiz :college:exam:")
           "* TODO %?\n%i:PROPERTIES:\n:Created: %U\n:END:")
          ("ce" "Event" entry
           (file+headline org-college-file "Event :college:event:")
           "* TODO %?\n%i:PROPERTIES:\n:Created: %U\n:END:")
          ("ct" "Todo" entry
           (file+headline org-college-file "College Todo :college:")
           "* TODO %?\n%i:PROPERTIES:\n:Created: %U\n:END:")

          ("i" "Interesting")
          ("iw" "Interesting Website" entry
           (file+headline org-roam-intersting-file "Website")
           "* %?\n%i\n")
          ("it" "Interesting tweet" entry
           (file+headline org-roam-intersting-file "Tweet")
           "- %?\n%i\n")
          ("ii" "Information" entry
           (file+headline org-roam-intersting-file  "Information")
           "** PROJ %?\n%i\n")
          ("iq" "Quote" entry
           (file+headline org-roam-intersting-file  "Quotes")
           "** %?\n%i\n")
          ("ip" "Project Idea" entry
           (file+headline org-roam-goals-file  "Project Ideas")
           "** PROJ %?\n%i\n")
          ("ib" "Blog Ideas" entry
           (file+headline org-roam-goals-file  "Blog Ideas")
           "- %?\n%i\n")

          ;; Media
          ("m" "Media")
          ("mr" "To Read" entry
           (file+headline +org-capture-todo-file  "To Read :media:read:")
           "* TODO %?\n%i\n")
          ("mw" "To Watch" entry
           (file+headline +org-capture-todo-file  "To Watch :media:watch:")
           "* TODO %?\n%i\n")

          ("r" "Rice")
          ("ie" "Emacs Ideas" entry
           (file+headline +org-capture-todo-file  "Emacs Ideas :emacs:rice:")
           "- %?\n%i\n")
          ("ro" "Other Ideas" entry
           (file+headline +org-capture-todo-file "Window Manager :wm:rice:")
           "- %?\n%i\n")

          ("o" "Free/Open software")
          ("oa" "AUR" entry
           (file+headline +org-capture-todo-file "AUR :foss:aur:")
           "* TODO %? \n%i\n")

          )))

;;(add-hook 'org-mode-hook #'mixed-pitch-mode)
(setq geiser-default-implementation  'guile)

(setq org-ditaa-jar-path "/usr/share/java/ditaa/ditaa-0.11.jar")

(setq org-hide-emphasis-markers t)

;(after! org (setq org-tags-column 60))

(setq-default elfeed-search-filter "@1-week-ago")

;(setq rmh-elfeed-org-files (list "~/.doom.d/elfeed.org" (concat org-roam-directory "internet/elfeed.org")))
(setq rmh-elfeed-org-files (list (concat org-roam-directory "elfeed.org")))

(setf url-queue-parallel-processes 20
      url-queue-timeout 10)

(after! elfeed (map!  :map elfeed-search-mode-map
                      :n "gv" 'elfeed-view-mpv
                      :n "R" 'elfeed-update
                      :n "r" 'elfeed-search-untag-all-unread
                      :n "u" 'elfeed-search-tag-all-unread
                      :n "G" 'evil-goto-line
                      :n "<f6>" 'elfeed-close-prev-buffer
                      :n "b" 'elfeed-search-browse-url
                      :n "c" 'elfeed-search-clear-filter
                      ))

(defun elfeed-close-prev-buffer ()
  (interactive)
  "elfeed-kill and restore prev buffer"
  (elfeed-kill-buffer)
  (previous-buffer))

(defun elfeed-v-mpv (url title)
  "Watch a video from URL in MPV"
  (defvar cmd (format "mpv --ytdl-format=worst  '%s'" url))
  (save-window-excursion
    (async-shell-command cmd)
    (save-window-excursion
      (shell-command (format"notify-send 'Loading Video' '%s'" title)))
    (message "Video Loading")
    )
  )


(defun elfeed-view-mpv (&optional use-generic-p)
  "Youtube-feed link"
  (interactive "P")
  (let ((entries (elfeed-search-selected)))
    (cl-loop for entry in entries
             do (elfeed-untag entry 'unread)
             when (elfeed-entry-link entry)
             do (elfeed-v-mpv it (elfeed-entry-title entry))) ;; print title
    (mapc #'elfeed-search-update-entry entries)
    (unless (use-region-p) (forward-line))))

;;(add-hook 'elfeed-show-mode-hook #'mixed-pitch-mode)

(setq lsp-rust-target "/tmp/rust-crap")



(with-eval-after-load 'telega
  (define-key telega-msg-button-map "k" nil)
  (define-key telega-msg-button-map "l" nil))
(setq telega-chat-bidi-display-reordering 'right-to-left)

(setq company-idle-delay 0.0
company-minimum-prefix-length 1)

(ranger-override-dired-mode t)

(when EMACS28+
  (add-hook 'latex-mode-hook #'TeX-latex-mode))
(setq haskell-process-type 'cabal-new-repl)
