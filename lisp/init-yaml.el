;;; YAML

(when (maybe-require-package 'yaml-mode)
  (add-auto-mode 'yaml-mode "\\.yml\\.erb\\'"))

(provide 'init-yaml)
