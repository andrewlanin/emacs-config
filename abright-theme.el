(deftheme abright "Emacs theme inspired by Alabaster by Nikita Prokopov")

(custom-theme-set-faces
 'abright
 `(default ((t (:background "#f0f0f0" :foreground "black"))))

 `(font-lock-keyword-face       ((t (:foreground "black"))))
 `(font-lock-constant-face      ((t (:foreground "black"))))
 `(font-lock-type-face          ((t (:foreground "black"))))
 `(font-lock-builtin-face       ((t (:foreground "black"))))
 `(font-lock-string-face        ((t (:foreground "#0000ff"))))
 `(font-lock-comment-face       ((t (:foreground "darkmagenta"))))
 `(font-lock-function-name-face ((t (:foreground "#209000"))))
 `(font-lock-variable-name-face ((t (:foreground "black"))))
 `(vertical-border              ((t (:background "#c0c0c0" :foreground "#c0c0c0"))))
 )

(provide-theme 'abright)
