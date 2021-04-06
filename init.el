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

;; bind-key module is part of use-package. It helps to reliably bind keys.
;; When binding hotkey with default emacs API like global-set-key, it still
;; can be rebound later to other function by one of the active minor modes.
;; bind-key module provides bind-key* function that helps to create key
;; binding that will stay valid no matter what. It is useful for basic bindings
;; that should work everywhere, like C-c, C-v.
(require 'bind-key)

;; Populate emacs own PATH from shell PATH.
(use-package exec-path-from-shell
  :config (exec-path-from-shell-initialize))

;; -----------------------------------------------------------------------------
;; General settings.
;; -----------------------------------------------------------------------------

;; Collect garbage less often.
(setq gc-cons-threshold (* 100 1024 1024))

;; Initial window size. Tuned to fill whole screen on macbook air.
(setq initial-frame-alist '((width . 177) (height . 42)))

;; Allow to resize emacs window with pixel precision. Default resize step -
;; one character size.
(setq frame-resize-pixelwise t)

;; Do not display startup buffer with basic information about emacs.
(setq inhibit-startup-screen t)

;; Make scratch buffer empty by default.
(setq initial-scratch-message nil)

(unless (string-equal system-type "darwin")
  ;; Do not display menu bar.
  (menu-bar-mode -1))

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
(bind-key* "C-p" 'find-file)
(bind-key* "C-s" 'save-buffer)
(bind-key* "C-S-s" 'write-file) ; Save as...
(bind-key* "C-x" 'kill-region)
(bind-key* "C-c" 'kill-ring-save)
(bind-key* "C-v" 'yank)
(bind-key* "C-z" 'undo)
(bind-key* "C-a" 'mark-whole-buffer)
(bind-key* "C-k" 'kill-current-buffer)
(bind-key* "C-q" 'save-buffers-kill-emacs)

;; Quick files.
(bind-key* "\e\ec" (lambda () (interactive) (find-file "~/.emacs.d/init.el")))

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
    (bind-key* "C-S-f" 'counsel-rg)
    (bind-key* "C-b"   'counsel-switch-buffer))

;; Swiper does interactive search inside current file.
(use-package swiper
  :config
    (bind-key* "C-f" 'swiper-isearch))

;; Replace command with nice feedback.
(use-package visual-regexp
  :config
    (bind-key* "C-r" 'vr/replace))

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

(bind-key* "C-t"   'split-window-horizontally-and-switch)
(bind-key* "C-S-t" 'split-window-vertically-and-switch)
(bind-key* "C-w"   'delete-window)
(bind-key* "C-S-w" 'delete-other-windows)

;; Move between windows.
(use-package windmove
  :config
    (bind-key* "<M-left>"  'windmove-left)
    (bind-key* "<M-right>" 'windmove-right)
    (bind-key* "<M-up>"    'windmove-up)
    (bind-key* "<M-down>"  'windmove-down))

;; Change windows size.
(bind-key* "M-S-<left>"  'shrink-window-horizontally)
(bind-key* "M-S-<right>" 'enlarge-window-horizontally)
(bind-key* "M-S-<down>"  'shrink-window)
(bind-key* "M-S-<up>"    'enlarge-window)

;; -----------------------------------------------------------------------------
;; Org mode.
;; -----------------------------------------------------------------------------

(use-package org-roam
  :init
    (setq org-roam-directory "~/OneDrive/Brain")
    (make-directory org-roam-directory :parents))

;; -----------------------------------------------------------------------------
;; Tree.
;; -----------------------------------------------------------------------------

(use-package treemacs
  :config
  (setq treemacs-no-png-images t
        treemacs-space-between-root-nodes nil
        treemacs-persist-file (expand-file-name "treemacs-workspaces"
                                                user-emacs-directory))
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

;; Line length limit.
(setq-default display-fill-column-indicator-column 80)
(setq-default display-fill-column-indicator-character (string-to-char ":"))
(add-hook 'emacs-lisp-mode-hook 'display-fill-column-indicator-mode)
(add-hook 'c-mode-hook 'display-fill-column-indicator-mode)
(add-hook 'c++-mode-hook 'display-fill-column-indicator-mode)
(add-hook 'rust-mode-hook 'display-fill-column-indicator-mode)

;; Line numbers.
(add-hook 'emacs-lisp-mode-hook 'display-line-numbers-mode)
(add-hook 'c-mode-hook 'display-line-numbers-mode)
(add-hook 'c++-mode-hook 'display-line-numbers-mode)
(add-hook 'rust-mode-hook 'display-line-numbers-mode)

;; Package that is used by lsp-mode to highlight errors in code.
(use-package flycheck)

;; Dropdown completion suggestions.
(use-package company
  :init (global-company-mode))

;; Language Server Protocol.
(use-package lsp-mode
  :init (setq lsp-headerline-breadcrumb-enable nil)
  :hook (
         (c++-mode . lsp)
         (go-mode . lsp)
         (rust-mode . lsp)
         (before-save . (lambda () (when (eq 'rust-mode major-mode)
                                     (lsp-format-buffer))))
         )
  :bind (("s-r" . lsp-rename))
  :commands lsp)

;; Extended UI for lsp-mode. Adds inline errors texts, find references, etc.
(use-package lsp-ui
  :init
  ;; lsp-ui-sideline renders compilation errors in text buffer itself to the
  ;; right of the main text. That generates a lot of content flickering during
  ;; typing. I'd rather see diagnostics on demand.
  (setq lsp-ui-sideline-enable nil)
  (setq lsp-ui-doc-enable nil)
  :bind (("s-i" . lsp-ui-imenu)))

(use-package go-mode)

(use-package rust-mode
  :bind (("s-c" . rust-check)
         ("s-b" . rust-build)
         ("s-t" . rust-test)))

;; TODO: Completion dropdown hotkey.
;; TODO: Go to definition.
;; TODO: Find references.
;; TODO: lsp-ui-doc hotkey.
;; TODO: Rename.
;; TODO: Debug C++.
;; TODO: Debug go.
;; TODO: Debug rust.
;; TODO: Shell.
;; TODO: Magit.
;; TODO: Common lisp.
