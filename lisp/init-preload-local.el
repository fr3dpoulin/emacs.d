;;; init-preload-local.el --- Local preload -*- lexical-binding: t -*-
;;; Commentary:

;; TODO: I don't think, this is supposed to be in the repo :-)

;;; Code:

(load "gud")
(load "column-marker")
(when (maybe-require-package 'go-mode)
  (load "go-impl"))

(provide 'init-preload-local)
;;; init-preload-local.el ends here
