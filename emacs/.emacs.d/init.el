(require 'package)

;;; PACKAGE LIST
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

;;; BOOTSTRAP USE-PACKAGE
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)



;; PACKAGES
(use-package command-log-mode)
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)	
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;;; UNDO
;; Vim style undo not needed for emacs 28
(use-package undo-fu)

;;; Vim Bindings
(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  ;; allows for using cgn
  ;; (setq evil-search-module 'evil-search)
  (setq evil-want-keybinding nil)
  ;; no vim insert bindings
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1))

;;; Vim Bindings Everywhere else
(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))

;; vertico
(use-package vertico
  :config
  (vertico-mode))

;; PERSONAL SETTINGS
(load-theme 'adwaita)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(set-face-attribute 'mode-line nil  :height 200)
;; (set-face-attribute 'default nil :font "Fira Code Retina" :height 280)
(setq visible-bell nil)
(setq ring-bell-function 'ignore)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)            ; Disable the menu bar
(eval-after-load "linum" '(set-face-attribute 'linum nil :height 100))
(setq inhibit-startup-message t)


;; TODO: test on linux
(defmacro with-system (type &rest body)
  "Evaluate BODY if `system-type' equals TYPE."
  (declare (indent defun))
  `(when (eq system-type ',type)
     ,@body))

(with-system gnu/linux
;; zathura as pdf viewer
;; ~/.local/bin/zathura.sh
 (setq TeX-view-program-list
       '(("zathura" 
 	 ("zathura" (mode-io-correlate "-sync.sh")
 	  " "
 	  (mode-io-correlate "%n:1:%t ")
 	  "%o"))))

(use-package eaf
  :load-path "~/.emacs.d/site-lisp/emacs-application-framework"
  :custom
					; See https://github.com/emacs-eaf/emacs-application-framework/wiki/Customization
  (eaf-browser-continue-where-left-off t)
  (eaf-browser-enable-adblocker t)
  (browse-url-browser-function 'eaf-open-browser)
  :config
  (defalias 'browse-web #'eaf-open-browser)
  (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
  (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
  (eaf-bind-key take_photo "p" eaf-camera-keybinding)
  (eaf-bind-key nil "M-q" eaf-browser-keybinding)) ;; unbind, see more in the Wiki

;; EAF Python process run under Rosetta2.
(setq eaf--mac-enable-rosetta t)

;; (M-x eaf-install-and-update) to update EAF, applications and their dependencies.
;; EAF applications

(require 'eaf-rss-reader)
(require 'eaf-terminal)
(require 'eaf-image-viewer)
(require 'eaf-pdf-viewer)
(require 'eaf-markdown-previewer)
(require 'eaf-file-browser)
(require 'eaf-file-manager)
(require 'eaf-mindmap)
(require 'eaf-video-player)
(require 'eaf-org-previewer)
(require 'eaf-jupyter)
(require 'eaf-system-monitor))


;; ORG-ROAM
;; org-roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Dropbox/Zettelkasten"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

;; org-roam-ui
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam 
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

;; md-roam
(setq org-roam-v2-ack t)
(require 'org-roam)
(setq org-roam-directory (file-truename "~/Dropbox/Zettelkasten"))
(setq org-roam-file-extensions '("org" "md"))
(add-to-list  'load-path "~/.emacs.d/elispfiles/md-roam.el")
(md-roam-mode 1)
(require 'md-roam)
(setq md-roam-file-extension "md")
(org-roam-db-autosync-mode 1) ; autosync-mode triggers db-sync. md-roam-mode must be already active

;;;; Org-roam
(define-key global-map (kbd "C-c n f") #'org-roam-node-find)
(define-key global-map (kbd "C-c n c") #'org-roam-capture)
(define-key global-map (kbd "C-c n i") #'org-roam-node-insert)
(define-key global-map (kbd "C-c n l") #'org-roam-buffer-toggle)
