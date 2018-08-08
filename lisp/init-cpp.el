(require-package 'glasses)
(require-package 'cmake-mode)
;;(require-package 'column-marker)
(require 'column-marker)

;;----------------------------------------------------------------------------
;; Open .h as C++ files as opposed to C file
;;----------------------------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;----------------------------------------------------------------------------
;; Style I want to use in c++ mode
;;----------------------------------------------------------------------------
(c-add-style "my-style"
             '("stroustrup"
               (indent-tabs-mode . nil)
               (c-basic-offset . 4)
               (c-offsets-alist . ((inline-open . 0)
                                   (brace-list-open . 0)
                                   (statement-case-open . +)))))

(defun my-c-mode-common-hook ()
  (c-set-style "my-style")        ; use my-style defined above

  (setq c-block-comment-prefix "* ")
  (setq comment-multi-line t)

  (c-toggle-auto-hungry-state 1)

  (setq fill-column 78)
  (turn-on-auto-fill)

  ;;  (c-setup-filladapt)
  ;;  (filladapt-mode t)
  (column-marker-1 80)
  (column-marker-2 120))

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;;----------------------------------------------------------------------------
;; Will highlight the FIXME, TODO and BUG keywords in the code
;;----------------------------------------------------------------------------
(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))



(setq compilation-last-buffer nil)
(defun compile-again (pfx)
  """Run the same compile as the last time.

If there was no last time, or there is a prefix argument, this acts like
M-x compile.
"""
(interactive "p")
(if (and (eq pfx 1)
         compilation-last-buffer)
    (progn
      (set-buffer compilation-last-buffer)
      (revert-buffer t t))
  (call-interactively 'compile)))

(defun my-compile-again-setup ()
  (local-set-key (kbd "C-c C-c") 'compile-again)
  )

(add-hook 'c-mode-common-hook #'my-compile-again-setup)



(require-package 'company-c-headers)

(defun my-enable-company-c-headers ()
  (add-to-list 'company-backends 'company-c-headers)
  (local-set-key (kbd "M-/") 'company-complete)
  ;; TODO: these should probably be automatically detected or added
  ;; through a local elisp file
  ;; (add-to-list 'company-c-headers-path-system "/opt/local/libexec/llvm-3.5/include/c++/v1")
  ;; (add-to-list 'company-c-headers-path-system "/opt/local/libexec/llvm-3.5/lib/clang/3.5.0/include")
  ;; (add-to-list 'company-c-headers-path-system "/System/Library/Frameworks")
  ;; (add-to-list 'company-c-headers-path-system "/Library/Frameworks")
  )

(add-hook 'company-mode-hook #'my-enable-company-c-headers)
;;(add-hook 'c-mode-common-hook #'my-enable-company-c-headers)


(require-package 'rtags)
(require-package 'company-rtags)
(require-package 'ivy-rtags)

;; Some notes:
;;
;; - Restart the rdm process
;;
;;     (rtags-restart-process)
;;
;; -


(rtags-enable-standard-keybindings c-mode-base-map)
(setq rtags-path (expand-file-name "rtags" user-emacs-directory))
(setq rtags-autostart-diagnostics t)
(setq rtags-completions-enabled t)
(setq rtags-display-result-backend 'ivy)

(defun my-rtags-setup ()

  (setq company-backends (delete 'company-clang company-backends))
  (push 'company-rtags company-backends)

  ;; Start an async process in a buffer to receive warnings/errors
  ;; from clang whenever a file gets reindexed. It integrates with
  ;; flymake to put highlighting on code with warnings and errors

  (rtags-diagnostics)
  )

(add-hook 'c-mode-common-hook #'my-rtags-setup)

;; turn-off flycheck since we got rtags-diagnostics
;;  This is a pretty bad hack but I am not sure how to do this better...

(defun my-turn-off-flycheck-when-c++-mode ()
  (when (eq major-mode 'c++-mode)
    (progn
      (remove-hook 'flycheck-mode-hook #'my-turn-off-flycheck-when-c++-mode)
      (flycheck-mode -1)
      (add-hook 'flycheck-mode-hook #'my-turn-off-flycheck-when-c++-mode))))

(add-hook 'flycheck-mode-hook #'my-turn-off-flycheck-when-c++-mode)



;; (setq
;;  ;; use gdb-many-windows by default
;;  gdb-many-windows t

;;  ;; Non-nil means display source file containing the main routine at startup
;;  gdb-show-main t
;;  )


(require 'glasses)
(add-hook 'c-mode-common-hook (lambda ()
                                (glasses-mode t)
                                (setq-default glasses-face (quote bold))
                                (setq-default glasses-separate-parentheses-p nil)
                                (setq-default glasses-separator nil)
                                (setq-default glasses-original-separator nil)
                                (glasses-set-overlay-properties)))


(require 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)
                ("\\.cmake\\'" . cmake-mode))
              auto-mode-alist))

(provide 'init-cpp)
