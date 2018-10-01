(when (maybe-require-package 'projectile)
  (add-hook 'after-init-hook 'projectile-mode)

  ;; Shorter modeline
  (setq-default projectile-mode-line-prefix " Proj")

  (after-load 'projectile
    (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
    (global-set-key (kbd "C-x p") 'projectile-find-file))

  (maybe-require-package 'ibuffer-projectile))


(provide 'init-projectile)
