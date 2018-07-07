(load "~/.emacs.d/site-lisp/gud/gud.el")
(load "~/.emacs.d/site-lisp/column-marker/column-marker.el")
(when (maybe-require-package 'go-mode)
      (load "~/.emacs.d/site-lisp/go-impl/go-impl.el"))

(provide 'init-preload-local)
