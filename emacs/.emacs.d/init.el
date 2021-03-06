;; emacs os config for writing and organization

;;; use-package
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)
(package-initialize)

;; ensure use-package is installed.
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

;; define user-init-dir
(defconst user-init-dir
          (cond ((boundp 'user-emacs-directory) user-emacs-directory)
                ((boundp 'user-init-directory) user-init-directory)
                (t "~/.emacs.d/")))

;; copy pasta
(defun load-user-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file user-init-dir)))

(load-user-file "font-resize.el")
;; (load-user-file "my-org.el") TODO fix org
(load-user-file "keymaps.el")
(load-user-file "utils.el")

;; TODO change smtpmail to use-package FIXME
;; (load-user-file "mail.el")

;; sensible settings from hrs
(add-to-list  'load-path "~/.emacs.d/personal/sensible-defaults.el")
(require 'sensible-defaults)
(sensible-defaults/use-all-settings)
(sensible-defaults/use-all-keybindings)
(sensible-defaults/backup-to-temp-directory)


;; pusihing p
(use-package command-log-mode
             :commands command-log-mode)

(use-package ivy
             :diminish
             :bind (("C-s" . swiper)
                    :map ivy-minibuffer-map
                    ("TAB" . ivy-alt-done)
                    :map ivy-switch-buffer-map
                    ("C-d" . ivy-switch-buffer-kill)
                    :map ivy-reverse-i-search-map
                    ("C-k" . ivy-previous-line)
                    ("C-d" . ivy-reverse-i-search-kill))
             :config
             (ivy-mode 1))

;;; kung fu
(use-package undo-fu)

;; evil deeds for a bad bad boy
(use-package evil
             :demand t
             :bind (("<escape>" . keyboard-escape-quit))
             :init
             (setq evil-search-module 'evil-search)
             (setq evil-want-keybinding nil)
             ;; no vim insert bindings
             (setq evil-undo-system 'undo-fu)
             :config
             (evil-mode 1)
             (evil-define-key 'normal org-mode-map (kbd "TAB") 'org-cycle))

;;; 666, the number of the beast
(use-package evil-collection
             :ensure t
             :after evil
             :config
             (setq evil-want-integration t)
	      (setq evil-collection-mode-list
		    '(deadgrep
		      dired
		      elfeed
		      ibuffer
		      magit
		      mu4e
		      pdf-view
		      which-key))
             (evil-collection-init))

;; tpope surround
(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

;; more vert
(use-package vertico
             :config
             (vertico-mode))

;; always on demon time
(use-package evil-org
  :after org
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))
(evil-commentary-mode)

;; ui tweaks
(tooltip-mode -1)
(tool-bar-mode nil)
(menu-bar-mode nil)
(column-number-mode)
(scroll-bar-mode -1)
(setq visible-bell nil)
(tool-bar-mode -1)
(menu-bar-mode 1)
(set-fringe-mode 10)

;; (pixel-scroll-precision-mode)
(setq inhibit-startup-message t)
(global-prettify-symbols-mode t)
(setq shell-command-switch "-ic")
(setq counsel-find-file-at-point t)
(setq ring-bell-function 'ignore)
(global-hl-line-mode)
(set-window-scroll-bars (minibuffer-window) nil nil)
(setq frame-title-format '((:eval (projectile-project-name))))


;; Install additinal themes from melpa
;; make sure to use :defer keyword
(use-package apropospriate-theme :ensure :defer)
(use-package nord-theme :ensure :defer)

(use-package circadian
  :ensure t
  :config
  (setq calendar-latitude 53.6)
  (setq calendar-longitude -2.43)
  (setq circadian-themes '((:sunrise . apropospriate-light)
  ;; (setq circadian-themes '((:sunrise . nord)
                           (:sunset  . dracula)))
  (circadian-setup))


;; hide minor modes
(use-package minions
  :config
  (setq minions-mode-line-lighter "?"
        minions-mode-line-delimiters (cons "" ""))
  (minions-mode 1))

;; modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 25)))
(set-face-attribute 'mode-line nil :height 100)
(set-face-attribute 'mode-line-inactive nil :height 100)
;; ;; highlight those diffs
;; (use-package diff-hl
;;   :config
;;   :hook ((text-mode prog-mode vc-dir-mode) . turn-on-diff-hl-mode))

;; ripgrep for searching
(use-package deadgrep
  :config
  (defun deadgrep--include-args (rg-args)
    (push "--hidden" rg-args))
  (advice-add 'deadgrep--arguments
              :filter-return #'deadgrep--include-args))


;; treesitter for syntax highlighting
(require 'tree-sitter)
(require 'tree-sitter-langs)
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

;; company for completion
(use-package company
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))

  :custom
  (company-backends '((company-capf company-dabbrev-code)))
  (company-idle-delay 0)
  (company-minimum-prefix-length 3)
  (company-tooltip-align-annotations t)
  (company-tooltip-limit 20)

  :config
  (setq lsp-completion-provider :capf))
(use-package all-the-icons
  :ensure t)

(use-package company-box
  :after company
  :hook (company-mode . company-box-mode)

  :config
  (setq company-box-icons-alist 'company-box-icons-all-the-icons))

;; projectile
(use-package projectile
  :bind
  ("C-c v" . deadgrep)

  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

  (define-key evil-normal-state-map (kbd "C-p") 'projectile-find-file)
  (evil-define-key 'motion deadgrep-mode-map (kbd "C-p") 'projectile-find-file)
  (evil-define-key 'motion rspec-mode-map (kbd "C-p") 'projectile-find-file)
  (evil-define-key 'motion rspec-compilation-mode-map (kbd "C-p") 'projectile-find-file)

  (setq projectile-completion-system 'ivy
        projectile-switch-project-action 'projectile-dired
        projectile-require-project-root nil)

  (projectile-global-mode))

;; git
(use-package magit
  :hook (with-editor-mode . evil-insert-state)
  :bind ("C-x g" . magit-status)

  :config
  (use-package git-commit)
  (use-package magit-section)
  (use-package with-editor)

  (require 'git-rebase)

  (setq magit-push-always-verify nil
        git-commit-summary-max-length 50))
(use-package magit-popup
  :ensure t ; make sure it is installed
  :demand t ; make sure it is loaded
  )

;; page through history of a file
(use-package git-timemachine)

;; Teach Emacs how to open links in your default Windows browser
(let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
      (cmd-args '("/c" "start")))
  (when (file-exists-p cmd-exe)
    (setq browse-url-generic-program  cmd-exe
          browse-url-generic-args     cmd-args
          browse-url-browser-function 'browse-url-generic
          search-web-default-browser 'browse-url-generic)))

;; org-roam TODO move to my-org.el
(require 'org)
(require 'org-roam)

(use-package org-roam
             :after org
             :ensure t
             :init
             (setq org-roam-v2-ack t)
             :custom
             (org-roam-directory (file-truename "~/Dropbox/Zettelkasten"))
             :bind (("C-c n l" . org-roam-buffer-toggle)
                    ("C-c n f" . org-roam-node-find)
                    ("C-c n g" . org-roam-ui-open)
                    ("C-c n i" . org-roam-node-insert)
                    ("C-c n c" . org-roam-capture)
                    ("C-c n a" . org-roam-alias-add)
                    :map org-mode-map
                    ("C-M-i" . completion-at-point)
                    ("C-c n j" . org-roam-dailies-capture-today)) ; Dailies
             :config
             (org-roam-setup)
             (org-roam-db-autosync-mode)
             (require 'org-roam-protocol))


;; md-roam TODO find reason why md-roam slows down emacs
;; (setq org-roam-directory (file-truename "~/Dropbox/Zettelkasten"))
;; (setq org-roam-file-extensions '("org" "md"))
;; (add-to-list  'load-path "~/.emacs.d/personal/md-roam")
;; (require 'md-roam)
;; (md-roam-mode 1)
;; (setq md-roam-file-extension "md")
;; (org-roam-db-autosync-mode 1) ; autosync-mode triggers db-sync. md-roam-mode must be already active

;; TODO add aliases and roam_refs
;; (add-to-list 'org-roam-capture-templates
;;              '("m" "Markdown" plain "" :target
;;                (file+head "%<%Y-%m-%dT%H%M%S>.md"
;;                           "---\ntitle: ${title}\nid: %<%Y-%m-%dT%H%M%S>\ncategory: \nroam_refs: \nroam_aliases: \n---\n")
;;                :unnarrowed t))

;; ;; org-roam-ui
;; (use-package websocket
;;              :after org-roam)
;;
;; (use-package org-roam-ui
;;              :after org-roam
;;              :config
;;              (setq org-roam-ui-sync-theme t
;;                    org-roam-ui-follow t
;;                    org-roam-ui-update-on-save t
;;                    org-roam-ui-open-on-start t))
;; ;; PDFs
;; (pdf-loader-install)
;; (add-to-list 'auto-mode-alist '("\\.pdf\\'" . auto-revert))
;;
;; shell paths
(getenv "SHELL")
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))


(require 'rainbow-delimiters)
(use-package rainbow-delimiters
             :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
             :init (which-key-mode)
             :diminish which-key-mode
             :config
             (setq which-key-idle-delay 0.3))

(use-package counsel
             :bind (("M-x" . counsel-M-x)
                    ("C-x b" . counsel-ibuffer)
                    ("C-x C-f" . counsel-find-file)
                    :map minibuffer-local-map
                    ("C-r" . 'counsel-minibuffer-history))
             :config
             (setq ivy-initial-inputs-alist nil))

(use-package ivy-rich
             :init
             (ivy-rich-mode 1))

(use-package helpful
             :commands (helpful-callable helpful-variable helpful-command helpful-key)
             :custom
             (counsel-describe-function-function #'helpful-callable)
             (counsel-describe-variable-function #'helpful-variable)
             :bind
             ([remap describe-function] . counsel-describe-function)
             ([remap describe-command] . helpful-command)
             ([remap describe-variable] . counsel-describe-variable)
             ([remap describe-key] . helpful-key))




(global-hl-todo-mode)
(setq hl-todo-keyword-faces
      '(("TODO"   . "#FF0000")
        ("FIXME"  . "#FF0000")
        ("DEBUG"  . "#A020F0")
        ("GOTCHA" . "#FF4500")
        ("STUB"   . "#1E90FF")))


;; Or if you use use-package
(use-package dashboard
             :ensure t
             :config
             (dashboard-setup-startup-hook)
             (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
             (setq dashboard-startup-banner 'nil) ; 'logo -> logo
             )

(use-package all-the-icons
             :if (display-graphic-p))

(require 'olivetti)
(auto-image-file-mode 1)

;; (require 'calendar)

;; Transparency
;; (set-frame-parameter (selected-frame) 'alpha '(100))
;; (add-to-list 'default-frame-alist '(alpha . (100)))

(use-package dired
  :ensure nil

  :config
  (defun hrs/dired-slideshow ()
    (interactive)
    (start-process "dired-slideshow" nil "s" (dired-current-directory)))

  (evil-define-key 'normal dired-mode-map (kbd "o") 'dired-find-file-other-window)
  (evil-define-key 'normal dired-mode-map (kbd "v") 'hrs/dired-slideshow)

  (setq-default dired-listing-switches
                (combine-and-quote-strings '("-l"
                                             "-v"
                                             "-g"
                                             "--no-group"
                                             "--human-readable"
                                             "--time-style=+%Y-%m-%d"
                                             "--almost-all")))
  (setq dired-clean-up-buffers-too t
        dired-dwim-target t
        dired-recursive-copies 'always
        dired-recursive-deletes 'top
        global-auto-revert-non-file-buffers t))

(use-package dired-hide-dotfiles
  :config
  (dired-hide-dotfiles-mode 1)
  (evil-define-key 'normal dired-mode-map "." 'dired-hide-dotfiles-mode))

(use-package dired-open
  :config
  (setq dired-open-extensions
        '(("avi" . "mpv")
          ("cbr" . "zathura")
          ("doc" . "abiword")
          ("docx" . "abiword")
          ("gif" . "ffplay")
          ("gnumeric" . "gnumeric")
          ("jpeg" . "s")
          ("jpg" . "s")
          ("mkv" . "mpv")
          ("mov" . "mpv")
          ("mp3" . "mpv")
          ("mp4" . "mpv")
          ("pdf" . "zathura")
          ("png" . "s")
          ("webm" . "mpv")
          ("xls" . "gnumeric")
          ("xlsx" . "gnumeric"))))

;; perform dired actions asynchronously
(use-package async
  :config
  (dired-async-mode 1))

;; engine mode
(use-package engine-mode
  :ensure t

  :config
  (engine-mode t))

;; (setq engine/browser-function 'eww-browse-url)

(defengine github
  "https://github.com/search?ref=simplesearch&q=%s"
  :keybinding "c")

(defengine duckduckgo
  "https://duckduckgo.com/?q=%s"
  :keybinding "d")

(defengine google
  "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
  :keybinding "g")

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  ;;(setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "powershell.exe")
  (setq explicit-powershell.exe-args '()))

(defun efs/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
  :after eshell)

(use-package eshell
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim")))

  (eshell-git-prompt-use-theme 'powerline))


;; programming specific
;;TODO  add LSP
;;TODO  add DAP

;;TODO  add SLIME for lisp
(setq inferior-lisp-program "sbcl")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(eshell-git-prompt vterm dracula-theme nord-theme apropospriate-theme circadian engine-mode which-key vertico use-package undo-fu tree-sitter-langs spacemacs-theme slime rainbow-delimiters org-roam-ui olivetti moody minions magit-popup ivy-rich hl-todo gruvbox-theme git-timemachine git-commit flycheck exec-path-from-shell evil-surround evil-org evil-commentary evil-collection dired-open dired-hide-dotfiles deadgrep dashboard counsel async all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(italic ((t (:slant italic)))))
