(require-package 'editorconfig)

(add-hook 'after-init-hook 'editorconfig-mode)
(after-load 'editorconfig (diminish 'editorconfig-mode))

(provide 'init-editorconfig)
