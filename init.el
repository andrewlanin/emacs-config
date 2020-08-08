;; -----------------------------------------------------------------------------
;; Package manager settings.
;; -----------------------------------------------------------------------------

;; Setup package manager.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; First package we install is use-package. It is used for convenient
;; installation and configuration of all other packages.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

;; -----------------------------------------------------------------------------
;; General settings.
;; -----------------------------------------------------------------------------

;; Do not display startup buffer with basic information about emacs.
(setq inhibit-startup-screen t)

;; Make scratch buffer empty by default.
(setq initial-scratch-message nil)

;; Do not display menu bar.
(menu-bar-mode -1)

;; Do not display tool bar.
(tool-bar-mode -1)

;; Hide native scrollbar.
(scroll-bar-mode -1)

;; Turn off cursor blinking.
(blink-cursor-mode 0)

(set-face-attribute 'default nil :font "Iosevka 12")

;; Display column number in the mode line.
(setq column-number-mode t)

;; Turn off backups
(setq
 make-backup-files nil  ; Do not create backup~ files.
 auto-save-default nil  ; Do not create #autosave# files.
 create-lockfiles nil   ; Do not create .# files.
 )

;; Automatically reload files changed externally.
(global-auto-revert-mode t)

;; Remove trailing spaces before saving file.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Ensure all files are ended with new line.
(setq require-final-newline t)

;; Use [y/n] confirmation instead of [yes/no] everywhere.
(fset 'yes-or-no-p 'y-or-n-p)

;; custom-file is file where M-x customize stores settings. If we don't
;; expicitly define it, then load of garbage will be added to the init.el
;; which we want to keep clean.
;;
;; M-x customize is a graphical settings interface of emacs.
(defconst custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file) (write-region "" nil custom-file))
(load custom-file)

(load-theme 'abright t)

;; -----------------------------------------------------------------------------
;; General key bindings.
;; -----------------------------------------------------------------------------



;; -----------------------------------------------------------------------------
;; Org mode.
;; -----------------------------------------------------------------------------

(use-package org-roam
	     :init
	     (setq org-roam-directory "~/org")
	     (make-directory org-roam-directory :parents))
