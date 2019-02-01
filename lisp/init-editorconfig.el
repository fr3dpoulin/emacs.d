;;; init-editorconfig.el --- Setup editorconfig mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'editorconfig)

(add-hook 'after-init-hook 'editorconfig-mode)
(after-load 'editorconfig (diminish 'editorconfig-mode))

(provide 'init-editorconfig)
;;; init-editorconfig.el ends here
