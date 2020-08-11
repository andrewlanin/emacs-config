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

;; Initial window size.
(setq initial-frame-alist '((width . 120) (height . 40)))

;; Do not display startup buffer with basic information about emacs.
(setq inhibit-startup-screen t)

;; Make scratch buffer empty by default.
(setq initial-scratch-message nil)

;; Do not display menu bar.
(menu-bar-mode -1)

;; Do not display tool bar.
(tool-bar-mode -1)

;; Hide native scrollbar. Scroll bar is not available in emacs-nox.
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

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

;; By default if you type something while some portion of text is selected,
;; emacs will add typed text to the end of selection. Activating
;; delete-selection-mode makes it behave similar to all other software:
;; delete selected text, than insert typed text in its place.
(delete-selection-mode 1)

;; -----------------------------------------------------------------------------
;; General key bindings.
;; -----------------------------------------------------------------------------

(global-set-key (kbd "C-p") 'find-file)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-S-s") 'write-file) ; Save as...
(global-set-key (kbd "C-x") 'kill-region)
(global-set-key (kbd "C-c") 'kill-ring-save)
(global-set-key (kbd "C-v") 'yank)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "C-q") 'save-buffers-kill-emacs)

;; -----------------------------------------------------------------------------
;; General extensions.
;; -----------------------------------------------------------------------------

;; Ivy is a general-purpose completion framework for emacs.
(use-package ivy
  :config
    (ivy-mode 1)
    ;; Display current variant number and total variants in the completion
    ;; buffer.
    (setq ivy-count-format "(%d/%d) "))

;; Counsel is emacs command enhancer. It replaces commands like M-x, find-file
;; and many other, adding nice completion to them.
(use-package counsel
  :config
    (counsel-mode 1))

;; Swiper does interactive search inside current file.
(use-package swiper
  :config
    (global-set-key (kbd "C-f") 'swiper-isearch))

;; Replace command with nice feedback.
(use-package visual-regexp
  :config
    (define-key global-map (kbd "C-r") 'vr/replace))

;; -----------------------------------------------------------------------------
;; Windows.
;; -----------------------------------------------------------------------------

(defun split-window-horizontally-and-switch ()
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil)
  (switch-to-next-buffer))

(defun split-window-vertically-and-switch ()
  (interactive)
  (split-window-vertically)
  (other-window 1 nil)
  (switch-to-next-buffer))

(global-set-key (kbd "C-t") 'split-window-horizontally-and-switch)
(global-set-key (kbd "C-S-t") 'split-window-vertically-and-switch)
(global-set-key (kbd "C-w") 'delete-window)
(global-set-key (kbd "C-S-w") 'delete-other-windows)

;; Move between windows.
(use-package windmove
  :config
    (global-set-key (kbd "<M-left>")  'windmove-left)
    (global-set-key (kbd "<M-right>") 'windmove-right)
    (global-set-key (kbd "<M-up>")    'windmove-up)
    (global-set-key (kbd "<M-down>")  'windmove-down))

;; -----------------------------------------------------------------------------
;; Org mode.
;; -----------------------------------------------------------------------------

(use-package org-roam
  :init
    (setq org-roam-directory "~/org")
    (make-directory org-roam-directory :parents))
