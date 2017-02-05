(when (maybe-require-package 'flycheck)
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list)

  (after-load 'flycheck
    (add-to-list 'guide-key/guide-key-sequence "C-c !")))

(provide 'init-flycheck)
