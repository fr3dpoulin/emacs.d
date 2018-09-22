(require-package 'go-mode)
;; (require-package 'flymake-go)
;;(require-package 'company-go)
(require-package 'exec-path-from-shell)
(require-package 'go-guru)
(require-package 'go-dlv)
(require-package 'go-eldoc)
;; NOTE: go-impl is currently incompatible with ivy so we are
;; keeping it disabled.
;;(require-package 'go-impl)
(require-package 'go-projectile)
(require-package 'godoctor)
(require-package 'go-stacktracer)
(require-package 'go-snippets)
(require-package 'go-direx)
(require-package 'go-add-tags)

(require-package 'lsp-mode)
(require-package 'lsp-go)

(require 'lsp-go)

;; Get the user's GOPATH
(when (memq window-system '(mac ns))
  (exec-path-from-shell-copy-env "GOPATH"))

;; Use lsp-mode
(add-hook 'go-mode-hook #'lsp-go-enable)

;; TODO: apply to all lsp-mode - should we do something more specific to golang and/or C++ ?
(when (maybe-require-package 'lsp-ui)
  (require 'lsp-ui)

  (add-hook 'lsp-mode-hook #'lsp-ui-mode)

  (setq lsp-ui-sideline-show-hover nil)

  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references))


;; Define function to call when go-mode loads
(defun my-go-mode-hook ()
  (add-hook 'before-save-hook #'gofmt-before-save) ; gofmt before every save

  (setq gofmt-command "goimports")      ; gofmt uses invokes goimports
  (setq go-add-tags-style 'snake-case) ; go-add-tags will default to snake-case

  (if (not (string-match "go" compile-command)) ; set compile command default
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))

  ;; go-guru settings
  ;; (go-guru-hl-identifier-mode)          ; highlight identifiers

  ;; Key bindings specific to go-mode
  ;; (local-set-key (kbd "M-.") 'godef-jump)   ; Go to definition
  ;; (local-set-key (kbd "M-*") 'pop-tag-mark) ; Return from where you came
  (local-set-key (kbd "C-c ?") 'godoc-at-point)

  ;; Refactoring keybord shortcuts
  ;;(local-set-key (kbd "C-c C-g r") 'godoctor-rename)
  (local-set-key (kbd "C-c C-g r") 'lsp-rename)
  (local-set-key (kbd "C-c C-g e") 'godoctor-extract)
  (local-set-key (kbd "C-c C-g d") 'go-goto-docstring)
  (local-set-key (kbd "C-c C-g v") 'godoctor-toggle)

  (local-set-key (kbd "C-c C-j") 'go-direx-pop-to-buffer)

  (local-set-key (kbd "C-c t") 'go-add-tags)

  ;;(local-set-key (kbd "M-/") 'company-complete)

  ;; M-/ : company-complete
  ;; C-c ; : comment-or-uncomment

  ;; go-eldoc
  ;;(go-eldoc-setup)
  )

;; Connect go-mode-hook with the function we just defined
(add-hook 'go-mode-hook #'my-go-mode-hook)

(defun flatten(x)
  (cond ((null x) nil)
        ((listp x) (append (flatten (car x)) (flatten (cdr x))))
        (t (list x))))

(when (maybe-require-package 'company-lsp)
  (after-load 'company
    (add-hook 'go-mode-hook
              #'(lambda ()
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

                  ))))

;; C-c C-a : go-import-add (add a new import)
;; go-remove-unused-imports

;; C-c C-d : describe expressions

;; Playground:
;; go-play-buffer, go-play-region: send to playground
;; go-download-play: download from playground
;; go-coverage

;; With compile errors:
;; M-g n : next-error
;; M-g p : previous-error

(after-load 'go-mode
  (add-hook 'go-mode-hook
            (lambda ()
              (guide-key/add-local-guide-key-sequence "C-c C-g")
              (guide-key/add-local-guide-key-sequence "C-c C-f")
              (guide-key/add-local-guide-key-sequence "C-c C-o") )))

(provide 'init-golang)
