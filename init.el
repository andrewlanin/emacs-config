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

;; Initial window size. Tuned to fill whole screen on macbook air.
(setq initial-frame-alist '((width . 177) (height . 42)))

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

;; Turn off both beep sound and visual blink in case of invalid command.
;; Error text in status line should be enough.
(setq visible-bell nil
      ring-bell-function (lambda () nil))

;; Font
(set-face-attribute 'default nil :font "Iosevka 16")
(setq-default line-spacing 0)

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

;; Theme.
(load-theme 'andrew t)

;; By default if you type something while some portion of text is selected,
;; emacs will add typed text to the end of selection. Activating
;; delete-selection-mode makes it behave similar to all other software:
;; delete selected text, than insert typed text in its place.
(delete-selection-mode 1)

;; -----------------------------------------------------------------------------
;; General key bindings.
;; -----------------------------------------------------------------------------

;; macOS modifier keys.
(setq mac-command-modifier 'control)
(setq mac-right-command-modifier 'control)
(setq mac-control-modifier 'super)
(setq mac-right-control-modifier 'super)
(setq mac-option-modifier 'meta)
(setq mac-left-option-modifier 'meta)
;; Right Alt (option) can be used to enter symbols like em dashes =—=.
(setq mac-right-option-modifier 'nil)

;; Basic actions.
(global-set-key (kbd "C-p") 'find-file)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-S-s") 'write-file) ; Save as...
(global-set-key (kbd "C-x") 'kill-region)
(global-set-key (kbd "C-c") 'kill-ring-save)
(global-set-key (kbd "C-v") 'yank)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "C-k") 'kill-current-buffer)
(global-set-key (kbd "C-q") 'save-buffers-kill-emacs)

;; Quick files.
(global-set-key (kbd "\e\ec") (lambda () (interactive) (find-file "~/.emacs.d/init.el")))

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
    (counsel-mode 1)
    (global-set-key (kbd "C-S-f") 'counsel-rg)
    (global-set-key (kbd "C-b") 'counsel-switch-buffer))

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

(global-set-key (kbd "C-t")   'split-window-horizontally-and-switch)
(global-set-key (kbd "C-S-t") 'split-window-vertically-and-switch)
(global-set-key (kbd "C-w")   'delete-window)
(global-set-key (kbd "C-S-w") 'delete-other-windows)

;; Move between windows.
(use-package windmove
  :config
    (global-set-key (kbd "<M-left>")  'windmove-left)
    (global-set-key (kbd "<M-right>") 'windmove-right)
    (global-set-key (kbd "<M-up>")    'windmove-up)
    (global-set-key (kbd "<M-down>")  'windmove-down))

;; Change windows size.
(global-set-key (kbd "M-S-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "M-S-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-S-<down>") 'shrink-window)
(global-set-key (kbd "M-S-<up>") 'enlarge-window)

;; -----------------------------------------------------------------------------
;; Org mode.
;; -----------------------------------------------------------------------------

(use-package org-roam
  :init
    (setq org-roam-directory "~/org")
    (make-directory org-roam-directory :parents))

;; -----------------------------------------------------------------------------
;; Tree.
;; -----------------------------------------------------------------------------

(use-package treemacs
  :config
  (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
        treemacs-deferred-git-apply-delay      0.5
        treemacs-directory-name-transformer    #'identity
        treemacs-display-in-side-window        t
        treemacs-eldoc-display                 t
        treemacs-file-event-delay              5000
        treemacs-file-extension-regex          treemacs-last-period-regex-value
        treemacs-file-follow-delay             0.2
        treemacs-file-name-transformer         #'identity
        treemacs-follow-after-init             t
        treemacs-git-command-pipe              ""
        treemacs-goto-tag-strategy             'refetch-index
        treemacs-indentation                   2
        treemacs-indentation-string            " "
        treemacs-is-never-other-window         nil
        treemacs-max-git-entries               5000
        treemacs-missing-project-action        'ask
        treemacs-no-png-images                 t
        treemacs-no-delete-other-windows       t
        treemacs-project-follow-cleanup        nil
        treemacs-persist-file                  (expand-file-name "treemacs-workspaces" user-emacs-directory)
        treemacs-position                      'left
        treemacs-recenter-distance             0.1
        treemacs-recenter-after-file-follow    nil
        treemacs-recenter-after-tag-follow     nil
        treemacs-recenter-after-project-jump   'always
        treemacs-recenter-after-project-expand 'on-distance
        treemacs-show-cursor                   nil
        treemacs-show-hidden-files             t
        treemacs-silent-filewatch              nil
        treemacs-silent-refresh                nil
        treemacs-sorting                       'alphabetic-asc
        treemacs-space-between-root-nodes      t
        treemacs-tag-follow-cleanup            t
        treemacs-tag-follow-delay              1.5
        treemacs-user-mode-line-format         nil
        treemacs-width                         35
        )
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode t)
  (global-set-key (kbd "<f2>") 'treemacs))

;; -----------------------------------------------------------------------------
;; Programming.
;; -----------------------------------------------------------------------------

;; Indentation.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;; Matching parentheses.
(set-face-background 'show-paren-match "grey80")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)
(show-paren-mode)

;; Comment/uncomment line.
(global-set-key (kbd "C-/") 'comment-line)

(setq-default display-fill-column-indicator-column 80)
(setq-default display-fill-column-indicator-character (string-to-char ":"))
(add-hook 'c++-mode-hook 'display-fill-column-indicator-mode)
