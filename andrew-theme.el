(deftheme andrew "My custom emacs theme inspired by Alabaster by Nikita Prokopov")

(custom-theme-set-faces
 'andrew
 `(default ((t (:background "white" :foreground "black"))))

 ;; GUI
 `(fringe                       ((t (:background "white"))))
 `(vertical-border              ((t (:foreground "#d0d0d0"))))
 `(fill-column-indicator        ((t (:foreground "#d0d0d0"))))
 `(hl-line                      ((t (:background "#d0d0d0"))))

 ;; Syntax
 `(font-lock-keyword-face       ((t (:foreground "black"))))
 `(font-lock-constant-face      ((t (:foreground "black"))))
 `(font-lock-type-face          ((t (:foreground "black"))))
 `(font-lock-builtin-face       ((t (:foreground "black"))))
 `(font-lock-string-face        ((t (:foreground "#0000ff"))))
 `(font-lock-comment-face       ((t (:foreground "darkmagenta"))))
 `(font-lock-doc-face           ((t (:foreground "darkmagenta"))))
 `(font-lock-function-name-face ((t (:foreground "black"))))
 `(font-lock-variable-name-face ((t (:foreground "black"))))
 )

(provide-theme 'andrew)
