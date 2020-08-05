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

;; custom-file is file where M-x customize stores settings. If we don't
;; expicitly define it, then load of garbage will be added to the init.el
;; which we want to keep clean.
;;
;; M-x customize is a graphical settings interface of emacs.
(defconst custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

;; Disable menu bar.
(menu-bar-mode -1)

(load-theme 'alabaster t)

(use-package org-roam
	     :init
	     (setq org-roam-directory "~/org")
	     (make-directory org-roam-directory :parents))

