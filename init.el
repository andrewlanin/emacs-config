;; -----------------------------------------------------------------------------
;; Package manager settings.
;; -----------------------------------------------------------------------------

;; Install straight.el package manager.
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; use-package is used for convenient installation and configuration of all
;; other packages.
(straight-use-package 'use-package)
;; Force use-package to use straight.el as a backend.
(setq straight-use-package-by-default t)

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
(if (eq system-type 'darwin)
    (set-face-attribute 'default nil :font "Iosevka 16")
    (set-face-attribute 'default nil :font "Iosevka 12"))
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
(load-theme 'andrews t)

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
(bind-key* "C--" 'text-scale-decrease)
(bind-key* "C-=" 'text-scale-increase)

;; Quick files.
(bind-key* "\e\ec" (lambda () (interactive) (find-file "~/.emacs.d/init.el")))

;; -----------------------------------------------------------------------------
;; Search, navigation.
;; -----------------------------------------------------------------------------

;; Add fuzzy matching to default emacs completion routine.
(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Generic completion UI.
(use-package vertico
  :init
  (vertico-mode)
  (setq vertico-cycle t))

;; Add more relevant information to completion variants. For example, during
;; M-x displays description for each function.
(use-package marginalia
  :init
  (marginalia-mode)

  :bind (
         ;; Switch between more and less detailed annotations.
         ("M-a" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-a" . marginalia-cycle)))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Enhanced navigation functions.
(use-package consult
  :bind (("C-f" . consult-line)
         ("C-S-f" . consult-ripgrep)
         ("C-b" . consult-buffer)
         ("C-g" . consult-goto-line)))

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

(use-package org
  :init
  (setq org-support-shift-select t))

(use-package org-roam
  :init
  (setq org-roam-directory "~/OneDrive/Brain")
  (make-directory org-roam-directory :parents)
  (setq org-roam-dailies-directory "") ; Relative to org-roam-directory
  (setq org-roam-v2-ack t) ; Use version 2 of org-roam

  :config
  (org-roam-setup)

  :bind
  (("C-o" . org-roam-node-find)))

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
  (global-set-key (kbd "<f2>") 'treemacs)
  (treemacs))

;; -----------------------------------------------------------------------------
;; Programming.
;; -----------------------------------------------------------------------------

;; Indentation.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

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
(add-hook 'objc-mode-hook 'display-fill-column-indicator-mode)
(add-hook 'rust-mode-hook 'display-fill-column-indicator-mode)
(add-hook 'go-mode-hook 'display-fill-column-indicator-mode)

;; Line numbers.
(add-hook 'emacs-lisp-mode-hook 'display-line-numbers-mode)
(add-hook 'c-mode-hook 'display-line-numbers-mode)
(add-hook 'c++-mode-hook 'display-line-numbers-mode)
(add-hook 'objc-mode-hook 'display-line-numbers-mode)
(add-hook 'rust-mode-hook 'display-line-numbers-mode)
(add-hook 'go-mode-hook 'display-line-numbers-mode)

;; Objective-C++.
(add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))

;; C and C++ code style config.
(load (expand-file-name "andrews-c-style.el" user-emacs-directory))
(add-hook 'c-mode-common-hook 'andrews-c-style-setup)

;; Git plugin.
(use-package magit)

;; Package that is used by lsp-mode to highlight errors in code.
(use-package flycheck)

;; Dropdown completion suggestions.
(use-package company
  :init
  ;; Turn off automatic completion.
  (setq company-idle-delay nil)

  :config
  (global-company-mode)

  :bind (
         ;; Invoke completion on key press.
         ("M-RET" . company-complete-common)
         ))

;; Language Server Protocol.
(use-package lsp-mode
  :init
  (setq lsp-headerline-breadcrumb-enable nil)
  ;; Disable automatic includes.
  (setq lsp-completion-enable-additional-text-edit nil)

  :hook ((c++-mode . lsp)
         (go-mode . lsp)
         (rust-mode . lsp)
         (before-save . (lambda ()
                          (when (member major-mode (list 'go-mode 'rust-mode))
                            (lsp-format-buffer)))))
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
  :bind (("s-i" . lsp-ui-imenu)
         ("s-d" . lsp-find-definition)
         ("s-e" . lsp-find-references)))

(use-package cmake-mode)

(use-package metal-mode
  :straight (metal-mode :type git :host github :repo "masfj/metal-mode"))

(use-package go-mode)

(use-package rust-mode
  :init
  (setq rust-indent-offset 4)

  :bind (("s-c" . rust-check)
         ("s-b" . rust-build)
         ("s-t" . rust-test)))

(add-hook 'json-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))

(add-hook 'js-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))

(use-package jinja2-mode)

;; TODO: lsp-ui-doc hotkey.
;; TODO: Debug C++.
;; TODO: Debug go.
;; TODO: Debug rust.
;; TODO: Remote workflow with tramp.
;; TODO: Special settings for home and work.
