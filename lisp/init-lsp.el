;;; init-lsp.el --- Language Server Protocol -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'lsp-mode)

(when (maybe-require-package 'lsp-ui)
  (require 'lsp-ui)

  (add-hook 'lsp-mode-hook #'lsp-ui-mode)

  (setq lsp-ui-sideline-show-hover nil)

  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references))

(defun sanityinc/flatten(x)
  (cond ((null x) nil)
        ((listp x) (append (sanityinc/flatten (car x)) (sanityinc/flatten (cdr x))))
        (t (list x))))

(when (maybe-require-package 'company-lsp)
  (after-load 'company

    (setq company-backends (sanityinc/flatten company-backends))

    ;; (delq 'company-clang company-backends)
    ;; (delq 'company-xcode company-backends)
    (push 'company-lsp company-backends)))

(provide 'init-lsp)
;;; init-lsp.el ends here
