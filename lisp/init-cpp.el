(require-package 'glasses)
(require-package 'cmake-mode)
;;(require-package 'column-marker) - not in MELPA anymore
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

If there was no last time, or there is a prefix argument, this
acts like M-x compile.
"""
  (interactive "p")
  (if (and (eq pfx 1)
           compilation-last-buffer)
      (progn
        (set-buffer compilation-last-buffer)
        (revert-buffer t t))
    (call-interactively 'compile)))

(defun my-compile-again-setup ()
  (local-set-key (kbd "C-c C-c") 'compile-again))

(add-hook 'c-mode-common-hook #'my-compile-again-setup)



(when (maybe-require-package 'company-c-headers)
  (after-load 'company
    (add-hook 'c-mode-common-hook
              (lambda ()
                (sanityinc/local-push-company-backend 'company-c-headers)
                ;;(local-set-key (kbd "M-/") 'company-complete)
                ;; TODO: these should probably be automatically detected or added
                ;; through a local elisp file
                ;; (add-to-list 'company-c-headers-path-system "/opt/local/libexec/llvm-3.5/include/c++/v1")
                ;; (add-to-list 'company-c-headers-path-system "/opt/local/libexec/llvm-3.5/lib/clang/3.5.0/include")
                ;; (add-to-list 'company-c-headers-path-system "/System/Library/Frameworks")
                ;; (add-to-list 'company-c-headers-path-system "/Library/Frameworks")
                ))))



(when (maybe-require-package 'modern-cpp-font-lock)
  (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)
  (after-load 'modern-cpp-font-lock
    (diminish 'modern-c++-font-lock-mode)
    ))



;; (require-package 'rtags)
;; (require-package 'ivy-rtags)

;; ;; TODO: Need to move elsewhere...

;; ;; From https://geokon-gh.github.io/.emacs.d/
;; ;;
;; ;; (setq image-animate-loop t)
;; ;;
;; ;; Note - check for package symon (tiny in-bar system monitor)

;; From http://endlessparentheses.com/a-few-paredit-keys-that-take-over-the-world.html
;; (global-set-key (kbd "C-M-u") #'paredit-backward-up)
;; (global-set-key (kbd "C-M-n") #'paredit-forward-up)
;; ;; This one's surpisingly useful for writing prose.
;; (global-set-key "\M-S"
;;                 #'paredit-splice-sexp-killing-backward)
;; (global-set-key "\M-R" #'paredit-raise-sexp)
;; (global-set-key "\M-(" #'paredit-wrap-round)
;; (global-set-key "\M-[" #'paredit-wrap-square)
;; (global-set-key "\M-{" #'paredit-wrap-curl)
;; (defun paredit-kill-maybe (arg)
;;   (interactive "P")
;;   (if (consp arg)
;;       (paredit-kill)
;;     (kill-line arg)))
;; (global-set-key [remap kill-line] #'paredit-kill-maybe)


;; From http://endlessparentheses.com/fill-and-unfill-paragraphs-with-a-single-key.html
;;
;; Purcell comment in that thread....
;;
;; (defun endless/fill-or-unfill ()
;;   "Like `fill-paragraph', but unfill if used twice."
;;   (interactive)
;;   (let ((fill-column
;;          (if (eq last-command 'endless/fill-or-unfill)
;;              (progn (setq this-command nil)
;;                     (point-max))
;;            fill-column)))
;;     (call-interactively #'fill-paragraph)))

;; (global-set-key [remap fill-paragraph]
;;                 #'endless/fill-or-unfill)


;; ;; Some notes:
;; ;;
;; ;; - Restart the rdm process
;; ;;
;; ;;     (rtags-restart-process)
;; ;;
;; ;; -

;; (rtags-enable-standard-keybindings c-mode-base-map)
;; (setq rtags-path (expand-file-name "rtags" user-emacs-directory))
;; (setq rtags-autostart-diagnostics t)
;; (setq rtags-completions-enabled t)
;; (setq rtags-display-result-backend 'ivy)

;; ;; New stuff to look into
;; ;; (rtags-enable-standard-keybindings)

;; (when (maybe-require-package 'company-rtags)
;;   (after-load 'company
;;     (add-hook 'c-mode-common-hook
;;               (lambda ()
;;                 (sanityinc/local-push-company-backend 'company-rtags)
;;                 ;; We are removing the company-clang to make sure it
;;                 ;; does not conflict with the rtags one.
;;                 (setq-local company-backends (delete 'company-clang company-backends))))))


;; Inspired by https://eklitzke.org/smarter-emacs-clang-format
;;
;; If a .clang-format file exists, will automatically run
;; clang-format-buffer when saving.
;;
;; TODO: this depends on projectile - how do I capture this?
(defun sanityinc/clang-format-buffer-smart ()
  "Reformat buffer if .clang-format exists in the projectile root."
  (when (file-exists-p (expand-file-name ".clang-format" (projectile-project-root)))
    (clang-format-buffer))
  )

(when (maybe-require-package 'clang-format)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (add-hook 'before-save-hook 'sanityinc/clang-format-buffer-smart nil t)

              ;; TODO: if there is a region selected, I would like to
              ;; instead call 'clang-format-region/buffer
              (local-set-key (kbd "C-M-TAB") 'clang-format-region)
              )))

;; ;; From https://oremacs.com/2017/03/28/emacs-cpp-ide/
;; (defun sanityinc/cpp-goto-symbol ()
;;   (interactive)
;;   (deactivate-mark)
;;   (ring-insert find-tag-marker-ring (point-marker))

;;   ;; (or (and (require 'rtags nil t)
;;   ;;          (rtags-find-symbol-at-point))
;;   ;;     (and (require 'semantic/ia)
;;   ;;          (condition-case nil
;;   ;;              (semantic-ia-fast-jump (point))
;;   ;;            (error nil))))

;;   (rtags-find-symbol-at-point)
;;   )

;; (add-hook 'c-mode-common-hook
;;           (lambda ()
;;             ;; I am not sure if this is really required sing we have
;;             ;; now the rtags-autostart-diagnostic set above, but this
;;             ;; does not seem to hurt
;;             (rtags-diagnostics)
;;             (guide-key/add-local-guide-key-sequence "C-c r")

;;             (local-set-key (kbd "M-.") 'sanityinc/cpp-goto-symbol)
;;             (local-set-key (kbd "M-,") 'pop-tag-mark)
;;             (local-set-key (kbd "M-?") 'rtags-display-summary)

;;             ;; This was similar to my golang mode but I believe M-, is
;;             ;; more "standard" than M-* and also easier to use.
;;             ;;(local-set-key (kbd "M-*") 'rtags-location-stack-back)

;;             ))

;; ;; turn-off flycheck since we got rtags-diagnostics
;; ;;  This is a pretty bad hack but I am not sure how to do this better...

;; (defun my-turn-off-flycheck-when-c++-mode ()
;;   (when (eq major-mode 'c++-mode)
;;     (progn
;;       (remove-hook 'flycheck-mode-hook #'my-turn-off-flycheck-when-c++-mode)
;;       (flycheck-mode -1)
;;       (add-hook 'flycheck-mode-hook #'my-turn-off-flycheck-when-c++-mode))))

;; (add-hook 'flycheck-mode-hook #'my-turn-off-flycheck-when-c++-mode)



;; (setq
;;  ;; use gdb-many-windows by default
;;  gdb-many-windows t

;;  ;; Non-nil means display source file containing the main routine at startup
;;  gdb-show-main t
;;  )


;;(require 'glasses)
(add-hook 'c-mode-common-hook
          (lambda ()
            (glasses-mode t)
            (setq-default glasses-face (quote bold))
            (setq-default glasses-separate-parentheses-p nil)
            (setq-default glasses-separator nil)
            (setq-default glasses-original-separator nil)
            (glasses-set-overlay-properties)))
(after-load 'glasses
  (diminish 'glasses-mode))



;;(require 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)
                ("\\.cmake\\'" . cmake-mode))
              auto-mode-alist))



(require-package 'lsp-mode)
;;(require-package 'emacs-cquery)
(require-package 'cquery)

(defun flatten(x)
  (cond ((null x) nil)
        ((listp x) (append (flatten (car x)) (flatten (cdr x))))
        (t (list x))))

(when (maybe-require-package 'lsp-ui)
  (require 'lsp-ui)

  (add-hook 'lsp-mode-hook #'lsp-ui-mode)

  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references))

(let ((my-cquery-path (executable-find "cquery")))
  (when my-cquery-path
    (require 'cquery)

    (setq cquery-executable my-cquery-path)
    (add-hook 'c-mode-common-hook #'lsp-cquery-enable)

    (when (maybe-require-package 'company-lsp)
      (after-load 'company
        (add-hook 'c-mode-common-hook
                  (lambda ()

                    (make-local-variable 'company-backends)
                    ;;(setq company-backends (list 'company-lsp 'company-cmake 'company-capf 'company-files))

                    ;; Remove a bunch of company backends that are covered
                    ;; by company-lsp. Also, for some reasons,
                    ;; company-backends sometime shows up with recursive
                    ;; backend list (not sure where this is coming
                    ;; from) but this will flatten it.

                    (setq company-backends (flatten company-backends))

                    (setq company-backends (delete 'company-clang company-backends))
                    (setq company-backends (delete 'company-semantic company-backends))
                    ;;(setq company-backends (delete 'company-dabbrev-code company-backends))
                    (setq company-backends (delete 'company-xcode company-backends))

                    (push 'company-lsp company-backends)

                    ;; Configure company-lsp to disable client-side
                    ;; cache/sorting because the server does a better job.

                    (setq company-transformers nil)
                    (setq company-lsp-async t)
                    (setq company-lsp-cache-candidates nil)
                    )
                  )
        )
      )
    ))

(provide 'init-cpp)
