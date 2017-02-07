(load "~/.emacs.d/site-lisp/gud/gud.el")
(when (maybe-require-package 'go-mode)
      (load "~/.emacs.d/site-lisp/go-impl/go-impl.el"))

(provide 'init-preload-local)
