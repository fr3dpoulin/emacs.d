(load "gud")
(load "column-marker")
(when (maybe-require-package 'go-mode)
  (load "go-impl"))

(provide 'init-preload-local)
