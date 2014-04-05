
;; loads and requires
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/org-mode/") ; org-mode!
(add-to-list 'load-path "~/.emacs.d/remember")
(add-to-list 'load-path "~/.emacs.d/emacs-w3m")
(add-to-list 'load-path "~/.emacs.d/pylookup")
(setq message-log-max t)

;; set this early
(require 'comint)
(define-key comint-mode-map [down] 'comint-next-matching-input-from-input)
(define-key comint-mode-map [up] 'comint-previous-matching-input-from-input)

(require 'psvn)
(setq svn-status-verbose nil)

;;will display function prototypes in c
(require 'c-eldoc)
(add-hook 'c-mode-hook 'c-turn-on-eldoc-mode)

;; yasnippet
(add-to-list 'load-path
                               "~/.emacs.d/yasnippet-0.6.1c")
    (require 'yasnippet) ;; not yasnippet-bundle
    (yas/initialize)
    (yas/load-directory "~/.emacs.d/yasnippet-0.6.1c/snippets")

(setq yas/visit-from-menu t)
(setq yas/use-menu 'abbreviate)

;; look at csv files
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(autoload 'csv-mode "csv-mode"
  "Major mode for editing comma-separated value files." t)

;; line numbersss

(require 'linum)
(setq linum-format "%6d ")

;; textmate style braces, quotes
(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers
(setq autopair-autowrap t)
(add-hook 'python-mode-hook
          #'(lambda ()
              (setq autopair-handle-action-fns
                    (list #'autopair-default-handle-action
                          #'autopair-python-triple-quote-action))))
(add-hook 'nxhtml-mode-hook
          #'(lambda ()
              (push '(?< . ?>)
                    (getf autopair-extra-pairs :code))))

;; org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(transient-mark-mode 1)

(setq org-directory "~/org")
(setq org-mobile-inbox-for-pull "~/org/notes.org")
(setq org-mobile-directory "~/Dropbox/MobileOrg")

; underscore shouldn't do subscript
(setq org-export-with-sub-superscripts nil)

;; ;; stupid twitter
;; (require 'twittering-mode)

;; (setq twittering-timer-interval 300)         ; Update your timeline each 300 seconds (5 minutes)
;; (setq twittering-url-show-status nil)        ; Keeps the echo area from showing all the http processes
;; (setq twittering-use-master-password t)      ; don't keep putting in a pin each time

;; ; gnus
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/gnus")
;; (require 'gnus)

;; ;; set C-c C-o to open a user's timeline
;; (add-hook 'twittering-mode-hook
;;                   (lambda ()
;;             (define-key twittering-mode-map (kbd "C-c C-o") 'twittering-other-user-timeline-interactive)))

;; ;; for gpg integration
;; (autoload 'alpaca-after-find-file "alpaca" nil t)
;; (add-hook 'find-file-hooks 'alpaca-after-find-file)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(setq *nxhtml-autostart-file* (expand-file-name "~/.emacs.d/nxhtml/autostart.el"))
(defun load-nxhtml-if-required ()
    (if (and (string-match ".+\\.\\(php\\)$" (buffer-file-name))
                        (not (featurep 'nxhtml-autostart)))
              (progn
                        (load *nxhtml-autostart-file*)
                        (nxhtml-mumamo-mode)))) ;; mumamo loads nxhtml-mode et al
(add-hook 'find-file-hook 'load-nxhtml-if-required)

(setq mumamo-background-colors nil)
(setq nxml-child-indent 4)                              ; indenting for nxhtml
(setq-default c-basic-offset 4)
(setq mustache-basic-offset 4)
(setq require-final-newline t)
(setq indent-tabs-mode nil)
(setq tab-width 4)

(require 'javascript-mode)
(require 'w3m-load)

(setq font-lock-maximum-decoration
      '((nxhtml-mode . 1)
        (javascript-mode . 1)
        (python-mode . 1)
        (mustache-mode . 1)))

(autoload 'mustache-mode "mustache-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.html$" . mustache-mode))

;; (autoload 'auto-revert-tail-mode "Tail" nil t)
;; (add-to-list 'auto-mode-alist '("\\.log$" . auto-revert-tail-mode))

;; pylookup
(setq pylookup-dir "~/.emacs.d/pylookup")
(add-to-list 'load-path pylookup-dir)
;; load pylookup when compile time
(eval-when-compile (require 'pylookup))

;; set executable file and db file
(setq pylookup-program (concat pylookup-dir "/pylookup.py"))
(setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))

;; to speedup, just load it on demand
(autoload 'pylookup-lookup "pylookup"
    "Lookup SEARCH-TERM in the Python HTML indexes." t)
(autoload 'pylookup-update "pylookup"
    "Run pylookup-update and create the database at `pylookup-db-file'." t)

;;(require 'javascript-mode)
;;(autoload 'javascript-mode "javascript" nil t)
;;(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))

(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


;(eval-after-load "python"
;  '(progn
     ;;(add-to-list 'load-path "~/.emacs.d/pymacs-0.24-beta2")
     ;;(require 'pymacs)
     ;;(pymacs-load "ropemacs" "rope-")
     ;;(setq ropemacs-enable-autoimport t)
     ;;(setq ropemacs-completing-read-function 'ido-completing-read)
     ;;(setq ropemacs-confirm-saving 'nil)
     ;;(define-key ropemacs-local-keymap (kbd "M-TAB") 'rope-code-assist);))

; more org mode and remember
(setq org-directory "~/org/")
(setq org-default-notes-file "~/org/.notes")
(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(add-hook 'remember-mode-hook 'org-remember-apply-template)
(define-key global-map (kbd "C-M-r") 'org-remember)

(setq org-remember-templates
      ;;'(("Todo" ?t "* TODO %? %^g\n %i\n " "~/org/todo.org" "Tasks")
      '(("Todo" ?t "* TODO %? \n %i\n " "~/org/todo.org" "Tasks")
      ("Journal"   ?j "** %^{Head Line} %U %^g\n%i%?"  "~/org/journal.org")
      ("Someday"   ?s "** %^{Someday Heading} %U\n%?\n"  "~/org/someday.org")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Defuns, hooks, keys, etc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq inhibit-splash-screen t)
(setq fill-column 100)

;; This function is used in various programming language mode hooks below.  It
;; does indentation after every newline when writing a program.

(defun newline-indents ()
  "Bind Return to `newline-and-indent' in the local keymap."
  (local-set-key "\C-m" 'newline-and-indent))


;; Tell Emacs to use the function above in certain editing modes.

(add-hook 'lisp-mode-hook             (function newline-indents))
(add-hook 'emacs-lisp-mode-hook       (function newline-indents))
(add-hook 'lisp-interaction-mode-hook (function newline-indents))
(add-hook 'scheme-mode-hook           (function newline-indents))
(add-hook 'c-mode-hook                (function newline-indents))
(add-hook 'c++-mode-hook              (function newline-indents))
(add-hook 'java-mode-hook             (function newline-indents))
(add-hook 'python-mode-hook           (function newline-indents))
(add-hook 'php-mode-hook              (function newline-indents))
;;(add-hook 'javascript-mode-hook       (function newline-indents))
(add-hook 'css-mode-hook              (function newline-indents))
(add-hook 'mustache-mode-hook         (function newline-indents))

;(add-hook 'php-mode-hook ())

;; type "y"/"n" instead of "yes"/"no"
(fset 'yes-or-no-p 'y-or-n-p)

;; in C mode, delete hungrily
(setq c-hungry-delete-key t)

;; don't annoy me with all the backup files--
;; put them in a central directory
(setq backup-directory-alist `(("." . "~/.emacs.d/saves")))

;; make backups by copying
(setq backup-by-copying-when-linked t)

;; do some version control with backups
(setq delete-old-versions t
        kept-new-versions 6
          kept-old-versions 2
            version-control t)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; no tabs by default. modes that really need tabs should enable
;; indent-tabs-mode explicitly. makefile-mode already does that, for
;; example.
(setq-default indent-tabs-mode nil)
;; if indent-tabs-mode is off, untabify before saving
(add-hook 'write-file-hooks
          (lambda () (if (not indent-tabs-mode)
                         (untabify (point-min) (point-max)))))

;; disable line numbers sometimes
(setq linum-disabled-modes-list '(eshell-mode wl-summary-mode compilation-mode))
(defun linum-on ()
  (unless (or (minibufferp) (member major-mode linum-disabled-modes-list))
    (linum-mode 1)))

;; tab spacing
(setq-default tab-widthh 4)
(setq tab-width 4)
;(setq indent-tabs-mode nil)

;; turn on paren matching
(show-paren-mode t)
(setq show-paren-style 'mixed)

;; CSS Mode (editing Cascading Style Sheet files)
;; http://www.garshol.priv.no/download/software/css-mode/index.html
(autoload 'css-mode "css-mode")
(setq auto-mode-alist
      (cons '("\\.css\\'" . css-mode) auto-mode-alist))
                                        ; use C-style indenting in CSS mode
(setq cssm-indent-function 'cssm-c-style-indenter)

;; Avoid stupid blanks in end of line lines
(defun empty-blank-lines ()
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (replace-regexp "^(.*) +$" "\1")
    ))
;;(add-hook 'write-file-hooks 'empty-blank-lines)

                                        ;Make shell mode split the window.
(defun my-shell ()
  (interactive)
  (if (= (count-windows) 1)
      (progn (split-window)))
  (select-window (next-window))
  (shell))

(defun cdf ()
  "switches to *shell* and cd's to the current buffer's file dir."
  (interactive)
  (let ((shell-window (get-buffer-window "*shell*"))
        (fn (buffer-file-name)))
    (if shell-window
        (select-window shell-window)
      (my-shell))
    (switch-to-buffer "*shell*")
    (insert "cd " fn)
    (search-backward "/")
    (kill-line)
    (comint-send-input)))

(setq major-mode 'text-mode)
(setq-default truncate-lines nil)

(define-key ctl-x-map "!" 'shell-command)


;; split ediff horizontally if > 150 char width
(setq ediff-split-window-function (lambda (&optional arg)
                                    (if (> (frame-width) 150)
                                        (split-window-horizontally arg)
                                      (split-window-vertically arg))))

;; make it easier To resize windows
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; more commands that are nice
(defun write-modified-buffers (arg)
  (interactive "P")
  (save-some-buffers (not arg)))

(defun end-of-window ()
  "Move point to the end of the window."
  (interactive)
  (goto-char (- (window-end) 1)))

(defun beginning-of-window ()
  "Move point to the beginning of the window."
  (interactive)
  (goto-char (window-start)))

(defun my-split-window ()
  (interactive)
  (split-window-horizontally)
  (select-window (next-window)))

;; bind next/last block/graf to alt up and down
(global-set-key (kbd "ESC <up>") 'backward-paragraph)
(global-set-key (kbd "ESC <down>") 'forward-paragraph)
(global-set-key (kbd "ESC p") 'backward-paragraph)
(global-set-key (kbd "ESC n") 'forward-paragraph)
                                        ; also C-x 3 should go to the opposite window
                                        ;(global-set-key (kbd "C-x 3") 'my-split-window)

(autoload 'hippie-expand "hippie-exp" "Try to expand text.") ;; Hippie expand

(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-visible
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key "\M-h" 'hippie-expand)

(setq user-mail-address "jeff@mylikes.com")
(setq user-full-name "Jeff Martin")


;; let emacs use the system clipboard
(setq x-select-enable-clipboard t)

;; don't show the menu bar
(setq menu-bar-mode nil)

                                        ;(defadvice py-execute-buffer (around python-keep-focus activate)
                                        ;  "Thie advice to make focus python source code after execute command `py-execute-buffer'."
                                        ;  (let ((remember-window (selected-window))
                                        ;               (remember-point (point)))
                                        ;       ad-do-it
                                        ;       (select-window remember-window)
                                        ;       (goto-char remember-point)))

(defun buffer-exists (bufname) (not (eq nil (get-buffer bufname))))
(defun python-send-buffer-and-go ()
  (interactive)
  (python-send-buffer)
  (let ((remember-window (selected-window))
        (remember-point (point)))
    (switch-to-buffer-other-window "*Python*")
    (select-window remember-window)
    (goto-char remember-point)))

(defun py-compile ()
  "Use compile to run python programs"
  (interactive)
  (if (buffer-exists "*Python*")
      (python-send-buffer)
    (compile (concat "python " (buffer-name)))))

                                        ;(setq compilation-scroll-output t)
                                        ;(setq compilation-disable-input nil)


(add-hook 'python-mode-hook
          '(lambda ()
             ;; (local-set-key "\C-c\C-c" 'py-compile)
             ;; (local-set-key "\C-c!" 'python-switch-to-python)
             (local-set-key "\C-c\C-c" 'python-shell-send-buffer)
             (local-set-key "\C-c!" 'python-shell-switch-to-shell)
             (local-set-key "\C-ch" 'pylookup-lookup)))

(add-hook 'inferior-python-mode-hook
          '(lambda ()
             (local-set-key (kbd "M-\t") 'python-shell-completion-complete-at-point)))

;; turn off menu bar
(menu-bar-mode 0)

(setq browse-url-browser-function 'w3m-browse-url) ;; w3m

;; helpful little key commands
(global-set-key (kbd "C-x C-b") 'ibuffer-other-window)
(global-set-key "\C-x\C-m" 'execute-extended-command)

;; i wrote this to not have to remap \C-w
(defun backward-kill-word-or-region ()
  "do backwards kill word or kill-region depending on whether there is an active region"
  (interactive)
  (if (and transient-mark-mode mark-active)
      (kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))

(global-set-key (kbd "C-w") 'backward-kill-word-or-region)

;; cycle through the mark ring
(global-set-key (kbd "M-l") 'pop-to-mark-command)
(setq mark-ring-max 5)

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "M-%") 'query-replace-regexp)

(setq require-final-newline t)
(put 'narrow-to-region 'disabled nil)
(define-key esc-map "o" 'other-window)

(ido-mode 'buffer)
(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)
(setq ido-enable-regexp nil)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-revert-interval 2)
 '(auto-revert-verbose nil)
 '(ediff-diff-options "-w")
 '(js2-bounce-indent-p nil)
 '(js2-cleanup-whitespace nil)
 '(js2-enter-indents-newline t)
 '(js2-highlight-level 1)
 '(js2-indent-on-enter-key nil)
 '(js2-mirror-mode nil)
 '(nxhtml-skip-welcome t)
 '(svn-status-default-diff-arguments (quote ("-x" "--ignore-all-space"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ediff-fine-diff-A ((((class color)) (:background "sky blue" :foreground "white"))))
 '(ediff-fine-diff-B ((((class color)) (:background "cyan3" :foreground "white" :weight bold))))
 '(log-view-file ((((class color) (background light)) (:background "black" :foreground "green" :weight bold))))
 '(log-view-message ((t (:background "black" :foreground "magenta"))))
 '(yas/field-highlight-face ((((class color) (background light)) (:background "DarkSeaGreen1" :foreground "black")))))

;; jinja mode
;;(autoload 'jinja-nxhtml-mumamo "jinja" "Jinja xhtml mode" t)
;;(autoload 'jinja-mode "jinja" "Jinja mode" t)

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(define-key ctl-x-4-map "t" 'toggle-window-split)

;; set pdb path
(setq pdb-path '/usr/bin/pdb
      gud-pdb-command-name (symbol-name pdb-path))

(defun my-pdb ()
  (interactive)
  (setq cur-buffer (buffer-name))
  (delete-other-windows)
  (split-window-vertically -20)
  (other-window 1)
  (pdb (concat "/usr/bin/pdb " cur-buffer)))
                                        ;(setq svn-status-hide-unknown t)

;; psvn doesn't like these :'(
(defun my-commit ()
  (interactive)
  (delete-other-windows)
  (call-interactively 'svn-status)
  (call-interactively 'svn-status-mark-added)
  (call-interactively 'svn-status-mark-changed)
  (call-interactively 'svn-status-mark-deleted)
  (call-interactively 'svn-status-mark-modified)
  (call-interactively 'svn-status-show-svn-diff)
  (split-window)
  (call-interactively 'svn-status-commit))

(defun my-status ()
  (interactive)
  (call-interactively 'svn-status)
  (call-interactively 'svn-status-show-svn-diff))

                                        ; open all marked files using 'F' in dired mode
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map "F" 'my-dired-find-file)
     (defun my-dired-find-file (&optional arg)
       "Open each of the marked files, or the file under the point, or when prefix arg, the next N files "
       (interactive "P")
       (let* ((fn-list (dired-get-marked-files nil arg)))
         (mapc 'find-file fn-list)))))

(defun get-todos ()
  (interactive)
  (multi-occur-in-matching-buffers ".*" "TODO:"))

;; load js2 mode when javascript mode loads
(add-hook 'javascript-mode-hook (lambda ()
                                  (js2-mode)))

;; pretty print json
(defun beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
                             "python -mjson.tool" (current-buffer) t)))

;; Macros
(fset 'space-after-commas
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote (", " 0 "%d")) arg)))

;; color theme
;;(require 'inkpot)

;;(inkpot)
