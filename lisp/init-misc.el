;;----------------------------------------------------------------------------
;; Misc config - yet to be placed in separate files
;;----------------------------------------------------------------------------
(add-auto-mode 'tcl-mode "Portfile\\'")
(fset 'yes-or-no-p 'y-or-n-p)

(add-hook 'prog-mode-hook 'goto-address-prog-mode)
(setq goto-address-mail-face 'link)

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(add-hook 'after-save-hook 'sanityinc/set-mode-for-new-scripts)

(defun sanityinc/set-mode-for-new-scripts ()
  "Invoke `normal-mode' if this file is a script and in `fundamental-mode'."
  (and
   (eq major-mode 'fundamental-mode)
   (>= (buffer-size) 2)
   (save-restriction
     (widen)
     (string= "#!" (buffer-substring (point-min) (+ 2 (point-min)))))
   (normal-mode)))


(setq-default regex-tool-backend 'perl)
(after-load 're-builder
  ;; Support a slightly more idiomatic quit binding in re-builder
  (define-key reb-mode-map (kbd "C-c C-k") 'reb-quit))

(add-auto-mode 'conf-mode "Procfile")


;; I clearly don't know what I am doing here...

;; (let ((my-backup-directory (expand-file-name "backup" user-emacs-directory)))
;;   (message my-backup-directory))
;; (setq my-backup-directory (expand-file-name "backup" user-emacs-directory))
;; (setq test-list nil)
;; (cons ( my-backup-directory) test-list)

;; (setq backup-directory-alist nil)

;; ;; prevent emacs to leave its backup file all over the place
;; (let ((my-backup-directory (expand-file-name "backup" user-emacs-directory)))
;;   (setq backup-directory-alist (cons )))


(provide 'init-misc)
